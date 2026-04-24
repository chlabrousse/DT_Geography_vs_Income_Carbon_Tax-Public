## Upload data from POTE
library(arrow)
library(dplyr)
library(ggplot2)
library(bit64)
library(haven)
library(stringr)
library(data.table)  
library(readxl)
library(scales)
library(readr)
library(xtable)

################### Load BTS 2022 -----------------------------------------------------

# Sp?cifier le chemin du dossier contenant les fichiers .parquet
folder_path = "XXXXXX/HAB_A118022B_DENSPOSTP"

# Lister tous les fichiers .parquet dans ce dossier
parquet_files = list.files(path = folder_path, pattern = "\\.parquet$", full.names = TRUE)

# Sp?cifier les colonnes ? lire
selected_columns = c("ident_s","s_net_tot","comr","apen","a88", "comt")

# Lire chaque fichier .parquet en ne s?lectionnant que certaines colonnes
data <- lapply(parquet_files, function(file) {
  read_parquet(file, col_select = all_of(selected_columns))
})

# Si vous souhaitez les combiner en un seul data frame
data = do.call(rbind,data)

setDT(data) ### we have 61,585,079 observations here


# Step 1: Remove rows with NA values in netnet
data <- data[!is.na(s_net_tot)] ####  no change
data <- data[!is.na(a88)] #### 59,492,419 observations

# Step 2: Remove silly values i.e. netnet <1000
data <- data[s_net_tot > 1000]  ####  59,398,373 observations


# Step 3: keep only individuals that are present once in the dataset
data_uniq <- data[order(s_net_tot), .SD[1], by =.(ident_s)]
setDT(data_uniq) 
#### we have 32,483,891 observations after this

# Create quintile of net income
data_uniq[, quintile := as.factor(ntile(s_net_tot, 5))]

# Optional: Set labels for the quintiles
data_uniq[, quintile := factor(quintile, labels = c("Q1", "Q2", "Q3", "Q4", "Q5"))]

rm(data)
rm(folder_path,parquet_files,selected_columns)
data_uniq <- data_uniq[!is.na(comr)]

#################### Add geography --------------------------------------------------

# Load communes data and classify city types
## grille densité 2025 + AAV 2020
## NOTE: ICI TÉLÉCHARGER LE FICHIER DE DIFFUSION DE LA GRILLE DE DENSITÉ 2025 ET LE FICHIER DES AIRES D'ATTRACTION DES VILLES DE 2020
communes_data <-  read_excel("fichier_diffusion_2025.xlsx", sheet = "Maille communale", skip = 4)
setDT(communes_data)
AAV_data <-   read_excel("AAV2020_au_01-01-2025.xlsx", sheet = "Composition_communale", skip = 5)
setDT(AAV_data)

# merge all data
communes_data <- AAV_data[communes_data, on = "CODGEO"]

communes_data[, city_type := fcase(
  DENS_AAV == 4, "rural non périurbain",
  DENS_AAV == 3, "rural périurbain",
  DENS_AAV == 2, "urbain intermédiaire",
  DENS_AAV == 1 & AAV2020 == "001" & CATEAAV2020 %in% c(11, 12), "Paris",
  DENS_AAV == 1, "Urbain dense hors Paris"
)]

## replace missing points
data_uniq[comr %in% 75101:75120, comr := 75056] #arrondissements Paris
data_uniq[comr %in% 69381:69389, comr := 69123] #arrondissements de Lyon
data_uniq[comr %in% 13201:13216, comr := 13055] #arrondissements de Marseille
data_uniq <- data_uniq[communes_data, on = .(comr = CODGEO), city_type := i.city_type]

missing_in_communes <- data_uniq[!communes_data, on = .(comr = CODGEO), .(comr)]
missing_in_communes


# Remove rows where city_size_type is NA
data_uniq <- data_uniq[!is.na(city_type)]
#### we have 31,844,428 observations after this
data_uniq$city_type <- factor(data_uniq$city_type, levels = c("rural non périurbain","rural périurbain","urbain intermédiaire","Urbain dense hors Paris","Paris"))


#################### Emissions Insee --------------------------------------------------

Emissions_per_sector <- read_csv("XXXXXX/data_emissions_IPP_CN.csv", col_types = cols(...1 = col_skip()))

# Convert the data frame to a data.table
Emissions_per_sector <- setDT(Emissions_per_sector)


Emissions_regression <- data.table(
  a88 = Emissions_per_sector$Code_NAF,
  emissions_per_worker_CN =  Emissions_per_sector$Emissions_Workers,
  emissions_per_worker_IPP =  Emissions_per_sector$Emissions_Workers_IPP)
Emissions_regression <- na.omit(Emissions_regression)


data_uniq <- merge(data_uniq, Emissions_regression, by = "a88")

# Create quintile of net income
data_uniq[, quintile := as.factor(ntile(s_net_tot, 5))]

# Optional: Set labels for the quintiles
data_uniq[, quintile := factor(quintile, labels = c("Q1", "Q2", "Q3", "Q4", "Q5"))]


mean(data_uniq$emissions_per_worker_CN)

median(data_uniq$emissions_per_worker_CN)

reg1 <- lm(emissions_per_worker_CN ~ city_type + quintile, data = data_uniq)
summary(reg1)


#### Predictions Cities
cities_levels <- unique(data_uniq$city_type)

pred_cities <- lapply(cities_levels, function(city) {
  newdata <- data_uniq
  newdata$city_type <- city
  newdata$pred <- predict(reg1, newdata)
  mean_pred <- mean(newdata$pred)
  data.frame(city_type = city, emissions_pred = mean_pred)
}) %>% bind_rows()

write.xlsx(pred_cities, "pred_cities.xlsx")


#### Predictions Quintiles
quintile_levels <- unique(data_uniq$quintile)

pred_quintile <- lapply(quintile_levels, function(q) {
  newdata <- data_uniq
  newdata$quintile <- q
  newdata$pred <- predict(reg1, newdata)
  mean_pred <- mean(newdata$pred)
  data.frame(quintile = q, emissions_pred = mean_pred)
}) %>% bind_rows()

write.xlsx(pred_quintile, "pred_quintile.xlsx")










############################### Table Workers ----------------------------------------

setDT(data_uniq)
data_uniq[, city_type := as.character(city_type)]
data_uniq[, quintile := as.character(quintile)]  # ? faire aussi pour quintile si facteur

cities_share_all <- data_uniq[, .N, by = city_type]
cities_share_all$share = cities_share_all$N/nrow(data_uniq)

# Part des travailleurs dans chaque secteur (sur ensemble)
total_workers <- nrow(data_uniq)
total_sector_workers <- data_uniq[, .N, by = a88]
share_sector_workers <- data_uniq[, .(share = .N / total_workers*100), by = a88]


######### Part des travailleurs dans chaque secteur pour chaque quintile
# - D'abord nombre de personnes par secteur et quintile
nb_sector_quintile <- data_uniq[, .N, by = .(a88, quintile)]
# - Nombre total de personnes par quintile
nb_total_quintile <- data_uniq[, .N, by = quintile]
# - Merge pour calcul de part
share_quintile <- merge(nb_sector_quintile, nb_total_quintile, by = "quintile", suffixes = c("_secteur", "_total"))
share_quintile_new <- merge(nb_sector_quintile, total_sector_workers, by = "a88", suffixes = c("_quintile", "_total_secteur"))

# - Calcul de la part
share_quintile[, share := N_secteur/ N_total*100]
share_quintile_new[, share := N_quintile / N_total_secteur*100]

# Reshape pour avoir les quintiles en colonnes
share_quintile_wide <- dcast(share_quintile, a88 ~ quintile, value.var = "share", fill = 0)
share_quintile_wide_new <- dcast(share_quintile_new, a88 ~ quintile, value.var = "share", fill = 0)



######### Part des travailleurs dans chaque secteur pour chaque type de ville
# - Nombre de personnes par secteur et ville
nb_sector_cities <- data_uniq[, .N, by = .(a88, city_type)]
# - Nombre total par ville
nb_total_cities <- data_uniq[, .N, by = city_type]
# - Merge pour calcul
share_cities <- merge(nb_sector_cities, nb_total_cities, by = "city_type", suffixes = c("_secteur", "_total"))
share_cities_new <- merge(nb_sector_cities, total_sector_workers, by = "a88", suffixes = c("_cities", "_total_sector"))


# - Calcul part
share_cities[, share := N_secteur / N_total*100]
share_cities_new[, share := N_cities / N_total_sector*100]

##Reshape pour villes en colonnes
share_cities_wide <- dcast(share_cities, a88 ~ city_type, value.var = "share", fill = 0)
share_cities_wide_new <- dcast(share_cities_new, a88 ~ city_type, value.var = "share", fill = 0)

# Assuming your data frame is named df
share_cities_wide <- share_cities_wide %>%
  select(a88,"rural non périurbain","rural périurbain","urbain intermédiaire","Urbain dense hors Paris","Paris")

share_cities_wide_new <- share_cities_wide_new %>%
  select(a88, "rural non périurbain","rural périurbain","urbain intermédiaire","Urbain dense hors Paris","Paris")


Emissions_table = Emissions_regression[, .(a88, emissions_per_worker_CN)]
Codes_NAF <- read_excel("XXXXXX/Codes_NAF_VA.xlsx")
setDT(Codes_NAF)
Codes_NAF$a88 = Codes_NAF$Code_NAF
Codes_NAF$a88 = gsub("'$","",Codes_NAF$a88)
Codes_NAF = Codes_NAF[,.(a88,Nom)]

# 6. Fusionner toutes les tables ensemble
final_table <- Reduce(function(x, y) merge(x, y, by = "a88", all = TRUE),
                      list(Emissions_table,share_sector_workers, share_cities_wide, share_quintile_wide))
final_table[is.na(final_table)] <- 0
final_table <- Reduce(function(x, y) merge(x, y, by = "a88", all = FALSE),
                      list(Codes_NAF,final_table))


# 6. Fusionner toutes les tables ensemble
final_table_new <- Reduce(function(x, y) merge(x, y, by = "a88", all = TRUE),
                          list(Emissions_table, share_sector_workers, share_cities_wide_new, share_quintile_wide_new))
final_table_new[is.na(final_table_new)] <- 0
final_table_new <- Reduce(function(x, y) merge(x, y, by = "a88", all = FALSE),
                          list(Codes_NAF,final_table_new))

final_table_new$share_tot = final_table_new$share
final_table_new <- final_table_new %>%
  select(Nom, a88, emissions_per_worker_CN, share_tot, "rural non périurbain","rural périurbain","urbain intermédiaire","Urbain dense hors Paris","Paris", Q1, Q2, Q3, Q4, Q5, share)


share_pop <- data_uniq[, .(population = sum(.N, na.rm = TRUE)), by = city_type][, share := population / sum(population)]


############## function

# Define a function to aggregate sectors
aggregate_sectors <- function(data, sector_range, new_a88, new_label) {
  formatted_sectors <- sprintf("%02d", sector_range)
  
  aggregated_row <- data %>%
    filter(a88 %in% formatted_sectors) %>%
    summarise(
      Nom = paste(new_label),
      a88 = new_a88,  # New sector label
      emissions_per_worker_CN = sum(emissions_per_worker_CN * share) / sum(share), # Weighted average
      share_tot = sum(share),
      `rural non périurbain` = sum(`rural non périurbain`* share)/share_tot ,
      `rural périurbain` = sum(`rural périurbain` * share)/share_tot,
      `urbain intermédiaire` = sum(`urbain intermédiaire` * share)/share_tot,
      `Urbain dense hors Paris` = sum(`Urbain dense hors Paris` * share)/share_tot,
      Paris = sum(Paris * share)/share_tot,
      Q1 = sum(Q1 * share) /share_tot,Q2 = sum(Q2 * share) /share_tot,Q3 = sum(Q3 * share) /share_tot,Q4 = sum(Q4 * share) /share_tot,Q5 = sum(Q5 * share) /share_tot
    )
  
  return(aggregated_row)
}

# Define a function to aggregate any list of sectors
aggregate_sectors_random <- function(data, sector_list, new_label) {
  # Ensure sectors are character values (already in correct format in your case)
  formatted_sectors <- as.character(sector_list)
  
  aggregated_row <- data %>%
    filter(a88 %in% formatted_sectors) %>%
    summarise(
      Nom = paste("Aggregated Sector", new_label),
      a88 = new_label,  # New sector label
      emissions_per_worker_CN = sum(emissions_per_worker_CN * share) / sum(share), # Weighted average
      share_tot = sum(share),
      `rural non périurbain` = sum(`rural non périurbain`* share)/share_tot ,
      `rural périurbain` = sum(`rural périurbain` * share)/share_tot,
      `urbain intermédiaire` = sum(`urbain intermédiaire` * share)/share_tot,
      `Urbain dense hors Paris` = sum(`Urbain dense hors Paris` * share)/share_tot,
      Paris = sum(Paris * share)/share_tot,
      Q1 = sum(Q1 * share) /share_tot,Q2 = sum(Q2 * share) /share_tot,Q3 = sum(Q3 * share) /share_tot,Q4 = sum(Q4 * share) /share_tot,Q5 = sum(Q5 * share) /share_tot
      
    )
  
  return(aggregated_row)
}


# Example usage:
# Aggregate sectors 10 to 24 and name it "truc"
row_agriculture <- aggregate_sectors(final_table_new, 1:3, "01-03","Agriculture")
H <- c("01","02", "03")
row_agriculture_most <- final_table_new[a88%in%H,]
row_industry <- aggregate_sectors(final_table_new, 5:33, "5-33","Industry")
row_industry_extractives <- aggregate_sectors(final_table_new, 5:9, "5-9","Industry Extractives")
row_industry_manuf <- aggregate_sectors(final_table_new, 10:33, "10-33","Industry Manuf")
H <- c("17","19", "20", "23", "24")
row_industry_manuf_most <- final_table_new[a88%in%H,]
row_energy <- final_table_new[a88%in%"35",]
row_Waste_Water <- aggregate_sectors(final_table_new, 36:39, "36-39","Waste and Water Management")
row_Waste <- aggregate_sectors(final_table_new, 37:39, "37-39","Waste")
row_Construction <- aggregate_sectors(final_table_new, 41:47, "41-47","Construction, Trade and Repairs")
row_transports <- aggregate_sectors(final_table_new, 49:53, "49-53","Transports")
H <- c("49", "50", "51")
row_transports_most <- final_table_new[a88%in%H,]
row_Services <- aggregate_sectors(final_table_new, 55:99, "55-99","Services")
row_Services_most <- final_table_new[a88%in%"77",]



overleaf_table_new <- bind_rows(row_agriculture,
                                row_agriculture_most,
                                row_industry, 
                                row_industry_extractives,
                                row_industry_manuf,
                                row_industry_manuf_most,
                                row_energy,
                                row_Waste_Water,
                                row_Waste,
                                row_Construction,
                                row_transports,
                                row_transports_most, 
                                row_Services, row_Services_most)

overleaf_table_new$share=NULL

latex_table <- xtable(overleaf_table_new)  # No row numbers

# Export to LaTeX format
print(latex_table, type = "latex", comment = FALSE)

############## function Figure 1
# final_table_new <- bind_rows(aggregated_row,final_table_new)


################# Table 7 overleaf
q <- quantile(data_uniq$emissions_per_worker_CN, probs = seq(0, 1, by = 0.1), na.rm = TRUE)
# Extraire les valeurs de a88 pour lesquelles emissions_per_worker_CN > 15
a88_high_emissions <- Emissions_regression[emissions_per_worker_CN > 5, a88]

new_custom_group <- aggregate_sectors_random(final_table_new,a88_high_emissions, "custom_group")

row_all <- aggregate_sectors(final_table_new, 1:99, "1-99","All")

row_agg_table_7 <- data.frame(
  `rural non périurbain` = new_custom_group$share*new_custom_group$`rural non périurbain`/row_all$`rural non périurbain`,
  `rural périurbain` = new_custom_group$share*new_custom_group$`rural périurbain`/row_all$`rural périurbain`,
  `urbain intermédiaire` = new_custom_group$share*new_custom_group$`urbain intermédiaire`/row_all$`urbain intermédiaire`,
  `Urbain dense hors Paris`= new_custom_group$share*new_custom_group$`Urbain dense hors Paris`/row_all$`Urbain dense hors Paris`,
  Paris = new_custom_group$share*new_custom_group$Paris/row_all$Paris,
  Q1 = new_custom_group$share*new_custom_group$Q1/row_all$Q1,
  Q2 = new_custom_group$share*new_custom_group$Q2/row_all$Q2,
  Q3 = new_custom_group$share*new_custom_group$Q3/row_all$Q3,
  Q4 = new_custom_group$share*new_custom_group$Q4/row_all$Q4,
  Q5 = new_custom_group$share*new_custom_group$Q5/row_all$Q5
)



################# Table 6 overleaf
# Define a function to aggregate sectors
aggregate_sectors_Table_6 <- function(data, sector_range, new_a88, new_label) {
  formatted_sectors <- sprintf("%02d", sector_range)
  
  aggregated_row <- data %>%
    filter(a88 %in% formatted_sectors) %>%
    summarise(
      Nom = paste(new_label),
      a88 = new_a88,  # New sector label
      emissions_per_worker_CN = sum(emissions_per_worker_CN * share) / sum(share), # Weighted average
      share_tot = sum(share),
      `rural non périurbain` = sum(`rural non périurbain`) ,
      `rural périurbain` = sum(`rural périurbain`),
      `urbain intermédiaire` = sum(`urbain intermédiaire`),
      `Urbain dense hors Paris` = sum(`Urbain dense hors Paris`),
      Paris = sum(Paris),
      Q1 = sum(Q1),Q2 = sum(Q2),Q3 = sum(Q3),Q4 = sum(Q4),Q5 = sum(Q5)
    )
  
  return(aggregated_row)
}
row_agriculture <- aggregate_sectors_Table_6(final_table, 1:3, "01-03","Agriculture")
row_industry_extractives <- aggregate_sectors_Table_6(final_table, 5:9, "5-9","Industry Extractives")
row_industry_manuf <- aggregate_sectors_Table_6(final_table, 10:33, "10-33","Industry Manuf")
row_energy <- final_table[a88%in%"35",]
row_energy$share_tot = row_energy$share
row_Waste_Water <- aggregate_sectors_Table_6(final_table, 36:39, "36-39","Waste and Water Management")
row_Construction <- aggregate_sectors_Table_6(final_table, 41:47, "41-47","Construction, Trade and Repairs")
row_transports <- aggregate_sectors_Table_6(final_table, 49:53, "49-53","Transports")
row_Services <- aggregate_sectors_Table_6(final_table, 55:99, "55-99","Services")

overleaf_table_new <- bind_rows(row_agriculture,
                                row_industry_extractives,
                                row_industry_manuf,
                                row_energy,
                                row_Waste_Water,
                                row_Construction,
                                row_transports,
                                row_Services)

overleaf_table_new$share=NULL

latex_table <- xtable(overleaf_table_new)  # No row numbers

# Export to LaTeX format
print(latex_table, type = "latex", comment = FALSE)

write.csv(overleaf_table_new, file = "Z:/BTS_Table_6.csv", row.names = FALSE)






################# Table 2
q <- quantile(data_uniq$emissions_per_worker_CN, probs = seq(0, 1, by = 0.1), na.rm = TRUE)
# Extraire les valeurs de a88 pour lesquelles emissions_per_worker_CN > 15
a88_high_emissions <- Emissions_regression[emissions_per_worker_CN > 5, a88]

new_custom_group <- aggregate_sectors_random(final_table_new,a88_high_emissions, "custom_group")

row_all <- aggregate_sectors(final_table_new, 1:99, "1-99","All")

row_agg <- data.frame(
  Rural = new_custom_group$share*new_custom_group$Rural/row_all$Rural,
  `Small cities` = new_custom_group$share*new_custom_group$`Small cities`/row_all$`Small cities`,
  `Medium cities` = new_custom_group$share*new_custom_group$`Medium cities`/row_all$`Medium cities`,
  `Large cities` = new_custom_group$share*new_custom_group$`Large cities`/row_all$`Large cities`,
  Paris = new_custom_group$share*new_custom_group$Paris/row_all$Paris,
  Q1 = new_custom_group$share*new_custom_group$Q1/row_all$Q1,
  Q2 = new_custom_group$share*new_custom_group$Q2/row_all$Q2,
  Q3 = new_custom_group$share*new_custom_group$Q3/row_all$Q3,
  Q4 = new_custom_group$share*new_custom_group$Q4/row_all$Q4,
  Q5 = new_custom_group$share*new_custom_group$Q5/row_all$Q5
)



################# Table 3
new_custom_group <- aggregate_sectors(final_table_new, 55:99, "1-XX","custom")
row_all <- aggregate_sectors(final_table_new, 1:99, "1-99","All")

row_agg <- data.frame(
  Rural = new_custom_group$share*new_custom_group$Rural/row_all$Rural,
  `Small cities` = new_custom_group$share*new_custom_group$`Small cities`/row_all$`Small cities`,
  `Medium cities` = new_custom_group$share*new_custom_group$`Medium cities`/row_all$`Medium cities`,
  `Large cities` = new_custom_group$share*new_custom_group$`Large cities`/row_all$`Large cities`,
  Paris = new_custom_group$share*new_custom_group$Paris/row_all$Paris,
  Q1 = new_custom_group$share*new_custom_group$Q1/row_all$Q1,
  Q2 = new_custom_group$share*new_custom_group$Q2/row_all$Q2,
  Q3 = new_custom_group$share*new_custom_group$Q3/row_all$Q3,
  Q4 = new_custom_group$share*new_custom_group$Q4/row_all$Q4,
  Q5 = new_custom_group$share*new_custom_group$Q5/row_all$Q5
)
round(row_agg,2)





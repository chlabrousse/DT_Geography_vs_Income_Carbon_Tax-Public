library(haven)
library(dplyr)
library(tidyr)
library(ggplot2)
library(data.table)
library(arrow)
library(readxl)

#### DOWNLOAD DATA
s1 = c("IDENT_MEN","pondmen","AGEPR","CATAEU","Patrib","QNIVIE1","DNIVIE1","REVDISP","REVPAT","dom",
       "REVTOT","REVSOC","COEFFUC","TAU","TUU","TYPLOG","TYPMEN5","TYPVOIS","NACTIFS","NPERS","AGEPR","ZEAT", "BIENIM1")

menages <- read_sas("XXXXXX/MENAGE.sas7bdat",  col_select = s1)


s2 = c("IDENT_MEN","C04500","C04511",
       "C04521", "C04522", "C04531", "C04541","C04551", "C07221", 
       "C04111","C04121","C04311","C04321","C04411", "C04431","C04441","C04611", "CTOT")
c05 <- read_sas("XXXXXX/C05.sas7bdat",  col_select = s2)

s3 = c("IDENT_MEN","Stalog")
conso_MEN <- read_sas("XXXXXX/DEPMEN.sas7bdat", col_select = s3)


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

share <- communes_data[, .(population = sum(PMUN22, na.rm = TRUE)), by = city_type][, share := population / sum(population)]

# Note: cette base de données est accessible uniquement sur le CASD
codes_BdF <- read_parquet("XXXX/menages_depcom_densite.parquet")
setDT(codes_BdF)
codes_BdF <- codes_BdF[, .(IDENT_MEN, LIBGEO, DEP)]

communes_BdF <- communes_data[codes_BdF, on = c("LIBGEO", "DEP")]
communes_BdF <- communes_BdF[, .(IDENT_MEN, city_type)]

# merge datasets
data <- merge(menages, c05, by = "IDENT_MEN")
data <- merge(data, conso_MEN, by = "IDENT_MEN")
data <- merge(data, communes_BdF, by = "IDENT_MEN")
rm(menages,c05,s1,s2,conso_MEN,s3)
setDT(data)

data <- data %>%
  filter(!is.na(REVDISP)) %>%
  filter(!is.na(city_type)) %>%
  filter(REVDISP > 0) %>%
  filter(!is.na(CTOT))

share_table <- data[, .(population = sum(pondmen, na.rm = TRUE)),by = city_type][, share := population / sum(population) * 100]
share_table

data[, quintile_REVDISP := ntile(REVDISP, 5)]


# ajouter une colonne
data <- data %>%
  mutate(fossil_fuel =  data$C04521 + data$C04522 + data$C04531 + data$C04541 + data$C04551 + data$C07221 ) %>%
  mutate(electricity =  data$C04500+data$C04511) %>%
  mutate(energy = fossil_fuel + electricity )  %>%
  mutate(fossil_fuel_share =  (data$C04521 + data$C04522 + data$C04531 + data$C04541 + data$C04551 + data$C07221)/data$CTOT*100) %>%
  mutate(electricity_share =  (data$C04500+data$C04511)/data$CTOT*100)%>%
  mutate(energy_share = fossil_fuel_share + electricity_share ) %>%
  mutate(housing_non_energy = data$C04111 + data$C04121 + data$C04311 + data$C04321 + data$C04411 + data$C04431 + data$C04441 + data$C04611)%>%
  mutate(housing_loyer = data$C04111 + data$C04121)


# Figure 2: average energy shares by quintiles
# plot(table(data$QNIVIE1)/length(data$QNIVIE1)*100) # little over-representation of Q1
# plot(table(data$DNIVIE1)/length(data$DNIVIE1)*100) # over-representation of D1
quintiles <- data %>%
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation =  sum(energy*pondmen)/sum(CTOT*pondmen)*100)


quintiles_fossil <- data %>%
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100)


# Convert Cities to a factor with the desired order
data$city_type <- factor(data$city_type, levels = c("rural non périurbain","rural périurbain","urbain intermédiaire","Urbain dense hors Paris","Paris"))

### Summarize the total population for each city type
city_population <- data %>%
  group_by(city_type) %>%
  summarise(total_population = sum(NPERS*pondmen, na.rm = TRUE)) %>%
  mutate(share_of_population = total_population / sum(total_population) * 100)  # Calculate share

geography <- data %>%
  group_by(city_type) %>%
  summarize(moyenne_consommation =  sum(energy*pondmen)/sum(CTOT*pondmen)*100)

# Save the data frame to the specified folder
geography_fossil <- data %>%
  group_by(city_type) %>%
  summarize(moyenne_consommation =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100)




##### Housing non energy
housing_geography <- data %>%
  group_by(city_type) %>%
  summarize(housing_share =  sum(housing_non_energy*pondmen)/sum(CTOT*pondmen)*100)

housing_quintiles <- data %>%
  group_by(QNIVIE1) %>%
  summarize(housing_share =  sum(housing_non_energy*pondmen)/sum(CTOT*pondmen)*100)

housing_both <- data %>%
  group_by(QNIVIE1,city_type) %>%
  summarize(housing_share =  sum(housing_non_energy*pondmen)/sum(CTOT*pondmen)*100)



##### Regression
reg1 <- lm(energy_share ~ REVDISP + city_type, data = data)
summary(reg1)

## s1 = c("IDENT_MEN","pondmen","AGEPR","CATAEU","Patrib","QNIVIE1","DNIVIE1","REVDISP","REVPAT",
##       "REVTOT","REVSOC","Rmini","TAU","TUU","TYPLOG","TYPMEN5","TYPVOIS","NACTIFS","NPERS","AGEPR")


reg2 <- lm(energy_share ~ REVDISP + city_type + AGEPR, data = data)
summary(reg2)

data$Quintile = as.character(data$QNIVIE1)

reg3 <- lm(energy_share ~ Quintile + city_type + AGEPR + NPERS, data = data, weights = pondmen)
summary(reg3)

reg4 <- lm(fossil_fuel_share ~ Quintile + city_type + AGEPR  + NPERS, data = data, weights = pondmen)
summary(reg4)

reg5 <- lm(electricity_share ~ Quintile + city_type + AGEPR  + NPERS, data = data, weights = pondmen)
summary(reg5)



#### Predictions Cities for FIGURES
cities_levels <- unique(data$city_type)

pred_cities_energy <- lapply(cities_levels, function(city) {
  newdata <- data
  newdata$city_type <- city
  newdata$pred <- predict(reg3, newdata)
  mean_pred <- weighted.mean(newdata$pred, newdata$pondmen)
  data.frame(city_type = city, energy_pred = mean_pred)
}) %>% bind_rows()


pred_cities_fossil_fuel <- lapply(cities_levels, function(city) {
  newdata <- data
  newdata$city_type <- city
  newdata$pred <- predict(reg4, newdata)
  mean_pred <- weighted.mean(newdata$pred, newdata$pondmen)
  data.frame(city_type = city, fossil_fuel_pred = mean_pred)
}) %>% bind_rows()


pred_cities_electricity <- lapply(cities_levels, function(city) {
  newdata <- data
  newdata$city_type <- city
  newdata$pred <- predict(reg5, newdata)
  mean_pred <- weighted.mean(newdata$pred, newdata$pondmen)
  data.frame(city_type = city, electricity_pred = mean_pred)
}) %>% bind_rows()


#### Predictions Quintiles for FIGURES
quintile_levels <- unique(data$Quintile)

pred_quintile_energy <- lapply(quintile_levels, function(q) {
  newdata <- data
  newdata$Quintile <- q
  newdata$pred <- predict(reg3, newdata)
  mean_pred <- weighted.mean(newdata$pred, newdata$pondmen)
  data.frame(Quintile = q, energy_share_pred = mean_pred)
}) %>% bind_rows()


pred_quintile_fossil_fuel <- lapply(quintile_levels, function(q) {
  newdata <- data
  newdata$Quintile <- q
  newdata$pred <- predict(reg4, newdata)
  mean_pred <- weighted.mean(newdata$pred, newdata$pondmen)
  data.frame(Quintile = q, fossil_fuel_pred = mean_pred)
}) %>% bind_rows()


###### TABLES
data <- data %>%
  mutate(housing_energy =  data$C04500 + data$C04511 + data$C04521 + data$C04522 + data$C04531 + data$C04541 + data$C04551) %>%
  mutate(transports_energy =  data$C07221) 

quintiles_data <- data %>%
  group_by(QNIVIE1) %>%
  summarize(energy_share =  sum(energy*pondmen)/sum(CTOT*pondmen)*100,
            fossil_share =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100,
            electricity_share =  sum(electricity*pondmen)/sum(CTOT*pondmen)*100,
            housing_energy_share =  sum(housing_energy*pondmen)/sum(CTOT*pondmen)*100,
            transports_energy_share =  sum(transports_energy*pondmen)/sum(CTOT*pondmen)*100)

geography_data <- data %>%
  group_by(city_type) %>%
  summarize(energy_share =  sum(energy*pondmen)/sum(CTOT*pondmen)*100,
            fossil_share =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100,
            electricity_share =  sum(electricity*pondmen)/sum(CTOT*pondmen)*100,
            housing_energy_share =  sum(housing_energy*pondmen)/sum(CTOT*pondmen)*100,
            transports_energy_share =  sum(transports_energy*pondmen)/sum(CTOT*pondmen)*100)

quintiles_data <- quintiles_data %>%
  rename(group = QNIVIE1)

quintiles_data$group = as.character((quintiles_data$group))

geography_data <- geography_data %>%
  rename(group = city_type)

descriptive_table = bind_rows(quintiles_data, geography_data)
descriptive_table
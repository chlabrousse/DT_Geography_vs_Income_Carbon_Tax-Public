library(haven)
library(dplyr)
library(tidyr)
library(ggplot2)
library(data.table)

#### DOWNLOAD DATA
s1 = c("IDENT_MEN","pondmen","AGEPR","CATAEU","Patrib","QNIVIE1","DNIVIE1","REVDISP","REVPAT","dom",
       "REVTOT","REVSOC","COEFFUC","TAU","TUU","TYPLOG","TYPMEN5","TYPVOIS","NACTIFS","NPERS","AGEPR","ZEAT", "BIENIM1")

menages <- read_sas("XXXXXX/MENAGE.sas7bdat",  col_select = s1)

s2 = c("IDENT_MEN","C04500","C04511",
       "C04521", "C04522", "C04531", "C04541","C04551", "C07221", 
       "C04111","C04121","C04311","C04321","C04411", "C04431","C04441","C04611", "CTOT")
c05 <- read_sas("W:/A1610/GEN_A1610170_DDIFFSAS/C05.sas7bdat",  col_select = s2)

s3 = c("IDENT_MEN","Stalog")
conso_MEN <- read_sas("XXXXXX/DEPMEN.sas7bdat", col_select = s3)


# merge datasets
data <- merge(menages, c05, by = "IDENT_MEN")
data <- merge(data, conso_MEN, by = "IDENT_MEN")
rm(menages,c05,s1,s2,conso_MEN,s3)

data <- data %>%
  filter(!is.na(REVDISP)) %>%
  filter(REVDISP > 0) %>%
  filter(!is.na(CTOT))

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


### housing shares
quintiles <- data %>%
  filter(housing_loyer > 0) %>%
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation =  sum(housing_loyer*pondmen)/sum(CTOT*pondmen)*100)

quintiles <- data %>%
  filter(BIENIM1 < 1) %>%
  filter(housing_loyer > 0) %>%
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation =  sum(housing_loyer*pondmen)/sum(CTOT*pondmen)*100)

quintiles <- data %>%
  filter(Stalog %in% c(4, 5, 6)) %>% ## locataire
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation =  sum(housing_loyer*pondmen)/sum(CTOT*pondmen)*100)


# Figure 2: average energy shares by quintiles
quintiles <- data %>%
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation =  sum(energy*pondmen)/sum(CTOT*pondmen)*100,
            moyenne_consommation_euros =  round(sum(energy*pondmen)/sum(pondmen),0) )


# Figure 3: average energy shares by deciles
quintiles_tot <- data %>%
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation_euros =  round(sum(CTOT*pondmen)/sum(pondmen),0) )

quintiles_fossil <- data %>%
  group_by(QNIVIE1) %>%
  summarize(moyenne_consommation =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100,
            moyenne_consommation_euros =  round(sum(fossil_fuel*pondmen)/sum(pondmen),0) )


# Figure 4: average energy shares by geography
data$Cities <- ifelse(data$TUU %in% c('0'), 'Rural', data$TUU)
data$Cities <- ifelse(data$TUU %in% c('1', '2'), 'Small', data$Cities)
data$Cities <- ifelse(data$TUU %in% c('3','4'), 'Medium', data$Cities)
data$Cities <- ifelse(data$TUU %in% c('5','6','7'), 'Large', data$Cities)
data$Cities <- ifelse(data$TUU %in% c('8'), 'Paris', data$Cities)

# Convert Cities to a factor with the desired order
data$Cities <- factor(data$Cities, levels = c("Rural", "Small", "Medium", "Large", "Paris"))

geography <- data %>%
  group_by(Cities) %>%
  summarize(moyenne_consommation =  sum(energy*pondmen)/sum(CTOT*pondmen)*100,
            moyenne_consommation_euros =  round(sum(energy*pondmen)/sum(pondmen),0) )

geography_fossil <- data %>%
  group_by(Cities) %>%
  summarize(moyenne_consommation =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100,
            moyenne_consommation_euros =  round(sum(fossil_fuel*pondmen)/sum(pondmen),0) )

quintiles_geo_fossil_fuel <- data %>%
  group_by(QNIVIE1,Cities) %>%
  summarize(moyenne_consommation =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100)


##### Regressions 
reg1 <- lm(energy_share ~ REVDISP + Cities, data = data)
summary(reg1)

## s1 = c("IDENT_MEN","pondmen","AGEPR","CATAEU","Patrib","QNIVIE1","DNIVIE1","REVDISP","REVPAT",
##       "REVTOT","REVSOC","Rmini","TAU","TUU","TYPLOG","TYPMEN5","TYPVOIS","NACTIFS","NPERS","AGEPR")

reg2 <- lm(energy_share ~ REVDISP + Cities + AGEPR, data = data)
summary(reg2)

data$Quintile = as.character(data$QNIVIE1)

reg3 <- lm(energy_share ~ Quintile + Cities + AGEPR + NPERS, data = data, weights = pondmen)
summary(reg3)

reg4 <- lm(fossil_fuel_share ~ Quintile + Cities + AGEPR  + NPERS, data = data, weights = pondmen)
summary(reg4)

reg5 <- lm(electricity_share ~ Quintile + Cities + AGEPR  + NPERS, data = data, weights = pondmen)
summary(reg5)


#### Predictions Cities for FIGURES
cities_levels <- unique(data$Cities)

pred_cities_energy <- lapply(cities_levels, function(city) {
  newdata <- data
  newdata$Cities <- city
  newdata$pred <- predict(reg3, newdata)
  mean_pred <- weighted.mean(newdata$pred, newdata$pondmen)
  data.frame(Cities = city, energy_pred = mean_pred)
}) %>% bind_rows()


pred_cities_fossil_fuel <- lapply(cities_levels, function(city) {
  newdata <- data
  newdata$Cities <- city
  newdata$pred <- predict(reg4, newdata)
  mean_pred <- weighted.mean(newdata$pred, newdata$pondmen)
  data.frame(Cities = city, fossil_fuel_pred = mean_pred)
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
  group_by(Cities) %>%
  summarize(energy_share =  sum(energy*pondmen)/sum(CTOT*pondmen)*100,
            fossil_share =  sum(fossil_fuel*pondmen)/sum(CTOT*pondmen)*100,
            electricity_share =  sum(electricity*pondmen)/sum(CTOT*pondmen)*100,
            housing_energy_share =  sum(housing_energy*pondmen)/sum(CTOT*pondmen)*100,
            transports_energy_share =  sum(transports_energy*pondmen)/sum(CTOT*pondmen)*100)

quintiles_data <- quintiles_data %>%
  rename(group = QNIVIE1)

quintiles_data$group = as.character((quintiles_data$group))

geography_data <- geography_data %>%
  rename(group = Cities)

descriptive_table = bind_rows(quintiles_data, geography_data)
descriptive_table



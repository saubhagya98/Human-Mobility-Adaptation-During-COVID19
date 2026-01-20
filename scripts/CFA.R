setwd("D:/Internship/Mobility Analysis/FinalPaper")
library(lavaan)
library(psych)
library(readr)
library(dplyr)
library(MVN)
data <- read_csv("a1_dataset.csv")
KMO(data)
model <- '
Factor1 =~  lei_recreational + lei_trips + lei_social_gathering
Factor2 =~  wmot_own_vehicle + w_come_from_home + mot_own_vehicle + w_with_few_known
Factor3  =~ 1*w_work_from_home + w_alone_home
Factor4  =~ 1*fin_atm_city + fin_atm_near
Factor5  =~ 1*wmot_public + mot_public
Factor6  =~  sof_govt_ngo + fin_post_office + sof_fairs
Factor7  =~ 1*mot_bicycle + wmot_bicycle
Factor8  =~ 1*w_with_few_irre_unknown + w_with_large_irre_unknown
Factor9  =~ 1*wmot_hired + mot_hired
Factor10 =~ sof_home_delivery_or_mobile_shops + sof_neighbors + fin_bank_near
Factor10 ~~ Factor10
Factor9 ~~ Factor9
Factor11 =~ 1*wmot_shared + mot_shared_vehi
Factor12 =~ 1*w_come_from_renthouse + wmot_walking
Factor13 =~ 1*sof_online + fin_online_banking
w_come_from_home	~~	w_come_from_renthouse
wmot_own_vehicle	~~	mot_own_vehicle
w_with_few_known	~~	w_come_from_renthouse
fin_atm_city	~~	fin_atm_near
w_come_from_home	~~	wmot_walking
wmot_own_vehicle	~~	wmot_shared
wmot_own_vehicle	~~	wmot_public
w_with_few_known	~~	wmot_walking
lei_trips	~~	fin_online_banking
lei_recreational	~~	fin_online_banking
w_work_from_home	~~	fin_online_banking
w_with_few_known	~~	w_work_from_home
w_come_from_renthouse	~~	wmot_walking
w_come_from_home	~~	w_with_few_known
fin_bank_near	~~	w_come_from_renthouse
wmot_hired	~~	w_come_from_renthouse
wmot_own_vehicle	~~	fin_online_banking
lei_social_gathering	~~	sof_home_delivery_or_mobile_shops
wmot_public	~~	mot_public
w_come_from_home	~~	fin_online_banking
wmot_hired	~~	mot_hired
wmot_own_vehicle	~~	w_come_from_home
mot_own_vehicle	~~	mot_public
lei_social_gathering	~~	sof_fairs
w_alone_home	~~	mot_public
mot_public	~~	sof_home_delivery_or_mobile_shops
lei_social_gathering	~~	fin_post_office
sof_home_delivery_or_mobile_shops	~~	fin_bank_near
fin_post_office	~~	sof_neighbors
w_alone_home	~~	fin_online_banking
wmot_own_vehicle	~~	w_come_from_renthouse
wmot_own_vehicle	~~	wmot_walking
w_with_few_irre_unknown	~~	wmot_walking
w_work_from_home	~~	w_come_from_renthouse
wmot_shared	~~	wmot_walking
mot_public	~~	wmot_walking
wmot_shared	~~	w_come_from_renthouse
w_work_from_home	~~	mot_public
mot_own_vehicle	~~	w_work_from_home
wmot_own_vehicle	~~	mot_public
mot_own_vehicle	~~	fin_post_office
wmot_public	~~	wmot_shared
sof_home_delivery_or_mobile_shops	~~	w_come_from_renthouse
wmot_public	~~	fin_post_office
mot_public	~~	fin_post_office
w_come_from_home	~~	w_work_from_home
wmot_public	~~	mot_bicycle
mot_public	~~	mot_bicycle
mot_public	~~	fin_bank_near
w_work_from_home	~~	w_alone_home
wmot_public	~~	sof_home_delivery_or_mobile_shops
mot_own_vehicle	~~	w_alone_home
lei_social_gathering	~~	fin_bank_near
w_come_from_home	~~	fin_bank_near
mot_public	~~	w_come_from_renthouse
lei_recreational	~~	mot_public
lei_trips	~~	mot_public
mot_own_vehicle	~~	wmot_public
wmot_own_vehicle	~~	w_with_few_known
wmot_public	~~	fin_bank_near'

data_z <- as.data.frame(scale(data))
fit2 <- cfa(model, data = data_z, estimator = "MLR", std.lv = TRUE)
modindices(fit2,sort=TRUE)
summary(fit2,fit.measures=TRUE)
# Extract robust fit indices for your CFA model
library(lavaan)
library(dplyr)
fit_indices <- fitMeasures(fit2, c(
  "cfi.robust",
  "tli.robust",
  "rmsea.robust",
  "rmsea.ci.lower.robust",
  "rmsea.ci.upper.robust",
  "srmr",
  "chisq.scaled",
  "df.scaled"
))
# Compute Chi-square/df
fit_indices["chisq_df_ratio"] <- fit_indices["chisq.scaled"] / fit_indices["df.scaled"]
# Create APA/NHB-style table
robust_table <- data.frame(
  Fit_Index = c("Robust CFI", "Robust TLI","Robust RMSEA [90% CI]",
                "SRMR", "Scaled χ²/df"),
  Value = c(
    sprintf("%.3f", fit_indices["cfi.robust"]),
    sprintf("%.3f", fit_indices["tli.robust"]),
    sprintf("%.3f [%.3f–%.3f]",
            fit_indices["rmsea.robust"],
            fit_indices["rmsea.ci.lower.robust"],
            fit_indices["rmsea.ci.upper.robust"]),
    sprintf("%.3f", fit_indices["srmr"]),
    sprintf("%.2f", fit_indices["chisq_df_ratio"])
  )
)
robust_table

# Test multivariate normality (Mardia’s test)
mardia_test <- mvn(data = data_z, mvnTest = "mardia")
install.packages("MVN")
mardia_test$multivariateNormality
mvn(data = data_z, mvnTest = "hz")
library(dplyr)

adsl <- haven::read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adsl.xpt"))
adae <- haven::read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adae.xpt")) 

adae <- adae %>% 
  filter(AEBODSYS %in% adae$AEBODSYS[1:3])

adas <- haven::read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adadas.xpt"))

adas <- adas %>% 
  filter(PARAMCD == "ACTOT")

adlb <- haven::read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adlbc.xpt"))

adlb <- adlb %>% 
  filter(PARAMCD %in% adlb$PARAMCD[1:4], AVISITN <=6)

saveRDS(adsl, file="./data/adsl.rds")
saveRDS(adae, file="./data/adae.rds")
saveRDS(adas, file="./data/adas.rds")
saveRDS(adlb, file="./data/adlb.rds")

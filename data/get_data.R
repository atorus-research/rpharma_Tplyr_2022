adsl <- haven::read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adsl.xpt"))
adae <- haven::read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adae.xpt"))
adas <- haven::read_xpt(url("https://github.com/phuse-org/TestDataFactory/raw/main/Updated/TDF_ADaM/adadas.xpt"))

saveRDS(adsl, file="./data/adsl.rds")
saveRDS(adae, file="./data/adae.rds")
saveRDS(adas, file="./data/adas.rds")
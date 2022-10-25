library(Tplyr)
library(dplyr)
library(tidyr)

## Read in the Data ----
adsl <- readRDS(file.path('data', 'adsl.rds'))

## If you need help, you can follow these two vignettes: 
## https://atorus-research.github.io/Tplyr/articles/metadata.html
## https://atorus-research.github.io/Tplyr/articles/custom-metadata.html

# Note: Remember that CDISC variable will be uppercase, and R is case sensitive. 

## Problem 1 - Create a demographics table summarizing AGE, AGEGR1, and Race ----
# Summarize data for adsl
# Set the treatment variable to TRT01P
# Filter the table data only for SAFFL == "Y"
# For AGE, set a row label value of "Age (years)"
# For AGEGR1, set a row label value of "Age Group n (%)"
# For RACE, set a row label of "Race n (%)"
t <- 
  
dat <- t %>% build()
dat


## Problem 2 - Using the same table produced above, build the Tplyr metadata, then examine the metadata dataframe ----
# Use the metadata=TRUE argument on build
# Use get_metadata() to look at the table metadata
t <- 

dat <- 
meta <- 
meta


## Problem 3 - Using the table produced above, look at a metadata object ----
# Find the row_id for Placebo subjects with a RACE of BLACK OR AFRICAN AMERICAN
# Use get_meta_result() to extract the tplyr_meta() object
# Helper to find the correct row_id
dat %>%
  filter(row_label2 == "BLACK OR AFRICAN AMERICAN")

result <- 
result

## Problem 4 - Using the same information as above, look at the relevant subset of data ----
# Choose the same row_id and use the function get_meta_subset()
# Helper to find the correct row_id
dat %>%
  filter(row_label2 == "BLACK OR AFRICAN AMERICAN")

sub <- 
sub

######## Problem 5 continues down below - this is some pre-work necessary for remaining questions ----
adsl <- readRDS(file.path('data', 'adsl.rds'))
adas <- readRDS(file.path('data', 'adas.rds'))

# This table code is to support the primary efficacy table for CDISC Pilot table 14-3.01
t <- tplyr_table(adas, TRTP, where=EFFFL == "Y" & ITTFL == "Y" & PARAMCD == "ACTOT" & ANL01FL == "Y") %>%
  set_pop_data(adsl) %>%
  set_pop_treat_var(TRT01P) %>%
  set_pop_where(EFFFL == "Y" & ITTFL == "Y") %>%
  set_distinct_by(USUBJID) %>%
  set_desc_layer_formats(
    'n' = f_str('xx', n),
    'Mean (SD)' = f_str('xx.x (xx.xx)', mean, sd),
    'Median (Range)' = f_str('xx.x (xxx;xx)', median, min, max)
  ) %>%
  add_layer(
    group_desc(AVAL, where= AVISITN ==  0, by = "Baseline")
  ) %>%
  add_layer(
    group_desc(AVAL, where= AVISITN == 24, by = "Week 24")
  ) %>%
  add_layer(
    group_desc(CHG,  where= AVISITN == 24, by = "Change from Baseline")
  )

sum_data <- t %>%
  build(metadata=TRUE) %>%
  apply_row_masks() %>%
  select(row_id, starts_with('row_label'),
         var1_Placebo, `var1_Xanomeline Low Dose`, `var1_Xanomeline High Dose`)

# I don't need the full model code for this example so just mock it up.
# But if you want to see it, it's available here:
# https://github.com/RConsortium/submissions-pilot1/blob/694a207aca7e419513ffe16f6f5873526da1bdcb/R/eff_models.R#L17
model_portion <- tibble::tribble(
  ~"row_id",  ~"row_label1",                       ~"var1_Xanomeline Low Dose", ~"var1_Xanomeline High Dose",
  "x4_1",    "p-value(Dose Response) [1][2]",      "",                          "0.245",
  "x4_3",    "p-value(Xan - Placebo) [1][3]",	    "0.569",    	               "0.233",
  "x4_4",    "   Diff of LS Means (SE)",           "-0.5 (0.82)",               "-1.0 (0.84)",
  "x4_5",    "   95% CI",                          "(-2.1;1.1)",                "(-2.7;0.7)",
  "x4_7",    "p-value(Xan High - Xan Low) [1][3]", "",                          "0.520",
  "x4_8",    "   Diff of LS Means (SE)",           "",                          "-0.5 (0.84)",
  "x4_9",    "   95% CI",                          "",                          "(-2.2;1.1)"
)

results <- bind_rows(sum_data, model_portion) %>%
  mutate(
    across(where(is.character), ~ replace_na(., ""))
  )

### End pre-work ----
## Problem 5 - Create a tplyr_meta() object, then create three other tplyr_meta objects by expanding the first one ----
# Create a tplyr_meta object 
#   - Set the name to TRTP, EFFFL, ITTFL, ANL01FL, SITEGR1, AVISIT, AVISITN, PARAMCD, AVAL, BASE, CHG
#   - Set the filters to EFFFL == "Y", ITTFL == "Y", PARAMCD == "ACTOT", ANL01FL == "Y", AVISITN == 24
# Note: Remember to use the quos() function when supplying names and filters.
# Create the second tplyr_meta() object by adding the filter `TRTP %in% c("Xanomeline High Dose", "Placebo")`
# Create the third tplyr_meta() object by adding the filter `TRTP %in% c("Xanomeline Low Dose", "Placebo")`
# Create the fourth tplyr_meta object by adding the filter `TRTP %in% c("Xanomeline High Dose", "Xanomeline Low Dose")`
meta <- 

# Xan High / Placebo contrast
meta_xhp <- 

# Xan Low / Placbo Contrast
meta_xlp <- 

# Xan High / Xan Low Contrast
meta_xlh <- 

## Problem 6 - Create a metadata dataframe and bind it to the Tplyr table's metadata
# The metadata dataframe is pre-prepared for you
# Use append metadata to bind it to the Tplyr tables metadata
# View the updated metadata using get_metadata()
eff_meta <- tibble::tribble(
  ~"row_id",  ~"row_label1",                       ~"var1_Xanomeline Low Dose", ~"var1_Xanomeline High Dose",
  "x4_1",    "p-value(Dose Response) [1][2]",      NULL,                        meta,
  "x4_3",    "p-value(Xan - Placebo) [1][3]",	     meta_xlp,    	              meta_xhp,
  "x4_4",    "   Diff of LS Means (SE)",           meta_xlp,                    meta_xhp,
  "x4_5",    "   95% CI",                          meta_xlp,                    meta_xhp,
  "x4_7",    "p-value(Xan High - Xan Low) [1][3]", NULL,                        meta_xlh,
  "x4_8",    "   Diff of LS Means (SE)",           NULL,                        meta_xlh,
  "x4_9",    "   95% CI",                          NULL,                        meta_xlh
)

t <- 
new_meta <- 
new_meta
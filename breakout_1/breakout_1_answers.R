library(Tplyr)

## Read in the Data ----
adsl <- readRDS(here::here('data', 'adsl.rds'))

## If you need help, you can follow the Get Started vignette right here: 
## https://atorus-research.github.io/Tplyr/articles/Tplyr.html

# Note: Remember that CDISC variable will be uppercase, and R is case sensitive. 

## Problem 1 - Create a `tplyr_table` object and inspect the table object ----
# Set the target dataset to adsl
# Set the treatment variable to TRT01P
# Assign the Tplyr table to an object named `t`

t <- tplyr_table(adsl, TRT01P) 
t

## Problem 2 - Attach a count layer to the Tplyr table ----
# Use the same Tplyr table from problem 1
# Add a count layer summarizing the variable AGEGR1
# Assign the row label using the `by` parameter to the value "Age categories in n (%)"
# Inspect your Tplyr table object again

t <- tplyr_table(adsl, TRT01P) %>% 
  add_layer(
    group_count(AGEGR1, by = "Age categories in n (%)")
  )
t

## Problem 3 - Attach a descriptive statistics layer to the Tplyr table ----
# Use the same Tplyr table from problem 2
# Add a desc layer summarizing the variable AGE
# Assign the row label using the `by` parameter to the value "Age (years)"
# Inspect your Tplyr table object again

t <- tplyr_table(adsl, TRT01P) %>% 
  add_layer(
    group_desc(AGE, by = "Age (years)")
  )
t

## Problem 4 - Combine the tables from problem 2 and problem 3 to make a 2 layer table ----
# Add a count layer summarizing the variable AGEGR1 from problem 2
# Add a desc layer summarizing the variable AGE from problem 3
# Inspect your Tplyr table object again

t <- tplyr_table(adsl, TRT01P) %>% 
  add_layer(
    group_count(AGEGR1, by = "Age categories in n (%)")
  ) %>%
  add_layer(
    group_desc(AGE, by = "Age (years)")
  )
t

## Problem 5 - Build the table from problem 4 and inspect the resulting dataframe ----
# Use the `build()` function to get the resulting dataframe from the Tpylr table
t <- tplyr_table(adsl, TRT01P) %>% 
  add_layer(
    group_count(AGEGR1, by = "Age categories in n (%)")
  ) %>%
  add_layer(
    group_desc(AGE, by = "Age (years)")
  )

dat <- t %>% build()
dat

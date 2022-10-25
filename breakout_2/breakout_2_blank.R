library(Tplyr)

## Read in the Data ----
adsl <- readRDS(here::here('data', 'adsl.rds'))
adae <- readRDS(here::here('data', 'adae.rds'))
adlb <- readRDS(here::here('data', 'adlb.rds'))

## If you need help, you can follow the Get Started vignette right here: 
## https://atorus-research.github.io/Tplyr/articles/Tplyr.html

# Note: Remember that CDISC variable will be uppercase, and R is case sensitive. 

## Problem 1 - Create descriptive statistics for AVAL in ADLB by AVISIT and PARAMCD where SAFFL is "Y", Display columns by SEX ----
# Set the target to ADLB
# Set the treatment variable to TRTA
# Set the table `where` to SAFFL == "Y"
# Set the columns to SEX
# Add a desc layer
# Set the target variable to AVAL
# Set the by variables to AVISIT and PARAMCD
t <- 

dat <- t %>% 
  build()
dat

##  Problem 2 - Using the above table, change the presentation of the data ----
# Help here: https://atorus-research.github.io/Tplyr/articles/desc.html#formatting
# On one row, present Mean
# On another row, present Q1, Median, and Q3
# 
t <- 
  
dat <- t %>% 
  build()
dat

## Problem 3 - Summarize AEDECOD from adae and use denominators from the population data ----
# Help here: https://atorus-research.github.io/Tplyr/articles/count.html#distinct-versus-event-counts
# Create a Tplyr table using data from adae
# Set the treatment variable to TRTA
# Set the population data to adsl
# Set the population treatment variable to TRT01A
# Add a count layer summarize AEDECOD
# Set distinct by USUBJID
# Summarize subjects who had an AE, the percentage of subjects in that treatment group who had the AE, and the number of events
t <- 

dat <- t %>% build()
dat
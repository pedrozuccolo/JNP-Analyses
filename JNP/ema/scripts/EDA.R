# Jovens na Pandemia - EMA - Exploratory data analyses

# set working dir
setwd('/Users/pedrozuccolo/Desktop/RADAR-Analyses/JNP/ema')



# Load packages
library(dplyr)
library(lubridate)



# Load esm_jnp dataset from dataset_build.R
source('scripts/dataset_build.R')


# check
str(esm_jnp)



# EDA
## How many observations are there in the dataset?
nrow(esm_jnp)

## How many participants contributed with data?
n_distinct(esm_jnp$id)

## How many responses from the parents and how many from adolescents
## 4 times a day per 6 days, twice. So, there were 147 * 48 = 7056 opportunities to respond
table(recode(esm_jnp$respondent, 'c' = "Adolescent", 'p' = 'Parent'))

## In adolescents, how many observations per subject?
## Count observations per subject
subject_counts <- esm_jnp %>%
  filter(respondent == "c") %>%
  group_by(id) %>%
  tally(name = "observation_count")

# Print the counts for each subject
print(subject_counts, n=147)

# Compute and print the statistics based on counts
stats <- subject_counts %>%
  summarise(
    max_responses = max(observation_count),
    min_responses = min(observation_count),
    mean_responses = mean(observation_count),
    median_responses = median(observation_count)
  )

print(stats)

#What is the most frequent value
mode_value <- subject_counts %>%
  group_by(observation_count) %>%
  tally() %>%
  arrange(desc(n)) %>%
  slice(1) %>%
  pull(observation_count)

print(paste("Mode:", mode_value))

## How many adolescents responded more than 30 times?
table(subject_counts$observation_count)



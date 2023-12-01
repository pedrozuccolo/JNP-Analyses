# Jovens na Pandemia - EMA dataset build"

# This script creates dataframes to analyse EMA obtained from participants 



#set working dir
setwd('/Users/pedrozuccolo/Desktop/RADAR-Analyses/JNP/ema')



#Load packages 
library(dplyr)
library(lubridate)
library(stringr)



#Load datasets 
## randomization dataset
participants <- read.csv("data/randomizationJun23.csv")


## ids from redcap (unprocessed) and comvc codes
comvc_ids <- read.csv("data/idcomvc_idredcap.csv")


## promis dataset
ema_jnp <- read.csv("data/comv_ema_Jun23.csv")



# Dataframe preparation
## merge comvc_ids and ema_jnp
ema_jnp <- merge(ema_jnp, comvc_ids, by = "Código", all.x = TRUE) %>%
  mutate(
    id = as.numeric(str_extract(record_id, "^\\d+")), # Extract the number part of id and make it a number
    respondent = case_when( # create variable that differentiate responses from parents and children/adolescents
      str_detect(record_id, "p") ~ "p", # If "p" is present
      str_detect(record_id, "f") ~ "c", # If "f" is present
      TRUE ~ NA_character_  # Else
    ),
    Data = as.POSIXct(Data, format = "%d/%m/%Y - %H:%M:%S", tz = "America/Sao_Paulo")
  )


##clean randomization dataset
participants_clean <- participants %>%
  select(id, avaliação, X, tria_dn_filho, tria_idd_filho, tria_rcads_total_tscore, grupo) %>% # select important variables
  rename(sex = X, init_assess_date = avaliação) %>% #rename variables
  mutate(
    id = as.numeric(str_extract(id, "^\\d+")), #extract number part from id and make it numeric
    init_assess_date = dmy(init_assess_date), #convert init_assess_date to datetime
    tria_dn_filho = dmy(tria_dn_filho) #convert dn_filho to datetime
  ) %>%
  filter(id %in% ema_jnp$id) #filter for participants who collected EMA data


##merge participants_clean and ema_jnp by id
esm_jnp <- merge(participants_clean, ema_jnp, by = "id", how = TRUE) %>%
  select(-Código, -record_id, -Missings, -E.Mail) %>%
  rename(assessment_date = Data, 
         group = grupo, 
         date_of_birth = tria_dn_filho, 
         age = tria_idd_filho
  ) 

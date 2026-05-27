# ==============================================================================
# BITS Meeting - Travel Grant assignment
# Author: Alice Romeo
# ==============================================================================

# 1. Load Libraries ------------------------------------------------------------
library(tidyverse)
library(readxl)
library(writexl)
library(lubridate)

# 2. Configuration -------------------------------------------------------------
INPUT_FILE  <- "input_data.xls" 
OUTPUT_FILE <- "TG.xlsx"
AGE_THRESHOLD <- 35
SCORE_THRESHOLD <- 3

# 3. Input data ----------------------------------------------------------------
input_data <- read_xls(INPUT_FILE)

processed_data <- input_data %>% 
  mutate(
    DataNascita = as.Date(DataNascita),
    anno_nascita = year(DataNascita),
    age = year(Sys.Date()) - anno_nascita,
    `Abs Type` = factor(`Abs Type`, levels = c("Oral communication", "Poster")), 
    Membership = factor(Membership, levels = c("BITS member", "applied", "none"))
  )

summary(processed_data)

# 4. Ranking -------------------------------------------------------------------
eligible <- processed_data %>%
  
# 1. average score of at least 3 out of 5
#  filter(`Abs Rate` >= SCORE_THRESHOLD) %>%
  
# 2. priority (1, 2, 3, 4, 5 rounds)
  mutate(
  priority = case_when(
    # age < 35, bits member, no past Travel Grants
    (age < AGE_THRESHOLD & Membership == "BITS member" & `Past-TG`== "N" & `Abs Rate` >= SCORE_THRESHOLD) ~ 1, 
    # other applicants, bits member, no past Travel Grants
    (age >= AGE_THRESHOLD & Membership == "BITS member" & `Past-TG`== "N" & `Abs Rate` >= SCORE_THRESHOLD) ~ 2,
    # new member, no past Travel Grants
    (Membership == "applied" & `Past-TG`== "N" & `Abs Rate` >= SCORE_THRESHOLD) ~ 3,
    # other, no past Travel Grants
    (Membership == "none" & `Past-TG`== "N" & `Abs Rate` >= SCORE_THRESHOLD) ~ 4,
    # past Travel Grants
    (`Past-TG`== "Y" & `Abs Rate` >= SCORE_THRESHOLD) ~ 5 ,
    `Abs Rate` < SCORE_THRESHOLD ~ 6,
    TRUE ~ 7 # fallback
  )
) %>% 
  arrange(priority, Membership, desc(`Abs Rate`), `Abs Type`) %>%
  select(
    Nominativo, Email, `Abs Rate`, `Abs Title`, `Abs Type`, 
    DataNascita, age, Membership, `Past-TG`, priority, Note
    )

# 5. Output Generation ---------------------------------------------------------
sheets_list <- list(
  "eligible"   = eligible,
  "1st - BITS member u35" = eligible %>% filter(priority == 1),
  "2nd - other BITS member" = eligible %>% filter(priority == 2),
  "3rd - applied" = eligible %>% filter(priority == 3),
  "4th - other" = eligible %>% filter(priority == 4),
  "5th - past TG" = eligible %>% filter(priority == 5),
  "excluded" = eligible %>% filter(priority == 6)
)

write_xlsx(sheets_list, OUTPUT_FILE)

# Manual check:
# - Each research group may have only one attendee awarded a travel grant (highest-scoring)
# - Within each round, if there are applicants with the same score, priority will be given to 
# researchers who have participated in previous BITS meetings and have not previously received 
# a BITS Travel Grant.


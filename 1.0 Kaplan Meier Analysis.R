# 0. Install and load packages
install.packages("survival")
install.packages("readxl")
install.packages("writexl")
install.packages("base")
library(survival)
library(ggplot2)
library(readxl)
library(writexl)
library(base)

# 1: Import mock data
file_path <- "[hidden]"
encounter_data <- read_excel(file_path)

# 2: Create two cohorts based on the occurrence of medication-related events
cohort_A <- subset(encounter_data, `Number of Medication-Related Events` > 0)
cohort_B <- subset(encounter_data, `Number of Medication-Related Events` = 0)

# 3: Create index date based on admission date
index_date_A <- cohort_A$`Admission date-time`
index_date_B <- cohort_B$`Admission date-time`

# 4: Create time from index date to end of stay (death or discharge)
# Assuming 'death_date' is the death date column
time_A <- cohort_A$`Length of stay`
time_B <- cohort_B$`Length of stay`

# 5: Run KM analysis
km_A <- survfit(Surv(time_A, event = cohort_A$`Died during admission`) ~ 1)
km_B <- survfit(Surv(time_B, event = cohort_B$`Died during admission`) ~ 1)

# 6. Extract and summarize KM outputs
summary_A <- summary(km_A)
summary_B <- summary(km_B)

df_summary_A <- data.frame(time = summary_A$time, surv = summary_A$surv, n.risk = summary_A$n.risk)
df_summary_B <- data.frame(time = summary_B$time, surv = summary_B$surv, n.risk = summary_B$n.risk)

# 7, Export to excel
write_xlsx(list(Cohort_A = df_summary_A, Cohort_B = df_summary_B), 
           path = "fkm_output.xlsx")

# 1. Reading data
library(tidyverse)
trust_data <- read.csv("OECD Trust 2010-2023.csv")
unemployment_data <- read.csv("Unemployment 2010-2023.csv")

# 2. Merging
trust_clean <- trust_data %>%
  select(Country = `Reference.area`,
         Year = TIME_PERIOD,
         Trust_Score = OBS_VALUE) %>%
  mutate(Country = recode(Country, "Slovak Republic" = "Slovakia"))
unemp_clean <- unemployment_data %>%
  select(Country = Geopolitical.entity..reporting.,
         Year = TIME_PERIOD,
         Unemployment_Rate = OBS_VALUE)
merged_data <- inner_join(trust_clean, unemp_clean, by = c("Country", "Year"))
# write_csv(merged_data, "Trust Unemployment Merged.csv")

# The data is already cleaned



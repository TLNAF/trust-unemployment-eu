# install.packages("fixest")
# install.packages("modelsummary")
# install.packages("flextable")
library(tidyverse)
library(fixest)
library(modelsummary)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# 1. Reading data
trust_data <- read.csv("OECD Trust 2010-2023.csv")
unemployment_data <- read.csv("Unemployment 2010-2023.csv")
gdp_raw <- read.csv("OECD GDP 2010-2023.csv")
inflation_raw <- read.csv("Inflation 2010-2023.csv")

# 2. Merging and cleaning
# 2.1. Cleaning Trust data:
trust_clean <- trust_data %>%
  select(Country = `Reference.area`,
         Year = TIME_PERIOD,
         Trust_Score = OBS_VALUE) %>%
  mutate(Country = recode(Country, "Slovak Republic" = "Slovakia"))

# 2.2. Cleaning Unemployment data:
unemp_clean <- unemployment_data %>%
  select(Country = Geopolitical.entity..reporting.,
         Year = TIME_PERIOD,
         Unemployment_Rate = OBS_VALUE)

# 2.3. Cleaning GDP data:
gdp_clean <- gdp_raw %>%
  filter(Price.base == "Chain linked volume (rebased)") %>%
  select(Country = Reference.area,
         Year = TIME_PERIOD,
         GDP_per_capita = OBS_VALUE)  %>%
  mutate(Country = ifelse(Country == "Slovak Republic", "Slovakia", Country))

# 2.4. Cleaning Inflation data:
inflation_clean <- inflation_raw %>%
  filter(Transformation == "Growth rate, over 1 year") %>%
  select(Country = Reference.area,
         Year = TIME_PERIOD,
         Inflation_Rate = OBS_VALUE) %>%
  mutate(Country = ifelse(Country == "Slovak Republic", "Slovakia", Country))

# 2.5. Merging data
merged_data <- trust_clean %>%
  inner_join(unemp_clean, by = c("Country", "Year")) %>%
  inner_join(gdp_clean, by = c("Country", "Year")) %>%
  inner_join(inflation_clean, by = c("Country", "Year"))

# 3. Sorting:
merged_data <- merged_data %>%
  arrange(Country, Year)

# 4. Plotting Unemployment vs. Trust:
merged_data %>%
  filter(Year == 2023) %>%
  ggplot(aes(x = Unemployment_Rate, y = Trust_Score)) +
  geom_point(size = 3, color = "steelblue") +
  geom_text(aes(label = Country), vjust = -1, size = 3) +
  geom_smooth(method = "lm", color = "red", linetype = "dashed", se = FALSE) +
  theme_minimal() +
  labs(title = "Trust vs. Unemployment (2023)",
       x = "Unemployment Rate (%)",
       y = "Trust Score (%)") +
  ylim(0, 100)

# 5. Calculate correlation:
correlation_res <- cor.test(merged_data$Unemployment_Rate, merged_data$Trust_Score)
print(correlation_res)

# 6. Linear regression (with and without controls):
ols_simple <- lm(Trust_Score ~ Unemployment_Rate, data = merged_data)
ols_full <- lm(Trust_Score ~ Unemployment_Rate + log(GDP_per_capita) + Inflation_Rate, 
                         data = merged_data)
summary(ols_full)

# 7. Fixed effects:
fe_model <- feols(Trust_Score ~ Unemployment_Rate + log(GDP_per_capita) + Inflation_Rate | Country + Year,
                  data = merged_data)
summary(fe_model)

# 8. Models summary:
models <- list(
  "Baseline" = ols_simple,
  "OLS with controls" = ols_full,
  "Two-way FE" = fe_model
)

modelsummary(models,
             stars = TRUE,
             output = "regression_table.tex",
             gof_omit = "IC|Log|Adj")
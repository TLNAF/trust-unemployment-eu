# Replication Package
## Unemployment and Institutional Trust in Europe

**Authors**: Quoc Viet Tran, Vladimir Litvinov, Daniel Jenkin, Theodor Tchipev  
**Course**: ECO_1S002_EP - Topics in Applied Econometrics  
**Institution**: *École Polytechnique* - Institut Polytechnique de Paris  
**Date**: May 2026

---

## Data Sources

The project combines publicly available datasets from the **OECD** and **Eurostat**.

### Trust in Government
Source: OECD  
Link: [OECD Trust in Government Dataset](https://data-viewer.oecd.org/?chartId=1e4ae76e-1025-45a4-a4a4-01a6f8ac6dc5&utm_source=chatgpt.com)

### Unemployment Rate
Source: Eurostat  
Link: [Eurostat Unemployment Dataset](https://ec.europa.eu/eurostat/databrowser/bookmark/765c3aea-33ca-453f-949e-769d4428e909?lang=en&createdAt=2026-05-14T13%3A18%3A43Z&utm_source=chatgpt.com)

### GDP per Capita
Source: OECD  
Link: [OECD GDP Dataset](https://data-viewer.oecd.org?chartId=5dfb3665-8cbd-407a-8816-ed8d6f795b17&utm_source=chatgpt.com)

### Inflation
Source: OECD  
Link: [OECD Inflation Dataset](https://data-viewer.oecd.org/?chartId=ae4352b5-c294-4421-a2a8-9c719ea9778d&utm_source=chatgpt.com)

---

## Variables

| Variable | Description |
|---|---|
| `Trust_Score` | Percentage of population reporting trust in government |
| `Unemployment_Rate` | Unemployment rate (% of labour force) |
| `GDP_per_capita` | Real GDP per capita (chain-linked volume) |
| `Inflation_Rate` | Annual inflation rate (%) |
| `Country` | Country identifier |
| `Year` | Observation year |

---

## Project Structure

```text
project/
├── data/
│   ├── OECD Trust 2010-2023.csv
│   ├── Unemployment 2010-2023.csv
│   ├── OECD GDP 2010-2023.csv
│   └── Inflation 2010-2023.csv
├── code/
│   └── analysis.R
├── output/
│   ├── trust_unemployment_plot.png
│   └── regression_table.tex
├── research_paper.tex
└── README.md
```
---

## Replication Instructions

### Requirements

This project is implemented in R. The following packages are required:

```r
install.packages(c("tidyverse", "fixest", "modelsummary", "rstudioapi"))
```

---

## Output Files

| File | Description |
|---|---|
| `trust_unemployment_plot.png` | Scatter plot of unemployment vs trust (2022) |
| `regression_table.tex` | Regression results (OLS + FE models) |

## Project Workflow

1. Import raw OECD and Eurostat datasets  
2. Clean and standardize country names and variables  
3. Merge datasets into a balanced panel  
4. Produce descriptive analysis (scatter plot + correlation)  
5. Estimate OLS regressions  
6. Estimate two-way fixed effects model  
7. Export regression table and figures

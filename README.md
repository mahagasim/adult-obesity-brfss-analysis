# Factors Influencing Adult Obesity in the United States

An applied health-data science analysis of adult obesity using the **2022 Behavioral Risk Factor Surveillance System (BRFSS)**. The project examines demographic, socioeconomic, behavioral, and health correlates of obesity and compares several regression frameworks for binary and ordered BMI outcomes.

> **Project context:** This repository is a cleaned, reproducible portfolio version of a 2023/24 Health Data Science course group project (EM1413). The original project was completed by **Maha Gasim, Amal Ahmed, and Arnela Halili**. Repository curation and reproducibility refactoring were completed by Maha Gasim.

## Research question

Which demographic, socioeconomic, behavioral, and health characteristics are associated with adult obesity in the United States, and how much does baseline obesity risk vary across states?

## Data

The original analysis used the **2022 BRFSS**. A Stata preprocessing step retained 15 variables from the working BRFSS file before the analysis continued in R.

The course report started from **445,132 observations** in the reduced BRFSS extract. After complete-case filtering and removal of survey-specific nonresponse codes used in the original workflow, the modelling dataset contained **39,551 observations**.

Raw BRFSS files are intentionally not stored in this repository. See [`data/README.md`](data/README.md) for the expected inputs and provenance.

## Methods

The repository reproduces the analytical scope of the submitted course project:

1. **Data preparation**
   - variable selection in Stata;
   - complete-case filtering;
   - removal of selected nonresponse/refusal codes;
   - recoding of age, education, income, sex, marital status, employment status, diabetes, heart disease, and state;
   - binary obesity indicator based on the BRFSS BMI category.
2. **Exploratory analysis**
   - distributions of demographic and health variables;
   - state-level obesity rates;
   - contingency, joint-probability, and conditional-probability tables.
3. **Binary logistic regression**
   - age-only model;
   - multivariable obesity model;
   - sex and income model.
4. **Multinomial logistic regression**
   - four-category BMI outcome.
5. **Ordinal logistic regression**
   - nested model comparison using AIC and BIC.
6. **Generalized linear mixed model (GLMM)**
   - logistic mixed model with a state-level random intercept.

## Repository structure

```text
adult-obesity-brfss-analysis/
├── README.md
├── AUTHORS.md
├── .gitignore
├── run_analysis.R
├── stata/
│   └── 01_extract_brfss.do
├── R/
│   ├── 00_packages.R
│   ├── 01_prepare_data.R
│   ├── 02_descriptive_analysis.R
│   └── 03_models.R
├── analysis/
│   └── obesity_analysis.Rmd
├── data/
│   ├── README.md
│   └── sample/
│       └── filtered_data_sample.csv
├── docs/
│   ├── methodology.md
│   └── source_inventory.md
└── results/
    └── README.md
```

## Reproducing the analysis

### Option A — use the prepared analysis dataset

Place the full `filtered_data.csv` produced by the original workflow at:

```text
data/processed/filtered_data.csv
```

Then run:

```r
source("run_analysis.R")
```

### Option B — rebuild from the reduced BRFSS extract

Place `Demo+Health data.dta` or `Demo+Health data.xlsx` in `data/raw/`. The Stata extraction script documents how the reduced file was created from the BRFSS working data, and the R preparation script applies the recoding/filtering used in the final report.

The small file under `data/sample/` is for code inspection and smoke testing only; it is **not intended for statistical inference**.

## Selected findings from the submitted report

The submitted analysis identified **North Dakota, Wisconsin, and Iowa** among the states with the highest observed obesity rates in the filtered dataset. In the mixed-effects model, the reported state random-intercept variance was approximately **0.016** (SD ≈ **0.127**), indicating modest between-state variation in baseline obesity odds.

These are results from the original course analysis and should be interpreted in that context.

## Methodological note

This repository preserves the modelling scope of the submitted project. The original code did **not** implement BRFSS survey-weighted estimation. The refactor therefore does not present the models as population-representative survey estimates; it focuses on transparent reproduction of the original applied modelling workflow.

## Skills demonstrated

- R / RMarkdown
- Stata
- health survey data preparation
- data cleaning and recoding
- exploratory data analysis and visualization
- binary logistic regression
- multinomial logistic regression
- ordinal logistic regression
- mixed-effects logistic regression (`glmmTMB`)
- model comparison with AIC/BIC
- reproducible project organization

## Attribution

See [`AUTHORS.md`](AUTHORS.md). The repository deliberately preserves the group-project attribution rather than presenting the original coursework as sole-authored work.

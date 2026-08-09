# Factors Influencing Adult Obesity in the United States

An applied health-data science analysis of adult obesity using the **2022 Behavioral Risk Factor Surveillance System (BRFSS)**. I examine demographic, socioeconomic, behavioral, and health correlates of obesity and compare several regression frameworks for binary and ordered BMI outcomes.

> **Project context:** I completed this project during the 2023/24 **Health Data Science (EM1413)** course as a group project with **Amal Ahmed and Arnela Halili**. I later reorganized the original coursework into this GitHub portfolio version to make the workflow clearer, reproducible, and easier to review.

## Results at a glance

The final modelling sample contained **39,551 observations across 54 state/territory groups**. The descriptive results show meaningful variation in observed obesity prevalence across age, sex, income, and geography.

### Descriptive analysis

![Observed obesity rate by age group](results/figures/obesity_by_age.svg)

Observed obesity was lowest among adults aged **18–29 (30.1%)**, rose through middle age, peaked among those aged **40–54 (44.9%)**, and declined among adults aged **70+ (33.5%)** in the filtered analytical sample.

![Observed obesity rate by sex](results/figures/obesity_by_sex.svg)

Women had a higher observed obesity rate (**42.3%**) than men (**37.4%**) in the filtered sample.

![Highest observed obesity rates by state](results/figures/top_states_obesity.svg)

The five highest observed state-level obesity rates in the analytical sample were **North Dakota (48.4%)**, **Wisconsin (47.0%)**, **Iowa (46.8%)**, **Kentucky (46.2%)**, and **Ohio (45.5%)**.

### Model analysis

I fitted and compared **eight model objects** across binary logistic, multinomial logistic, ordinal logistic, and mixed-effects frameworks. The final generalized linear mixed model estimated obesity using demographic, socioeconomic, behavioral, and health covariates with a **state-level random intercept**.

![Selected GLMM odds ratios](results/figures/glmm_selected_odds_ratios.svg)

Selected reported GLMM estimates:

| Predictor | Odds ratio | 95% CI | Interpretation |
|---|---:|---:|---|
| Age 30–39 vs 18–29 | 1.39 | 1.26–1.54 | Higher odds of obesity |
| Age 40–54 vs 18–29 | 1.41 | 1.27–1.56 | Higher odds of obesity |
| Age 55–69 vs 18–29 | 1.07 | 0.96–1.19 | CI crosses 1 |
| Age 70+ vs 18–29 | 0.65 | 0.57–0.73 | Lower odds of obesity |
| General health: very good vs excellent | 1.46 | 1.29–1.66 | Higher odds of obesity |
| General health: good vs excellent | 2.57 | 2.28–2.89 | Higher odds of obesity |
| General health: fair vs excellent | 2.89 | 2.55–3.26 | Higher odds of obesity |
| General health: poor vs excellent | 2.34 | 2.05–2.67 | Higher odds of obesity |

The reported state random-intercept variance was **0.0157** (SD **0.1255**) with an ICC of approximately **0.0155**, indicating modest between-state variation after accounting for the included individual-level covariates.

➡️ **[See the complete results, all models, comparisons, and interpretation](results/README.md)**

## Research question

Which demographic, socioeconomic, behavioral, and health characteristics are associated with adult obesity in the United States, and how much does baseline obesity risk vary across states?

## Data

I used the **2022 BRFSS public-use dataset** released by the U.S. Centers for Disease Control and Prevention (CDC). The original working extract contained **445,132 observations**. After complete-case filtering and removal of selected nonresponse/refusal codes used in the coursework workflow, the modelling dataset contained **39,551 observations**.

I do not commit the large raw or processed BRFSS files to this repository. Instead, I document the public source, exact variables, extraction workflow, data preparation, and reproduction steps in [`data/README.md`](data/README.md).

## Analytical workflow

1. **Data preparation** — I selected variables in Stata, applied complete-case filtering, removed selected nonresponse/refusal codes, and recoded age, education, income, sex, marital status, employment status, diabetes, heart disease, BMI, and state.
2. **Exploratory analysis** — I examined demographic and health distributions, BMI composition, state-level obesity rates, and joint/conditional probability tables.
3. **Binary logistic regression** — I estimated an age-only model, a broader multivariable model, and a focused sex + income model.
4. **Multinomial logistic regression** — I modelled the four-category BMI outcome with obesity as the reference category.
5. **Ordinal logistic regression** — I compared three nested ordered-BMI specifications using AIC and BIC.
6. **Generalized linear mixed model (GLMM)** — I fitted a logistic mixed-effects model with a random intercept for state.
7. **Model comparison and diagnostics** — I compared fit statistics and preserved quality-control notes where the original rendered coursework contained inconsistencies.

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
│   └── README.md
├── docs/
│   ├── methodology.md
│   ├── refactor_notes.md
│   └── source_inventory.md
└── results/
    ├── README.md
    ├── tables/
    └── figures/
        ├── obesity_by_age.svg
        ├── obesity_by_sex.svg
        ├── top_states_obesity.svg
        └── glmm_selected_odds_ratios.svg
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

### Option B — rebuild from the public BRFSS source

Download the 2022 BRFSS public-use XPT file from the CDC source documented in [`data/README.md`](data/README.md). The Stata extraction script documents the original variable selection, and the R preparation script applies the cleaning and recoding used in the analysis.

## Methodological note

The original coursework did **not** implement BRFSS survey-weighted estimation. I therefore do not present these results as survey-weighted U.S. population estimates or causal effects. The descriptive percentages and model coefficients are results from the filtered analytical sample and are presented to demonstrate the analytical workflow, statistical modelling, interpretation, and reproducibility.

## Skills demonstrated

- R / RMarkdown
- Stata
- health survey data preparation
- data cleaning and recoding
- exploratory data analysis and visualization
- probability analysis
- binary logistic regression
- multinomial logistic regression
- ordinal logistic regression
- mixed-effects logistic regression (`glmmTMB`)
- model comparison with AIC/BIC and likelihood-ratio testing
- model diagnostics and quality control
- reproducible project organization
- public health data provenance and responsible data handling

## Attribution

I completed the original analysis as a **group project with Amal Ahmed and Arnela Halili**. See [`AUTHORS.md`](AUTHORS.md) for attribution. I do not present the original group coursework as sole-authored work.

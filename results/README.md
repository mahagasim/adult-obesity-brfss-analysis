# Complete Results

This page documents the **full analytical workflow** represented in the submitted Health Data Science project. It includes the descriptive analysis, probability tables, all fitted model classes, model comparisons, and the final state-level mixed model.

> **Interpretation boundary:** These results come from the project's filtered analytical sample (`N = 39,551`) and are **not BRFSS survey-weighted population estimates**. They demonstrate data-management, modelling, diagnostic, comparison, and interpretation skills rather than causal inference.

## 1. Analytical sample

The working BRFSS extract contained 445,132 observations. After complete-case filtering and removal of selected nonresponse/refusal codes used in the original coursework workflow, the final analytical sample contained **39,551 observations**.

### BMI outcome distribution

| BMI category | N | Percent |
|---|---:|---:|
| Underweight | 843 | 2.13% |
| Normal weight | 10,298 | 26.04% |
| Overweight | 12,575 | 31.79% |
| Obese | 15,835 | 40.04% |

Binary obesity outcome:

| Status | N | Percent |
|---|---:|---:|
| Not obese | 23,716 | 59.96% |
| Obese | 15,835 | 40.04% |

The complete distributions for age, sex, marital status, education, employment, income, heart disease, diabetes, general health, smoking and physical activity are available in [`tables/descriptive_distributions.csv`](tables/descriptive_distributions.csv).

## 2. Descriptive analysis

### Obesity by age

| Age group | N | Observed obesity rate |
|---|---:|---:|
| 18–29 | 2,734 | 30.10% |
| 30–39 | 5,549 | 39.30% |
| 40–54 | 10,024 | 44.88% |
| 55–69 | 13,145 | 42.75% |
| 70+ | 8,099 | 33.49% |

![Observed obesity rate by age group](figures/obesity_by_age.svg)

### Obesity by sex

| Sex | N | Observed obesity rate |
|---|---:|---:|
| Male | 18,479 | 37.44% |
| Female | 21,072 | 42.31% |

![Observed obesity rate by sex](figures/obesity_by_sex.svg)

### Obesity by income group

| Income group | N | Observed obesity rate |
|---|---:|---:|
| Low income | 11,349 | 41.79% |
| Middle income | 17,526 | 40.36% |
| High income | 10,676 | 37.64% |

### State-level variation

The highest observed obesity rates in the filtered analytical sample were:

| State | Total observations | Obese observations | Observed obesity rate |
|---|---:|---:|---:|
| North Dakota | 308 | 149 | 48.38% |
| Wisconsin | 1,084 | 509 | 46.96% |
| Iowa | 805 | 377 | 46.83% |
| Kentucky | 435 | 201 | 46.21% |
| Ohio | 1,676 | 762 | 45.47% |

![Highest observed obesity rates by state](figures/top_states_obesity.svg)

The complete 54-state/territory table is in [`tables/state_obesity_rates.csv`](tables/state_obesity_rates.csv).

## 3. Joint and conditional probability analysis

The original project also examined joint and conditional probabilities for obesity by **sex, age and income**. The corrected tables recomputed directly from the final 39,551-row analytical dataset are stored in [`tables/probability_tables.csv`](tables/probability_tables.csv).

Examples:

- `P(Obese | Female) = 0.4231`
- `P(Obese | Male) = 0.3744`
- `P(Obese | Age 40–54) = 0.4488`
- `P(Obese | Age 18–29) = 0.3010`
- `P(Obese | Low income) = 0.4179`
- `P(Obese | High income) = 0.3764`

## 4. Complete model inventory

The project fits **eight model objects** across four modelling frameworks.

| # | Model | Outcome | Purpose |
|---|---|---|---|
| 1 | Age-only binary logistic regression | Obese vs not obese | Establish age pattern |
| 2 | Multivariable binary logistic regression | Obese vs not obese | Add health, socioeconomic and demographic predictors |
| 3 | Sex + income binary logistic regression | Obese vs not obese | Focused demographic/economic model |
| 4 | Multinomial logistic regression | 4-category BMI | Compare underweight, normal weight and overweight with obesity |
| 5 | Ordinal logistic model 1 | Ordered BMI category | Baseline demographic model |
| 6 | Ordinal logistic model 2 | Ordered BMI category | Add health predictors |
| 7 | Ordinal logistic model 3 | Ordered BMI category | Add income and employment; final ordinal specification |
| 8 | State random-intercept GLMM | Obese vs not obese | Model individual predictors plus between-state heterogeneity |

`R/03_models.R` now exports a complete `summary()` for **every one** of these models when the analysis is rerun.

---

# Binary logistic regression

## 5. Model 1 — age-only logistic regression

Formula:

```r
obesity_status ~ age5cat
```

Fit:

- Null deviance: **53,248**
- Residual deviance: **52,846**
- AIC: **52,855.67** (rounded to 52,856 in printed summary)

| Predictor | Log-odds estimate | SE | z | p-value |
|---|---:|---:|---:|---:|
| Intercept / age 18–29 | -0.84243 | 0.04169 | -20.205 | <2e-16 |
| Age 30–39 | 0.40789 | 0.04994 | 8.168 | 3.14e-16 |
| Age 40–54 | 0.63700 | 0.04628 | 13.765 | <2e-16 |
| Age 55–69 | 0.55053 | 0.04527 | 12.162 | <2e-16 |
| Age 70+ | 0.15612 | 0.04788 | 3.261 | 0.00111 |

The unadjusted age model therefore shows higher obesity odds in every older age category relative to ages 18–29, with the largest log-odds difference among ages 40–54.

## 6. Model 2 — multivariable logistic regression

Formula:

```r
obesity_status ~ genhlth + poorhlth + hrtdisease + diabetic + marital +
                 edu + employstatus + income
```

Fit:

- Residual deviance: **50,318**
- AIC: **50,441.60**

The model includes self-rated general health, days of poor health, heart disease, diabetes, marital status, education, employment and the original detailed income variable.

Strong patterns in the submitted coefficient table include:

- progressively larger positive coefficients for worse general health relative to excellent health;
- strong diabetes associations, particularly relative to the non-diabetic reference category;
- several marital-status differences relative to married respondents;
- several employment-status differences relative to employed-for-wages respondents;
- relatively limited evidence for education after adjustment;
- heterogeneous effects across the detailed `poorhlth` and income categories.

### Model 1 vs Model 2

| Model | AIC |
|---|---:|
| Age-only | 52,855.67 |
| Multivariable | 50,441.60 |

Likelihood-ratio test reported in the project:

- Deviance difference: **2,528.1**
- Difference in df: **57**
- `p < 2.2e-16`

The multivariable model therefore fits substantially better than the age-only model.

## 7. Model 3 — sex + income logistic regression

Formula:

```r
obesity_status ~ sex + income_group
```

Fit:

- Null deviance: **53,248**
- Residual deviance: **53,119**
- AIC: **53,127**

| Predictor | Estimate | SE | z | p-value |
|---|---:|---:|---:|---:|
| Intercept | -0.44498 | 0.02262 | -19.673 | <2e-16 |
| Female vs male | 0.19434 | 0.02069 | 9.391 | <2e-16 |
| Middle vs low income | -0.05050 | 0.02452 | -2.059 | 0.0395 |
| High vs low income | -0.15372 | 0.02770 | -5.549 | 2.87e-08 |

This focused model captures the same descriptive pattern: women have higher obesity odds than men, while the high-income group has lower obesity odds than the low-income reference group.

---

# Multinomial logistic regression

## 8. Model 4 — multinomial BMI model

Outcome categories: **Underweight, Normal weight, Overweight, Obese**, with **Obese as the reference category**.

Formula:

```r
bmi ~ hrtdisease + diabetic_status + age5cat + sex + edu + income_group +
      totinda + smokeday + genhlth
```

Fit:

- Residual deviance: **87,081.85**
- Log-likelihood: **-43,540.93**
- Fisher scoring iterations: **7**

The submitted output estimates three equations simultaneously:

1. Underweight vs obese
2. Normal weight vs obese
3. Overweight vs obese

Major reported patterns include:

- **Diabetes:** non-diabetic respondents had substantially higher log-odds of being underweight, normal weight or overweight rather than obese.
- **Age:** ages 30–54 were much less likely to be underweight/normal weight relative to obesity; ages 70+ were more likely to be normal weight or overweight rather than obese.
- **Sex:** women were more likely to be underweight rather than obese but less likely to be overweight rather than obese.
- **Education:** elementary-or-less and high-school categories had positive coefficients for underweight vs obesity in the reported specification.
- **Income:** middle- and high-income respondents were less likely to be underweight or normal weight rather than obese relative to the low-income reference in this particular parameterization.
- **Physical activity and smoking:** several categories were strongly associated with BMI-category membership.
- **General health:** better self-rated health was strongly associated with being normal weight or overweight rather than obese.

The model also emitted a **Hauck–Donner warning for the underweight intercept**, which is retained as part of the original diagnostic output rather than hidden.

---

# Ordinal logistic regression

## 9. Models 5–7 — nested ordinal BMI models

The project compares three cumulative proportional-odds models with progressively richer covariate sets.

### Model 1

```r
bmi ~ age5cat + sex + marital + edu
```

### Model 2

```r
bmi ~ age5cat + sex + marital + edu + genhlth +
      hrtdisease + diabetic_status + smokeday
```

### Model 3

```r
bmi ~ age5cat + sex + marital + edu + genhlth +
      hrtdisease + diabetic_status + smokeday +
      income_group + employstatus
```

### Model comparison

| Ordinal model | AIC | BIC |
|---|---:|---:|
| Model 1 | 91,360.78 | 91,489.56 |
| Model 2 | 88,514.37 | 88,711.83 |
| **Model 3** | **88,376.06** | **88,650.79** |

**Model 3 is preferred by both AIC and BIC.**

The submitted Model 3 interpretation reports statistically important associations for age, sex, marital status, general health, heart disease, diabetes, smoking, middle-income status and several employment categories, while education and high-income status were not statistically important in that specification.

Because the submitted HTML prints the full coefficient table only for the final ordinal specification, the portfolio does **not fabricate historical coefficient tables for Models 1 and 2**. The refactored R code now exports full summaries for all three whenever the analysis is rerun.

---

# Generalized linear mixed model

## 10. Model 8 — state random-intercept GLMM

Formula:

```r
obesity_status ~ age5cat + genhlth + hrtdisease + diabetic + marital +
                 edu + employstatus + income_group + smokeday +
                 totinda + sex + (1 | state)
```

### Model fit

| Statistic | Value |
|---|---:|
| AIC | 49,464.2 |
| BIC | 49,756.1 |
| Log-likelihood | -24,698.1 |
| Deviance | 49,396.2 |
| Residual df | 39,517 |
| Observations | 39,551 |
| State/territory groups | 54 |

### Random effect

| Statistic | Value |
|---|---:|
| State intercept variance | 0.01574 |
| State intercept SD | 0.1255 |

The between-state random effect is modest relative to the individual-level variation.

### Selected GLMM fixed effects

![Selected GLMM odds ratios](figures/glmm_selected_odds_ratios.svg)

| Predictor | Log-odds estimate | Approx. OR | Significance |
|---|---:|---:|---|
| Age 30–39 vs 18–29 | 0.3310 | 1.39 | p<0.001 |
| Age 40–54 vs 18–29 | 0.3423 | 1.41 | p<0.001 |
| Age 55–69 vs 18–29 | 0.0675 | 1.07 | p=0.213 |
| Age 70+ vs 18–29 | -0.4368 | 0.65 | p<0.001 |
| General health: very good vs excellent | 0.3812 | 1.46 | p<0.001 |
| General health: good vs excellent | 0.9435 | 2.57 | p<0.001 |
| General health: fair vs excellent | 1.0596 | 2.89 | p<0.001 |
| General health: poor vs excellent | 0.8507 | 2.34 | p<0.001 |
| Female vs male | 0.2035 | 1.23 | p<0.001 |

Other GLMM findings in the submitted output include significant coefficients for heart disease, diabetes, several marital and employment categories, income, smoking and the physical-activity indicator. Education and the age 55–69 category were not statistically significant in the final GLMM.

### Diagnostic caution

The original report's prose states that VIF values were acceptable, but the rendered VIF table is internally inconsistent. The portfolio therefore **does not present that diagnostic as a verified result**. This is documented as a quality-control issue rather than silently repeated.

---

# 11. What the repository now demonstrates

The complete project now shows the progression from:

**raw public health survey data → variable selection → cleaning/recoding → descriptive statistics → probability analysis → binary logistic models → nested model comparison → multinomial modelling → ordinal modelling → multilevel modelling → interpretation and diagnostics.**

This is the part of the project that best demonstrates health-data analytics and data-science thinking: not just fitting one model, but comparing alternative representations of the outcome, evaluating model fit, interpreting covariates, checking hierarchical variation and documenting analytical limitations.

## Machine-readable result tables

- [`tables/descriptive_distributions.csv`](tables/descriptive_distributions.csv)
- [`tables/probability_tables.csv`](tables/probability_tables.csv)
- [`tables/state_obesity_rates.csv`](tables/state_obesity_rates.csv)

## Reproducible model-output exports

After rerunning the pipeline, `R/03_models.R` writes complete text summaries for:

- `age_logit`
- `multivariable_logit`
- `sex_income_logit`
- `multinomial`
- `ordinal_1`
- `ordinal_2`
- `ordinal_3`
- `state_glmm`

It also exports model-fit statistics, the ordinal AIC/BIC comparison, and the likelihood-ratio comparison between the age-only and multivariable logistic models.

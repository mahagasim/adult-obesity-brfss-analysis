# Results

This page summarizes the main descriptive and model outputs reported in the submitted Health Data Science project. The values below come from the project's **filtered analytical sample** and are not BRFSS survey-weighted population estimates.

## Descriptive results

### Obesity by age

| Age group | Observed obesity rate |
|---|---:|
| 18–29 | 30.1% |
| 30–39 | 39.3% |
| 40–54 | 44.9% |
| 55–69 | 42.8% |
| 70+ | 33.5% |

![Observed obesity rate by age group](figures/obesity_by_age.svg)

The observed rate increased from early adulthood through middle age, reaching its highest value in the 40–54 group, before declining among older adults.

### Obesity by sex

| Sex | Observed obesity rate |
|---|---:|
| Male | 37.4% |
| Female | 42.3% |

![Observed obesity rate by sex](figures/obesity_by_sex.svg)

### Highest observed state-level obesity rates

| State | Total observations | Obese observations | Observed obesity rate |
|---|---:|---:|---:|
| North Dakota | 308 | 149 | 48.4% |
| Wisconsin | 1,084 | 509 | 47.0% |
| Iowa | 805 | 377 | 46.8% |
| Kentucky | 435 | 201 | 46.2% |
| Ohio | 1,676 | 762 | 45.5% |

![Highest observed obesity rates by state](figures/top_states_obesity.svg)

## Model results

The submitted project estimated several model classes: binary logistic regression, multinomial logistic regression, ordinal logistic regression, and a generalized linear mixed model (GLMM). The GLMM used a binary obesity outcome with individual-level covariates and a **random intercept for state**.

### Selected GLMM fixed effects

| Predictor | Odds ratio | 95% CI |
|---|---:|---:|
| Age 30–39 vs 18–29 | 1.39 | 1.26–1.54 |
| Age 40–54 vs 18–29 | 1.41 | 1.27–1.56 |
| Age 55–69 vs 18–29 | 1.07 | 0.96–1.19 |
| Age 70+ vs 18–29 | 0.65 | 0.57–0.73 |
| General health: very good vs excellent | 1.46 | 1.29–1.66 |
| General health: good vs excellent | 2.57 | 2.28–2.89 |
| General health: fair vs excellent | 2.89 | 2.55–3.26 |
| General health: poor vs excellent | 2.34 | 2.05–2.67 |

![Selected GLMM odds ratios](figures/glmm_selected_odds_ratios.svg)

For the selected age coefficients, adults aged 30–39 and 40–54 had higher adjusted odds of obesity relative to the 18–29 reference group. The 55–69 confidence interval crossed 1, while adults aged 70+ had lower adjusted odds. Poorer self-rated general health was strongly associated with higher adjusted odds of obesity relative to excellent health.

### State-level random effect

| Statistic | Reported value |
|---|---:|
| State random-intercept variance | 0.0157 |
| State random-intercept SD | 0.1255 |
| ICC | 0.0155 |
| State/territory groups | 54 |
| Observations | 39,551 |

The model therefore found modest residual between-state heterogeneity after adjustment for the included individual-level predictors.

## Interpretation boundary

These outputs reproduce the results reported in the original course project. The original workflow did **not** use BRFSS survey weights, so these numbers should not be interpreted as survey-weighted U.S. population prevalence estimates or causal effects. They are descriptive associations and model estimates from the project's filtered sample.

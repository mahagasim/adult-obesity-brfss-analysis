# Methodology notes

## Outcome definitions

- **Binary obesity:** BMI category 4 in the project variable `bmi` (`_BMI5CAT` in BRFSS) is coded as `Obese`; all other retained categories are coded as `Not Obese`.
- **Four-category BMI outcome:** the original `bmi` category is used for multinomial and ordinal models.

## Recoding used in the submitted workflow

- age bands are collapsed to 18–29, 30–39, 40–54, 55–69, and 70+;
- education is collapsed to elementary-or-less, high-school-or-equivalent, and college-or-more;
- income categories are collapsed using the original numeric cut points into low, middle, and high income;
- state codes are mapped to state/territory names;
- selected BRFSS nonresponse/refusal codes are removed before modelling.

## Models

1. age-only binary logistic regression;
2. multivariable binary logistic regression;
3. sex + income logistic regression;
4. multinomial logistic regression for BMI category;
5. three nested ordinal logistic models compared by AIC and BIC;
6. binomial GLMM with a random intercept for state.

## Refactor decisions

The original final RMarkdown renamed columns by position and the rendered report showed a length-mismatch warning. The portfolio version maps BRFSS variables by explicit names instead. This is a reproducibility repair, not a substantive change to the intended variables or models.

The original analysis was not survey-weighted. No survey-weighted model has been silently substituted in this repository.

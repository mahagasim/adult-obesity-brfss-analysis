fit_obesity_models <- function(data, output_dir = "results") {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  model_output_dir <- file.path(output_dir, "model_outputs")
  dir.create(model_output_dir, recursive = TRUE, showWarnings = FALSE)

  age_model <- stats::glm(obesity_status ~ age5cat, data = data, family = "binomial")

  multivariable_logit <- stats::glm(
    obesity_status ~ genhlth + poorhlth + hrtdisease + diabetic + marital +
      edu + employstatus + income,
    data = data,
    family = "binomial"
  )

  sex_income_logit <- stats::glm(
    obesity_status ~ sex + income_group,
    data = data,
    family = "binomial"
  )

  multinomial_model <- VGAM::vglm(
    bmi ~ hrtdisease + diabetic_status + age5cat + sex + edu + income_group +
      totinda + smokeday + genhlth,
    family = VGAM::multinomial(refLevel = 4),
    data = data
  )

  ordinal_1 <- VGAM::vglm(
    bmi ~ age5cat + sex + marital + edu,
    family = VGAM::cumulative(parallel = TRUE), data = data
  )
  ordinal_2 <- VGAM::vglm(
    bmi ~ age5cat + sex + marital + edu + genhlth + hrtdisease + diabetic_status + smokeday,
    family = VGAM::cumulative(parallel = TRUE), data = data
  )
  ordinal_3 <- VGAM::vglm(
    bmi ~ age5cat + sex + marital + edu + genhlth + hrtdisease + diabetic_status +
      smokeday + income_group + employstatus,
    family = VGAM::cumulative(parallel = TRUE), data = data
  )

  comparison <- data.frame(
    model = c("Ordinal 1", "Ordinal 2", "Ordinal 3"),
    AIC = c(stats::AIC(ordinal_1), stats::AIC(ordinal_2), stats::AIC(ordinal_3)),
    BIC = c(stats::BIC(ordinal_1), stats::BIC(ordinal_2), stats::BIC(ordinal_3))
  )
  utils::write.csv(comparison, file.path(output_dir, "ordinal_model_comparison.csv"), row.names = FALSE)

  glmm_predictors <- c(
    "age5cat", "genhlth", "hrtdisease", "diabetic", "marital", "edu",
    "employstatus", "income_group", "smokeday", "totinda", "sex"
  )
  glmm_formula <- stats::as.formula(
    paste("obesity_status ~", paste(glmm_predictors, collapse = " + "), "+ (1 | state)")
  )
  state_glmm <- glmmTMB::glmmTMB(
    glmm_formula, data = data, family = stats::binomial(link = "logit")
  )

  models <- list(
    age_logit = age_model,
    multivariable_logit = multivariable_logit,
    sex_income_logit = sex_income_logit,
    multinomial = multinomial_model,
    ordinal_1 = ordinal_1,
    ordinal_2 = ordinal_2,
    ordinal_3 = ordinal_3,
    state_glmm = state_glmm
  )

  # Export a complete text summary for every fitted model so the repository
  # exposes all model output rather than only a subset shown in the README.
  for (nm in names(models)) {
    capture.output(
      summary(models[[nm]]),
      file = file.path(model_output_dir, paste0(nm, "_summary.txt"))
    )
  }

  # Export model-fit statistics for the three binary-logit models and GLMM.
  fit_statistics <- data.frame(
    model = c("Age-only logit", "Multivariable logit", "Sex + income logit", "State GLMM"),
    AIC = c(stats::AIC(age_model), stats::AIC(multivariable_logit), stats::AIC(sex_income_logit), stats::AIC(state_glmm)),
    BIC = c(stats::BIC(age_model), stats::BIC(multivariable_logit), stats::BIC(sex_income_logit), stats::BIC(state_glmm)),
    logLik = c(as.numeric(stats::logLik(age_model)), as.numeric(stats::logLik(multivariable_logit)), as.numeric(stats::logLik(sex_income_logit)), as.numeric(stats::logLik(state_glmm)))
  )
  utils::write.csv(fit_statistics, file.path(output_dir, "model_fit_statistics.csv"), row.names = FALSE)

  # Likelihood-ratio comparison reported in the submitted project.
  capture.output(
    stats::anova(age_model, multivariable_logit, test = "LRT"),
    file = file.path(model_output_dir, "age_vs_multivariable_logit_LRT.txt")
  )

  c(models, list(
    ordinal_comparison = comparison,
    fit_statistics = fit_statistics
  ))
}

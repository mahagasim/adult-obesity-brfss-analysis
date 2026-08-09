source("R/00_packages.R")
source("R/01_prepare_data.R")
source("R/02_descriptive_analysis.R")
source("R/03_models.R")

data <- load_analysis_data()
cat("Analysis rows:", nrow(data), "\n")
cat("Analysis columns:", ncol(data), "\n")

descriptives <- run_descriptives(data)
models <- fit_obesity_models(data)

cat("\nTop state obesity rates in analysis data:\n")
print(utils::head(descriptives$obesity_by_state, 10))
cat("\nOrdinal model comparison:\n")
print(models$ordinal_comparison)

required_packages <- c(
  "dplyr",
  "readxl",
  "haven",
  "ggplot2",
  "maps",
  "VGAM",
  "glmmTMB",
  "car",
  "effects",
  "sjPlot"
)

missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing_packages) > 0) {
  stop(
    "Missing R packages: ",
    paste(missing_packages, collapse = ", "),
    ". Install them before running the analysis."
  )
}

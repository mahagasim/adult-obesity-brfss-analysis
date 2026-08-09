# Data preparation for the 2022 BRFSS obesity project
# Refactored from the original course RMarkdown without changing the substantive recodes.

state_mapping <- c(
  `1`="Alabama", `2`="Alaska", `4`="Arizona", `5`="Arkansas", `6`="California",
  `8`="Colorado", `9`="Connecticut", `10`="Delaware", `11`="District of Columbia",
  `12`="Florida", `13`="Georgia", `15`="Hawaii", `16`="Idaho", `17`="Illinois",
  `18`="Indiana", `19`="Iowa", `20`="Kansas", `21`="Kentucky", `22`="Louisiana",
  `23`="Maine", `24`="Maryland", `25`="Massachusetts", `26`="Michigan",
  `27`="Minnesota", `28`="Mississippi", `29`="Missouri", `30`="Montana",
  `31`="Nebraska", `32`="Nevada", `33`="New Hampshire", `34`="New Jersey",
  `35`="New Mexico", `36`="New York", `37`="North Carolina", `38`="North Dakota",
  `39`="Ohio", `40`="Oklahoma", `41`="Oregon", `42`="Pennsylvania",
  `44`="Rhode Island", `45`="South Carolina", `46`="South Dakota",
  `47`="Tennessee", `48`="Texas", `49`="Utah", `50`="Vermont", `51`="Virginia",
  `53`="Washington", `54`="West Virginia", `55`="Wisconsin", `56`="Wyoming",
  `66`="Guam", `72`="Puerto Rico", `78`="Virgin Islands"
)

age_labels <- c(
  "Age 18 to 24", "Age 25 to 29", "Age 30 to 34", "Age 35 to 39",
  "Age 40 to 44", "Age 45 to 49", "Age 50 to 54", "Age 55 to 59",
  "Age 60 to 64", "Age 65 to 69", "Age 70 to 74", "Age 75 to 79",
  "Age 80 or older"
)

age_mapping <- c(
  "Age 18 to 24"="Age 18 to 29", "Age 25 to 29"="Age 18 to 29",
  "Age 30 to 34"="Age 30 to 39", "Age 35 to 39"="Age 30 to 39",
  "Age 40 to 44"="Age 40 to 54", "Age 45 to 49"="Age 40 to 54",
  "Age 50 to 54"="Age 40 to 54", "Age 55 to 59"="Age 55 to 69",
  "Age 60 to 64"="Age 55 to 69", "Age 65 to 69"="Age 55 to 69",
  "Age 70 to 74"="Age 70 and older", "Age 75 to 79"="Age 70 and older",
  "Age 80 or older"="Age 70 and older"
)

edu_levels <- c(
  "Never attended school or only kindergarten",
  "Grades 1 through 8 (Elementary)",
  "Grades 9 through 11 (Some high school)",
  "Grade 12 or GED (High school graduate)",
  "College 1 year to 3 years (Some college or technical school)",
  "College 4 years or more (College graduate)"
)

edu_mapping <- c(
  "Never attended school or only kindergarten"="Elementary or less",
  "Grades 1 through 8 (Elementary)"="Elementary or less",
  "Grades 9 through 11 (Some high school)"="High school or equivalent",
  "Grade 12 or GED (High school graduate)"="High school or equivalent",
  "College 1 year to 3 years (Some college or technical school)"="College or more",
  "College 4 years or more (College graduate)"="College or more"
)

invalid_values <- list(
  genhlth=c(9,7), poorhlth=c(88,77,99), cvdcrhd4=c(7,9), diabete4=c(7,9),
  marital=9, educa=9, employ1=9, income3=c(77,99), smokday2=c(7,9),
  `_totinda`=9, `_ageg5yr`=14
)

load_reduced_brfss <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext == "xlsx") return(readxl::read_excel(path))
  if (ext == "dta") return(haven::read_dta(path))
  if (ext == "csv") return(utils::read.csv(path, check.names = FALSE))
  stop("Unsupported input format: ", ext)
}

prepare_brfss <- function(path) {
  data <- load_reduced_brfss(path)

  required <- c(
    "_state", "genhlth", "poorhlth", "cvdcrhd4", "diabete4", "marital",
    "educa", "employ1", "income3", "smokday2", "_totinda", "_sex",
    "_ageg5yr", "_bmi5", "_bmi5cat"
  )
  missing <- setdiff(required, names(data))
  if (length(missing) > 0) {
    stop("Input is missing expected BRFSS variables: ", paste(missing, collapse = ", "))
  }

  data <- data[, required]
  data$index <- paste0("row", seq_len(nrow(data)))
  data <- stats::na.omit(data)

  for (nm in names(invalid_values)) {
    data <- data[!(data[[nm]] %in% invalid_values[[nm]]), , drop = FALSE]
  }

  data <- dplyr::rename(
    data,
    state=`_state`, hrtdisease=cvdcrhd4, diabetic=diabete4, edu=educa,
    employstatus=employ1, income=income3, smokeday=smokday2, totinda=`_totinda`,
    sex=`_sex`, age5cat=`_ageg5yr`, bmi5=`_bmi5`, bmi=`_bmi5cat`
  )

  data$age5cat <- factor(data$age5cat, levels=1:13, labels=age_labels)
  data$age5cat <- factor(age_mapping[as.character(data$age5cat)])

  data$edu <- factor(data$edu, levels=1:6, labels=edu_levels)
  data$edu <- factor(edu_mapping[as.character(data$edu)])

  data$income_group <- cut(
    as.numeric(data$income), breaks=c(0,4,7,11),
    labels=c("Low Income","Middle Income","High Income"), include.lowest=TRUE
  )

  data$diabetic_status <- ifelse(
    data$diabetic %in% c(1,2), 1,
    ifelse(data$diabetic %in% c(3,4), 2, NA)
  )

  data$obesity_status <- factor(
    ifelse(data$bmi == 4, 1, 0), levels=c(0,1), labels=c("Not Obese","Obese")
  )

  data$state <- factor(state_mapping[as.character(data$state)])
  data$sex <- factor(data$sex, levels=c(1,2), labels=c("Male","Female"))
  data$marital <- factor(
    data$marital, levels=1:6,
    labels=c("Married","Divorced","Widowed","Separated","Never married","Member of an unmarried couple")
  )
  data$employstatus <- factor(
    data$employstatus, levels=1:8,
    labels=c("Employed for wages","Self-employed","Out of work for 1 year or more",
             "Out of work for less than 1 year","A homemaker","A student","Retired","Unable to work")
  )
  data$hrtdisease <- factor(data$hrtdisease, levels=c(1,2), labels=c("Yes","No"))

  factor_vars <- c(
    "genhlth","poorhlth","hrtdisease","diabetic","marital","employstatus",
    "income","smokeday","totinda","sex","obesity_status","diabetic_status"
  )
  data[factor_vars] <- lapply(data[factor_vars], factor)

  data
}

load_analysis_data <- function() {
  processed <- "data/processed/filtered_data.csv"
  if (file.exists(processed)) {
    x <- utils::read.csv(processed, stringsAsFactors = FALSE, check.names = FALSE)
    factor_vars <- intersect(
      c("state","genhlth","poorhlth","hrtdisease","diabetic","marital","edu",
        "employstatus","income","smokeday","totinda","sex","age5cat","bmi",
        "obesity_status","income_group","diabetic_status"), names(x)
    )
    x[factor_vars] <- lapply(x[factor_vars], factor)
    return(x)
  }

  candidates <- c("data/raw/Demo+Health data.dta", "data/raw/Demo+Health data.xlsx")
  input <- candidates[file.exists(candidates)][1]
  if (is.na(input)) {
    stop("No analysis input found. See data/README.md.")
  }
  prepare_brfss(input)
}

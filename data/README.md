# Data

## Source

This project used the **2022 Behavioral Risk Factor Surveillance System (BRFSS)**. The original Drive workspace contains the large working files `LLCP2022.XPT`, `data.dta`, `BRFSS_year 2022.xlsx`, and smaller reduced files used by the analysis.

## Original extraction

The original Stata script retained these variables:

`educa marital employ1 income3 _totinda genhlth poorhlth smokday2 diabete4 cvdcrhd4 _ageg5yr _sex _bmi5 _bmi5cat _state`

The cleaned extraction script is in `stata/01_extract_brfss.do`.

## Files intentionally excluded from Git

- full BRFSS XPT / DTA / Excel data;
- the 5.3 MB full intermediate `filtered_data.csv`;
- `.RData` and `.Rhistory` session-state files.

This keeps the repository focused on code and provenance rather than machine-specific working data.

## Expected inputs

For the easiest reproduction, copy the original `filtered_data.csv` to:

`data/processed/filtered_data.csv`

Alternatively, place `Demo+Health data.dta` or `Demo+Health data.xlsx` in `data/raw/` and let `R/01_prepare_data.R` rebuild the analysis dataset.

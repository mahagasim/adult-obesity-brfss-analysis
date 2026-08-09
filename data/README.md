# Data

## Source and access status

This project uses the **2022 Behavioral Risk Factor Surveillance System (BRFSS)** public-use data released by the U.S. Centers for Disease Control and Prevention (CDC).

Official source: https://www.cdc.gov/brfss/annual_data/annual_2022.html

The CDC 2022 annual-data page reports **445,132 records** in the combined landline and cell-phone public-use dataset and provides the files in ASCII and SAS Transport (XPT) formats. CDC guidance states that BRFSS data and materials produced by the federal agency are generally in the **public domain** and may be reproduced without permission, with CDC/BRFSS acknowledged as the source.

Suggested source acknowledgement:

> Centers for Disease Control and Prevention (CDC). Behavioral Risk Factor Surveillance System Survey Data. Atlanta, Georgia: U.S. Department of Health and Human Services, Centers for Disease Control and Prevention, 2022.

## Privacy and data-governance decision

The variables used in this repository come from the standard **public-use 2022 BRFSS file**. No restricted-use health records, directly identifying information, or privately supplied patient-level data are included in the repository.

Although the source data are public, the full raw files are **not committed to GitHub**. This is a repository-design decision rather than a confidentiality restriction: the uncompressed working files are very large and would add repository weight without improving assessment of the analytical workflow.

Instead, this repository provides:

- the official CDC source and provenance;
- the exact variables used;
- the Stata extraction code;
- the R data-preparation code;
- descriptive and model results;
- sufficient instructions to reproduce the analysis from the public source.

This approach makes the project auditable while keeping the portfolio focused on analytical reasoning, code, modelling, and reproducibility.

## Original project files

The original Drive workspace contains working copies of the public BRFSS data in several formats, including:

- `LLCP2022.XPT` — original CDC SAS Transport file;
- `data.dta` — Stata working conversion;
- `BRFSS_year 2022.xlsx` — Excel working conversion;
- `Demo+Health data.dta` / `Demo+Health data.xlsx` — reduced working extracts;
- `filtered_data.csv` — processed analytical dataset.

These working conversions do not change the access status of the underlying source: they derive from the public-use BRFSS data.

## Variables used

The original Stata workflow retained:

`educa marital employ1 income3 _totinda genhlth poorhlth smokday2 diabete4 cvdcrhd4 _ageg5yr _sex _bmi5 _bmi5cat _state`

The cleaned extraction script is in `stata/01_extract_brfss.do`.

## Files intentionally excluded from Git

- full BRFSS XPT / DTA / Excel files;
- the full intermediate `filtered_data.csv`;
- `.RData` and `.Rhistory` session-state files;
- duplicate rendered reports and scratch files.

## Reproducing from the public source

1. Download the **2022 BRFSS SAS Transport (XPT)** file from the official CDC page above.
2. Import the XPT file into Stata/R or convert it to a supported working format.
3. Use `stata/01_extract_brfss.do` to retain the project variables, or reproduce the same selection directly in R.
4. Run the R preparation and modelling scripts documented in the main README.

For the historical course workflow, `Demo+Health data.dta`, `Demo+Health data.xlsx`, or `filtered_data.csv` can also be used if available locally.

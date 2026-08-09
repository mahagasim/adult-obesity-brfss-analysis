# Source inventory from the original Drive workspace

The project folder `The data - LLCP2022XPT` was reviewed to distinguish authoritative analysis files from scratch/generated/large-data artifacts.

| Drive item | Role in original project | Portfolio treatment |
|---|---|---|
| `The Combined Report.Rmd` | Final combined group analysis | Primary source for analytical scope, recodes, models, and interpretation |
| `The-Combined-Report.html` | Rendered final report | Used for result/interpretation cross-check; not committed |
| `Report BeWell group.Rmd` / HTML | Near-final duplicate | Not committed |
| `Report SAMPLE -Maha.Rmd` | Maha development version | Reviewed for provenance; not committed |
| `Maha.Rmd` | Earlier exploratory version | Reviewed; not committed |
| `new updated.Rmd` | Intermediate cleaning/modelling version | Used to cross-check cleaning and early model development |
| `glmm-Health Data Science - Third Model.Rmd` | GLMM development file | Used to cross-check mixed-effects specification |
| `Health Data Science.Rmd` and copies | Earlier working versions | Not committed |
| `Untitled.do` | Stata variable-extraction step | Refactored into `stata/01_extract_brfss.do` |
| `filtered_data.csv` | 39,551-row processed analysis dataset | Full file excluded from Git |
| `Demo+Health data.xlsx` / `.dta` | Reduced BRFSS input | Excluded; documented as supported local inputs |
| `LLCP2022.XPT`, `data.dta`, `BRFSS_year 2022.xlsx` | Large raw/working BRFSS files | Excluded from Git |
| `.RData`, `.Rhistory` | R session state | Excluded from Git |
| `rsconnect/`, generated HTML/resource folders | Deployment/render artifacts | Excluded from Git |

The goal is to preserve the substantive project while removing duplicates, absolute local paths, session state, and large generated/source files that do not belong in a portfolio repository.

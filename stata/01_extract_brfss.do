* 01_extract_brfss.do
* Reproducible version of the original project extraction step.
* Place the working BRFSS Stata file at data/raw/data.dta.

clear all
set more off

use "data/raw/data.dta", clear

keep educa marital employ1 income3 _totinda genhlth poorhlth smokday2 ///
     diabete4 cvdcrhd4 _ageg5yr _sex _bmi5 _bmi5cat _state

save "data/raw/Demo+Health data.dta", replace

# Refactor notes

- Replaced absolute Windows paths with repository-relative paths.
- Preserved the exact 15-variable Stata extraction list from the original `.do` file.
- Replaced positional column renaming with explicit BRFSS-name mapping.
- Preserved the original recoding logic and model formulas.
- Separated raw/processed data from tracked code.
- Added explicit group-project attribution and methodological scope notes.
- Did not add new inferential claims or silently replace the original models with survey-weighted alternatives.

# adslbuilder

An R package for building ADSL (Analysis Data Subject Level) datasets from SDTM (Study Data Tabulation Model) data. This package demonstrates a SAS-to-R conversion workflow for clinical trial data processing.

## Installation

```r
# Install from source
devtools::install("path/to/adslbuilder")
```

## Quick Start

```r
library(adslbuilder)

# Create ADSL dataset from SDTM CSV files
adsl <- create_adsl_from_csv(
  csv_path = "/path/to/SDTM",
  adam_lib = "/path/to/output"
)
```

## Package Structure

This package converts SAS macros to R functions organized as follows:

- **Logic Functions** (`logic.R`): Core utility functions for age group calculation and date conversion
- **Rule Functions** (`rules.R`): Domain-specific transformation rules
- **Import Functions** (`import.R`): Functions to import SDTM CSV files
- **Processing Functions** (`process.R`): Domain processing functions
- **Builder Functions** (`builders.R`): ADSL component builders
- **Main Pipeline** (`create_adsl.R`): Main function orchestrating the entire workflow

## Main Functions

### `create_adsl_from_csv()`

Main pipeline function that:
1. Extracts all SDTM CSV files (DM, EX, DS, AE)
2. Processes each domain
3. Builds ADSL components
4. Merges components into final ADSL dataset
5. Writes output to CSV file

### Domain Processing Functions

- `dm_process()`: Process Demographics domain
- `ex_process()`: Process Exposure domain
- `ds_process()`: Process Disposition domain
- `ae_process()`: Process Adverse Events domain

### Rule Functions

- `dm_rule()`: Apply DM domain rules
- `ex_rule()`: Apply EX domain rules
- `ds_rule()`: Apply DS domain rules
- `ae_rule()`: Apply AE domain rules
- `flag_rule()`: Apply flag rules
- `trt_plan_rule()`: Apply treatment plan rules

### Utility Functions

- `agegrp_calc()`: Calculate age groups
- `dtc_to_dt()`: Convert date/time character to Date objects
- `sdtm_import_csv()`: Import single SDTM CSV file
- `sdtm_extract_all()`: Extract all SDTM CSV files

## Example Usage

```r
library(adslbuilder)

# Set paths
csv_path <- "sas_input_files/Final package/SDTM"
adam_lib <- "sas_input_files/Final package/adam"

# Create ADSL dataset
adsl <- create_adsl_from_csv(csv_path = csv_path, adam_lib = adam_lib)

# View result
head(adsl)
```

## Dependencies

- `dplyr` (>= 1.0.0): Data manipulation
- `readr` (>= 2.0.0): CSV file reading
- `lubridate` (>= 1.8.0): Date handling

## Conversion Notes

This package was automatically converted from SAS code. Key conversion features:

- SAS macros → R functions
- Global environment assignments → Function return values
- SAS %include → R package structure
- SAS data steps → dplyr pipelines
- SAS date formats → R Date objects

## License

MIT


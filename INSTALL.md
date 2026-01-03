# Installation and Usage Guide

## Quick Installation

```r
# From the package directory
devtools::install("adslbuilder")

# Or using install.packages if you have a tarball
install.packages("adslbuilder_0.1.0.tar.gz", repos = NULL, type = "source")
```

## Verify Installation

```r
library(adslbuilder)

# Check if package loaded correctly
packageVersion("adslbuilder")

# List available functions
ls("package:adslbuilder")
```

## Basic Usage

```r
library(adslbuilder)

# Set paths to your SDTM data
csv_path <- "sas_input_files/Final package/SDTM"
adam_lib <- "sas_input_files/Final package/adam"

# Create ADSL dataset
adsl <- create_adsl_from_csv(
  csv_path = csv_path,
  adam_lib = adam_lib
)

# View results
head(adsl)
summary(adsl)
```

## Package Structure

The package is organized into logical modules:

- **utils.R**: Internal utility functions
- **logic.R**: Core logic (age groups, date conversion)
- **rules.R**: Domain-specific transformation rules
- **import.R**: SDTM data import functions
- **process.R**: Domain processing functions
- **builders.R**: ADSL component builders
- **create_adsl.R**: Main pipeline function

## For Demo Purposes

This package demonstrates:
1. ✅ SAS macro → R function conversion
2. ✅ Global environment → Function parameters
3. ✅ Script-based → Package-based structure
4. ✅ Proper R package conventions
5. ✅ Reusable, testable functions

Perfect for showcasing SAS-to-R conversion capabilities!


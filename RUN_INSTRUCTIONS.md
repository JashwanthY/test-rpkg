# Instructions to Run the ADSL Builder Demo

## Prerequisites

1. **Conda environment 'tlf' must be activated**
2. **R must be properly installed** in the conda environment
3. **Required R packages** must be installed: `dplyr`, `readr`, `lubridate`

## Option 1: Using the Setup Script (Recommended)

```bash
cd converted_code_248072ae/adslbuilder
bash setup_and_run.sh
```

## Option 2: Manual Setup and Run

### Step 1: Activate Conda Environment
```bash
conda activate tlf
```

### Step 2: Install Required R Packages
```r
# In R or Rscript
install.packages(c("dplyr", "readr", "lubridate"), repos="https://cran.r-project.org")
```

### Step 3: Run the Demo
```bash
cd converted_code_248072ae/adslbuilder
Rscript --vanilla run_demo_minimal.R
```

## Option 3: Install as Package and Use

### Step 1: Install devtools (if not installed)
```r
install.packages("devtools", repos="https://cran.r-project.org")
```

### Step 2: Install the Package
```r
library(devtools)
install("converted_code_248072ae/adslbuilder")
```

### Step 3: Use the Package
```r
library(adslbuilder)

# Set paths
csv_path <- "converted_code_248072ae/sas_input_files/Final package/SDTM"
adam_lib <- "converted_code_248072ae/sas_input_files/Final package/adam"

# Create ADSL
adsl <- create_adsl_from_csv(
  csv_path = csv_path,
  adam_lib = adam_lib
)

# View results
head(adsl)
```

## Troubleshooting

### Issue: "cannot find system Renviron"
This is a warning that can usually be ignored. If R functions don't work, the R installation may need to be reconfigured.

### Issue: "package 'utils' in options("defaultPackages") was not found"
This suggests R's base packages aren't loading. Try:
```bash
conda install -c conda-forge r-base r-essentials
```

### Issue: "could not find function 'install.packages'"
R's base environment isn't loading. Try reinstalling R in the conda environment:
```bash
conda install -c conda-forge r-base
```

### Issue: Missing packages
Install them manually:
```r
install.packages(c("dplyr", "readr", "lubridate"), repos="https://cran.r-project.org")
```

## Expected Output

When successful, you should see:
```
=== ADSL Creation Completed Successfully! ===
Number of subjects: [number]
Number of variables: [number]

First 5 rows of ADSL:
[data frame output]

ADSL variables:
[list of column names]
```

## File Structure

The demo uses:
- `run_demo_minimal.R` - Main demo script (sources R files directly)
- `R/*.R` - All package functions
- `sas_input_files/Final package/SDTM/` - Input SDTM CSV files
- `sas_input_files/Final package/adam/` - Output directory for ADSL CSV


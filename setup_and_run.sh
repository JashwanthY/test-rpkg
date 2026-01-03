#!/bin/bash
# Setup and run script for adslbuilder demo

echo "=== ADSL Builder Demo Setup ==="
echo ""

# Activate conda environment
echo "Activating conda environment 'tlf'..."
source $(conda info --base)/etc/profile.d/conda.sh
conda activate tlf

# Check R installation
echo "Checking R installation..."
R --version

# Install required R packages if not already installed
echo ""
echo "Installing required R packages..."
Rscript --vanilla << 'EOF'
# Check and install packages
packages <- c("dplyr", "readr", "lubridate", "devtools")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]

if(length(new_packages)) {
  cat("Installing packages:", paste(new_packages, collapse=", "), "\n")
  install.packages(new_packages, repos="https://cran.r-project.org", quiet=FALSE)
} else {
  cat("All required packages are already installed.\n")
}
EOF

# Run the demo
echo ""
echo "=== Running ADSL Creation Demo ==="
cd "$(dirname "$0")"
Rscript --vanilla run_demo_minimal.R


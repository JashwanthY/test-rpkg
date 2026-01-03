#!/usr/bin/env Rscript
# Minimal demo script with explicit package loading

# Suppress warnings during startup
options(warn = -1)

# Try to load required packages
required_packages <- c("dplyr", "readr", "lubridate")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  cat("ERROR: Missing required packages:", paste(missing_packages, collapse = ", "), "\n")
  cat("Please install them with: install.packages(c(", 
      paste0('"', missing_packages, '"', collapse = ", "), "))\n")
  quit(status = 1)
}

# Load packages
suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(lubridate)
})

cat("=== ADSL Builder Demo ===\n\n")

# Get script directory
args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
if (length(file_arg) > 0) {
  script_dir <- dirname(normalizePath(sub("^--file=", "", file_arg)))
} else {
  script_dir <- getwd()
}

cat("Script directory:", script_dir, "\n")

# Source all R files in order
cat("Loading R functions...\n")
tryCatch({
  source(file.path(script_dir, "R", "utils.R"))
  source(file.path(script_dir, "R", "logic.R"))
  source(file.path(script_dir, "R", "rules.R"))
  source(file.path(script_dir, "R", "import.R"))
  source(file.path(script_dir, "R", "process.R"))
  source(file.path(script_dir, "R", "builders.R"))
  source(file.path(script_dir, "R", "create_adsl.R"))
  cat("Functions loaded successfully!\n\n")
}, error = function(e) {
  cat("ERROR loading functions:", e$message, "\n")
  quit(status = 1)
})

# Set paths
base_path <- file.path(dirname(script_dir), "sas_input_files", "Final package")
csv_path <- file.path(base_path, "SDTM")
adam_lib <- file.path(base_path, "adam")

cat("=== Running ADSL Creation Pipeline ===\n")
cat("SDTM Path:", csv_path, "\n")
cat("Output Path:", adam_lib, "\n\n")

# Check if paths exist
if (!dir.exists(csv_path)) {
  cat("ERROR: SDTM directory not found:", csv_path, "\n")
  quit(status = 1)
}

# Create output directory if it doesn't exist
if (!dir.exists(adam_lib)) {
  dir.create(adam_lib, recursive = TRUE)
  cat("Created output directory:", adam_lib, "\n")
}

# Run the pipeline
cat("Creating ADSL dataset...\n")
tryCatch({
  adsl <- create_adsl_from_csv(
    csv_path = csv_path,
    adam_lib = adam_lib
  )
  
  # Display summary
  cat("\n=== ADSL Creation Completed Successfully! ===\n")
  cat("Number of subjects:", nrow(adsl), "\n")
  cat("Number of variables:", ncol(adsl), "\n\n")
  
  # Display first few rows
  cat("First 5 rows of ADSL:\n")
  print(head(adsl, 5))
  
  # Display column names
  cat("\nADSL variables:\n")
  print(names(adsl))
  
  cat("\n=== Demo completed successfully! ===\n")
}, error = function(e) {
  cat("ERROR during ADSL creation:", e$message, "\n")
  print(traceback())
  quit(status = 1)
})


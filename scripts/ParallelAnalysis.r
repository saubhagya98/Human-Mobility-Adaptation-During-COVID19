# ==============================================================================
# Comprehensive R Script for Horn's Parallel Analysis and Velicer's MAP Test
# Project: COVID-19 Human Mobility Factor Analysis (Sri Lanka Survey Dataset)
# Dataset: 40 Mobility and Behavioral Adaptation Items (N = 1,898) 
# ==============================================================================

# ------------------------------------------------------------------------------
# Step 1: Install and Load Required Libraries
# ------------------------------------------------------------------------------
# The 'psych' package contains optimized functions for EFA/PCA diagnostics,
# including fa.parallel() and MAP().
if (!requireNamespace("psych", quietly = TRUE)) {
  install.packages("psych")
}
library(psych)

# ------------------------------------------------------------------------------
# Step 2: Load and Prepare the Dataset
# ------------------------------------------------------------------------------
# Update the data_path to the location of your CSV file on your local machine.
# The uploaded file contains 40 items with a '_PP' suffix.
data_path <- "data/output/dataset_for_unsupervised_ML.csv"

if (!file.exists(data_path)) {
  stop("Dataset not found! Please place the CSV in your active working directory or update 'data_path'.")
}

# Read raw dataset
mobility_data <- read.csv(data_path, header = TRUE, stringsAsFactors = FALSE)

# Verify dimensions and column headers
cat("--- Dataset Diagnostics ---\n")
cat("Observations (Rows):", nrow(mobility_data), "\n") # Expected: 1898 
cat("Variables (Columns):", ncol(mobility_data), "\n\n") # Expected: 40 
print(head(mobility_data[, 1:5])) # Print a preview of the first 5 variables 

# ------------------------------------------------------------------------------
# Step 3: Horn's Parallel Analysis (PA)
# ------------------------------------------------------------------------------
# Horn's PA contrasts empirical eigenvalues against eigenvalues computed from 
# random data matrices of identical dimensions (1,898 x 40).[2, 3]
# We use 'fa = "both"' to plot and compare eigenvalues for both Principal 
# Components (PCA) and Exploratory Factor Analysis (EFA/Principal Axis).
# Set seed for reproducible Monte-Carlo simulations.
set.seed(12345) 

# Running the analysis
parallel_results <- fa.parallel(
  x = mobility_data, 
  fa = "fa",                 
  fm = "minres",             
  n.iter = 500, 
  error.bars = FALSE, 
  main = "Parallel Analysis for Latent Structure (40 Raw Items)"
)

# Printing only the number of factors
cat("Suggested number of factors:", parallel_results$nfact, "\n")

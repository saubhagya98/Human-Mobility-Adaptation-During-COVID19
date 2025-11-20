# Libraries
library(tidyverse)
library(ggforce)
library(ggtext)
library(readr)

# Data Preparation
# Step 1: Load all wave datasets
pre <- read_csv("PrePandemic.csv",show_col_types = FALSE)
first <- read_csv("First_Wave.csv",show_col_types = FALSE)
second <- read_csv("Second_Wave.csv",show_col_types = FALSE)
third <- read_csv("Third_Wave.csv", show_col_types = FALSE)

# Step 2: Compute mean per cluster for the factor "going to recreational places"
get_means <- function(df, wave_name) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`going to recreational places`, na.rm = TRUE)) %>%
    mutate(Wave = wave_name)
}

pre_means <- get_means(pre, "Pre-Pandemic")
first_means <- get_means(first, "First Wave")
second_means <- get_means(second, "Second Wave")
third_means <- get_means(third, "Third Wave")

# Combine into one dataframe
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Ensure Wave is ordered
all_means$Wave <- factor(all_means$Wave, levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

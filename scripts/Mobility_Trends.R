# Libraries
library(tidyverse)
library(ggforce)
library(ggtext)
library(readr)
library(cowplot)

# Data
pre <- read_csv("data/input/PrePandemic.csv",show_col_types = FALSE)
first <- read_csv("data/input/First_Wave.csv",show_col_types = FALSE)
second <- read_csv("data/input/Second_Wave.csv",show_col_types = FALSE)
third <- read_csv("data/input/Third_Wave.csv", show_col_types = FALSE)

# Factor 1

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

palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")

# Ensure ordered factor
all_means$Wave <- factor(all_means$Wave, levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Main slope graph
main_plot <- ggplot(all_means, aes(x = Wave, y = Mean, group = factor(cluster), color = factor(cluster))) +
  geom_line(size = 1.1) +
  geom_point(size = 2) +
  labs(
    title = "Slope Graph of Mean Mobility: Going to Recreational Places",
    x = "Wave",
    y = "Mean Score",
    color = "Cluster"
  ) +
  scale_color_manual(values = palette_cb) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "bottom"
  )

# Zoomed plot (only from First Wave onward)
zoom_df <- all_means %>% filter(Wave %in% c("First Wave", "Second Wave", "Third Wave"))

zoom_plot <- ggplot(zoom_df, aes(x = Wave, y = Mean, group = factor(cluster), color = factor(cluster))) +
  geom_line(size = 1.1) +
  geom_point(size = 2) +
  labs(title = "Zoomed Trend", x = "Wave", y = "Mean") +
  scale_color_manual(values = palette_cb) +
  theme_minimal(base_size = 10) +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 10)
  ) +
  coord_cartesian(ylim = c(-1.55, -1.35))

# Combine main + inset
final_plot <- ggdraw() +
  draw_plot(main_plot) +
  draw_plot(zoom_plot, x = 0.55, y = 0.4, width = 0.4, height = 0.4)

# Save output
ggsave("data/output/Factor1.png", plot = final_plot, width = 10, height = 6, dpi = 600, bg = "white")

# Factor 2
# Step 2: Define the variable for Factor 2
target_var <- "using own motor vehicles to going to work"

# Step 3: Function to calculate cluster means
get_means <- function(df, wave_label) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(.data[[target_var]], na.rm = TRUE)) %>%
    mutate(Wave = wave_label)
}

# Step 4: Get mean values for each wave
means_pre <- get_means(pre, "Pre-Pandemic")
means_first <- get_means(first, "First Wave")
means_second <- get_means(second, "Second Wave")
means_third <- get_means(third, "Third Wave")

# Step 5: Combine into a tidy dataframe
motor_means <- bind_rows(means_pre, means_first, means_second, means_third)

# Order wave factor for plotting
motor_means$Wave <- factor(motor_means$Wave, levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Colorblind-safe palette
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")

# Step 6: Plot (without value labels)
motor_plot <- ggplot(motor_means, aes(x = Wave, y = Mean, group = factor(cluster), color = factor(cluster))) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3.2) +
  scale_color_manual(values = palette_cb) +
  labs(
    title = "Change in Private Commuting & Work Exposure Across Pandemic Waves",
    subtitle = "Mean scores for the factor: <i>Using Own Motor Vehicles to Go to Work</i>, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 2: Private Commuting)",
    color = "Cluster"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_markdown(size = 12),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 12),
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    plot.margin = margin(15, 15, 15, 15)
  )

# Step 7: Save the cleaned plot
ggsave("data/output/Factor2.png", plot = motor_plot, width = 10, height = 6, dpi = 600, bg = "white")

# Factor 3
# Step 2: Define the variable for Factor 3
target_var <- "work from home"

# Step 3: Function to compute mean by cluster
get_means <- function(df, wave_label) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(.data[[target_var]], na.rm = TRUE)) %>%
    mutate(Wave = wave_label)
}

# Step 4: Calculate means for all waves
means_pre <- get_means(pre, "Pre-Pandemic")
means_first <- get_means(first, "First Wave")
means_second <- get_means(second, "Second Wave")
means_third <- get_means(third, "Third Wave")

# Step 5: Combine all into one tidy data frame
home_means <- bind_rows(means_pre, means_first, means_second, means_third)

# Step 6: Convert Wave into ordered factor
home_means$Wave <- factor(home_means$Wave, levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Define colorblind-friendly palette
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")

# Step 7: Plot the slope graph
home_plot <- ggplot(home_means, aes(x = Wave, y = Mean, group = factor(cluster), color = factor(cluster))) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3.2) +
  scale_color_manual(values = palette_cb) +
  labs(
    title = "Change in Home-Based Work Isolation Across Pandemic Waves",
    subtitle = "Mean scores for the factor: <i>Work from Home</i>, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 3: Home-Based Work Isolation)",
    color = "Cluster"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_markdown(size = 12),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 12),
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    plot.margin = margin(15, 15, 15, 15)
  )

# Step 8: Save the final plot
ggsave("data/output/Factor3.png", plot = home_plot, width = 10, height = 6, dpi = 600, bg = "white")

# Factor 4
# Step 2: Define the variable representing Factor 4
target_var <- "accessing to ATM in city"

# Step 3: Function to calculate mean by cluster
get_means <- function(df, wave_label) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(.data[[target_var]], na.rm = TRUE)) %>%
    mutate(Wave = wave_label)
}

# Step 4: Calculate means for each wave
means_pre <- get_means(pre, "Pre-Pandemic")
means_first <- get_means(first, "First Wave")
means_second <- get_means(second, "Second Wave")
means_third <- get_means(third, "Third Wave")

# Step 5: Combine all results
atm_means <- bind_rows(means_pre, means_first, means_second, means_third)

# Step 6: Format 'Wave' as ordered factor for correct slope ordering
atm_means$Wave <- factor(atm_means$Wave, levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Define a colorblind-friendly color palette
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")

# Step 7: Create slope plot
atm_plot <- ggplot(atm_means, aes(x = Wave, y = Mean, group = factor(cluster), color = factor(cluster))) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3.2) +
  scale_color_manual(values = palette_cb) +
  labs(
    title = "Change in Financial Access Points Across Pandemic Waves",
    subtitle = "Mean scores for the factor: <i>Accessing to ATM in City</i>, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 4: Financial Access Points)",
    color = "Cluster"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_markdown(size = 12),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 12),
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    plot.margin = margin(15, 15, 15, 15)
  )

# Step 8: Save final image in high resolution
ggsave("data/output/Factor4.png", plot = atm_plot, width = 10, height = 6, dpi = 600, bg = "white")

# Factor 5
# Step 2: Set variable representing Factor 5
target_var <- "using public transport to going to work"

# Step 3: Function to compute mean by cluster for a given wave
get_means <- function(df, wave_label) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(.data[[target_var]], na.rm = TRUE)) %>%
    mutate(Wave = wave_label)
}

# Step 4: Compute mean values for all waves
means_pre <- get_means(pre, "Pre-Pandemic")
means_first <- get_means(first, "First Wave")
means_second <- get_means(second, "Second Wave")
means_third <- get_means(third, "Third Wave")

# Step 5: Combine into single dataset
public_transport_means <- bind_rows(means_pre, means_first, means_second, means_third)

# Step 6: Format 'Wave' as an ordered factor for slope plotting
public_transport_means$Wave <- factor(public_transport_means$Wave,
                                      levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Step 7: Define color palette (colorblind friendly)
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")

# Step 8: Generate slope plot
pt_plot <- ggplot(public_transport_means, aes(x = Wave, y = Mean, group = factor(cluster), color = factor(cluster))) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3.2) +
  scale_color_manual(values = palette_cb) +
  labs(
    title = "Change in Public Transport Reliance Across Pandemic Waves",
    subtitle = "Mean scores for the factor: <i>Using Public Transport to Go to Work</i>, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 5: Public Transport Reliance)",
    color = "Cluster"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_markdown(size = 12),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 12),
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    plot.margin = margin(15, 15, 15, 15)
  )

# Step 9: Save the plot
ggsave("data/output/Factor5.png", plot = pt_plot, width = 10, height = 6, dpi = 600, bg = "white")

# Factor 6
# Function to calculate means by cluster
get_means <- function(data, variable, wave_label) {
  data %>%
    group_by(cluster) %>%
    summarise(Mean = mean(.data[[variable]], na.rm = TRUE)) %>%
    mutate(Wave = wave_label)
}

# Calculate means for Factor 6
factor6_var <- "accessing to food through Govt/NGO"
factor6_means <- bind_rows(
  get_means(pre, factor6_var, "Pre-Pandemic"),
  get_means(first, factor6_var, "First Wave"),
  get_means(second, factor6_var, "Second Wave"),
  get_means(third, factor6_var, "Third Wave")
)

# Convert Wave to ordered factor
factor6_means$Wave <- factor(factor6_means$Wave,
                             levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Colorblind-friendly palette
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")

# Plot
ggplot(factor6_means, aes(x = Wave, y = Mean, group = factor(cluster), color = factor(cluster))) +
  geom_line(linewidth = 1.3) +
  geom_point(size = 3) +
  scale_color_manual(values = palette_cb) +
  labs(
    title = "Access to Essential Services During Pandemic Waves",
    subtitle = "Mean scores for the factor: <i>Accessing Food through Govt/NGO</i>, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score \n(Factor 6:Essential Services and Community Resources Access)",
    color = "Cluster"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_markdown(size = 12),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 11),
    legend.position = "bottom",
    legend.title = element_text(size = 11),
    legend.text = element_text(size = 10),
    plot.margin = margin(15, 15, 15, 15)
  )

# Save to file
ggsave("data/output/Factor6.png", width = 10, height = 6, dpi = 600, bg = "white")

# Factor 7
# Colorblind-friendly palette
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")

# Load the datasets for each pandemic phase
pre_df <- read_csv("PrePandemic.csv",show_col_types = FALSE)
first_df <- read_csv("First_Wave.csv", show_col_types = FALSE)
second_df <- read_csv("Second_Wave.csv", show_col_types = FALSE)
third_df <- read_csv("Third_Wave.csv", show_col_types = FALSE)

# Function to calculate means for a given dataset
calc_means <- function(df, phase) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`using bicycle to going to work`, na.rm = TRUE)) %>%
    mutate(Phase = phase)
}

# Calculate means for each phase
pre_means <- calc_means(pre_df, "Pre-Pandemic")
first_means <- calc_means(first_df, "First Wave")
second_means <- calc_means(second_df, "Second Wave")
third_means <- calc_means(third_df, "Third Wave")

# Combine all means into one dataframe
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Ensure correct ordering of phases
all_means$Phase <- factor(all_means$Phase, 
                          levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))


# Plot with white background and consistent style
p <- ggplot(all_means, aes(x = Phase, y = Mean, color = as.factor(cluster), group = cluster)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  scale_color_manual(values = palette_cb)+
  labs(
    title = "Change in Bicycle Mobility Across Pandemic Waves",
    subtitle = "Mean scores for the factor: Using Bicycle to Go to Work, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 7: Bicycle Mobility)",
    color = "Cluster"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 14),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Save the plot
ggsave("data/output/Factor7.png", p, width = 12, height = 7, dpi = 300)

# Factor 8
# Colorblind-friendly palette
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")


# Function to calculate means for the target variable
calc_means <- function(df, phase) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`work with irregular few unknown people and limited unknown people`, na.rm = TRUE)) %>%
    mutate(Phase = phase)
}

# Calculate means for each phase
pre_means <- calc_means(pre_df, "Pre-Pandemic")
first_means <- calc_means(first_df, "First Wave")
second_means <- calc_means(second_df, "Second Wave")
third_means <- calc_means(third_df, "Third Wave")

# Combine all means
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Set factor order for phases
all_means$Phase <- factor(all_means$Phase,
                          levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Create plot
p <- ggplot(all_means, aes(x = Phase, y = Mean, color = as.factor(cluster), group = cluster)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  scale_color_manual(values = palette_cb)+
  labs(
    title = "Change in Variable Level of Work Exposure Across Pandemic Waves",
    subtitle = "Mean scores for the factor: Work with Limited & Irregular Contact with Unknown People, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 8: Variable Work Exposure)",
    color = "Cluster"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 14),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Save plot
ggsave("data/output/Factor8.png", p, width = 12, height = 7, dpi = 300)

# Factor 9
# Colorblind-friendly palette
palette_cb <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7")


# Function to calculate means for the target variable
calc_means <- function(df, phase) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`using hired three wheelers to going to work`, na.rm = TRUE)) %>%
    mutate(Phase = phase)
}

# Calculate means for each phase
pre_means <- calc_means(pre_df, "Pre-Pandemic")
first_means <- calc_means(first_df, "First Wave")
second_means <- calc_means(second_df, "Second Wave")
third_means <- calc_means(third_df, "Third Wave")

# Combine all means
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Set factor order for phases
all_means$Phase <- factor(all_means$Phase,
                          levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Create plot
p <- ggplot(all_means, aes(x = Phase, y = Mean, color = as.factor(cluster), group = cluster)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  scale_color_manual(values = palette_cb)+
  labs(
    title = "Change in Hired Transport Dependence Across Pandemic Waves",
    subtitle = "Mean scores for the factor: Using Hired Three-Wheelers to Go to Work, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 9: Hired Transport Dependence)",
    color = "Cluster"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 14),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Save plot
ggsave("data/output/Factor9.png", p, width = 12, height = 7, dpi = 300)

# Factor 10
# Function to calculate means for the target variable
calc_means <- function(df, phase) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`accessing to Home delivery/mobile shops`, na.rm = TRUE)) %>%
    mutate(Phase = phase)
}

# Calculate means for each phase
pre_means <- calc_means(pre_df, "Pre-Pandemic")
first_means <- calc_means(first_df, "First Wave")
second_means <- calc_means(second_df, "Second Wave")
third_means <- calc_means(third_df, "Third Wave")

# Combine all means
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Set factor order for phases
all_means$Phase <- factor(all_means$Phase,
                          levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Create plot
p <- ggplot(all_means, aes(x = Phase, y = Mean, color = as.factor(cluster), group = cluster)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  scale_color_manual(values = palette_cb)+
  labs(
    title = "Change in Community Resource Sourcing Across Pandemic Waves",
    subtitle = "Mean scores for the factor: Accessing Home Delivery or Mobile Shops, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 10: Community Resource Sourcing)",
    color = "Cluster"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 14),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Save plot
ggsave("data/output/Factor10.png", p, width = 12, height = 7, dpi = 300)

# Factor 11
# Function to calculate means for the target variable
calc_means <- function(df, phase) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`using shared vehicle  to going to work`, na.rm = TRUE)) %>%
    mutate(Phase = phase)
}

# Calculate means for each phase
pre_means <- calc_means(pre_df, "Pre-Pandemic")
first_means <- calc_means(first_df, "First Wave")
second_means <- calc_means(second_df, "Second Wave")
third_means <- calc_means(third_df, "Third Wave")

# Combine all means
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Set factor order for phases
all_means$Phase <- factor(all_means$Phase,
                          levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Create plot
p <- ggplot(all_means, aes(x = Phase, y = Mean, color = as.factor(cluster), group = cluster)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  scale_color_manual(values = palette_cb)+
  labs(
    title = "Change in Shared Group Transport Across Pandemic Waves",
    subtitle = "Mean scores for the factor: Using Shared Vehicle to Go to Work, by cluster",
    x = "Pandemic Phase",
    y = "Standardized Mean Score (Factor 11: Shared Group Transport)",
    color = "Cluster"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 14),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Save plot
ggsave("data/output/Factor11.png", p, width = 12, height = 7, dpi = 300)

# Factor 12
# Function to calculate means
calc_means <- function(df, phase) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`walking to going to work`, na.rm = TRUE)) %>%
    mutate(Phase = phase)
}

# Calculate means for all phases
pre_means <- calc_means(pre_df, "Pre-Pandemic")
first_means <- calc_means(first_df, "First Wave")
second_means <- calc_means(second_df, "Second Wave")
third_means <- calc_means(third_df, "Third Wave")

# Combine means
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Set order of phases
all_means$Phase <- factor(all_means$Phase,
                          levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Create wrapped y-axis label (manual line break)
y_label <- "Standardized Mean Score\n(Factor 12: Proximal Living and Active Commuting)"

# Create plot
p <- ggplot(all_means, aes(x = Phase, y = Mean, color = as.factor(cluster), group = cluster)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  scale_color_manual(values = palette_cb)+
  labs(
    title = "Change in Proximal Living and Active Commuting Across Pandemic Waves",
    subtitle = "Mean scores for the factor: Walking to Go to Work, by cluster",
    x = "Pandemic Phase",
    y = y_label,
    color = "Cluster"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 14),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Save plot
ggsave("data/output/Factor12.png", p, width = 12, height = 7, dpi = 300)

# Factor 13
# Function to calculate means for the variable
calc_means <- function(df, phase) {
  df %>%
    group_by(cluster) %>%
    summarise(Mean = mean(`accessing to online apps`, na.rm = TRUE)) %>%
    mutate(Phase = phase)
}

# Calculate means for all phases
pre_means <- calc_means(pre_df, "Pre-Pandemic")
first_means <- calc_means(first_df, "First Wave")
second_means <- calc_means(second_df, "Second Wave")
third_means <- calc_means(third_df, "Third Wave")

# Combine all means
all_means <- bind_rows(pre_means, first_means, second_means, third_means)

# Ensure correct order of phases
all_means$Phase <- factor(all_means$Phase,
                          levels = c("Pre-Pandemic", "First Wave", "Second Wave", "Third Wave"))

# Define y-axis label with line break
y_label <- "Standardized Mean Score\n(Factor 13: Digital Platform Engagement)"

# Create plot
p <- ggplot(all_means, aes(x = Phase, y = Mean, color = as.factor(cluster), group = cluster)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  theme_minimal(base_size = 14) +
  scale_color_manual(values = palette_cb)+
  labs(
    title = "Change in Digital Platform Engagement Across Pandemic Waves",
    subtitle = "Mean scores for the factor: Accessing Online Apps, by cluster",
    x = "Pandemic Phase",
    y = y_label,
    color = "Cluster"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    plot.subtitle = element_text(size = 14),
    legend.position = "bottom",
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# Save plot
ggsave("data/output/Factor13.png", p, width = 12, height = 7, dpi = 300)







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





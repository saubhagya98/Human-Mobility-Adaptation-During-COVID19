# Libraries
library(tidyverse)
library(ggforce)
library(ggtext)
library(readr)
library(cowplot)

# Data Preparation
# Step 1: Load all wave datasets
pre <- read_csv("data/input/PrePandemic.csv",show_col_types = FALSE)
first <- read_csv("data/input/First_Wave.csv",show_col_types = FALSE)
second <- read_csv("data/input/Second_Wave.csv",show_col_types = FALSE)
third <- read_csv("data/input/Third_Wave.csv", show_col_types = FALSE)

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

# Factor 1

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
ggsave("Factor1.png", plot = final_plot, width = 10, height = 6, dpi = 600, bg = "white")



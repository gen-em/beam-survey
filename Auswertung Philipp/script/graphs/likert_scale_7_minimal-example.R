library(tidyverse)
library(dplyr) 
library(ggplot2) 
library(patchwork)
library(ggtext) 
library(RColorBrewer)


## Create sample data
neutral_data <- data.frame(
  Category = c(
    "CME-Punkte sammeln",
    "Wissen aktuell halten",
    "Weiterbildung in spez. Fachbereichen",
    "Alternative zu Praesenzveranstaltungen",
    "Erlernen fachlicher Grundlagen"
  ),
  Response = rep(4, 5),  
  Count = c(8, 3, 7, 14, 5),
  Total = rep(101, 5),  
  Percentage = c(7.92, 2.97, 6.93, 13.86, 4.95),
  Code = rep("Neutral", 5)
)

nonneutral_data <- data.frame(
  Category = rep(c(
    "CME-Punkte sammeln",
    "Wissen aktuell halten",
    "Weiterbildung in spez. Fachbereichen",
    "Alternative zu Praesenzveranstaltungen",
    "Erlernen fachlicher Grundlagen"
  ), times = c(6, 3, 5, 5, 5)),
  
  Response = c(
    1, 2, 3, 5, 6, 7,
    5, 6, 7,
    1, 3, 5, 6, 7,
    2, 3, 5, 6, 7,
    2, 3, 5, 6, 7 
  ),
  
  Count = c(
    1, 3, 2, 11, 23, 53,
    7, 29, 62,
    1, 1, 12, 42, 37,
    5, 12, 18, 24, 27,
    3, 4, 12, 28, 49
  ),
  
  Total = rep(101, 24),  # Total respondents per category
  
  Percentage = c(
    0.99, 2.97, 1.98, 10.89, 22.70, 52.47,
    6.93, 28.71, 61.38,
    0.99, 0.99, 11.88, 41.58, 37.62,
    4.95, 11.88, 18.81, 23.76, 26.73,
    2.97, 3.96, 11.88, 27.72, 48.51
  ),
  
  Code = as.character(c(
    1, 2, 3, 5, 6, 7,
    5, 6, 7,
    1, 3, 5, 6, 7,
    2, 3, 5, 6, 7,
    2, 3, 5, 6, 7
  )),
  
  Label = c(
    "", "", "", "10.9%", "22.8%", "52.5%",
    "6.9%", "28.7%", "61.4%",
    "", "", "11.9%", "41.6%", "37.6%",
    "", "11.9%", "18.8%", "23.8%", "26.7%",
    "", "", "11.9%", "27.7%", "48.5%" 
  )
)

## Naming the columns & Setting order
column_names <- c(
  "Erlernen fachlicher Grundlagen",
  "Alternative zu Praesenzveranstaltungen",
  "Weiterbildung in spez. Fachbereichen",
  "Wissen aktuell halten",
  "CME-Punkte sammeln"
)

## Define Legend Labels
labels <- c(
  "1" = "Auf keinen Fall",
  "2" = "Wahrscheinlich nicht",
  "3" = "Eher nicht",
  "Neutral" = "Unentschlossen",
  "5" = "Eher ja",
  "6" = "Wahrscheinlich ja",
  "7" = "Auf jeden Fall"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Color and Label Setup
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

brewer_colors <- brewer.pal(n = 7, name = "RdBu")
cols <- c(
  "1" = brewer_colors[1],
  "2" = brewer_colors[2],
  "3" = brewer_colors[3],
  "Neutral" = "#B4B4B4",
  "5" = brewer_colors[5],
  "6" = brewer_colors[6],
  "7" = brewer_colors[7]
)

# Function to create formatted legend labels
custom_labels <- function(labels, colors) {
  sapply(names(labels), function(i) {
    paste0("<span style='color:", colors[i], ";'>", labels[i], "</span>")
  })
}

# Create one formatted label set for all values (1-7 + Neutral)
formatted_labels <- custom_labels(labels, cols)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Calculate Plot Dimensions
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stacked_sums <- nonneutral_data %>%
  group_by(Category) %>%
  summarise(
    LeftSum = sum(Percentage[Code %in% c("1", "2", "3")]),
    RightSum = sum(Percentage[Code %in% c("5", "6", "7")])
  ) %>%
  ungroup()

max_left_stack <- max(stacked_sums$LeftSum)
max_right_stack <- max(stacked_sums$RightSum)
max_neutral <- max(neutral_data$Percentage)

x_left <- max(ceiling(max_left_stack / 10) * 10, 15)
x_right <- max(ceiling(max_right_stack / 10) * 10, 15)
x_neutral <- max(ceiling(max_neutral / 5) * 5, 12.5)

x_left <- min(x_left, 100)
x_right <- min(x_right, 100)
x_neutral <- min(x_neutral, 100)

width_ratio <- (x_left + x_right) / max(x_neutral, 12.5)

x_breaks <- unique(sort(c(
  -10, 10, 
  seq(-ceiling(x_left / 10) * 10, ceiling(x_right / 10) * 10, by = 20)
)))

hjust_values <- sapply(x_breaks, function(x) {
  if (x == min(x_breaks, na.rm = TRUE)) {
    0
  } else if (x == max(x_breaks, na.rm = TRUE)) {
    1
  } else {
    0.5
  }
})

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Create Plots
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p1 <- ggplot(nonneutral_data, 
             aes(x = ifelse(Code %in% c("1", "2", "3"), -Percentage, Percentage),
                 y = factor(Category, levels = rev(column_names)),  # Force the correct order
                 fill = factor(Code, levels = c("3", "2", "1", "5", "6", "7")))) +
  geom_col(position = position_stack(reverse = TRUE)) +
  geom_text(aes(label = Label),
            position = position_stack(vjust = 0.5, reverse = TRUE),
            size = 2.5) + #Reduced Text Size
  scale_fill_manual(
    values = cols,
    labels = formatted_labels
  ) +
  guides(fill = guide_legend(title = NULL, 
                             nrow = 1, 
                             byrow = FALSE,
                             override.aes = list(fill = NA, size = 0))) +
  scale_x_continuous(breaks = x_breaks,
                     labels = ~paste0(abs(.x), "%"),
                     limits = c(-x_left, x_right),
                     expand = c(0, 0)) +
  geom_vline(xintercept = 0, 
             linetype = "solid", 
             linewidth = 1.5, 
             color = "grey30") +
  theme_bw() +
  theme(
    panel.grid.major.y = element_blank(),
    legend.text = element_markdown(size = 8, face = "bold"),
    legend.box.just = "left",
    legend.justification = "left",
    legend.position = "top",
    axis.title = element_blank(),
    axis.text = element_markdown(),
    axis.text.x = element_markdown(hjust = hjust_values),
    axis.text.y = element_markdown(),
    axis.ticks.y = element_line(),
    panel.background = element_blank(),
    plot.background = element_rect(fill = "transparent", color = NA),
    legend.background = element_blank(),
  ) +
  coord_fixed(ratio = 7)

p2 <- ggplot(neutral_data, aes(x = Percentage, y = Category, fill = Code)) +
  geom_col() +
  geom_text(data = neutral_data %>% 
              filter(Percentage >= 5),
            aes(label = paste0(round(Percentage, 1), "%")),
            position = position_stack(vjust = 0.5),
            size = 2.5) +
  geom_text(data = neutral_data %>% 
              filter(Percentage < 5),
            aes(label = paste0(round(Percentage, 1), "%"),
                x = Percentage + 1),
            hjust = 0,
            size = 2.5) +  # Reduced text size
  scale_fill_manual(
    values = cols,
    labels = formatted_labels
  ) +
  guides(fill = guide_legend(title = NULL,
                             nrow = 1,
                             override.aes = list(fill = NA, size = 0))) +
  scale_x_continuous(limits = c(0, x_neutral),
                     expand = c(0, 0),
                     labels = ~paste0(.x, "%")) +
  theme_bw() +
  theme(
    panel.grid.major.y = element_blank(),
    legend.text = element_markdown(size = 8, face = "bold"),
    legend.justification = "left",
    legend.position = "top",
    axis.title = element_blank(),
    axis.text = element_markdown(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    panel.background = element_blank(),
    plot.background = element_rect(fill = "transparent", color = NA),
    legend.background = element_blank()
  ) +
  coord_fixed(ratio = 7)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Combine and Return Plots
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot_example <- (p1 | p2) +
  plot_layout(
    guides = "keep",
    widths = c(1, 1 / width_ratio)
  ) +
  plot_annotation(
    title = "Plot Test",
    theme = theme(
      plot.title = element_text(
        hjust = 0.5,
        vjust = 1,
        size = 12,
        face = "bold"
      ),
      plot.background = element_rect(fill = "transparent", color = NA),
      legend.position = "top",
      legend.justification = "left",
      legend.box.just = "left"
    )
  )

ggsave(
  filename = "plot_example.png",  
  plot = plot_example,         
  width = 9,                   
  height = 9 * 0.4,            
  dpi = 150,                   
  units = "in",                
  device = "png"               
)
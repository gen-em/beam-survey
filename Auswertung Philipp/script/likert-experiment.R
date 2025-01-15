# Einstellungen ----
source("./script/global.R")
source("./script/filter_grundlegend.R")

# Definiere Eingangsfilter, um später leichter wechseln zu können
filtered_data <- filtered_assistent

# Entferne alle anderen Filter, belasse nur filtered_data & table_ & plot_
rm(list = setdiff(ls(), c(ls(pattern = "^filtered_data"), grep("^(table_|plot_|data_)", ls(), value = TRUE))))

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 1 - Basisdaten ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

library(ggplot2)
library(patchwork)
library(dplyr)
library(tidyr)
library(scales)
library(ggtext)

# Filter the relevant columns
filtered_data_subset <- filtered_data %>%
  select(
    `5.23-grundlagen`,
    `5.23-alternative_praesenz`,
    `5.23-spezielle_fachbereiche`,
    `5.23-aktuell`,
    `5.23-cme`
  )

# Rename the columns for better readability
colnames(filtered_data_subset) <- c(
  "Erlernen fachlicher Grundlagen",
  "Alternative zu Präsenzveranstaltungen",
  "Weiterbildung in spez. Fachbereichen",
  "Wissen aktuell halten",
  "CME-Punkte sammeln"
)

# Transform data to long format
filtered_data_long <- filtered_data_subset %>%
  pivot_longer(
    cols = everything(),
    names_to = "Category",
    values_to = "Response"
  )

# Summarize and calculate proportions
# Summarize and calculate percentages instead of proportions
response_summary <- filtered_data_long %>%
  group_by(Category) %>%                            
  mutate(Total = n()) %>%                          
  group_by(Category, Response) %>%                  
  summarise(
    Count = n(),
    Total = first(Total),                          
    Percentage = (Count / Total) * 100,    # Changed from Proportion to Percentage
    .groups = "drop"
  ) %>%
  ungroup()

# Define custom colors and labels
cols <- c("#D73027", "#FC8D59", "#FEE090", "#B4B4B4", "#91BFDB", "#4575B4", "#313695")
names(cols) <- c(1, 2, 3, "Neutral", 5, 6, 7)

labels <- c(
  "Auf keinen Fall",
  "Wahrscheinlich nicht",
  "Eher nicht",
  "Unentschlossen",
  "Eher ja",
  "Wahrscheinlich ja",
  "Auf jeden Fall"
)

names(labels) <- c(1, 2, 3, "Neutral", 5, 6, 7)

# Custom legend labels function
custom_labels <- function(labels, colors) {
  sapply(1:length(labels), function(i) {
    paste0(
      "<span style='color:", colors[i], ";'>", labels[i], "</span>"
    )
  })
}

# Generate formatted labels
formatted_labels <- custom_labels(
  labels = labels[c(1, 2, 3, 5, 6, 7)],
  colors = cols[c(1, 2, 3, 5, 6, 7)]
)

formatted_labels_neutral <- custom_labels(
  labels = labels["Neutral"],
  colors = cols["Neutral"]
)

# Split data into neutral and non-neutral
response_summary <- response_summary %>%
  mutate(
    Code = case_when(
      Response %in% c(1, 2, 3) ~ as.character(Response),
      Response == 4 ~ "Neutral",
      Response %in% c(5, 6, 7) ~ as.character(Response)
    )
  )

df_neutral <- filter(response_summary, Code == "Neutral")
df_nonneutral <- filter(response_summary, Code != "Neutral")

### Berechnungen für die X-Achsen (Min/Max Größe & Konstante Relationen)
# Calculate stacked sums
stacked_sums <- df_nonneutral %>%
  group_by(Category) %>%
  summarise(
    LeftSum = sum(Percentage[Code %in% c("1", "2", "3")]),
    RightSum = sum(Percentage[Code %in% c("5", "6", "7")])
  ) %>%
  ungroup()

# Get the maximum stacked sums for each side
max_left_stack <- max(stacked_sums$LeftSum)
max_right_stack <- max(stacked_sums$RightSum)
max_neutral <- max(df_neutral$Percentage)

# Set X-axis length rounded up to next multiple of 10 or 5 and add Minimum length
x_left <- max(ceiling(max_left_stack / 10) * 10, 15)  # Minimum 15%
x_right <- max(ceiling(max_right_stack / 10) * 10, 15)  # Minimum 15%
x_neutral <- max(ceiling(max_neutral / 5) * 5, 12.5)  # Minimum 12.5%

# Cap the limits at 100% if they exceed it
x_left <- min(x_left, 100)
x_right <- min(x_right, 100)
x_neutral <- min(x_neutral, 100)

# Calculate the x-axis ranges
range_p1 <- x_left + x_right  # Total range for p1
range_p2 <- max(x_neutral, 12.5)       # Total range for p2

# Calculate the width ratio between p1 and p2 to keep x-ratios when joining graphs
width_ratio <- range_p1 / range_p2

### Labeling der X-Achsen
# Generate breaks dynamically, ensuring 10% is always included, sonst alle 20%
x_breaks <- unique(sort(c(-10, 10, seq(-ceiling(x_left / 10) * 10, ceiling(x_right / 10) * 10, by = 20))))

# Dynamically generate hjust values for the breaks
hjust_values <- sapply(x_breaks, function(x) {
  if (x == min(x_breaks, na.rm = TRUE)) {
    0  # Left-align the first tick label
  } else if (x == max(x_breaks, na.rm = TRUE)) {
    1  # Right-align the last tick label
  } else {
    0.5  # Center-align all other labels
  }
})

### Conditional Labels on Bars
# % CutOff for showing labels on Bars
percent_cutoff = 7
# Add a column for conditional labels
df_nonneutral <- df_nonneutral %>%
  mutate(Label = ifelse(abs(Percentage) >= percent_cutoff, paste0(round(abs(Percentage), 1), "%"), ""))


#%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Graph erstellen
#%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Plot for non-neutral data (responses 1-3 and 5-7)
p1 <- ggplot(df_nonneutral, aes(x = ifelse(Code %in% c("1", "2", "3"), -Percentage, Percentage), 
                                y = Category, 
                                fill = factor(Code, levels = c("3", "2", "1", "5", "6", "7")))) +
  geom_col(position = position_stack(reverse = TRUE)) +
  # Use the Label column to ensure proper centering
  geom_text(aes(label = Label),
            position = position_stack(vjust = 0.5, reverse = TRUE)) +
  scale_fill_manual(
    values = cols[c(1, 2, 3, 5, 6, 7)],
    labels = formatted_labels
  ) +
  guides(fill = guide_legend(
    title = NULL, 
    nrow = 1, 
    byrow = TRUE,
    override.aes = list(fill = NA, size = 0)
  )) +
  scale_x_continuous(
    breaks = x_breaks,
    labels = ~ paste0(abs(.x), "%"),  # Standard percentage labels
    limits = c(-x_left, x_right),
    expand = c(0, 0)
  ) +
  geom_vline(xintercept = 0, linetype = "solid", size = 1, color = "grey30") +  # Bold 0% line
  theme_bw() +
  theme(
    legend.position = "top",
    legend.text = element_markdown(size = 10, face = "bold"),
    axis.title = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.text = element_markdown(),
    axis.text.x = element_text(hjust = hjust_values)
  )

# Plot for neutral data (response 4)
p2 <- ggplot(df_neutral, aes(x = Percentage, y = Category, fill = Code)) +
  geom_col() +
  # Inside labels for >=7%
  geom_text(data = . %>% filter(Percentage >= percent_cutoff),
            aes(label = paste0(round(Percentage, 1), "%")),
            position = position_stack(vjust = 0.5)) + 
  # Outside labels for <7%
  geom_text(data = . %>% filter(Percentage < percent_cutoff),
            aes(label = paste0(round(Percentage, 1), "%"),
                x = Percentage + 1), # Offset to the right
            hjust = 0) +
  scale_fill_manual(
    values = cols["Neutral"],
    labels = formatted_labels_neutral
  ) +
  guides(fill = guide_legend(
    title = NULL, 
    nrow = 1,
    override.aes = list(fill = NA, size = 0)
  )) +
  scale_x_continuous(
    limits = c(0, x_neutral),
    expand = c(0, 0),
    labels = ~ paste0(.x, "%")
  ) +
  theme_bw() +
  theme(
    legend.position = "top",
    legend.text = element_markdown(size = 10, face = "bold"),
    axis.title = element_blank(),
    axis.text.y = element_blank(),  # Remove y-axis labels
    axis.ticks.y = element_blank(), # Remove y-axis ticks
    axis.text = element_markdown(),
    panel.grid.major.y = element_blank()
  )

# Combine the plots side by side with adjusted widths
final_plot <- (p1 | p2) +  # Use | to arrange side by side
  plot_layout(
    guides = "collect",     # Collect legends
    widths = c(1, 1 / width_ratio)  # Dynamically adjust width of p2
  ) &
  theme(
    legend.position = "top", 
    legend.margin = margin(5, 0, 5, 0)
  )

# Print the final plot
print(final_plot)
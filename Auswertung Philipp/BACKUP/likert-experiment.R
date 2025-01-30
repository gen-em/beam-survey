#==============================================================================
# CONFIGURATION
#==============================================================================

# Load required packages and global settings
source("./script/global.R")
source("./script/filter_grundlegend.R")

#------------------------------------------------------------------------------
# Data filtering setup
#------------------------------------------------------------------------------
filtered_data <- filtered_assistent

# Cleanup workspace, keeping only essential objects
rm(list = setdiff(ls(), c(ls(pattern = "^filtered_data"), 
                          grep("^(table_|plot_|data_)", ls(), value = TRUE))))

#------------------------------------------------------------------------------
# Constants and Parameters
#------------------------------------------------------------------------------
# Plot Title
PLOT_TITLE <- "Würden ÄrztInnen in Weiterbildung E-Learning in folgenden Anwendungsfällen nutzen?"

# Output Name (table_**name** und plot_**name** werden automatisch erstellt)
# Nur NAME_FRAGE definieren
NAME_FRAGE <- "motivation"  # Define the base name
OUTPUT_TABLE <- paste0("table_", NAME_FRAGE)
OUTPUT_PLOT <- paste0("plot_", NAME_FRAGE)   

# Column definitions
SELECTED_COLUMNS <- c(
  "5.23-grundlagen",
  "5.23-alternative_praesenz",
  "5.23-spezielle_fachbereiche",
  "5.23-aktuell",
  "5.23-cme"
)

COLUMN_NAMES <- c(
  "Erlernen fachlicher Grundlagen",
  "Alternative zu Präsenzveranstaltungen",
  "Weiterbildung in spez. Fachbereichen",
  "Wissen aktuell halten",
  "CME-Punkte sammeln"
)

# Visualization parameters (Brewer color palette, Percent-Cutoff for labels)
BREWER_PALETTE <- "RdBu"
minimum_label_percentage <- 4

# Label definitions
labels <- c(
  "1" = "Auf keinen Fall",
  "2" = "Wahrscheinlich nicht",
  "3" = "Eher nicht",
  "Neutral" = "Unentschlossen",
  "5" = "Eher ja",
  "6" = "Wahrscheinlich ja",
  "7" = "Auf jeden Fall"
)

#==============================================================================
# DATA PREPARATION
#==============================================================================

# Create initial subset
filtered_data_subset <- filtered_data %>%
  dplyr::select(all_of(SELECTED_COLUMNS)) %>%
  setNames(COLUMN_NAMES)

# Create reversed labels for column renaming
labels_reversed <- setNames(names(labels), labels)

#------------------------------------------------------------------------------
# Create Summary Table
#------------------------------------------------------------------------------

assign(OUTPUT_TABLE, filtered_data_subset) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Abfrage",
    values_to = "rating"
  ) %>%
  count(Abfrage, rating) %>%
  pivot_wider(
    names_from = rating,
    values_from = n,
    values_fill = 0
  ) %>%
  dplyr::select(-`NA`) %>%
  dplyr::select(Abfrage, as.character(1:7)) %>%
  rename("Neutral" = "4") %>%
  rename(!!!labels_reversed)

#==============================================================================
# VISUALIZATION PREPARATION
#==============================================================================

#------------------------------------------------------------------------------
# Transform Data for Plotting
#------------------------------------------------------------------------------

# Create long format data
filtered_data_long <- filtered_data_subset %>%
  pivot_longer(
    cols = everything(),
    names_to = "Category",
    values_to = "Response"
  )

# Calculate response percentages
response_summary <- filtered_data_long %>%
  group_by(Category) %>%
  mutate(Total = n()) %>%
  group_by(Category, Response) %>%
  summarise(
    Count = n(),
    Total = first(Total),
    Percentage = (Count / Total) * 100,
    .groups = "drop"
  ) %>%
  ungroup()

#------------------------------------------------------------------------------
# Color and Label Setup
#------------------------------------------------------------------------------

# Set up color palette
brewer_colors <- brewer.pal(n = 7, name = BREWER_PALETTE)

# Define color mapping
cols <- c(
  "1" = brewer_colors[1],
  "2" = brewer_colors[2],
  "3" = brewer_colors[3],
  "Neutral" = "#B4B4B4",
  "5" = brewer_colors[5],
  "6" = brewer_colors[6],
  "7" = brewer_colors[7]
)

# Create formatted labels function
custom_labels <- function(labels, colors) {
  sapply(1:length(labels), function(i) {
    paste0("<span style='color:", colors[i], ";'>", labels[i], "</span>")
  })
}

# Generate formatted labels
formatted_labels <- custom_labels(
  labels = labels[c(1, 2, 3, 5, 6, 7)],
  colors = cols[c(1, 2, 3, 5, 6, 7)]
)

formatted_labels_neutral <- paste0(
  "<span style='color:", cols["Neutral"], ";'>", 
  labels["Neutral"], 
  "</span>"
)

#------------------------------------------------------------------------------
# Data Processing for Visualization
#------------------------------------------------------------------------------

# Add response codes and split data
response_summary <- response_summary %>%
  mutate(
    Code = case_when(
      Response %in% c(1, 2, 3) ~ as.character(Response),
      Response == 4 ~ "Neutral",
      Response %in% c(5, 6, 7) ~ as.character(Response)
    )
  )

# Split into neutral and non-neutral datasets
df_neutral <- filter(response_summary, Code == "Neutral")
df_nonneutral <- filter(response_summary, Code != "Neutral")

# Add conditional labels
df_nonneutral <- df_nonneutral %>%
  mutate(Label = ifelse(
    abs(Percentage) >= minimum_label_percentage, 
    paste0(round(abs(Percentage), 1), "%"), 
    ""
  ))

# Split into positive and negative datasets
df_negative <- df_nonneutral %>%
  filter(Code %in% c("1", "2", "3")) %>%
  mutate(Position = -Percentage)

df_positive <- df_nonneutral %>%
  filter(Code %in% c("5", "6", "7")) %>%
  mutate(Position = Percentage)

#------------------------------------------------------------------------------
# Calculate Plot Dimensions
#------------------------------------------------------------------------------

# Calculate stacked sums
stacked_sums <- df_nonneutral %>%
  group_by(Category) %>%
  summarise(
    LeftSum = sum(Percentage[Code %in% c("1", "2", "3")]),
    RightSum = sum(Percentage[Code %in% c("5", "6", "7")])
  ) %>%
  ungroup()

# Calculate axis limits
max_left_stack <- max(stacked_sums$LeftSum)
max_right_stack <- max(stacked_sums$RightSum)
max_neutral <- max(df_neutral$Percentage)

# Set and adjust axis ranges
x_left <- max(ceiling(max_left_stack / 10) * 10, 15)
x_right <- max(ceiling(max_right_stack / 10) * 10, 15)
x_neutral <- max(ceiling(max_neutral / 5) * 5, 12.5)

# Apply limits
x_left <- min(x_left, 100)
x_right <- min(x_right, 100)
x_neutral <- min(x_neutral, 100)

# Calculate plot ratios
range_p1 <- x_left + x_right
range_p2 <- max(x_neutral, 12.5)
width_ratio <- range_p1 / range_p2

# Generate axis breaks
x_breaks <- unique(sort(c(
  -10, 10, 
  seq(-ceiling(x_left / 10) * 10, ceiling(x_right / 10) * 10, by = 20)
)))

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

#==============================================================================
# Store all necessary data into a custom named list
#==============================================================================

# Create a list with all necessary components
plot_components <- list(
  df_neutral = df_neutral,
  df_nonneutral = df_nonneutral,
  cols = cols,
  formatted_labels = formatted_labels,
  formatted_labels_neutral = formatted_labels_neutral,
  x_breaks = x_breaks,
  x_left = x_left,
  x_right = x_right,
  x_neutral = x_neutral,
  hjust_values = hjust_values,
  width_ratio = width_ratio,
  minimum_label_percentage = minimum_label_percentage,
  plot_title = PLOT_TITLE
)

# Assign the components to our output name with _data suffix
assign(paste0("data_", OUTPUT_PLOT), plot_components)

#==============================================================================
# PLOT CREATION
#==============================================================================

create_plots <- function(components) {
  # Create main plot
  p1 <- ggplot(components$df_nonneutral, 
               aes(x = ifelse(Code %in% c("1", "2", "3"), -Percentage, Percentage),
                   y = Category,
                   fill = factor(Code, levels = c("3", "2", "1", "5", "6", "7")))) +
    geom_col(position = position_stack(reverse = TRUE)) +
    geom_text(aes(label = Label),
              position = position_stack(vjust = 0.5, reverse = TRUE)) +
    scale_fill_manual(values = components$cols[c("1", "2", "3", "5", "6", "7")],
                      labels = components$formatted_labels) +
    guides(fill = guide_legend(title = NULL, 
                               nrow = 1, 
                               byrow = FALSE,
                               override.aes = list(fill = NA, size = 0))) +
    scale_x_continuous(breaks = components$x_breaks,
                       labels = ~paste0(abs(.x), "%"),
                       limits = c(-components$x_left, components$x_right),
                       expand = c(0, 0)) +
    geom_vline(xintercept = 0, 
               linetype = "solid", 
               linewidth = 1.5, 
               color = "grey30") +
    theme_bw() +
    theme(
      panel.grid.major.y = element_blank(),
      legend.text = element_markdown(size = 10, face = "bold"),
      legend.position = c(0.483, 1.1),
      axis.title = element_blank(),
      axis.text = element_markdown(),
      axis.text.x = element_markdown(hjust = hjust_values),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank()
    ) +
    coord_fixed(ratio = 7)
  
  # Create neutral response plot
  p2 <- ggplot(components$df_neutral, aes(x = Percentage, y = Category, fill = Code)) +
    geom_col() +
    geom_text(data = components$df_neutral %>% 
                filter(Percentage >= components$minimum_label_percentage),
              aes(label = paste0(round(Percentage, 1), "%")),
              position = position_stack(vjust = 0.5)) +
    geom_text(data = components$df_neutral %>% 
                filter(Percentage < components$minimum_label_percentage),
              aes(label = paste0(round(Percentage, 1), "%"),
                  x = Percentage + 1),
              hjust = 0) +
    scale_fill_manual(values = components$cols["Neutral"],
                      labels = components$formatted_labels_neutral) +
    guides(fill = guide_legend(title = NULL,
                               nrow = 1,
                               override.aes = list(fill = NA, size = 0))) +
    scale_x_continuous(limits = c(0, components$x_neutral),
                       expand = c(0, 0),
                       labels = ~paste0(.x, "%")) +
    theme_bw() +
    theme(
      panel.grid.major.y = element_blank(),
      legend.text = element_markdown(size = 10, face = "bold"),
      legend.position = c(0.4, 1.1),
      axis.title = element_blank(),
      axis.text = element_markdown(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank()
    ) +
    coord_fixed(ratio = 7)
  
  # Combine plots
  (p1 | p2) +
    plot_layout(
      guides = "keep",
      widths = c(1, 1 / components$width_ratio)
    ) +
    plot_annotation(                        
      title = components$plot_title,        
      theme = theme(                        
        plot.title = element_text(
          hjust = 0.5,
          vjust = 1,
          size = 12,
          face = "bold"
    ),
  )
)
}

# Create and assign the plot using the components
assign(OUTPUT_PLOT, create_plots(get(paste0("data_", OUTPUT_PLOT))))

# Clean up keeping only our outputs
to_keep <- c(
  OUTPUT_TABLE, 
  OUTPUT_PLOT,
  paste0("data_", OUTPUT_PLOT)
)
rm(list = setdiff(ls(), to_keep))

# Print the plot (optional, depending on your needs)
print(plot_motivation)
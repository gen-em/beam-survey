#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R Code ----
# Functions for creating 7-point Likert scale visualizations and tables
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_likert_7_table <- function(filtered_data, selected_columns, column_names, labels) {
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Create Summary Table
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Create initial subset and prepare labels
  filtered_data_subset <- filtered_data %>%
    dplyr::select(all_of(selected_columns)) %>%
    setNames(column_names)
  
  labels_reversed <- setNames(names(labels), labels)
  
  # Generate and transform table
  filtered_data_subset %>%
    pivot_longer(
      cols = everything(),
      names_to = "Abfrage",
      values_to = "rating"
    ) %>%
    count(Abfrage, rating) %>%
    # Ensure all ratings 1-7 are included
    complete(
      Abfrage,
      rating = 1:7,
      fill = list(n = 0)
    ) %>%
    pivot_wider(
      names_from = rating,
      values_from = n,
      values_fill = 0
    ) %>%
    mutate(across(everything(), ~replace_na(., 0))) %>%  # Replace NAs with 0
    rename_with(~"4", matches("^4$")) %>%  # Rename 4 first
    rename_with(~"Neutral", matches("^4$")) %>%  # Then rename 4 to Neutral
    rename_with(~labels[.x], matches("^[1-7]$")) %>%  # Then apply the labels
    select(-`NA`)  # Remove the NA column if it exists
}

create_likert_7_plot <- function(filtered_data, selected_columns, column_names, plot_title, 
                               brewer_palette, minimum_label_percentage, labels, show_y_labels = TRUE) {
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Preparation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Create initial subset
  filtered_data_subset <- filtered_data %>%
    dplyr::select(all_of(selected_columns)) %>%
    setNames(column_names)
  
  # Transform data for plotting
  filtered_data_long <- filtered_data_subset %>%
    pivot_longer(
      cols = everything(),
      names_to = "Category",
      values_to = "Response"
    )
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Calculate Response Percentages
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
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
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Color and Label Setup
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  brewer_colors <- brewer.pal(n = 7, name = brewer_palette)
  cols <- c(
    "1" = brewer_colors[1],
    "2" = brewer_colors[2],
    "3" = brewer_colors[3],
    "Neutral" = "#B4B4B4",
    "5" = brewer_colors[5],
    "6" = brewer_colors[6],
    "7" = brewer_colors[7]
  )
  
  custom_labels <- function(labels, colors) {
    sapply(1:length(labels), function(i) {
      paste0("<span style='color:", colors[i], ";'>", labels[i], "</span>")
    })
  }
  
  formatted_labels <- custom_labels(
    labels = labels[c(1, 2, 3, 5, 6, 7)],
    colors = cols[c(1, 2, 3, 5, 6, 7)]
  )
  
  formatted_labels_neutral <- paste0(
    "<span style='color:", cols["Neutral"], ";'>", 
    labels["Neutral"], 
    "</span>"
  )
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Processing
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
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
  
  df_nonneutral <- df_nonneutral %>%
    mutate(Label = ifelse(
      abs(Percentage) >= minimum_label_percentage, 
      paste0(round(abs(Percentage), 1), "%"), 
      ""
    ))
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Calculate Plot Dimensions
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  stacked_sums <- df_nonneutral %>%
    group_by(Category) %>%
    summarise(
      LeftSum = sum(Percentage[Code %in% c("1", "2", "3")]),
      RightSum = sum(Percentage[Code %in% c("5", "6", "7")])
    ) %>%
    ungroup()
  
  max_left_stack <- max(stacked_sums$LeftSum)
  max_right_stack <- max(stacked_sums$RightSum)
  max_neutral <- max(df_neutral$Percentage)
  
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
  
  p1 <- ggplot(df_nonneutral, 
               aes(x = ifelse(Code %in% c("1", "2", "3"), -Percentage, Percentage),
                   y = Category,
                   fill = factor(Code, levels = c("3", "2", "1", "5", "6", "7")))) +
    geom_col(position = position_stack(reverse = TRUE)) +
    geom_text(aes(label = Label),
              position = position_stack(vjust = 0.5, reverse = TRUE),
              size = 2.5) + #Reduced Text Size
    scale_fill_manual(values = cols[c("1", "2", "3", "5", "6", "7")],
                      labels = formatted_labels) +
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
      legend.text = element_markdown(size = 9, face = "bold"),
      legend.position = "top",
      axis.title = element_blank(),
      axis.text = element_markdown(),
      axis.text.x = element_markdown(hjust = hjust_values),
      axis.text.y = if(show_y_labels) element_text() else element_blank(),
      axis.ticks.y = if(show_y_labels) element_line() else element_blank()
    ) +
    coord_fixed(ratio = 7)
  
  p2 <- ggplot(df_neutral, aes(x = Percentage, y = Category, fill = Code)) +
    geom_col() +
    geom_text(data = df_neutral %>% 
                filter(Percentage >= minimum_label_percentage),
              aes(label = paste0(round(Percentage, 1), "%")),
              position = position_stack(vjust = 0.5),
              size = 2.5) +
    geom_text(data = df_neutral %>% 
                filter(Percentage < minimum_label_percentage),
              aes(label = paste0(round(Percentage, 1), "%"),
                  x = Percentage + 1),
              hjust = 0,
              size = 2.5) +  # Reduced text size
    scale_fill_manual(values = cols["Neutral"],
                      labels = formatted_labels_neutral) +
    guides(fill = guide_legend(title = NULL,
                               nrow = 1,
                               override.aes = list(fill = NA, size = 0))) +
    scale_x_continuous(limits = c(0, x_neutral),
                       expand = c(0, 0),
                       labels = ~paste0(.x, "%")) +
    theme_bw() +
    theme(
      panel.grid.major.y = element_blank(),
      legend.text = element_markdown(size = 9, face = "bold"),
      legend.position = "top",
      axis.title = element_blank(),
      axis.text = element_markdown(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank()
    ) +
    coord_fixed(ratio = 7)
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Combine and Return Plots
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  (p1 | p2) +
    plot_layout(
      guides = "keep",
      widths = c(1, 1 / width_ratio)
    ) +
    plot_annotation(
      title = plot_title,
      theme = theme(
        plot.title = element_text(
          hjust = 0.5,
          vjust = 1,
          size = 12,
          face = "bold"
        )
      )
    )
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Konfiguration ----
# In die sourcende Datei einfügen und # entfernen :)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# NAME_FRAGE <- "name_der_variablen für plot_ und table_"
# PLOT_TITLE <- "Titeltext des Plots"
# 
# ## Columns of Interest definieren (aus filtered_data)
# SELECTED_COLUMNS <- c(
#   "5.23-grundlagen",
#   "5.23-alternative_praesenz",
#   "5.23-spezielle_fachbereiche",
#   "5.23-aktuell",
#   "5.23-cme"
# )
# 
# ## Columns benennen
# COLUMN_NAMES <- c(
#   "Erlernen fachlicher Grundlagen",
#   "Alternative zu Präsenzveranstaltungen",
#   "Weiterbildung in spez. Fachbereichen",
#   "Wissen aktuell halten",
#   "CME-Punkte sammeln"
# )
# 
# ## Welche Brewer Palette zur Farbgebung des Graphen?
# BREWER_PALETTE <- "RdBu"
# 
# ## Minimum % pro Bar-Part ab welchem die % angezeigt werden
# MINIMUM_LABEL_PERCENTAGE <- 4
# 
# ## Labels an der Y-Achse zeigen? TRUE & FALSE
# SHOW_Y_LABELS <- TRUE  # Y-Achsen Labels anzeigen
# 
# ## Labels definieren
# LABELS <- c(
#   "1" = "Auf keinen Fall",
#   "2" = "Wahrscheinlich nicht",
#   "3" = "Eher nicht",
#   "Neutral" = "Unentschlossen",
#   "5" = "Eher ja",
#   "6" = "Wahrscheinlich ja",
#   "7" = "Auf jeden Fall"
# )
# 
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# # Generate Outputs
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# assign(paste0("table_", NAME_FRAGE), 
#        create_likert_7_table(
#          filtered_data, 
#          SELECTED_COLUMNS, 
#          COLUMN_NAMES, 
#          LABELS
#        )
# )
# 
# assign(paste0("plot_", NAME_FRAGE), 
#        create_likert_7_plot(
#          filtered_data, 
#          SELECTED_COLUMNS, 
#          COLUMN_NAMES,
#          PLOT_TITLE, 
#          BREWER_PALETTE, 
#          MINIMUM_LABEL_PERCENTAGE, 
#          LABELS, 
#          SHOW_Y_LABELS)
# )

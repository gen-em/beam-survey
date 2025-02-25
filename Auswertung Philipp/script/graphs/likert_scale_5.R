#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R Code ----
# Functions for creating 5-point Likert scale visualizations and tables
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## TABELLE generieren ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_likert_5_table <- function(filtered_data, selected_columns, column_names, labels) {
  # Create initial subset and prepare labels
  filtered_data_subset <- filtered_data %>%
    dplyr::select(all_of(selected_columns)) %>%
    setNames(column_names)
  
  # Generate and transform table
  summary_table <- filtered_data_subset %>%
    pivot_longer(
      cols = everything(),
      names_to = "Abfrage",
      values_to = "rating"
    ) %>%
    filter(!is.na(rating), rating %in% 1:5) %>%  # Remove NAs and ensure only values 1-5
    count(Abfrage, rating) %>%
    complete(
      Abfrage,
      rating = 1:5,
      fill = list(n = 0)
    ) %>%
    group_by(Abfrage) %>%
    mutate(
      percentage = round((n / sum(n)) * 100, 1),  # Calculate percentage
      formatted = paste0(n, " (", percentage, "%)"),  # Format count and percentage
      count_total = sum(n)  # Calculate total count per group
    ) %>%
    select(-n, -percentage) %>%
    pivot_wider(
      names_from = rating,
      values_from = formatted,
      values_fill = "0 (0%)"
    ) %>%
    rename_with(~labels[.x], matches("^[1-5]$")) %>%  # Apply custom labels
    ungroup() %>%
    mutate(`Antworten N (%)` = paste0(count_total, " (100%)")) %>%  # Create total column
    select(Abfrage, `Antworten N (%)`, everything(), -count_total)  # Remove temp column
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## PLOT generieren ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
create_likert_5_plot <- function(filtered_data, selected_columns, column_names, plot_title, 
                                 brewer_palette, minimum_label_percentage, labels, show_y_labels = TRUE) {
  # Data Preparation
  filtered_data_subset <- filtered_data %>%
    dplyr::select(all_of(selected_columns)) %>%
    setNames(column_names)
  
  # Transform data for plotting, excluding NAs
  filtered_data_long <- filtered_data_subset %>%
    pivot_longer(
      cols = everything(),
      names_to = "Category",
      values_to = "Response"
    ) %>%
    filter(!is.na(Response), Response %in% 1:5)  # Remove NAs and ensure only values 1-5
  
  # Calculate Response Percentages
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
  
  # Color and Label Setup
  brewer_colors <- brewer.pal(n = 9, name = brewer_palette)
  cols <- setNames(brewer_colors[2:6], as.character(1:5))
  
  custom_labels <- function(labels, colors) {
    sapply(1:length(labels), function(i) {
      paste0("<span style='color:", colors[i], ";'>", labels[i], "</span>")
    })
  }
  
  formatted_labels <- custom_labels(
    labels = labels[as.character(1:5)],  # Use original label order
    colors = cols[as.character(1:5)]     # Use matching colors
  )
  
  # Sort categories by total percentage of highest ratings (5)
  category_order <- response_summary %>%
    filter(Response == 5) %>%
    arrange(desc(Percentage)) %>%
    pull(Category)
  
  # Data Processing
  df_responses <- response_summary %>%
    group_by(Category) %>%
    mutate(
      Category = factor(Category, levels = category_order),
      Response = factor(Response, levels = 1:5),
      Cumulative = cumsum(Percentage),
      MidPoint = Cumulative - Percentage/2,
      Label = ifelse(
        Percentage >= minimum_label_percentage,
        paste0(round(Percentage, 1), "%"),
        ""
      )
    ) %>%
    ungroup()
  
  # Create Plot
  ggplot(df_responses, 
         aes(x = Category, 
             y = Percentage,
             fill = Response)) +
    geom_col(position = position_stack(reverse = TRUE), width = 0.7) +
    geom_text(aes(y = MidPoint,
                  label = Label),
              size = 3.5) +
    scale_fill_manual(values = cols,
                      labels = formatted_labels,
                      drop = FALSE) +
    guides(fill = guide_legend(
      title = NULL,
      nrow = 1,
      byrow = FALSE,
      reverse = FALSE,
      theme = theme(
        legend.text.position = "top",
        legend.key.width = unit(1, "null"),
        legend.key.height = unit(0, "null")
      ),
      override.aes = list(
        size = 0
      )
    )) +
    scale_y_continuous(limits = c(0, 100),
                       expand = c(0, 0),
                       labels = ~paste0(.x, "%")) +
    theme_bw() +
    theme(
      panel.background = element_blank(),   # Entfernt den Hintergrund des Panels
      plot.background = element_blank(),    # Entfernt den gesamten Plot-Hintergrund
      panel.grid.major.y = element_blank(),
      legend.text = element_markdown(size = 10, face = "bold"),
      legend.position = "top",
      legend.background = element_blank(),  # Removes background behind the legend
      legend.key = element_blank(),         # Removes background behind individual legend items
      axis.title = element_blank(),
      axis.text.x = element_text(size = 10),
      axis.text.y = if(show_y_labels) element_text(size = 10) else element_blank(),
      axis.ticks.y = if(show_y_labels) element_line() else element_blank(),
      plot.title = element_text(
        hjust = 0.5,
        vjust = 1,
        size = 12,
        face = "bold"
      )
    ) +
    ggtitle(plot_title) +
    coord_flip()  # Flip the axes for horizontal orientation
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Konfiguration ----
# In die sourcende Datei einfügen und # entfernen :)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# 
# NAME_FRAGE <- "name_der_variablen für plot_ und table_"
# PLOT_TITLE <- "Titel auf dem Graph"
# 
# ## Welche columns aus filtered_data soll eingeschlossen werden?
# SELECTED_COLUMNS <- c(
#   "6.42"
# )
# 
# ## Column Namen definieren
# COLUMN_NAMES <- c(
#   "Fachliche Belastung Notaufnahmedienst"
# )
# 
# ## Welche Brewer Palette zur Farbgebung des Graph?
# BREWER_PALETTE <- "Reds"
# 
# ## Minimaler Prozentsatz, ab welchem die % auf dem Bar-Part angezeigt werden
# MINIMUM_LABEL_PERCENTAGE <- 4
# 
# ## Show Y Axis labels? (Falls mehrere columns / fragen auf einem Graph)
# SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
# 
# ## Definiere die Labels / Likert-Punkte
# LABELS <- c(
#   "1" = "Überhaupt nicht",
#   "2" = "Kaum",
#   "3" = "Ein bisschen",
#   "4" = "Belastet",
#   "5" = "Sehr"
# )
# 
# 
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# # Generate Outputs
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# assign(paste0("table_", NAME_FRAGE), 
#        create_likert_5_table(
#          filtered_data, 
#          SELECTED_COLUMNS, 
#          COLUMN_NAMES, 
#          LABELS
#        )
# )
# 
# assign(paste0("plot_", NAME_FRAGE), 
#        create_likert_5_plot(
#          filtered_data, 
#          SELECTED_COLUMNS, 
#          COLUMN_NAMES,
#          PLOT_TITLE, 
#          BREWER_PALETTE, 
#          MINIMUM_LABEL_PERCENTAGE, 
#          LABELS, 
#          SHOW_Y_LABELS)
# )
# 
# ## Print bei Bedarf
# print(plot_anwendungsfaelle_elearning_likert)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_stacked_bar_chart_wide <- function(
    filtered_data,
    column_of_interest,
    value_mapping,
    ordered_levels,
    NAME_FRAGE,
    PLOT_TITLE,
    SHORT_TITLE,
    BREWER_PALETTE = "Greens",
    REMOVE_VALUE = FALSE
) {
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Preparation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Map raw values in the dataset to formatted labels using the provided mapping
  filtered_data[[column_of_interest]] <- as.character(filtered_data[[column_of_interest]])
  mapped_values <- recode(filtered_data[[column_of_interest]], !!!value_mapping)
  
  # Conditionally remove the specified value
  if (REMOVE_VALUE != FALSE) {
    mapped_values <- mapped_values[mapped_values != REMOVE_VALUE]
    ordered_levels <- ordered_levels[ordered_levels != REMOVE_VALUE]  # Remove from order list
  }
  
  # Count occurrences based on mapped values
  count_values <- table(factor(mapped_values, levels = ordered_levels))
  
  # Total number of rows
  total_rows <- sum(count_values)
  
  # Calculate percentages
  percent_values <- (count_values / total_rows) * 100
  
  # Create a new dataframe for visualization
  table_result <- data.frame(
    Category = ordered_levels,  
    Anzahl = as.vector(count_values),  
    Prozent = as.vector(round(percent_values, 1))
  )
  colnames(table_result)[1] <- SHORT_TITLE  # Dynamically rename first column
  
  # Remove categories with 0 occurrences
  table_result <- table_result[table_result$Anzahl > 0, ]
  
  # Save Data for Plot before adding the summarizing row
  plot_data <- table_result
  
  # Add a summary row at the bottom, Ensure column names match exactly
  summary_row <- data.frame(
    Category = "Anzahl (N)",  
    Anzahl = total_rows,  
    Prozent = 100,
    stringsAsFactors = FALSE  # Prevent factor coercion issues
  )
  
  # Append the summary row while ensuring column names align
  colnames(summary_row) <- colnames(table_result)
  table_result <- rbind(table_result, summary_row)
  
  # Assign table to global environment with dynamic naming
  assign(paste0("table_", NAME_FRAGE), table_result, envir = .GlobalEnv)
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Upright Stacked Bar Chart
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Remove NA values from the dataset
  plot_data <- plot_data[!is.na(plot_data$Prozent), ]

  plot_result <- ggplot(plot_data, aes(
    x = 1, 
    y = Prozent, 
    fill = factor(!!sym(SHORT_TITLE), levels = rev(ordered_levels)) 
  )) +
    geom_bar(stat = "identity", width = 0.8) +  # Stacked bar
    theme_minimal() +
    labs(
      title = PLOT_TITLE,
      x = NULL,  # No x-label needed
      y = "Prozent",
      fill = SHORT_TITLE  # Legend title (makes it clear what the legend represents)
    ) +
    theme(
      panel.grid.major.x = element_blank(),  # Remove major gridlines
      panel.grid.minor.x = element_blank(),  # Remove minor gridlines
      panel.background = element_blank(),  # Ensures a clean, white background
      axis.text.x = element_blank(),  # Remove X-axis labels
      axis.ticks.x = element_blank(), # Remove X-axis ticks
      axis.ticks.y = element_line(),
      legend.position = "right",  # Place legend next to bars
      legend.title = element_blank(), # Keine Label Titel
      legend.text = element_text(size = 9, hjust = 0.5),  # Legend labels formatting
      plot.title = element_text(hjust = 0.5),
      plot.title.position = "plot",  # Extend centering across the entire plot area (including labels)
    ) +
    ## Prozent-Labels in den Bar-Parts
    geom_text(aes(
      label = ifelse(Prozent >= 3, paste0(Prozent, "%"), ""),  # Hide labels <3%
      size = ifelse(Prozent >= 6, 4, 3)  # Conditional text size
      ),
    position = position_stack(vjust = 0.5),
    ) +
    scale_size_identity(guide = "none") + # Ensures ggplot respects the manually assigned sizes
    scale_fill_brewer(palette = BREWER_PALETTE, direction = -1)  # Apply chosen color palette
  
  
  # Assign plot to global environment with dynamic naming
  assign(paste0("plot_", NAME_FRAGE), plot_result, envir = .GlobalEnv)
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Konfiguration ----
# In die sourcende Datei einfügen und # entfernen :)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
# ## Details zur Frage
# FRAGE_NUMMER <- "7_43"
# LABEL_FRAGE <- "fortbildungsbudget"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf(
#   "Wie hoch ist das Fortbildungsbudget von %s?", NAME_KOLLEKTIV
# )
# 
# ## Kurztitel für Tabelle etc.
# SHORT_TITLE <- "Fortbildungsbudget"
# 
# ## Welche Column?
# COLUMN_OF_INTEREST <- "7.43"
# 
# ## Benennung der Antwortoptionen (streng nach Reihenfolge!)
# VALUE_MAPPING <- c(
#   "keines" = "Kein Budget",
#   "<200" = "< 200€",
#   "200-400" = "200 - 400€",
#   "401-600" = "401 - 600€",
#   "601-800" = "601 - 800€",
#   "801 - 1000€" = "801 - 1000€",
#   ">1000" = ">1000€",
#   "unbekannt" = "Unbekannt"
# )
# 
# ## Nochmalige Benennung der Antwortoptionen zur Sortierung (wichtig)
# ORDERED_LEVELS <- c(
#   "Kein Budget",
#   "< 200€",
#   "200 - 400€",
#   "401 - 600€",
#   "601 - 800€",
#   "801 - 1000€",
#   ">1000€",
#   "Unbekannt"
# )
# 
# ## Einzelne Antwortoption entfernen (z.B. Unbekannt)
# ## Name muss dem Namen in ORDERED_LEVELS entsprechen
# ## Wenn = FALSE wird nichts entfernt
# REMOVE_VALUE = "Unbekannt"
# 
# ## Brewer Palette für Farbgebung
# BREWER_PALETTE <- "Greens"
# 
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # Generate Outputs
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
# create_stacked_bar_chart_wide(
#   filtered_data = filtered_data,
#   column_of_interest = COLUMN_OF_INTEREST,
#   value_mapping = VALUE_MAPPING,
#   ordered_levels = ORDERED_LEVELS,
#   NAME_FRAGE = NAME_FRAGE,
#   PLOT_TITLE = PLOT_TITLE,
#   SHORT_TITLE = SHORT_TITLE,
#   BREWER_PALETTE = BREWER_PALETTE,
#   REMOVE_VALUE = REMOVE_VALUE
# )


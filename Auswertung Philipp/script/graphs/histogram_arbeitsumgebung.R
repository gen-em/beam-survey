#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_work_environment_distribution_plot <- function(
    filtered_data,
    column_of_interest,
    value_mapping,
    ordered_levels,
    NAME_FRAGE,
    PLOT_TITLE,
    BREWER_PALETTE
) {
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Preparation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Map raw values in the dataset to formatted labels using the provided mapping
  mapped_values <- recode(filtered_data[[column_of_interest]], !!!value_mapping)
  
  # Count occurrences based on mapped values
  count_values <- table(factor(mapped_values, levels = ordered_levels))
  
  # Total number of rows
  total_rows <- nrow(filtered_data)
  
  # Calculate percentages
  percent_values <- (count_values / total_rows) * 100
  
  # Create a new dataframe for arbeitsumfeld with only the required columns
  table_result <- data.frame(
    Arbeitsumfeld = ordered_levels,  # Use predefined ordered levels
    Anzahl = as.vector(count_values),  # Convert count_values to a vector
    Prozent = as.vector(round(percent_values, 1))  # Convert percent_values to a vector and round
  )
  
  # Reihenfolge explizit festlegen
  table_result$Arbeitsumfeld <- factor(table_result$Arbeitsumfeld, levels = ordered_levels)
  
  # Kopie für den Graph
  data_plot <- table_result
  
  # Gesamtzeile hinzufügen
  total_row <- data.frame(
    Arbeitsumfeld = "Antworten (N)",
    Anzahl = total_rows,
    Prozent = 100
  )
  
  table_result <- rbind(table_result, total_row)
  
  # Alle Zeilenumbrüche aus der Tabelle entfernen
  table_result$Arbeitsumfeld <- gsub("\n", " ", table_result$Arbeitsumfeld)
  
  # Tabelle global speichern
  assign(paste0("table_", NAME_FRAGE), table_result, envir = .GlobalEnv)
  
  # Arbeitsumfeld mit Anzahl 0 filtern
  data_plot <- data_plot[data_plot$Anzahl != 0, ]
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Histogram erstellen
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  plot_result <- ggplot(data_plot, aes(x = Arbeitsumfeld, y = Prozent, fill = Arbeitsumfeld)) +
    geom_bar(stat = "identity", color = "black") +
    theme_minimal() +
    labs(
      title = PLOT_TITLE,
      x = "Arbeitsumfeld",
      y = "Prozent"
    ) +
    theme(
      legend.position = "none", 
      axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.5),
      panel.grid.major.x = element_blank(),  # Remove major x-axis gridlines
      panel.grid.minor.x = element_blank(),   # Remove minor x-axis gridlines
      panel.grid.major.y = element_line(size = 0.1),  # Make major y-gridlines thinner
      panel.grid.minor.y = element_line(size = 0.05),   # Make minor y-gridlines thinner
      plot.title = element_text(hjust = 0.5)
    ) +
    scale_fill_brewer(palette = BREWER_PALETTE, direction = 1)
  
  # Graph global speichern
  assign(paste0("plot_", NAME_FRAGE), plot_result, envir = .GlobalEnv)
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Konfiguration ----
# In die sourcende Datei einfügen und # entfernen :)
# LABEL_KOLLEKTIV & filtered_data & NAME_KOLLEKTIV müssen definiert sein
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# ## Details zur Frage
# FRAGE_NUMMER <- "1_10"
# LABEL_FRAGE <- "arbeitsumfeld"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf(
#   "In welchem Arbeitsumfeld sind die %s tätig?", NAME_KOLLEKTIV
# )
# 
# ## Welche Column?
# COLUMN_OF_INTEREST <- "1.10"
# 
# ## Benennung der Antwortoptionen (streng nach Reihenfolge!)
# VALUE_MAPPING <- c(
#   "<200" = "Kleines \nKrankenhaus \n(<200 Betten)",
#   "200-500" = "Mittelgroßes \nKrankenhaus \n(200-500 Betten)",
#   ">500" = "Schwerpunkt- / \nMaximalversorger \n(>500 Betten)",
#   "ambulant" = "Ambulant",
#   "präklinisch" = "Ausschließlich \nPräklinisch",
#   "sonstiges" = "Sonstiges"
# )
# 
# ## Nochmalige Benennung der Antwortoptionen zur Sortierung (wichtig)
# ORDERED_LEVELS <- c(
#   "Kleines \nKrankenhaus \n(<200 Betten)",
#   "Mittelgroßes \nKrankenhaus \n(200-500 Betten)",
#   "Schwerpunkt- / \nMaximalversorger \n(>500 Betten)",
#   "Ambulant",
#   "Ausschließlich \nPräklinisch",
#   "Sonstiges"
# )
# 
# ## Brewer Palette für Farbgebung
# BREWER_PALETTE <- "Set2"
# 
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # Generate Outputs
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
# create_work_environment_distribution_plot(
#   filtered_data = filtered_data,
#   column_of_interest = COLUMN_OF_INTEREST,
#   value_mapping = VALUE_MAPPING,
#   ordered_levels = ORDERED_LEVELS,
#   NAME_FRAGE = NAME_FRAGE,
#   PLOT_TITLE = PLOT_TITLE,
#   BREWER_PALETTE = BREWER_PALETTE
# )

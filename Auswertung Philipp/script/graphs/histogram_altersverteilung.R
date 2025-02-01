#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_age_distribution_plot <- function(
    filtered_data,
    column_of_interest,
    NAME_FRAGE,
    PLOT_TITLE,
    BREWER_PALETTE
) {

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Preparation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Manuelle Sortierung der Altersgruppen
  filtered_data <- filtered_data %>%
    mutate(!!sym(column_of_interest) := factor(
      !!sym(column_of_interest),
      levels = c("<25", "25-30", "31-35", "36-40", "41-45", "46-50", ">50"),
      ordered = TRUE
    ))
  
  # Gruppieren und Prozentzahlen berechnen
  table_result <- filtered_data %>%
    group_by(!!sym(column_of_interest)) %>%
    summarize(Anzahl = n()) %>%
    mutate(Prozent = (Anzahl / sum(Anzahl)) * 100) %>%
    mutate(Prozent = round(Prozent, 1))
  
  # Anpassen der Spaltennamen
  colnames(table_result) <- c("Alter", "Anzahl", "Prozent")
  
  # Kopieren für den Graph
  data_plot <- table_result
  
  # Gesamtzeile hinzufügen
  total_row <- data.frame(
    Alter = "Antworten (N)",
    Anzahl = sum(table_result$Anzahl),
    Prozent = 100
  )
  
  table_result <- rbind(table_result, total_row)
  
  # Tabelle global speichern
  assign(paste0("table_", NAME_FRAGE), table_result, envir = .GlobalEnv)

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Histogramm erstellen
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Histogramm erstellen
  plot_result <- ggplot(data_plot, aes(x = Alter, y = Prozent, fill = Alter)) +
    geom_bar(stat = "identity", color = "black") +
    theme_minimal() +
    labs(
      title = PLOT_TITLE,
      x = "Alter",
      y = "Prozent"
    ) +
    theme(
      legend.position = "none",  # Remove legend
      plot.title = element_text(hjust = 0.5),  # Center title
      panel.grid.major.x = element_blank(),  # Remove major x-axis gridlines
      panel.grid.minor.x = element_blank(),   # Remove minor x-axis gridlines
      panel.grid.major.y = element_line(size = 0.1),  # Make major y-gridlines thinner
      panel.grid.minor.y = element_line(size = 0.05)   # Make minor y-gridlines thinner
    ) +
    scale_fill_brewer(palette = BREWER_PALETTE, direction = 1)
  
  # Graph global speichern
  assign(paste0("plot_", NAME_FRAGE), plot_result, envir = .GlobalEnv)
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Konfiguration ----
# In die sourcende Datei einfügen und # entfernen :)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#
# ## Details zur Frage
# FRAGE_NUMMER <- "1_1"
# LABEL_FRAGE <- "alter"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf(
#   "Altersverteilung der %s", NAME_KOLLEKTIV
# )
# 
# ## Welche Spalte wird ausgewertet?
# COLUMN_OF_INTEREST <- "1.1"
# 
# ## Brewer Color Palette für Graph
# BREWER_PALETTE <- "Greens"
# 
# 
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # Generate Outputs
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
# create_age_distribution_plot(
#   filtered_data = filtered_data,
#   column_of_interest = COLUMN_OF_INTEREST,
#   NAME_FRAGE = NAME_FRAGE,
#   PLOT_TITLE = PLOT_TITLE,
#   BREWER_PALETTE = BREWER_PALETTE
# )
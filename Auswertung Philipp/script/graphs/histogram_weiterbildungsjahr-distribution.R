#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_training_year_distribution_plot <- function(
    filtered_data,
    column_of_interest,
    NAME_FRAGE,
    PLOT_TITLE,
    BREWER_PALETTE
) {

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Preparation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Entfernen von NA-Werten und Gruppierung
  table_result <- filtered_data %>%
    filter(!is.na(!!sym(column_of_interest))) %>%
    group_by(!!sym(column_of_interest)) %>%
    summarize(Anzahl = n()) %>%
    mutate(Prozent = (Anzahl / sum(Anzahl)) * 100) %>%
    mutate(Prozent = round(Prozent, 1))
  
  # Anpassen der Spaltennamen
  colnames(table_result) <- c("Weiterbildungsjahr", "Anzahl", "Prozent")
  
  # Kopieren für den Graph
  data_plot <- table_result
  
  # Gesamtzeile hinzufügen
  total_row <- data.frame(
    Weiterbildungsjahr = "Antworten (N)",
    Anzahl = sum(table_result$Anzahl),
    Prozent = 100
  )
  
  table_result <- rbind(table_result, total_row)
  
  # Tabelle global speichern
  assign(paste0("table_", NAME_FRAGE), table_result, envir = .GlobalEnv)

  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Histogramm erstellen
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

  plot_result <- data_plot %>%
    mutate(Weiterbildungsjahr = factor(Weiterbildungsjahr, levels = sort(unique(Weiterbildungsjahr)))) %>%
    ggplot(aes(x = Weiterbildungsjahr, y = Prozent, fill = Weiterbildungsjahr)) +
    geom_bar(stat = "identity", color = "black") +
    theme_minimal() +
    labs(
      title = PLOT_TITLE,
      x = "Weiterbildungsjahr",
      y = "Prozent"
    ) +
    theme(legend.position = "none",
          plot.title = element_text(hjust = 0.5)
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
# FRAGE_NUMMER <- "1_5"
# LABEL_FRAGE <- "weiterbildungsjahr"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf(
#   "Verteilung der Weiterbildungsjahre unter %s", NAME_KOLLEKTIV
# )
# 
# ## Welche Spalte wird ausgewertet?
# COLUMN_OF_INTEREST <- "1.5"
# 
# ## Brewer Color Palette für Graph
# BREWER_PALETTE <- "Purples"
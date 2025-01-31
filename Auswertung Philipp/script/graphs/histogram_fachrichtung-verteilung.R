#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_specialty_distribution_plot <- function(
    filtered_data,
    cols_of_interest,
    row_names,
    NAME_FRAGE,
    PLOT_TITLE,
    BREWER_PALETTE
) {
  
  # Relevante Zeilen auswählen
  fachrichtung_cols <- filtered_data %>%
    select(all_of(cols_of_interest))
  
  # Leere Zeilen herausfiltern
  fachrichtung_cols <- fachrichtung_cols %>%
    filter(rowSums(is.na(.)) < ncol(.))
  
  # Kumulative Anzahl & Prozente berechnen
  fachrichtung_kumulativ <- colSums(fachrichtung_cols == TRUE, na.rm = TRUE)
  total_rows <- nrow(fachrichtung_cols)
  percentages <- (fachrichtung_kumulativ / total_rows) * 100
  
  # In Dataframe überführen
  table_result <- data.frame(
    Anzahl = fachrichtung_kumulativ,
    Prozent = round(percentages, 1)
  )
  rownames(table_result) <- row_names
  
  # Kopie der Tabelle für den Graph
  data_plot <- table_result
  
  # Gesamtzeile hinzufügen
  total_row <- data.frame(
    Anzahl = total_rows,
    Prozent = 100
  )
  rownames(total_row) <- "Antworten (N)"
  
  table_result <- rbind(table_result, total_row)
  
  # Tabelle global speichern
  assign(paste0("table_", NAME_FRAGE), table_result, envir = .GlobalEnv)
  
  # Fachrichtungen mit Anzahl 0 filtern
  data_plot <- data_plot[data_plot$Anzahl != 0, ]
  
  # Histogramm erstellen
  plot_result <- ggplot(data_plot, aes(x = row.names(data_plot), y = Prozent, fill = row.names(data_plot))) +
    geom_bar(stat = "identity", color = "black") +
    theme_minimal() +
    labs(
      title = PLOT_TITLE,
      x = "Fachrichtung",
      y = "Prozent"
    ) +
    theme(
      legend.position = "none", 
      axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 0.5),
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
# Define Configuration
# FRAGE_NUMMER <- "1_6"
# LABEL_FRAGE <- "fachrichtung"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf("Angestrebte Facharztbezeichnung von %s", NAME_KOLLEKTIV)
# 
# ## Farbe des Graphen festlegen
# BREWER_PALETTE <- "Set2"
# 
# ## Specify columns of interest
# COLS_OF_INTEREST <- c("1.6-innere", 
#                       "1.6-allgemein", 
#                       "1.6-anaesthesie", 
#                       "1.6-unfallchirurgie",
#                       "1.6-viszeralchirurgie", 
#                       "1.6-andereschirurgisches", 
#                       "1.6-neurologie",
#                       "1.6-urologie", 
#                       "1.6-sonstiges")
# 
# # Define row names
# ROW_NAMES <- c("Innere Medizin", 
#                "Allgemeinmedizin", 
#                "Anästhesie", 
#                "Unfallchirurgie", 
#                "Viszeralchirurgie", 
#                "Anderes chir. Fachgebiet", 
#                "Neurologie", 
#                "Urologie", 
#                "Sonstiges")
# 
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # Generate Outputs
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
# create_specialty_distribution_plot(
#   filtered_data = filtered_data,
#   cols_of_interest = COLS_OF_INTEREST,
#   row_names = ROW_NAMES,
#   NAME_FRAGE = NAME_FRAGE,
#   PLOT_TITLE = PLOT_TITLE,
#   BREWER_PALETTE = BREWER_PALETTE
# )
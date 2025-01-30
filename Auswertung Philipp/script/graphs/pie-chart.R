#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
# Tortendiagramm und Tabelle
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_pie_chart <- function(
    filtered_data,
    column_of_interest,
    NAME_FRAGE,
    LABEL_TITLE,
    ANTWORT_OPTIONEN,
    PLOT_TITLE,
    BREWER_PALETTE
) {
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Preparation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  # Count occurrences of each response
  count_values <- table(filtered_data[[column_of_interest]], useNA = "no")
  total_rows <- sum(count_values)
  
  # Calculate percentages
  percent_values <- (count_values / total_rows) * 100
  
  # Create a dataframe for the table
  table_result <- data.frame(
    Antwort = ANTWORT_OPTIONEN,
    Anzahl = as.numeric(count_values),
    Prozent = round(as.numeric(percent_values), 1)
  )
  colnames(table_result)[1] <- LABEL_TITLE
  
  # Create a copy for the plot
  data_plot <- table_result
  
  # Add a total row to the table
  total_row <- data.frame(
    LABEL_TITLE = "Antworten (N)",
    Anzahl = total_rows,
    Prozent = 100
  )
  
  colnames(total_row) <- colnames(table_result)
  table_result <- rbind(table_result, total_row)
  
  # Assign table to global environment with dynamic naming
  assign(paste0("table_", NAME_FRAGE), table_result, envir = .GlobalEnv)
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Pie Chart
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  plot_result <- ggplot(data_plot, aes(x = "", y = Prozent, fill = !!sym(LABEL_TITLE))) +
    geom_bar(stat = "identity", width = 1, color = "black") +
    coord_polar(theta = "y") +  # Convert to pie chart
    theme_void() +  # Remove background and axes
    labs(title = PLOT_TITLE) +
    scale_fill_brewer(palette = BREWER_PALETTE) +  # Apply chosen color palette
    geom_text(aes(x = 1, label = paste(Prozent, "%")),
              position = position_stack(vjust = 0.5),
              color = "black", size = 5)  # Add percentage labels
  
  
  # Assign plot to global environment with dynamic naming
  assign(paste0("plot_", NAME_FRAGE), plot_result, envir = .GlobalEnv)

}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Konfiguration ----
# In die sourcende Datei einfügen und # entfernen :)
# LABEL_KOLLEKTIV & filtered_data & NAME_KOLLEKTIV müssen definiert sein
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# 
# ## Details zur Frage
# FRAGE_NUMMER <- "5_22"
# LABEL_FRAGE <- "elearning_zukunft"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf(
#   "Können %s sich vorstellen, E-Learning in Zukunft zur Fortbildung zu nutzen?", NAME_KOLLEKTIV
# )
# 
# ## Titel der angezeigten Labels (kurz, knackig)
# LABEL_TITLE <- "Zukünftige Nutzung E-Learning"
# 
# ## Welche Column?
# COLUMN_OF_INTEREST <- "5.22"
# 
# ## Benennung der Antwortoptionen
# ANTWORT_OPTIONEN <- c(
#   "Ja", 
#   "Nein"
# )
# 
# ## Brewer Palette für Farbgebung
# BREWER_PALETTE <- "Pastel2"
# 
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# # Generate Outputs
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# create_pie_chart(
#   filtered_data = filtered_data, 
#   column_of_interest = COLUMN_OF_INTEREST, 
#   NAME_FRAGE = NAME_FRAGE,
#   LABEL_TITLE = LABEL_TITLE,
#   ANTWORT_OPTIONEN = ANTWORT_OPTIONEN, 
#   PLOT_TITLE = PLOT_TITLE,
#   BREWER_PALETTE = BREWER_PALETTE
# )
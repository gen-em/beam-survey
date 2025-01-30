#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
# Tortendiagramm und Tabelle
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_pie_chart <- function(
    filtered_data,
    column_of_interest,
    NAME_FRAGE,
    TITEL_KURZ,
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
  colnames(table_result)[1] <- TITEL_KURZ
  
  # Create a copy for the plot
  data_plot <- table_result
  
  # Add a total row to the table
  total_row <- data.frame(
    TITEL_KURZ = "Antworten (N)",
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
  
  
  plot_result <- ggplot(data_plot, aes(x = "", y = Prozent, fill = !!sym(TITEL_KURZ))) +
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
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# 
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# ## Configuration ----
# #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# NAME_FRAGE <- "5_22_assistenten_elearning_zukunft"
# PLOT_TITLE <- "Könnten AssistentInnen in Weiterbildung sich vorstellen, in Zukunft E-Learning Inhalte zu nutzen?"
# TITEL_KURZ <- "Zukünftige Nutzung E-Learning"
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
#   filtered_data = filtered_assistent, 
#   column_of_interest = COLUMN_OF_INTEREST, 
#   NAME_FRAGE = NAME_FRAGE,
#   TITEL_KURZ = TITEL_KURZ,
#   ANTWORT_OPTIONEN = ANTWORT_OPTIONEN, 
#   PLOT_TITLE = PLOT_TITLE,
#   BREWER_PALETTE = BREWER_PALETTE
# )
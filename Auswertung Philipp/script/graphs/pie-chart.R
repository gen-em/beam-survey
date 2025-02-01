#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
# Tortendiagramm und Tabelle
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_pie_chart <- function(
    filtered_data,
    column_of_interest,
    NAME_FRAGE,
    LABEL_TITLE,
    VALUE_MAPPING,
    PLOT_TITLE,
    BREWER_PALETTE
) {
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Data Preparation
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Convert logical values to character before applying recode
  filtered_data[[column_of_interest]] <- as.character(filtered_data[[column_of_interest]])
  filtered_data[[column_of_interest]] <- recode(filtered_data[[column_of_interest]], !!!VALUE_MAPPING)
  
  # Set the factor levels in the order of VALUE_MAPPING (default order)
  filtered_data[[column_of_interest]] <- factor(
    filtered_data[[column_of_interest]], 
    levels = VALUE_MAPPING
  )
  
  # Count occurrences of each response
  count_values <- table(filtered_data[[column_of_interest]], useNA = "no")
  total_rows <- sum(count_values)
  
  # Calculate percentages
  percent_values <- (count_values / total_rows) * 100
  
  # Create a dataframe for the table
  table_result <- data.frame(
    Antwort = names(count_values),
    Anzahl = as.numeric(count_values),
    Prozent = round(as.numeric(percent_values), 1)
  )
  colnames(table_result)[1] <- LABEL_TITLE
  
  # Ensure the table keeps VALUE_MAPPING order
  table_result[[LABEL_TITLE]] <- factor(
    table_result[[LABEL_TITLE]], 
    levels = VALUE_MAPPING
  )
  
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
  colnames(table_result)[1] <- gsub("\n", "", colnames(table_result)[1])  # Clean column header
  
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
    theme(plot.title = element_text(hjust = 0.5, vjust = -1),  # Center title fully
          plot.title.position = "plot",  # Extend title alignment across the entire plot
          ) +
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
# FRAGE_NUMMER <- "1_11"
# LABEL_FRAGE <- "hauptsaechlich_notaufnahme"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf(
#   "Anteil der %s, welche hauptsächlich in der Notaufnahme tätig sind", NAME_KOLLEKTIV
# )
# 
# ## Titel der angezeigten Labels (kurz, knackig)
# LABEL_TITLE <- "Hauptsächlich Notaufnahme"
# 
# ## Welche Column?
# COLUMN_OF_INTEREST <- "1.11"
# 
# ## Benennung / Assoziation der Antwortoptionen
# VALUE_MAPPING <- c(
#   "TRUE" = "Ja",
#   "FALSE" = "Nein"
# )
# 
# ## Brewer Palette für Farbgebung
# BREWER_PALETTE <- "Pastel2"
# 
# 
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # Generate Outputs
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
# create_pie_chart(
#   filtered_data = filtered_data, 
#   column_of_interest = COLUMN_OF_INTEREST, 
#   NAME_FRAGE = NAME_FRAGE,
#   LABEL_TITLE = LABEL_TITLE,
#   VALUE_MAPPING = VALUE_MAPPING,
#   PLOT_TITLE = PLOT_TITLE,
#   BREWER_PALETTE = BREWER_PALETTE
# )
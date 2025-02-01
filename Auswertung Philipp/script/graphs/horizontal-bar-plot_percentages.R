#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# R-Code ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_horizontal_bar_plot_percentages <- function(
    filtered_data, 
    columns_of_interest, 
    column_mapping, 
    short_column_names, 
    NAME_FRAGE, 
    PLOT_TITLE,
    ANNOTATE_ANZAHL = FALSE,
    brewer_palette
) {
  
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Data Preparation
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  # Subset the dataset to include only specified columns
  filtered_subset <- filtered_data[, columns_of_interest]
  
  # Calculate the count of TRUE values for each column
  true_counts <- colSums(filtered_subset == TRUE, na.rm = TRUE)
  
  # Calculate total number of rows (100% reference)
  total_rows <- nrow(filtered_subset)
  
  # Compute the percentage
  percentages <- (true_counts / total_rows) * 100
  
  # Create a data frame with the results
  table_result <- data.frame(
    Antwortoption = names(filtered_subset),
    Anzahl = true_counts,
    Prozent = round(percentages, 1)
  )
  
  # Apply the column mapping
  table_result$Antwortoption <- column_mapping[table_result$Antwortoption]
  
  # Add new column values for visualization
  table_result$Antwortoption_kurz <- short_column_names
  
  # Create a total row (for table only, not for graph)
  total_row <- data.frame(
    Antwortoption = "Antworten (N)",
    Anzahl = total_rows,
    Prozent = 100,
    Antwortoption_kurz = ""
  )
  
  # Order the table by Anzahl (descending)
  table_result <- table_result[order(-table_result$Anzahl), ]
  rownames(table_result) <- 1:nrow(table_result)
  
  # Combine table with the total row
  table_result <- rbind(table_result, total_row)
  
  # Remove Antwortoption_kurz before final table assignment
  table_result_final <- table_result[, c("Antwortoption", "Anzahl", "Prozent")]
  
  # Assign table to global environment with dynamic naming
  assign(paste0("table_", NAME_FRAGE), table_result_final, envir = .GlobalEnv)
  
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Horizontal Bar Plot
  #%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  plot_result <- ggplot(subset(table_result, Antwortoption != "Antworten (N)"), 
                        aes(x = Prozent, 
                            y = reorder(Antwortoption_kurz, Prozent),
                            fill = Antwortoption_kurz)) +
    geom_bar(stat = "identity") +
    
    # Two geom_text layers for conditional positioning
    geom_text(data = subset(table_result, Prozent >= 20 & Antwortoption != "Antworten (N)"),
              aes(label = sprintf("%.1f%%", Prozent)),
              hjust = 1.2,
              color = "black") +  
    geom_text(data = subset(table_result, Prozent < 20 & Antwortoption != "Antworten (N)"),
              aes(label = sprintf("%.1f%%", Prozent)),
              hjust = -0.2,
              color = "black") +
    
    theme_minimal() +
    theme(
      axis.title.y = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_line(size = 0.1),  # Make major x-axis gridlines thinner
      panel.grid.minor.x = element_line(size = 0.05),  # Make minor x-axi
      axis.text = element_text(size = 10),
      legend.position = "none",
      plot.title.position = "plot",  # Ensures title spans the entire plot width
      plot.title = element_text(hjust = 0.5, vjust = 1) # Center title
    ) +
    
    labs(
      title = paste(PLOT_TITLE),
      x = "Prozent"
    ) +
    
    scale_x_continuous(
      limits = c(0, max(table_result$Prozent) * 1.15),  # Dynamically scales up, no forced 100%
      expand = c(0, 0)
    ) +
    
    scale_fill_brewer(palette = brewer_palette, direction = 1)
  
  # Conditionally add annotation if ANNOTATE_ANZAHL is TRUE
  if (ANNOTATE_ANZAHL) {
    plot_result <- plot_result +
      annotate("text", x = max(table_result$Prozent) * 0.85, y = 1, 
               label = paste("Antworten\nN=", total_rows), 
               hjust = 0.5, vjust = 0.5, size = 4, color = "black")
  }
  
  # Assign plot to global environment with dynamic naming
  assign(paste0("plot_", NAME_FRAGE), plot_result, envir = .GlobalEnv)
}


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Konfiguration ----
# In die sourcende Datei einfügen und # entfernen :)
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
# ## Details zur Frage
# FRAGE_NUMMER <- "5_25"
# LABEL_FRAGE <- "wuensche_inhaltsvermittlung"
# 
# ## Fragennamen zusammensetzen für table_ & plot_ Benennung
# NAME_FRAGE <- paste0(
#   FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
# )
# 
# ## Titel des Plots festlegen
# ## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
# PLOT_TITLE <- sprintf(
#   "Wünsche von %s an Arten der Inhaltsvermittlung im E-Learning", NAME_KOLLEKTIV
# )
# 
# ## Anzeige von "Antworten N=XXX" auf dem Graph
# ANNOTATE_ANZAHL = TRUE
# 
# columns_of_interest <- c(
#   "5.25-kurze_textinhalte",
#   "5.25-lange_textinhalte",	
#   "5.25-audio_ondemand",
#   "5.25-video_ondemand",
#   "5.25-livestreams",
#   "5.25-onlineseminare",
#   "5.25-onlinevortraege"
# )
# 
# column_mapping <- c(
#   "5.25-kurze_textinhalte" = "Kurze Textinhalte (<10 Minuten), welche sich im Alltag zwischendurch lesen lassen",
#   "5.25-lange_textinhalte" = "Lange Textinhalte (> 10 Minuten), in welchen Themen ausführlicher erläutert werden",
#   "5.25-audio_ondemand" = "Audio-Inhalte On-Demand (Podcast, Audiomitschnitte von Vorträgen oä.)",
#   "5.25-video_ondemand" = "Video-Inhalte On-Demand",
#   "5.25-livestreams" = "Livestreams von Veranstaltungen / Vorträgen / Seminaren",
#   "5.25-onlineseminare" = "Online-Seminare in kleineren Gruppen",
#   "5.25-onlinevortraege" = "Online-Vorträge (live) mit der Möglichkeit Fragen zu stellen"
# )
# 
# short_column_names <- c(
#   "Kurze Textinhalte \n(<10 Minuten)",
#   "Lange Textinhalte \n(>10 Minuten)",
#   "Audio-Inhalte \non Demand",
#   "Video Inhalte \nOn-Demand",
#   "Livestreams von \nPräsenzveranstaltungen",
#   "Kleingruppen \nOnline-Seminare",
#   "Reine Online-Vorträge"
# )
# 
# brewer_palette <- "Set3"
# 
# 
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# # Generate Outputs
# #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 
# create_horizontal_bar_plot_percentages(
#   filtered_data, 
#   columns_of_interest, 
#   column_mapping, 
#   short_column_names, 
#   NAME_FRAGE, 
#   PLOT_TITLE,
#   ANNOTATE_ANZAHL,
#   brewer_palette
# )
# Load dependencies
source("./script/global.R")
source("./script/filter_grundlegend.R")
source("./script/likert_scale_7.R")
source("./script/likert_scale_5.R")

filtered_data <- filtered_assistent

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 5.23 Anwendungsfälle E-Learning Likert ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "anwendungsfaelle_elearning_likert"
PLOT_TITLE <- "Würden ÄrztInnen in Weiterbildung E-Learning in folgenden Anwendungsfällen nutzen?"
SELECTED_COLUMNS <- c(
  "5.23-grundlagen",
  "5.23-alternative_praesenz",
  "5.23-spezielle_fachbereiche",
  "5.23-aktuell",
  "5.23-cme"
)
COLUMN_NAMES <- c(
  "Erlernen fachlicher Grundlagen",
  "Alternative zu Präsenzveranstaltungen",
  "Weiterbildung in spez. Fachbereichen",
  "Wissen aktuell halten",
  "CME-Punkte sammeln"
)
BREWER_PALETTE <- "RdBu"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- TRUE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Auf keinen Fall",
  "2" = "Wahrscheinlich nicht",
  "3" = "Eher nicht",
  "Neutral" = "Unentschlossen",
  "5" = "Eher ja",
  "6" = "Wahrscheinlich ja",
  "7" = "Auf jeden Fall"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_7_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
         )
       )

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_7_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
       )



#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 5.24 Anwendungsfälle E-Learning Likert ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "cme_wichtig_likert"
PLOT_TITLE <- "Wie wichtig ist es ÄrztInnen in Weiterbildung für E-Learning CME-Punkte zu erhalten?"
SELECTED_COLUMNS <- c(
  "5.24"
)
COLUMN_NAMES <- c(
  "CME-Punkte erhalten"
)
BREWER_PALETTE <- "RdBu"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Unwichtig",
  "2" = "Eher unwichtig",
  "3" = "Weniger wichtig",
  "Neutral" = "Neutral",
  "5" = "Eher wichtig",
  "6" = "Wichtig",
  "7" = "Sehr wichtig"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_7_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_7_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 6.33 Vorbereitung Notfälle eigenes Fachgebiet ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "nofall_vorbereitet_eigenes_fachgebiet_likert"
PLOT_TITLE <- "Wie gut fühlen sich ÄrztInnen in Weiterbildung auf Notfälle in Ihrem Fachgebiet vorbereitet?"
SELECTED_COLUMNS <- c(
  "6.33"
)
COLUMN_NAMES <- c(
  "Notfallvorbereitung eigenes Fachgebiet"
)
BREWER_PALETTE <- "RdBu"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Sehr schlecht",
  "2" = "Schlecht",
  "3" = "Eher schlecht",
  "Neutral" = "Neutral",
  "5" = "Eher gut",
  "6" = "Gut",
  "7" = "Sehr gut"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_7_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_7_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 6.35 Vorbereitung Notfälle anderes Fachgebiet ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "nofall_vorbereitet_anderes_fachgebiet_likert"
PLOT_TITLE <- "Wie gut fühlen sich ÄrztInnen in Weiterbildung auf Notfälle in anderen Fachgebieten vorbereitet?"
SELECTED_COLUMNS <- c(
  "6.35"
)
COLUMN_NAMES <- c(
  "Notfallvorbereitung andere Fachgebiete"
)
BREWER_PALETTE <- "RdBu"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Sehr schlecht",
  "2" = "Schlecht",
  "3" = "Eher schlecht",
  "Neutral" = "Neutral",
  "5" = "Eher gut",
  "6" = "Gut",
  "7" = "Sehr gut"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_7_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_7_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 6.39 Emotionale Belastung durch Nachtdienste ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "belastung_nachtdienste_emotional_likert"
PLOT_TITLE <- "Wie sehr belasten Nachtdienste AssistenzärztInnen in Weiterbildung aus emotionaler Sicht?"
SELECTED_COLUMNS <- c(
  "6.39"
)
COLUMN_NAMES <- c(
  "Emotionale Belastung Nachtdienst"
)
BREWER_PALETTE <- "Reds"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Überhaupt nicht",
  "2" = "Kaum",
  "3" = "Ein bisschen",
  "4" = "Belastet",
  "5" = "Sehr"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_5_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_5_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 6.40 Fachliche Belastung durch Nachtdienste ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "belastung_nachtdienste_fachlich_likert"
PLOT_TITLE <- "Wie sehr belasten Nachtdienste AssistenzärztInnen in Weiterbildung aus fachlicher Sicht?"
SELECTED_COLUMNS <- c(
  "6.40"
)
COLUMN_NAMES <- c(
  "Fachliche Belastung Nachtdienst"
)
BREWER_PALETTE <- "Reds"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Überhaupt nicht",
  "2" = "Kaum",
  "3" = "Ein bisschen",
  "4" = "Belastet",
  "5" = "Sehr"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_5_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_5_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 6.41 Emotionale Belastung durch Notaufnahmedienste ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "belastung_notaufnahmedienste_emotional_likert"
PLOT_TITLE <- "Wie sehr belasten Notaufnahmedienste AssistenzärztInnen in Weiterbildung aus emotionaler Sicht?"
SELECTED_COLUMNS <- c(
  "6.41"
)
COLUMN_NAMES <- c(
  "Emotionale Belastung Notaufnahmedienst"
)
BREWER_PALETTE <- "Reds"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Überhaupt nicht",
  "2" = "Kaum",
  "3" = "Ein bisschen",
  "4" = "Belastet",
  "5" = "Sehr"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_5_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_5_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 6.42 Fachliche Belastung durch Nachtdienste ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "belastung_notaufnahmedienste_fachlich_likert"
PLOT_TITLE <- "Wie sehr belasten Notaufnahmedienste AssistenzärztInnen in Weiterbildung aus fachlicher Sicht?"
SELECTED_COLUMNS <- c(
  "6.42"
)
COLUMN_NAMES <- c(
  "Fachliche Belastung Notaufnahmedienst"
)
BREWER_PALETTE <- "Reds"
MINIMUM_LABEL_PERCENTAGE <- 4
SHOW_Y_LABELS <- FALSE  # Y-Achsen Labels anzeigen
LABELS <- c(
  "1" = "Überhaupt nicht",
  "2" = "Kaum",
  "3" = "Ein bisschen",
  "4" = "Belastet",
  "5" = "Sehr"
)


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assign(paste0("table_", NAME_FRAGE), 
       create_likert_5_table(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES, 
         LABELS
       )
)

assign(paste0("plot_", NAME_FRAGE), 
       create_likert_5_plot(
         filtered_data, 
         SELECTED_COLUMNS, 
         COLUMN_NAMES,
         PLOT_TITLE, 
         BREWER_PALETTE, 
         MINIMUM_LABEL_PERCENTAGE, 
         LABELS, 
         SHOW_Y_LABELS)
)

print(plot_anwendungsfaelle_elearning_likert)
print(plot_cme_wichtig_likert)
print(plot_nofall_vorbereitet_eigenes_fachgebiet_likert)
print(plot_nofall_vorbereitet_anderes_fachgebiet_likert)
print(plot_belastung_nachtdienste_emotional_likert)
print(plot_belastung_nachtdienste_fachlich_likert)
print(plot_belastung_notaufnahmedienste_emotional_likert)
print(plot_belastung_notaufnahmedienste_fachlich_likert)

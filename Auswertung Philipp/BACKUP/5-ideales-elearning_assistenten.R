# Load dependencies
source("./script/global.R")
source("./script/filter_grundlegend.R")
source("./script/graphs.R")

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

## Columns of Interest definieren (aus filtered_data)
SELECTED_COLUMNS <- c(
  "5.23-grundlagen",
  "5.23-alternative_praesenz",
  "5.23-spezielle_fachbereiche",
  "5.23-aktuell",
  "5.23-cme"
)

## Columns benennen
COLUMN_NAMES <- c(
  "Erlernen fachlicher Grundlagen",
  "Alternative zu Präsenzveranstaltungen",
  "Weiterbildung in spez. Fachbereichen",
  "Wissen aktuell halten",
  "CME-Punkte sammeln"
)

## Welche Brewer Palette zur Farbgebung des Graphen?
BREWER_PALETTE <- "RdBu"

## Minimum % pro Bar-Part ab welchem die % angezeigt werden
MINIMUM_LABEL_PERCENTAGE <- 4

## Labels an der Y-Achse zeigen? TRUE & FALSE
SHOW_Y_LABELS <- TRUE  # Y-Achsen Labels anzeigen

## Labels definieren
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
# 5.25 Wünsche Inhaltsvermittlung E-Learning ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "5_25_wuensche_inhaltsvermittlung"
PLOT_TITLE <- "Wünsche von ÄrztInnen in Weiterbildung an Arten der Inhaltsvermittlung im E-Learning"

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

columns_of_interest <- c(
  "5.25-kurze_textinhalte",
  "5.25-lange_textinhalte",	
  "5.25-audio_ondemand",
  "5.25-video_ondemand",
  "5.25-livestreams",
  "5.25-onlineseminare",
  "5.25-onlinevortraege"
)

column_mapping <- c(
  "5.25-kurze_textinhalte" = "Kurze Textinhalte (<10 Minuten), welche sich im Alltag zwischendurch lesen lassen",
  "5.25-lange_textinhalte" = "Lange Textinhalte (> 10 Minuten), in welchen Themen ausführlicher erläutert werden",
  "5.25-audio_ondemand" = "Audio-Inhalte On-Demand (Podcast, Audiomitschnitte von Vorträgen oä.)",
  "5.25-video_ondemand" = "Video-Inhalte On-Demand",
  "5.25-livestreams" = "Livestreams von Veranstaltungen / Vorträgen / Seminaren",
  "5.25-onlineseminare" = "Online-Seminare in kleineren Gruppen",
  "5.25-onlinevortraege" = "Online-Vorträge (live) mit der Möglichkeit Fragen zu stellen"
)

new_column_values <- c(
  "Kurze Textinhalte \n(<10 Minuten)",
  "Lange Textinhalte \n(>10 Minuten)",
  "Audio-Inhalte \non Demand",
  "Video Inhalte \nOn-Demand",
  "Livestreams von \nPräsenzveranstaltungen",
  "Kleingruppen \nOnline-Seminare",
  "Reine Online-Vorträge"
)

brewer_palette <- "Set3"


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_horizontal_bar_plot_percentages(
  filtered_data, 
  columns_of_interest, 
  column_mapping, 
  new_column_values, 
  NAME_FRAGE, 
  PLOT_TITLE,
  ANNOTATE_ANZAHL,
  brewer_palette
  )










#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# PRINT'em ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
print(plot_5_25_wuensche_inhaltsvermittlung)

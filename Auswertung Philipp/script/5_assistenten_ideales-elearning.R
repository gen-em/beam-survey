# Load dependencies
source("./script/config/global.R")
source("./script/config/filter_grundlegend.R")
source("./script/config/graph-include.R")
source("./script/config/cleanup.R")

filtered_data <- filtered_assistent

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 5.22 E-Learning in Zukunft nutzen? ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NAME_FRAGE <- "5_22_assistenten_elearning_zukunft"
PLOT_TITLE <- "Könnten AssistentInnen in Weiterbildung sich vorstellen, in Zukunft E-Learning Inhalte zu nutzen?"
TITEL_KURZ <- "Zukünftige Nutzung E-Learning"

## Welche Column?
COLUMN_OF_INTEREST <- "5.22"

## Benennung der Antwortoptionen
ANTWORT_OPTIONEN <- c(
                      "Ja", 
                      "Nein"
                      )

## Brewer Palette für Farbgebung
BREWER_PALETTE <- "Pastel2"

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_pie_chart(
  filtered_data = filtered_assistent, 
  column_of_interest = COLUMN_OF_INTEREST, 
  NAME_FRAGE = NAME_FRAGE,
  TITEL_KURZ = TITEL_KURZ,
  ANTWORT_OPTIONEN = ANTWORT_OPTIONEN, 
  PLOT_TITLE = PLOT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 5.23 Anwendungsfälle E-Learning Likert ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "5_25_assistenten_anwendungsfaelle_elearning_likert"
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

NAME_FRAGE <- "5_25_assistenten_cme_wichtig_likert"
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

NAME_FRAGE <- "5_25_assistenten_wuensche_inhaltsvermittlung"
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

short_column_names <- c(
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
  short_column_names, 
  NAME_FRAGE, 
  PLOT_TITLE,
  ANNOTATE_ANZAHL,
  brewer_palette
  )



#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 5.26 Kriterien Auswahl von Kursen & Inhalten ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "5_26_assistenten_kriterien_kursauswahl"
PLOT_TITLE <- "Welche Kriterien sind für ÄrztInnen in Weiterbildung relevant für die Auswahl von Kursen?"

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

columns_of_interest <- c(
  "5.26-alltagsrelevanz",
  "5.26-qualitaetseindruck",
  "5.26-bekanntheit",
  "5.26-beteiligung_fachgesellschaften",
  "5.26-zertifikat"
)

column_mapping <- c(
  "5.26-alltagsrelevanz" = "Alltagsrelevanz des Themas",
  "5.26-qualitaetseindruck" = "Qualitätseindruck des Kurses und der Inhalte",
  "5.26-bekanntheit" = "Bekannte Namen / Firmen hinter dem Kurs",
  "5.26-beteiligung_fachgesellschaften" = "Beteiligung von Fachgesellschaften am Kurs",
  "5.26-zertifikat" = "Erhalt eines Zertifikates / einer Qualifikation mit Abschluss des Kurses"
)


short_column_names <- c(
  "Alltagsrelevanz",
  "Qualitätseindruck",
  "Bekanntheit \nAnbieterIn",
  "Beteiligung von \nFachgesellschaften",
  "Zertifikat oder \nQualifikation"
)

brewer_palette <- "Set3"


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_horizontal_bar_plot_percentages(
  filtered_data, 
  columns_of_interest, 
  column_mapping, 
  short_column_names, 
  NAME_FRAGE, 
  PLOT_TITLE,
  ANNOTATE_ANZAHL,
  brewer_palette
)



#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# 5.31 Welche Wege bisher Veranstaltungen gefunden ? ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
## Configuration ----
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NAME_FRAGE <- "5_31_assistenten_veranstaltungen_bisher_gefunden"
PLOT_TITLE <- "Wie haben ÄrztInnen in Weiterbildung Fortbildungen bisher gefunden?"

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

columns_of_interest <- c(
  "5.31-suchmaschinen",
  "5.31-aerztekammern",
  "5.31-anzeigen_print",
  "5.31-email",
  "5.31-empfehlungen",
  "5.31-fachgesellschaften"
)

column_mapping <- c(
  "5.31-suchmaschinen" = "Internetsuchmaschinen (Google o.Ä.)",
  "5.31-aerztekammern" = "Fortbildungsdatenbanken der Ärztekammern",
  "5.31-anzeigen_print" = "Anzeigen in Printmedien (Zeitschriften / Journals o.Ä.)",
  "5.31-email" = "Werbung per Email",
  "5.31-empfehlungen" = "Empfehlungen von KollegInnen",
  "5.31-fachgesellschaften" = "Mailings von Fachgesellschaften"
)

short_column_names <- c(
  "Suchmaschinen",
  "Datenbanken von\nÄrztekammern",
  "Anzeigen in \nPrintmedien",
  "Email Werbung",
  "Empfehlungen von \nKollegInnen",
  "Mailings von\nFachgesellschaften"
)

brewer_palette <- "Set3"


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Generate Outputs
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_horizontal_bar_plot_percentages(
  filtered_data, 
  columns_of_interest, 
  column_mapping, 
  short_column_names, 
  NAME_FRAGE, 
  PLOT_TITLE,
  ANNOTATE_ANZAHL,
  brewer_palette
)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# Clean up ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
cleanup_workspace()

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# PRINT'em ----
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
print(plot_5_25_assistenten_wuensche_inhaltsvermittlung)
print(plot_5_22_assistenten_elearning_zukunft)
print(plot_5_26_assistenten_kriterien_kursauswahl)
print(plot_5_31_assistenten_veranstaltungen_bisher_gefunden)
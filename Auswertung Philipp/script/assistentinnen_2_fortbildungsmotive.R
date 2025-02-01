# Load dependencies
source("./script/config/global.R")
source("./script/config/filter_grundlegend.R")
source("./script/config/graph-include.R")
source("./script/config/cleanup.R")

## Welches KOLLEKTIV soll ausgewertet werden? 
## Filter in filter_grundlegend definiert
## Nur LABEL_KOLLEKTIV muss entsprechend angepasst werden
## Mögliche Werte
## LABEL_KOLLEKTIV =  alle
##                    studentinnen
##                    assistentinnen
##                    fachaerztinnen
##                    oberaerztinnen
##                    chefaerztinnen
##                    weiterbildende

LABEL_KOLLEKTIV <- "assistentinnen"
filtered_data <- get(paste0("filtered_", LABEL_KOLLEKTIV))
NAME_KOLLEKTIV <- get(paste0("name_", LABEL_KOLLEKTIV))

## Sollen die Plots geprintet werden? TRUE = ja, FALSE = nein
PRINT_PLOTS = FALSE

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 2.15 Motive zur Fort- & Weiterbildung - Histogramm ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "2_15"
LABEL_FRAGE <- "motive_fortbildung"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Motive von %s zur Fort- & Weiterbildung", NAME_KOLLEKTIV
)

## Anzeige von "Antworten N=XXX" auf dem Graph
ANNOTATE_ANZAHL = TRUE

columns_of_interest <- c(
  "2.15-interesse", 
  "2.15-angst_fehler", 
  "2.15-cme", 
  "2.15-arbeitgeber_erwartet",
  "2.15-urkunden", 
  "2.15-umfeld", 
  "2.15-fachlich_uptodate", 
  "2.15-abrechnung",
  "2.15-zertifizierungen", 
  "2.15-fortbildungsbudget_verfallen",
  "2.15-qualitaetsverbesserung", 
  "2.15-versorgungsqualitaet"
)

column_mapping <- c(
  "2.15-interesse" = "Ich habe persönliches / berufliches Interesse an den Inhalten",
  "2.15-angst_fehler" = "Ich habe Angst Fehler zu machen",
  "2.15-cme" = "Ich sammle CME Punkte",
  "2.15-arbeitgeber_erwartet" = "Mein Arbeitgeber erwartet oder fordert es von mir",
  "2.15-urkunden" = "Ich möchte Zertifikate / Urkunden erlangen welche ich präsentieren / ausstellen kann",
  "2.15-umfeld" = "Weil mein Umfeld sich regelmäßig fortbildet",
  "2.15-fachlich_uptodate" = "Weil ich fachlich auf dem neuesten Stand bleiben möchte",
  "2.15-abrechnung" = "Ich brauche Fortbildungen als Voraussetzung zur Abrechnung bestimmter Leistungen",
  "2.15-zertifizierungen" = "Ich brauche Fortbildungen als Voraussetzung für Zertifizierungen (der Praxis/Abteilung oä.)",
  "2.15-fortbildungsbudget_verfallen" = "Mein Fortbildungsbudget soll nicht verfallen",
  "2.15-qualitaetsverbesserung" = "Ich möchte die Qualität meiner Arbeit verbessern",
  "2.15-versorgungsqualitaet" = "Ich möchte die Versorgungsqualität meiner PatientInnen verbessern"
)

short_column_names <- c(
  "Persönliches oder\nBerufliches Interesse",
  "Angst vor Fehlern",
  "Sammeln von CME Punkten",
  "Arbeitgeber erwartet es",
  "Präsentierbare Zertifikate",
  "Umfeld bildet sich fort",
  "Fachlich auf dem\nneuesten Stand bleiben",
  "Zur Abrechnung\nvon Leistungen",
  "Voraussetzung\nfür Zertifizierungen",
  "Fortbildungsbudget\nsoll nicht verfallen",
  "Qualität der eigenen\nArbeit verbessern",
  "Versorgungsqualität\nvon Patienten verbessern"
)

brewer_palette <- "Set3"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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


#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# PRINT'em ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (PRINT_PLOTS) {
  print(get(paste0("plot_2_15_", LABEL_KOLLEKTIV, "_motive_fortbildung")))
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Clean up ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#cleanup_workspace()
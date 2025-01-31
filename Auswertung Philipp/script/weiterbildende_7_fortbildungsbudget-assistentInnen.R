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

LABEL_KOLLEKTIV <- "weiterbildende"
filtered_data <- get(paste0("filtered_", LABEL_KOLLEKTIV))
NAME_KOLLEKTIV <- get(paste0("name_", LABEL_KOLLEKTIV))

## Sollen die Plots geprintet werden? TRUE = ja, FALSE = nein
PRINT_PLOTS = TRUE

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 7.45 Fortbildungsbudget Weiterzubildende pro Jahr - Stacked-Bar-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "7_45"
LABEL_FRAGE <- "fortbildungsbudget_weiterzubildende"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie hoch ist das Fortbildungsbudget der Weiterzubildenden \nvon teilnehmenden %s?", NAME_KOLLEKTIV
)

## Kurztitel für Tabelle etc.
SHORT_TITLE <- "Fortbildungsbudget"

## Welche Column?
COLUMN_OF_INTEREST <- "7.45"

## Benennung der Antwortoptionen (streng nach Reihenfolge!)
VALUE_MAPPING <- c(
  "keines" = "Kein Budget",
  "<200" = "< 200€",
  "200-400" = "200 - 400€",
  "401-600" = "401 - 600€",
  "601-800" = "601 - 800€",
  "801 - 1000€" = "801 - 1000€",
  ">1000" = ">1000€",
  "unbekannt" = "Unbekannt"
)

## Nochmalige Benennung der Antwortoptionen zur Sortierung (wichtig)
ORDERED_LEVELS <- c(
  "Kein Budget",
  "< 200€",
  "200 - 400€",
  "401 - 600€",
  "601 - 800€",
  "801 - 1000€",
  ">1000€",
  "Unbekannt"
)

## Einzelne Antwortoption entfernen (z.B. Unbekannt)
## Name muss dem Namen in ORDERED_LEVELS entsprechen
## Wenn = FALSE wird nichts entfernt
REMOVE_VALUE = "Unbekannt"

## Brewer Palette für Farbgebung
BREWER_PALETTE <- "GnBu"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_stacked_bar_chart_wide(
  filtered_data = filtered_data,
  column_of_interest = COLUMN_OF_INTEREST,
  value_mapping = VALUE_MAPPING,
  ordered_levels = ORDERED_LEVELS,
  NAME_FRAGE = NAME_FRAGE,
  PLOT_TITLE = PLOT_TITLE,
  SHORT_TITLE = SHORT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE,
  REMOVE_VALUE = REMOVE_VALUE
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 7.46 Fortbildungstage Weiterzubildende pro Jahr - Stacked-Bar-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "7_46"
LABEL_FRAGE <- "fortbildungstage_weiterzubildende"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie viele Fortbildungstage haben Weiterzubildende \nvon teilnehmenden %s?", NAME_KOLLEKTIV
)

## Kurztitel für Tabelle etc.
SHORT_TITLE <- "Fortbildungstage"

## Welche Column?
COLUMN_OF_INTEREST <- "7.46"

## Benennung der Antwortoptionen (streng nach Reihenfolge!)
VALUE_MAPPING <- c(
  "keine" = "Keine",
  "1" = "1 Tag",
  "2" = "2 Tage",
  "3" = "3 Tage",
  "4" = "4 Tage",
  "5" = "5 Tage",
  ">5" = ">5 Tage",
  "unbekannt" = "Unbekannt"
)

## Nochmalige Benennung der Antwortoptionen zur Sortierung (wichtig)
ORDERED_LEVELS <- c(
  "Keine",
  "1 Tag",
  "2 Tage",
  "3 Tage",
  "4 Tage",
  "5 Tage",
  ">5 Tage",
  "Unbekannt"
)

## Einzelne Antwortoption entfernen (z.B. Unbekannt)
## Name muss dem Namen in ORDERED_LEVELS entsprechen
## Wenn = FALSE wird nichts entfernt
REMOVE_VALUE = "Unbekannt"

## Brewer Palette für Farbgebung
BREWER_PALETTE <- "BuPu"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Generate Outputs
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

create_stacked_bar_chart_wide(
  filtered_data = filtered_data,
  column_of_interest = COLUMN_OF_INTEREST,
  value_mapping = VALUE_MAPPING,
  ordered_levels = ORDERED_LEVELS,
  NAME_FRAGE = NAME_FRAGE,
  PLOT_TITLE = PLOT_TITLE,
  SHORT_TITLE = SHORT_TITLE,
  BREWER_PALETTE = BREWER_PALETTE,
  REMOVE_VALUE = REMOVE_VALUE
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# PRINT'em ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (PRINT_PLOTS) {
  print(get(paste0("plot_7_45_", LABEL_KOLLEKTIV, "_fortbildungsbudget_weiterzubildende")))
  print(get(paste0("plot_7_46_", LABEL_KOLLEKTIV, "_fortbildungstage_weiterzubildende")))
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Clean up ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cleanup_workspace()
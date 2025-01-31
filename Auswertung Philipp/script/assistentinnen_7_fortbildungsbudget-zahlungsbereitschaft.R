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
PRINT_PLOTS = TRUE

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# 7.43 Fortbildungsbudget pro Jahr - Stacked-Bar-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "7_43"
LABEL_FRAGE <- "fortbildungsbudget"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie hoch ist das Fortbildungsbudget von %s?", NAME_KOLLEKTIV
)

## Kurztitel für Tabelle etc.
SHORT_TITLE <- "Fortbildungsbudget"

## Welche Column?
COLUMN_OF_INTEREST <- "7.43"

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
# 7.44 Fortbildungstage pro Jahr - Stacked-Bar-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "7_44"
LABEL_FRAGE <- "fortbildungstage"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie viele Fortbildungstage haben %s?", NAME_KOLLEKTIV
)

## Kurztitel für Tabelle etc.
SHORT_TITLE <- "Fortbildungstage"

## Welche Column?
COLUMN_OF_INTEREST <- "7.44"

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
# 7.49 Persönliche Ausgabe hochwertiger Fortbildungskurs - Stacked-Bar-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "7_49"
LABEL_FRAGE <- "ausgabe_zusaetzlich"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie viel Geld würden %s zusätzlich \nfür eine hochwertige Fortbildung ausgeben?", NAME_KOLLEKTIV
)

## Kurztitel für Tabelle etc.
SHORT_TITLE <- "Zusätzliche Ausgabe"

## Welche Column?
COLUMN_OF_INTEREST <- "7.49"

## Benennung der Antwortoptionen (streng nach Reihenfolge!)
VALUE_MAPPING <- c(
  "keines" = "Keines",
  "<150" = "< 150€",
  "150-300" = "150 - 300€",
  "301-450" = "301 - 450€",
  "451-600" = "451 - 600€",
  "601-750" = "601 - 750€",
  ">750" = "> 750€"
)

## Nochmalige Benennung der Antwortoptionen zur Sortierung (wichtig)
ORDERED_LEVELS <- c(
  "Keines",
  "< 150€",
  "150 - 300€",
  "301 - 450€",
  "451 - 600€",
  "601 - 750€",
  "> 750€"
)

## Einzelne Antwortoption entfernen (z.B. Unbekannt)
## Name muss dem Namen in ORDERED_LEVELS entsprechen
## Wenn = FALSE wird nichts entfernt
REMOVE_VALUE = "Unbekannt"

## Brewer Palette für Farbgebung
BREWER_PALETTE <- "PuBuGn"

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
# 7.50 Persönliche Ausgabe hochwertiger KLINAM Fortbildungskurs - Stacked-Bar-Chart ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Configuration ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## Details zur Frage
FRAGE_NUMMER <- "7_50"
LABEL_FRAGE <- "ausgabe_zusaetzlich_klinam"

## Fragennamen zusammensetzen für table_ & plot_ Benennung
NAME_FRAGE <- paste0(
  FRAGE_NUMMER, "_", LABEL_KOLLEKTIV, "_", LABEL_FRAGE
)

## Titel des Plots festlegen
## %s wird durch die Beschreibung in "filter_grundlegend" ersetzt (Als Plural hinterlegt)
PLOT_TITLE <- sprintf(
  "Wie viel Geld würden %s zusätzlich für eine \nhochwertige Fortbildung in klinischer Notfallmedizin ausgeben?", NAME_KOLLEKTIV
)

## Kurztitel für Tabelle etc.
SHORT_TITLE <- "Zusätzliche Ausgabe"

## Welche Column?
COLUMN_OF_INTEREST <- "7.50"

## Benennung der Antwortoptionen (streng nach Reihenfolge!)
VALUE_MAPPING <- c(
  "keines" = "Keines",
  "<150" = "< 150€",
  "150-300" = "150 - 300€",
  "301-450" = "301 - 450€",
  "451-600" = "451 - 600€",
  "601-750" = "601 - 750€",
  ">750" = "> 750€"
)

## Nochmalige Benennung der Antwortoptionen zur Sortierung (wichtig)
ORDERED_LEVELS <- c(
  "Keines",
  "< 150€",
  "150 - 300€",
  "301 - 450€",
  "451 - 600€",
  "601 - 750€",
  "> 750€"
)

## Einzelne Antwortoption entfernen (z.B. Unbekannt)
## Name muss dem Namen in ORDERED_LEVELS entsprechen
## Wenn = FALSE wird nichts entfernt
REMOVE_VALUE = "Unbekannt"

## Brewer Palette für Farbgebung
BREWER_PALETTE <- "PuBuGn"

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
print(get(paste0("plot_7_43_", LABEL_KOLLEKTIV, "_fortbildungsbudget")))
print(get(paste0("plot_7_44_", LABEL_KOLLEKTIV, "_fortbildungstage")))
print(get(paste0("plot_7_49_", LABEL_KOLLEKTIV, "_ausgabe_zusaetzlich")))
print(get(paste0("plot_7_50_", LABEL_KOLLEKTIV, "_ausgabe_zusaetzlich_klinam")))
}
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Clean up ----
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cleanup_workspace()
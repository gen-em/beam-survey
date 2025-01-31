#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Rohdaten aus Excel-Datei einfügen ----
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Excel Datei ist manuell bereinigt worden 
# - Nicht-ÄrztInnen entfernt
# - Sonstiges korrigiert / aufgehübscht
# - Likert-Scale Spalten zusammengefasst
# - ja/nein in Boolean TRUE/FALSE überführt
# - Spaltentitel angepasst
# - Antworten fürs Einlesen in R verbessert
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rohdaten_quelldatei <- "./rohdaten/beam-ergebnisse_philipp-edit.xlsx"
rohdaten <- read_excel(rohdaten_quelldatei, sheet = 1)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
# Filter nach Gen-EM Kriterien ----
# 
# filtered_alle = Alle TeilnehmerInnen
# filtered_studentinnen = Studenten
# filtered_assistentinnen = MedizinerInnen in Weiterbildung
# filtered_fachaerztinnen = FachärztInnen
# filtered_oberaerztinnen = OberärztInnen
# filtered_chefaerztinnen = ChefärztInnen
# filtered_weiterbildende = OberärztInnen + ChefärztInnen
#...........................................................................................
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Alle TeilnehmerInnen ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Var = filtered_alle
# LABEL = alle
filtered_alle <- rohdaten
## Name für das Kollektiv, um es in den Grafiktiteln einzubinden
name_alle <- "TeilnehmerInnen"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## StudentInnen ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Var = filtered_studentinnen
# LABEL = studentinnen
filtered_studentinnen <- rohdaten %>%
  filter(`1.2` %in% c("student"))
# Name für das Kollektiv, um es in den Grafiktiteln einzubinden
name_studentinnen <- "StudentInnen"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## ÄrztInnen in Weiterbildung + Approbiert vor Beginn Weiterbildung ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Var = filtered_assistentinnen
# LABEL = assistentinnen
filtered_assistentinnen <- rohdaten %>%
  filter(`1.2` %in% c("arzt_weiterbildung", "approbiert_vor_beginn"))
# Name für das Kollektiv, um es in den Grafiktiteln einzubinden
name_assistentinnen <- "MedizinerInnen in Weiterbildung"


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Facharzt ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Var = filtered_fachaerztinnen
# LABEL = fachaerztinnen
filtered_fachaerztinnen <- rohdaten %>%
  filter(`1.2` %in% c("facharzt"))
# Name für das Kollektiv, um es in den Grafiktiteln einzubinden
name_fachaerztinnen <- "FachärztInnen"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Oberarzt ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Var = filtered_oberaerztinnen
# LABEL = oberaerztinnen
filtered_oberaerztinnen <- rohdaten %>%
  filter(`1.2` %in% c("oberarzt"))
# Name für das Kollektiv, um es in den Grafiktiteln einzubinden
name_oberaerztinnen <- "OberärztInnen"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Chefarzt ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Var = filtered_chefaerztinnen
# LABEL = chefaerztinnen
filtered_chefaerztinnen <- rohdaten %>%
  filter(`1.2` %in% c("chefarzt"))
# Name für das Kollektiv, um es in den Grafiktiteln einzubinden
name_chefaerztinnen <- "ChefärztInnen"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Weiterbildende ----
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Var = filtered_weiterbildende
# LABEL = weiterbildende
filtered_weiterbildende <- rohdaten %>%
  filter(`1.2` %in% c("chefarzt", "oberarzt"))
# Name für das Kollektiv, um es in den Grafiktiteln einzubinden
name_weiterbildende <- "OberärztInnen & ChefärztInnen"

# Auskommentiert, weil R nicht fragt ob etwas überschrieben werden soll. Wird in andere Datei verschoben.
Spaltennamen_roh <- colnames(Ergebnisse)
Spaltennamen <- Spaltennamen_roh

writeLines(Spaltennamen, "Spaltennamen.txt")
#writeLines(Spaltennamen_roh, "Spaltennamen_rescue.txt")
#Zur Sicherheit auskommentiert
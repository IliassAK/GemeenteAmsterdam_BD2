library(leaflet)
library(shiny)
library(dplyr)
library(DT)
library(markdown)
library(shinythemes)
library(plotly)
library(ggplot2)
library(ggvis)
library(jsonlite)
library(viridis)

# ----------------
# Begin Global settings
# ----------------

# FALSE = laad alle indicatoren in geheugen en hou ze daar, TRUE = gebruik indicatoren alleen bij opstarten en haal ze daarna live op (bespaard geheugen na opstarten)
slow_mo <- FALSE

# TRUE = gebruik een lokale (file based) cache voor snel opstarten , FALSE = gebruik deze lokale cache niet 
allow_local_cache <- TRUE
#hoe lang vertrouwen we deze cache in uren
local_cache_timeout <- 72

# placeholder voor lege dropdown items
emptyInputString <- "(leeg)"

# placeholder voor dropdown items (waarbij er standaard geen geselecteerd hoort te zijn)
placeholderInputString <- "(selecteer)"

leefbaarheidWaardeText <- c("Zeer onvoldoende", "Ruim onvoldoende", "Onvoldoende", "Zwak", "Voldoene", "Ruim voldoende", 
                            "Goed", "Zeer goed", "Uitstekend")


# Set the default theme
thema <- reactiveValues(th="Veiligheid")

# ----------------
# End Global settings
# ----------------

if (slow_mo) {
  source("dbconnection//amsterdam_MYSQL_datasource.R")
} else {
  source("dbconnection//amsterdam_RAM_from_MYSQL_datasource.R")
}

#in slow_mo mode werkt de cache niet
if (!slow_mo && allow_local_cache) {
  source("dbconnection//offlineCache.R")
  if (isCacheValid(cacheTimeOutHours = local_cache_timeout)) {
    if(!loadLocalCache()){
      print("Error while Trying to load the local cache, using database instead.")
      initializeData(stats=TRUE)
      saveLocalCache()
    }
  } else {
    print("local cache has expired, using database instead and saving the results")
    initializeData(stats=TRUE)
    saveLocalCache()
  }
} else {
  initializeData(stats=TRUE)
}

#dit moet opgeslagen woden in de database
treeLength <- length(gebiedenTree$`Postcode 4`$features)
for(i in treeLength:1){
  if (gebiedenTree$`Postcode 4`$features[[i]]$properties$niveau != 11) {
    gebiedenTree$`Postcode 4`$features[[i]] <- NULL
  }
}

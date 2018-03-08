source("dbconnection//amsterdam_MYSQL_connection.R")
library(dplyr)
library(jsonlite)
# ----------------
# Initialization code
# ----------------

#het ophalen van de data, je kan met "en_varnaam=FALSE" het ophalen van specifieke data uitzetten (alleen voor development handig lijkt me)
#ook kan je de "... retrieval took N seconds to complete." berichten uitzetten met "stats=FALSE"
#standaard is alles TRUE
initializeData <- function(stats=TRUE,en_gebiedenGeoJson=TRUE,en_gebieden=TRUE,en_metaData=TRUE,en_kernCijfers=TRUE,en_metadataTree=TRUE,en_dataTree=TRUE,en_gebiedenTree=TRUE,en_leefbaarheidGeoJson=TRUE,en_leefbaarheidTree=TRUE){
  conn <- connectDb()
  
  
  if(en_gebiedenGeoJson && !exists("gebiedenTree") &&  !exists("gebiedenGeoJson")){
    ggjT <- Sys.time()
    gebiedenGeoJson <<- getJSONGebieden(conn)
    if(stats){cat(paste0("gebiedenGeoJson retrieval took ",Sys.time() - ggjT, " seconds to complete.\n"))}
    remove(ggjT)
  }
  if(en_gebieden && !exists("gebieden")){
    gT <- Sys.time()
    gebieden <<- getGebieden(conn)
    if(stats){cat(paste0("gebieden retrieval took ",Sys.time() - gT, " seconds to complete.\n"))}
    remove(gT)
  }
  if(en_metaData && !exists("metaDataTree") && !exists("metaData")){
    mT <- Sys.time()
    metaData <<- getMetadata(conn)
    if(stats){cat(paste0("metaData retrieval took ",Sys.time() - mT, " seconds to complete.\n"))}
    remove(mT)
  }
  if(en_kernCijfers &&!exists("dataTree") && !exists("kernCijfers")){
    kT <- Sys.time()
    kernCijfers <<- getKerncijfers(conn)
    if(stats){cat(paste0("kernCijfers retrieval took ",ceiling(Sys.time() - kT), " seconds to complete.\n"))}
    remove(kT)
  }
  
  if(( en_metadataTree) && !exists("metadataTree")){
    mdtT <- Sys.time()
    metadataTree <<- buildMetadataTree()
    if(stats){cat(paste0("Metadata structure took ",Sys.time() - mdtT, " seconds to build.\n"))}
  }
  
  if(( en_kernCijfers || en_dataTree) && !exists("dataTree")){
    datrT <- Sys.time()
    dataTree <<- buildDataTree()
    if(stats){cat(paste0("Data structure took ",ceiling(Sys.time() - datrT), " seconds to build.\n"))}
  }
  
  if(en_gebiedenTree && !exists("gebiedenTree")){
    gJST <- Sys.time()
    gebiedenTree <<- buildGebiedenTree()
    if(stats){cat(paste0("Gebieden JSON structure took ",Sys.time() - gJST, " seconds to build.\n"))}
  }
  
  disconnectDb(conn)
  
  tryCatch({
    remove("gebiedenGeoJson","kernCijfers","metaData")
  },warning=function(e){
    #doe niks, we krijgen soms een nutteloze warning
  })
}

# ----------------
# set code
# ----------------

#alles in dit bestand gaat er van uit dat kerncijfers,gebieden en metadata in de scope te krijgen zijn

#build metadata tree
buildMetadataTree <- function(){
  metadataTree <- list()
  themas <- (metaData %>% distinct(thema) %>% arrange(thema))$thema
  
  for (theme in themas) {
    indicators <- metaData %>% filter(thema == theme) %>% arrange(label)
    metadataTree[[theme]] <- indicators
  }
  
  
  return(metadataTree)
}

#begin van het bouwen van de dataTree
buildDataTree <- function(){
  if(!exists("metadataTree")){
    metadataTree <<- buildMetadataTree()
  }
  
  dataTree <- list()
  themas <- (metaData %>% distinct(thema) %>% arrange(thema))$thema
  
  #themas <- themas[2:3] #limit aantal voor build tijd
  
  dataTree <- unlist(lapply(themas,buildDataThemeTree), recursive = FALSE)
  return(dataTree)
}

#stap 2, themes
buildDataThemeTree <- function(theme){
  #theme is een chr
  dataTreeTheme<- list()
  
  indicators <- metaData %>% filter(thema == theme) %>% arrange(label)

  dataTreeTheme[[theme]] <- unlist(apply(
    indicators,
    1,
    buildDataIndicatorTree)
    ,recursive = FALSE)
  return(dataTreeTheme)
}

#stap 3, indicatoren
buildDataIndicatorTree <- function(indicator){
  #indicator is een df row in formaat metaData
  dataTreeIndicator <- list()
  
  
  #bepaal welke data bij de huidige indicator hoort en laat vanaf nu "variabelenaam" weg uit data
  KPIs <- kernCijfers %>% filter(variabelenaam == indicator["variabelenaam"]) %>% mutate( label = indicator["label"]) %>% select(jaar,gebiedcode,waarde,variabelenaam,label)
  #bepaal welke gebieden voor de KPIs relevant zijn
  areas <- gebieden %>% filter(gebiedcode %in% KPIs$gebiedcode)
  #todo join gebieden en KPIs op basis van gebiedcode en pass jaar,gebiedcode,waarde, niveaunaam door naar buildDataNiveauTree
  KPIs <- inner_join(KPIs,areas,by=c("gebiedcode")) %>% select(jaar,gebiedcode,waarde,niveaunaam,variabelenaam,gebiednaam,label)
  #bepaal niveaus voor volgende stap
  levels <- distinct(areas, niveaunaam) %>% arrange(niveaunaam)
  
  dataTreeIndicator[[indicator["variabelenaam"]]] <- unlist(apply(
    levels,
    1,                                                           
    buildDataNiveauTree,
    indicatorData=KPIs
  ), 
  recursive = FALSE)
  return(dataTreeIndicator)
}

#stap 4, niveaus (final)
buildDataNiveauTree <- function(level,indicatorData){
  #level is een chr, indicatorData is de data in formaat kernCijfers[-variabelenaam]
  dataTreeNiveau <- list()
  #browser()
  tryCatch({
    dataTreeNiveau[[level]] <- indicatorData[indicatorData$niveaunaam == level,]
    return(dataTreeNiveau)
  },
  error=function(e){return(dataTreeNiveau)}
  )
  
  
}

#build jsongebieden cache
buildGebiedenTree <- function(){
  gebiedenTree <- list()
  i <- 1
  for(niveauNaam in gebiedenGeoJson$niveaunaam){
    gebiedenTree[[niveauNaam]] <- fromJSON(gebiedenGeoJson$json[i], simplifyVector =  FALSE)
    i <- i+1
  }
  return(gebiedenTree)
}

# ----------------
# get code
# ----------------

getThemesVector <- function(){
  names(metadataTree)
}

getIndicatorLabelVector <- function(thema){
  metadataTree[[thema]]$label
}

getIndicatorLabel <- function(thema, indicator){
  labelName <- which(metadataTree[[thema]]$variabelenaam == indicator)
  metadataTree[[thema]]$label[labelName]
}

getIndicatorMetaDataText <- function(thema, indicator){
  definitie <- which(metadataTree[[thema]]$variabelenaam == indicator)
  metadataTree[[thema]]$definitie[definitie]
}

getIndicatorNameVector <- function(thema){
  metadataTree[[thema]]$variabelenaam
}

getIndicatorSymbol <- function(thema, indicator){
  symbolType <- which(metadataTree[[thema]]$variabelenaam == indicator)
  metadataTree[[thema]]$symbool[symbolType]
}

#returned de kolommen die we gebruiken voor de leaves van de dataTree, hanidg voor het initialiseren van een dataframe met de juiste structuur
getLeafStructureDf <- function(){
  return(dataTree[[1]][[1]][[1]][0,])
}

#voor selectie label/value pair
getNamedIndicatorVector <- function (thema){
  labels <- getIndicatorLabelVector(thema)
  variables <- getIndicatorNameVector(thema)
  names(variables) <- labels
  return(variables)
}

getThemeFromIndicator <- function(indicatorname, isLabel=FALSE){
  for (theme in names(metadataTree)) {
    if (!isLabel) {
      testResult <- indicatorname %in% metadataTree[[theme]]$variabelenaam
    } else {
      testResult <- indicatorname %in% metadataTree[[theme]]$label
    }
    
    if(testResult){
      return(theme)
    }
  }
}

#voor selectie gevuld met alle indicatoren, gegroepeerd per thema
getThemeLabeledIndicatorList <- function(){
  ThemeLabeledIndicatorList <- list()
  
  for (theme in getThemesVector()) {
    ThemeLabeledIndicatorList[[theme]] <- getNamedIndicatorVector(theme)
  }
  
  return(ThemeLabeledIndicatorList)
}

getBackButtonText <- function()
{
  textBackButton
}

getBackButtonIcon <- function()
{
  iconBackButton
}

#ook bekend als niveaunaam en schaal
getLevelVector <- function(thema,indicator){
  if(!is.null(dataTree[[thema]][[indicator]])){
    names(dataTree[[thema]][[indicator]])
  } else {
    NULL
  }
}

getAreaNameByAreaCode <- function(areaCodes){
  (gebieden %>% filter(gebiedcode %in% areaCodes))$gebiednaam
}

getYearVector <- function(thema,indicator,schaal){
  if(!is.null(dataTree[[thema]][[indicator]][[schaal]])){
    (dataTree[[thema]][[indicator]][[schaal]] %>% select(jaar) %>% distinct(jaar))[[1]]
  } else {
    NULL
  }
}

getDataDF <- function(thema,indicator,schaal,useLabel=FALSE){
  if(!is.null(dataTree[[thema]][[indicator]][[schaal]])){
      dataTree[[thema]][[indicator]][[schaal]]
    
  } else {
    NULL
  }
}

getDataDFForYear <- function(thema,indicator,schaal,jaarfilter){
  data <- dataTree[[thema]][[indicator]][[schaal]]
  if(!is.null(data)) {
    data <- filter(data, jaar == jaarfilter)
  } 
  
  if(!is.null(data) && nrow(data) >= 1) {
    return(data)
  }
  
  return(NULL)
}

#gemaakt voor de multi-select van de data viewer, krijgt een vector van variabelenamen en returned een df met alle data bij deze indicator
getDataDFForFullIndicator <- function(indicators){
  #maak een lege dataframe met de structuur van een dataTree leaf 
  returnDF <- getLeafStructureDf()
  for(theme in getThemesVector()){
    for(indicator in indicators){
      if (!is.null(dataTree[[theme]][[indicator]])) {
        for (level in getLevelVector(theme,indicator)) {
          returnDF <- rbind.data.frame(returnDF,getDataDF(theme,indicator,level))
        }
      }
    }
  }
  row.names(returnDF) <- NULL
  return(returnDF)
}

getGeoJSON <- function(schaal){
  gebiedenTree[[schaal]]
}

getLabeledLevelContentVector <- function(level){
  areaDF <- gebieden %>% filter(niveaunaam == level) %>% select(gebiedcode, gebiednaam)

  aCodes <- c(areaDF$gebiedcode)
  aNames <- c(areaDF$gebiednaam)
  
  names(aCodes) <- aNames
  return(aCodes)
}

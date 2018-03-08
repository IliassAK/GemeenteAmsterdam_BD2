source("dbconnection//amsterdam_MYSQL_connection.R")
library(dplyr)
library(jsonlite)


#Doel van deze is om kerncijfers niet te bewaren in geheugen maar in de db

conn <- connectDb()

initializeData <- function(stats=TRUE){
  
  if(!exists("gebiedenTree") &&  !exists("gebiedenGeoJson")){
    ggjT <- Sys.time()
    gebiedenGeoJson <<- getJSONGebieden(conn)
    if(stats){cat(paste0("gebiedenGeoJson retrieval took ",Sys.time() - ggjT, " seconds to complete.\n"))}
    remove(ggjT)
  }
  if( !exists("leefbaarheidTree") &&  !exists("leefbaarheidGeoJson")){
    ggjT <- Sys.time()
    leefbaarheidGeoJson <<- getLeefbaarheidJSONGebieden(conn)
    if(stats){cat(paste0("leefbaarheidGeoJson retrieval took ",Sys.time() - ggjT, " seconds to complete.\n"))}
    remove(ggjT)
  }
  if(!exists("gebieden")){
    gT <- Sys.time()
    gebieden <<- getGebieden(conn)
    if(stats){cat(paste0("gebieden retrieval took ",Sys.time() - gT, " seconds to complete.\n"))}
    remove(gT)
  }
  if(!exists("metaDataTree") && !exists("metaData")){
    mT <- Sys.time()
    metaData <<- getMetadata(conn)
    if(stats){cat(paste0("metaData retrieval took ",Sys.time() - mT, " seconds to complete.\n"))}
    remove(mT)
  }
  if(!exists("dataTree") && !exists("kernCijfers")){
    kT <- Sys.time()
    kernCijfers <<- getKerncijfers(conn)
    if(stats){cat(paste0("kernCijfers retrieval took ",ceiling(Sys.time() - kT), " seconds to complete.\n"))}
    remove(kT)
  }
  
  if(!exists("metadataTree")){
    mdtT <- Sys.time()
    metadataTree <<- buildMetadataTree()
    if(stats){cat(paste0("Metadata structure took ",Sys.time() - mdtT, " seconds to build.\n"))}
  }
  
  if(!exists("dataTree")){
    datrT <- Sys.time()
    dataTree <<- buildDataTree()
    if(stats){cat(paste0("Data structure took ",ceiling(Sys.time() - datrT), " seconds to build.\n"))}
  }
  
  if(!exists("gebiedenTree")){
    gJST <- Sys.time()
    gebiedenTree <<- buildGebiedenTree()
    if(stats){cat(paste0("Gebieden JSON structure took ",Sys.time() - gJST, " seconds to build.\n"))}
  }
  
  if(!exists("leefbaarheidTree")){
    gJST <- Sys.time()
    leefbaarheidTree <<- buildLeefbaarheidTree()
    if(stats){cat(paste0("Leefbaarheid JSON structure took ",Sys.time() - gJST, " seconds to build.\n"))}
  }
  
  disconnectDb(conn)
  
  tryCatch({
    remove("gebiedenGeoJson","kernCijfers","metaData", "leefbaarheidGeoJson")
  },warning=function(e){
    #doe niks, we krijgen soms een verwaarloosbare warning
  })
  #print("Memory usage:")
  #print(object.size(x=lapply(ls(), get)), units="Mb")
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
  KPIs <- kernCijfers %>% filter(variabelenaam == indicator["variabelenaam"]) %>% mutate( label = indicator["label"]) %>% select(gebiedcode,jaar,variabelenaam)
  #bepaal welke gebieden voor de KPIs relevant zijn
  areas <- gebieden %>% filter(gebiedcode %in% KPIs$gebiedcode)
  #join gebieden en KPIs op basis van gebiedcode en pass jaar,gebiedcode,waarde, niveaunaam door naar buildDataNiveauTree
  KPIs <- inner_join(KPIs,areas,by=c("gebiedcode")) %>% select(gebiedcode,niveaunaam,jaar,variabelenaam)
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
  tryCatch({
    dataTreeNiveau[[level]][["gebiedcode"]] <- unique(indicatorData[indicatorData$niveaunaam == level,c("gebiedcode")])
    dataTreeNiveau[[level]][["jaar"]] <- unique(indicatorData[indicatorData$niveaunaam == level,c("jaar")])
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

buildLeefbaarheidTree <- function(){
  leefbaarheidTree <- list()
  i <- 1
  for(niveauNaam in leefbaarheidGeoJson$niveaunaam){
    leefbaarheidTree[[niveauNaam]] <- fromJSON(leefbaarheidGeoJson$json[i], simplifyVector =  FALSE)
    i <- i+1
  }
  return(leefbaarheidTree)
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

#returned de kolommen die we gebruiken voor de leaves van de dataTree, hanidg voor het initialiseren van een dataframe met de juiste structuur
getLeafStructureDf <- function(){
  #conn <- connectDb()
  #tmpDF <- getKerncijfers(conn, "SELECT * FROM kerncijfer LIMIT 1")
  #disconnectDb(conn)
  tmpDF <- data.frame(jaar=c(2015),gebiedcode=c("code"),waarde=c(0),niveaunaam=c("naam"),variabelenaam=c("naam"),gebiednaam=c("naam"),label="label",stringsAsFactors = F)
  return(tmpDF[0,])
}

#voor selectie label/value pair
getNamedIndicatorVector <- function (thema){
  labels <- getIndicatorLabelVector(thema)
  variables <- getIndicatorNameVector(thema)
  names(variables) <- labels
  return(variables)
}

#voor selectie gevuld met alle indicatoren, gegroepeerd per thema
getThemeLabeledIndicatorList <- function(){
  ThemeLabeledIndicatorList <- list()
  
  for (theme in getThemesVector()) {
    ThemeLabeledIndicatorList[[theme]] <- getNamedIndicatorVector(theme)
  }
  
  return(ThemeLabeledIndicatorList)
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
    dataTree[[thema]][[indicator]][[schaal]][["jaar"]]
  } else {
    NULL
  }
}

getDataDF <- function(thema,indicator,schaal,useLabel=FALSE){
  conn <- connectDb()
  q <- paste0("SELECT * FROM kerncijfer WHERE variabelenaam IN ",
              vectorToMYSQLArray(indicator),
              " AND gebiedcode IN",
              vectorToMYSQLArray(
                dataTree[[thema]][[indicator]][[schaal]][["gebiedcode"]]
              )
  )
  tmpDF <- data.frame()
  tryCatch({
    tmpDF <- getKerncijfers(conn, q)
    tmpDF <- inner_join(tmpDF,metadataTree[[thema]],by=c("variabelenaam"))
    tmpDF <- inner_join(tmpDF,gebieden,by=c("gebiedcode")) %>% select(jaar,gebiedcode,waarde,niveaunaam,variabelenaam,gebiednaam,label)
  },
  warn=function(e){
    print(paste0("getDataDF: warning during retrieval: ",e))
  },
  error=function(e){
    print(paste0("getDataDF: error during retrieval: ",e))
    cat(q)
    return(NULL)
  })
  disconnectDb(conn)
  return(tmpDF)
}


getDataDFForYear <- function(thema,indicator,schaal,jaarfilter){
  conn <- connectDb()
  q <- paste0("SELECT * FROM kerncijfer WHERE variabelenaam IN ",
              vectorToMYSQLArray(indicator),
              " AND gebiedcode IN ",
              vectorToMYSQLArray(
                dataTree[[thema]][[indicator]][[schaal]][["gebiedcode"]]
              ),
              " AND jaar IN ",
              vectorToMYSQLArray(c(jaarfilter))
  )

  tmpDF <- data.frame()
  tryCatch({
    tmpDF <- getKerncijfers(conn, q)
    tmpDF <- inner_join(tmpDF,metadataTree[[thema]],by=c("variabelenaam"))
    tmpDF <- inner_join(tmpDF,gebieden,by=c("gebiedcode")) %>% select(jaar,gebiedcode,waarde,niveaunaam,variabelenaam,gebiednaam,label)
  },
  warn=function(e){
    print(paste0("getDataDFForYear: warning during retrieval: ",e))
  },
  error=function(e){
    print(paste0("getDataDFForYear: error during retrieval: ",e))
    cat(q)
    return(NULL)
  })
  
  disconnectDb(conn)
  return(tmpDF)
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

getLeefbaarheidJSON <- function(schaal){
  leefbaarheidTree[[schaal]]
}
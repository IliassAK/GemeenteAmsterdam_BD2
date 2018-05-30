#Render the comparison map
output$mapCorrelations <- renderLeaflet(createLeafletMap())
mapCorrelationsProxy <- leafletProxy("mapCorrelations")

#setwd("D:/Development/Projects/Big Data Project/2018_BD2_OpenData2/correlatie")


# onzeSDnieuw_westcorrelatie <- read.csv("onzeSDnieuw_westcorrelatie.csv",sep = ",")
# onzeSDzuid_oostcorrelatie <- read.csv("onzeSDzuid_oostcorrelatie.csv",sep = ",")
# onzeSDnoordcorrelatie <- read.csv("onzeSDnoordcorrelatie.csv",sep = ",")
# onzeSDWestpoortcorrelatie <- read.csv("onzeSDWestpoortcorrelatie.csv",sep = ",")
# onzeSDWestcorrelatie <- read.csv("onzeSDWestcorrelatie.csv",sep = ",")
# onzeSDZuidcorrelatie <- read.csv("onzeSDZuidcorrelatie.csv",sep = ",")
# onzeSDcentrumcorrelatie <- read.csv("onzeSDcentrumcorrelatie.csv",sep = ",")
# onzeSDOostcorrelatie <- read.csv("onzeSDOostcorrelatie.csv",sep = ",")
normalisatiestadsdeel <- dbGetQuery(conn, "SELECT * FROM sdAlle")
correlatieTotaal <- dbGetQuery(conn, "SELECT * FROM correlatieTotaal")




#creeer lijst met standsdelen
stadsdelen <- as.character(unique(normalisatiestadsdeel$gebiednaam))

#updateSelectInput(session, "testCorrelatie",
#                 choices = c("", sort(stadsdelen)),
#                 selected = NULL) 

#creeer lijst met variabel naam +id
alleVariabelen <- unique (cbind.data.frame(normalisatiestadsdeel$variabelenaam, normalisatiestadsdeel$variabele_ID, normalisatiestadsdeel$label, normalisatiestadsdeel$thema))
colnames(alleVariabelen) <- c("variabele", "id", "label" , "thema")

#Main function creeert een lijst met indicators
selecteerIndicatoren <- function(indicator, correlationvalue, area, checkbox){
  
  #Verwijzing naar juiste gebied/Database
  
  currentArea <- correlatieTotaal %>% subset(correlatieTotaal$Stadsdeel == area)
  
  ##########Todo automatisch verwijzen naarjuist tabel
  
  indicator <- unique(subset(alleVariabelen$id, alleVariabelen$variabele == indicator))
  
  #filter ID van gebied tabel
  thema <- subset(alleVariabelen$thema, alleVariabelen$id == indicator)
  currentArea <- subset(currentArea$statistics_2_id, currentArea$statistics_1_id == indicator & abs(currentArea$value) >= correlationvalue[1] & abs(currentArea$value) <= correlationvalue[2] & abs(currentArea$value) != 1)
  thema
  #Als de checkbox is aan gevinkt, filter op thema
  
  if(checkbox == TRUE){
    SelectedArea <- subset(alleVariabelen$label, alleVariabelen$id %in% currentArea & alleVariabelen$thema != thema)
    
    
  } else {
    SelectedArea <- subset(alleVariabelen$label, alleVariabelen$id %in% currentArea)
    
  }
  
  
  #Return filtered lijst van variabelen 
  return(as.character(SelectedArea))
  
  
  
}

addToMapCorrelations <- function(map, level="Stadsdeel") {
  json <- getGeoJSON(level)
  json$style  = list(
    weight = 3,
    color = "#555555",
    fillColor = "#ec0000",
    opacity = 1,
    fillOpacity = 0.5
  )
  addGeoJSON(map, json)
}

updateCorrelationGraph1 <- function(properties) {
  if(input$CorrelationElem1 == "" ||  input$correlationLevel == "" || input$filterCorrelation == ""){
    return()
  }
  
  pMode <- "lines+markers"
  pType <- "scatter"
  fullplot <- plot_ly(mode = pMode, type = pType) %>%
    layout(
      
      xaxis = list( title = "jaar") #type="category" werkt hier niet omdat de eerst toegevoegde indicator een jaar kan bevatten dat na de 2e indicator komt, maar door plotly toch als eerste word getoond (xaxis bevat 2016,2016,2014,2015)  
    )
  fullplot$elementId <- NULL
  
  if(!is.na(properties)) {
    indicators <- input$CorrelationElem1
    #code <- properties$gebiedcode
    
    
    data <- getDataDFForFullIndicator(indicators) %>% filter(gebiednaam == selectedArea)
    
    for (i in 1:length(indicators)) {
      dataIndicator <- data %>% filter(variabelenaam == indicators[i])
      fullplot <- fullplot %>% add_trace(data = dataIndicator, x = ~jaar, y = ~waarde, mode = pMode, inherit = TRUE, text = ~label, name = ~label)
    }
  }
  output$CorrelationGraph1 <- renderPlotly({fullplot})
  
}

updateCorrelationGraph2 <- function(properties) {
  if(input$CorrelationElem1 == "" ||  input$correlationLevel == "" || input$filterCorrelation == ""){
    return()
  }
  
  
  pMode <- "lines+markers"
  pType <- "scatter"
  fullplot2 <- plot_ly(mode = pMode, type = pType) %>%
    layout(
      xaxis = list( title = "jaar") #type="category" werkt hier niet omdat de eerst toegevoegde indicator een jaar kan bevatten dat na de 2e indicator komt, maar door plotly toch als eerste word getoond (xaxis bevat 2016,2016,2014,2015)  
    )
  fullplot2$elementId <- NULL
  
  if(!is.na(properties)) {
    indicators <- input$CorrelationElem2
    indicators <- unique(subset(alleVariabelen$variabele, alleVariabelen$label == indicators))
    updateSelectInput(session, "testLevel",
                      choices = c("", sort(indicators)),
                      selected = NULL) 
    
    
    #code <- properties$gebiedcode
    
    data <- getDataDFForFullIndicator(indicators) %>% filter(gebiednaam == selectedArea)
    
    
    for (i in 1:length(indicators)) {
      dataIndicator <- data %>% filter(label == input$CorrelationElem2)
      fullplot2 <- fullplot2 %>% add_trace(data = dataIndicator, x = ~jaar, y = ~waarde, mode = pMode, inherit = TRUE, text = ~label, name = ~label)
    }
  }
  output$CorrelationGraph2 <- renderPlotly({fullplot2})
}




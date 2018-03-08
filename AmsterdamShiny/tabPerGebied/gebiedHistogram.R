selectedGebiedCode <- c()

clearSelectionMap <- function() {
  selectedGebiedCode <<- c()
  #output$clickedItemText <- renderText(HTML(paste('<b>', getIndicatorLabel(thema$th, input$indicator)," ... ",  '<b>')))
  output$histogram <- renderPlotly({
    p <- plot_ly(data=getLeafStructureDf(), x = ~jaar, y= ~waarde, mode = 'lines+markers', type = 'scatter')
    p$elementId <- NULL
    p
  })
}

selectedAreaSelect_clear <- function(){
  updateSelectInput(session, "selectedAreaSelect",
                    choices = c(emptyInputString),
                    selected = NULL) 
}

#als iemand een niveau aanklikt word de lijst gevuld
observeEvent(input$level, {
  if (!is.null(input$level)) {
    updateSelectInput(session, "selectedAreaSelect",
                      choices = getLabeledLevelContentVector(input$level)
                      ,selected = NULL)
  }
})

#leeg geselecteerdge gebieden als er een nieuwe indicator geselecteerd is
observeEvent(input$indicator,{
  clearSelectionMap()
  selectedAreaSelect_clear()
})


# Set the values in the "selectedAreaSelect" multi-select based on the clicked area on the map and update the list of clicked areas
observeEvent(input$map_geojson_click, {
  updateSelectInput(session, "selectedAreaSelect",
                    selected = c(input$selectedAreaSelect, input$map_geojson_click$properties$gebiedcode)) 
  
})

#update on "selectedAreaSelect"
observeEvent(input$selectedAreaSelect, {
  updateHistogram(input$selectedAreaSelect)
})

updateHistogram <- function(areaCodes){
  if (length(areaCodes) < 1) {
    clearSelectionMap()
    return()
  } 
  if(areaCodes == emptyInputString){
    clearSelectionMap()
    return()
  }
  
  dataGraphList <- list()
  index <- 0
  for (code in areaCodes) {
    index <- index + 1 
    areaDf <-  getDataDF(thema$th, input$indicator, input$level) %>%
      filter(gebiedcode == code) %>%
      select(jaar,waarde)
    tryCatch({
      
    },error=function(e){
      print(error)
    })
    
    
    dataGraphList[[code]] <- areaDf
  }
  
  if(nrow(dataGraphList) > 0 && nrow(dataGraphList[[1]]) == 0) {
    cat("dataGraphList empty")
    return()
  }
  
  plotTitle <- paste('<b>', getIndicatorLabel(thema$th, input$indicator), paste0(paste(getAreaNameByAreaCode(selectedGebiedCode),collapse=", ")),  '<b>')
  
  if (nrow(dataGraphList[[1]]) < 5) {
    pMode <- ""
    pType <- "bar"
  } else {
    pMode <- "lines+markers"
    pType <- "scatter"
  }
  
  fullplot <- plot_ly( mode = pMode, type = pType)
  fullplot$elementId <- NULL
  fullplot <- fullplot%>%
    layout(
      title = plotTitle,
      yaxis = list( title = getIndicatorLabel(thema$th,input$indicator)),
      xaxis = list( title = "jaar", type="category")  
    )
  index = 0
  for (areaDF in dataGraphList) {
    index <- index + 1
    areaCode <- names(dataGraphList)[index]
    areaName <- getAreaNameByAreaCode(areaCode)
    
    fullplot <- fullplot %>% add_trace(data = areaDF, x = ~jaar, y= ~waarde,mode=pMode, inherit = TRUE, text = areaName, name=areaName)
  }
  
  output$histogram <- renderPlotly({fullplot})
}

determineLevels <- function(indicators) {
  possibleLevels <- c()
  droppedLevels <- data.frame(level=c(),reason=c())
  for (indicator in indicators) {
    #browser()
    theme <- getThemeFromIndicator(indicator)
    if (length(possibleLevels) == 0 ) {
      possibleLevels <- getLevelVector(theme,indicator)
    } else {
      #browser()
      newLevels <- getLevelVector(theme,indicator)
      same <- intersect(newLevels, possibleLevels)
      difference <- setdiff(newLevels, possibleLevels)
      possbileLevels <- same
      for (level in difference) {
        droppedLevels <- rbind(droppedLevels, data.frame(level=level,reason=indicator))
      }
    }
  }
  return(list(possibleLevels=possibleLevels, droppedLevels=droppedLevels))
}

addToMapComparisons <- function(map, level) {
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

updateHistogramIndicators <- function(properties) {
  
  pMode <- "lines+markers"
  pType <- "scatter"
  fullplot <- plot_ly(mode = pMode, type = pType) %>%
    layout(
      xaxis = list( title = "jaar") #type="category" werkt hier niet omdat de eerst toegevoegde indicator een jaar kan bevatten dat na de 2e indicator komt, maar door plotly toch als eerste word getoond (xaxis bevat 2016,2016,2014,2015)  
    )
  fullplot$elementId <- NULL
  
  if(!is.na(properties)) {
    indicators <- input$PerIndicator
    code <- properties$gebiedcode
    
    data <- getDataDFForFullIndicator(indicators) %>% filter(gebiedcode == code)
    
    for (i in 1:length(indicators)) {
      dataIndicator <- data %>% filter(variabelenaam == indicators[i])
      fullplot <- fullplot %>% add_trace(data = dataIndicator, x = ~jaar, y = ~waarde, mode = pMode, inherit = TRUE, text = ~label, name = ~label)
    }
  }
  output$histogram1 <- renderPlotly({fullplot})
}
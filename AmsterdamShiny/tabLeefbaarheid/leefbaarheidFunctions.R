addToMapLeefbaarheid <- function(map, level){
  json <- getGeoJSON(level)
  json$style  = list(
    weight = 3,
    color = "#555555",
    opacity = 0.85,
    fillOpacity = 0.85
  )
  
  #TODO niet statisch zoeken voor 2014, maar het laatst mogelijke jaar opzoeken
  data <- getDataDFForYear("Leefbaarheid", "LHSCORE", level, 2014)
  
  mycols <- c("#730000", "#E50000", "#E1702E", "#FFFFBE", "#D3FFBE", "#93E667", "#55BE00", "#267300","#263D00")
  mypalette <- colorRampPalette(mycols)(255)
  pal <- colorNumeric(mycols, c(1,9))
  json$features <- lapply(json$features, function(feat)
  {
    value <- data %>% filter(gebiedcode == feat$properties$gebiedcode)
    feat$properties$style <- list(
      fillColor = pal(
        value$waarde
      )
    )
    feat
  })
  addGeoJSON(map, json)
}


mapLeefbaarheidDataTable <- function(properties) {
  df = data.frame(matrix(unlist(properties[1:2]), nrow=2, byrow=TRUE))
  row.names(df) <- c("Gebiedcode", "Gebiednaam")
  
  renderTable(rownames = TRUE, colnames = FALSE, bordered = FALSE, striped = TRUE, hover = FALSE, {
    df
  })
}

leefbaarheidScoreDataTable <- function(clickedItemGebiedCode, level) {
  df <- getDataDF("Leefbaarheid","LHSCORE", level) %>% filter(gebiedcode == clickedItemGebiedCode) %>% select(jaar,waarde)
  df <- df[-nrow(df),]
  #row.names(df)<- df$jaar
  #df$jaar <- NULL
  
  df$waarde <- leefbaarheidWaardeText[df$waarde]
  #browser()
  renderTable(rownames = F, colnames = FALSE, bordered = FALSE, striped = TRUE, hover = FALSE, {
    df
  })
}


leefbaarheidDimensiePlot <- function(clickedItemGebiedCode, level) {
  woningen <- (getDataDFForYear("Leefbaarheid", "LHWON", level, 2014) %>% filter(gebiedcode == clickedItemGebiedCode))$waarde
  bewoners <- (getDataDFForYear("Leefbaarheid", "LHBEW", level, 2014) %>% filter(gebiedcode == clickedItemGebiedCode))$waarde
  voorzieningen <- (getDataDFForYear("Leefbaarheid", "LHVRZ", level, 2014) %>% filter(gebiedcode == clickedItemGebiedCode))$waarde
  veiligheid <- (getDataDFForYear("Leefbaarheid", "LHVEIRE", level, 2014) %>% filter(gebiedcode == clickedItemGebiedCode))$waarde
  fysiekeomgeving <- (getDataDFForYear("Leefbaarheid", "LHFYS", level, 2014) %>% filter(gebiedcode == clickedItemGebiedCode))$waarde
  
  dimensionColors <-c("#ec0000", "#ec0000", "#ec0000", "#ec0000", "#ec0000")
  if(woningen > 0) {
    dimensionColors[1] = "#00d120"
  }
  if(bewoners > 0) {
    dimensionColors[2] = "#00d120"
  }
  if(voorzieningen > 0) {
    dimensionColors[3] = "#00d120"
  }
  if(veiligheid > 0) {
    dimensionColors[4] = "#00d120"
  }
  if(fysiekeomgeving > 0) {
    dimensionColors[5] = "#00d120"
  }
  
  renderPlotly({
    p <- plot_ly(x = c(
      woningen,
      bewoners,
      voorzieningen,
      veiligheid,
      fysiekeomgeving
            ),
            y = c("Woningen", "Bewoners", "Voorzieningen", "Veiligheid", "Fysieke Omgeving"),
            type = "bar",
            marker = list(color = dimensionColors),
            orientation = 'h') %>%
      layout(margin = list(l = 120))
    p$elementId <- NULL
    p
  })
}



leefbaarheidVergelijkingGebiedenPlot <- function(data, currentGebiedcode) {
  plotData <- data.frame("naam" = character(), "waarde" = numeric(), "label" = character(), "barcolor" = character()) 
  for (i in 1:nrow(data)) {
    # Get the leefbaarheid score of 2014 for this gebied
    
    
    newdf <- data.frame(getAreaNameByAreaCode(data[i,]$gebiedcode), data[i,]$waarde, "Gebied", "#535353")
    names(newdf) <- c("naam", "waarde", "label", "barcolor")
    
    # Give the selected item a different color
    if(!is.na(currentGebiedcode) && data[i,]$gebiedcode == currentGebiedcode) {
      newdf$label <- "Huidig"
      newdf$barcolor <- "#B3B3B3"
    }
    
    # Merge this df into the complete df
    plotData <- rbind(plotData, newdf)
  }
  
  renderPlotly({
    p <- plot_ly(plotData, x = ~naam, y = ~waarde, group = ~label, type = "bar", marker = list(color = plotData$barcolor)) %>%
      layout(margin = list(b = 150), xaxis = list(title = ""), yaxis = list(title = "Score", zeroline = FALSE))
    p$elementId <- NULL
    p
  })
}

lhGetGebiedNaam <- function(item) {
  if(!is.null(item$pc4)) {
    item$pc4
  } else if(!is.null(item$BU_NAAM)) {
    item$BU_NAAM
  } else if(!is.null(item$WK_NAAM)) {
    item$WK_NAAM
  } else if(!is.null(item$GM_NAAM)) {
    item$GM_NAAM
  } else {
    NULL
  }
}
# Render the initial map
output$map <- renderLeaflet(createLeafletMap())
proxy <- leafletProxy("map")

# Back button
observeEvent(input$butBack, {  
  updateTabsetPanel(session, "inTabset", selected = "pergebied")
})

# Filter event Indicator
observeEvent(input$indicator, {
  updateSelectInput(session, "level",
                    choices = c(placeholderInputString, getLevelVector(thema$th, input$indicator)), 
                    selected = NULL)
  
})

# Filter event Theme
observeEvent(thema$th, {
  updateSelectInput(session, "indicator",
                    choices = c(placeholderInputString, getNamedIndicatorVector(thema$th)),
                    selected = NULL)
})

# Filter event Level
observeEvent(input$level, {
  if(input$level == emptyInputString)
    return()
  
  years <- getYearVector(thema$th, input$indicator, input$level)
  if(is.null(years))
    updateSliderInput(session, "year", min = 0, max = 0, value = 0)
  else
    updateSliderInput(session, "year", min = min(years), max = max(years), value = max(years))
    
  output$metadataText <- renderText(getIndicatorMetaDataText(thema$th, input$indicator))
})

# Update the map
observe({
  clearMap(proxy)
  clearSelectionMap()
  
  if(is.null(thema$th) || input$indicator == placeholderInputString || input$level == emptyInputString || input$level == placeholderInputString || !is.numeric(input$year) || input$year == 0)
    return()

  data <- getDataDFForYear(thema$th, input$indicator, input$level, input$year)
  DataAllYears <- getDataDF(thema$th, input$indicator, input$level)
  minValue <- min(DataAllYears$waarde)
  maxValue <- max(DataAllYears$waarde)
  
  if(!is.null(data)) {
    proxy %>% clearControls()
    addToMap(proxy, input$level, data, minValue, maxValue, getIndicatorSymbol(thema$th, input$indicator))
  }
})

# Set the datable in the right column to the mouseover area on the map
observeEvent(input$map_geojson_mouseover, {
  output$mapdataTable <- renderSelectedAreaInfoTable(input$map_geojson_mouseover$properties)
})




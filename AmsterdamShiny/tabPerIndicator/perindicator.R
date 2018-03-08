#Render the comparison map
output$mapComparisons <- renderLeaflet(createLeafletMap())
mapComparisonsProxy <- leafletProxy("mapComparisons")


#update level dropdown op basis van geselecteerde indicatoren
observeEvent(input$PerIndicator, {
  levelresults <- determineLevels(input$PerIndicator)
  levels <- levelresults$possibleLevels
  updateSelectInput(session, "levelPerIndicator",
                    choices = c(placeholderInputString, levels),
                    selected = NULL) 
})

observeEvent(input$levelPerIndicator, {
  clearMap(mapComparisonsProxy)
  mapComparisonsProxy %>% clearControls()
  updateHistogramIndicators(NA)
  
  if(input$levelPerIndicator == emptyInputString || input$levelPerIndicator == placeholderInputString)
    return()
  
  addToMapComparisons(mapComparisonsProxy, input$levelPerIndicator)
})

# Set the datable in the right column to the mouseover area on the map
observeEvent(input$mapComparisons_geojson_mouseover, {
  output$comparisonMapdataTable <- renderSelectedAreaInfoTable(input$mapComparisons_geojson_mouseover$properties)
})

observeEvent(input$mapComparisons_geojson_click, {
  updateHistogramIndicators(input$mapComparisons_geojson_click$properties)
})
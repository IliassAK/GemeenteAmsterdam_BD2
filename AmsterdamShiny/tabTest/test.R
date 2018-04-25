#Render the comparison map
output$mapCorrelations <- renderLeaflet(createLeafletMap())
mapCorrelationsProxy <- leafletProxy("mapCorrelations")


#update level dropdown op basis van geselecteerde indicatoren
observeEvent(input$CorrelationElem1, {
  levelresults <- determineCorrelationLevels(input$CorrelationElem1)
  levels <- levelresults$possibleLevels
  updateSelectInput(session, "CorrelationLevel",
                    choices = c(placeholderInputString, levels),
                    selected = NULL) 
})
#Temporary
observeEvent(input$CorrelationElem2, {
  levelresults <- determineCorrelationLevels(input$CorrelationElem2)
  levels <- levelresults$possibleLevels
  updateSelectInput(session, "CorrelationLevel",
                    choices = c(placeholderInputString, levels),
                    selected = NULL) 
})

observeEvent(input$CorrelationLevel, {
  clearMap(mapCorrelationsProxy)
  mapCorrelationsProxy %>% clearControls()
  updateCorrelationGraph1(NA)
  
  if(input$CorrelationLevel == emptyInputString || input$CorrelationLevel == placeholderInputString)
    return()
  
  addToMapCorrelations(mapCorrelationsProxy, input$CorrelationLevel)
})

# Set the datable in the right column to the mouseover area on the map
observeEvent(input$mapCorrelations_geojson_mouseover, {
  output$comparisonMapdataTable <- renderSelectedAreaInfoTable(input$mapCorrelations_geojson_mouseover$properties)
})

observeEvent(input$mapCorrelations_geojson_click, {
  updateCorrelationGraph1(input$mapCorrelations_geojson_click$properties)
})


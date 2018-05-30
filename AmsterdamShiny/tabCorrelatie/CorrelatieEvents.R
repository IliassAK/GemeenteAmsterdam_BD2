#Render the comparison map
output$mapCorrelations <- renderLeaflet(createLeafletMap())
mapCorrelationsProxy <- leafletProxy("mapCorrelations")
output$comparisonMapdataTable <- renderSelectedAreaInfoTable("Noord")

#Observevent Kaart

observeEvent(input$mapCorrelations_geojson_mouseover, {
  output$comparisonMapdataTable <- renderSelectedAreaInfoTable(input$mapCorrelations_geojson_mouseover$properties)
})


# observe event Indicator Lijst
observeEvent(input$CorrelationElem1, {
  
  clearMap(mapCorrelationsProxy)
  mapCorrelationsProxy %>% clearControls()
  addToMapCorrelations(mapCorrelationsProxy)
  
  if(input$CorrelationElem1 != "" || input$correlatieGrens != "" || input$mapCorrelations_geojson_click$properties != "" || input$filterCorrelation != ""){
    
    
    
    levelresults <- selecteerIndicatoren(input$CorrelationElem1, input$correlatieGrens, input$mapCorrelations_geojson_click$properties, input$filterCorrelation)
    sort(levelresults)
    updateSelectInput(session, "CorrelationElem2",
                      choices = c("", sort(levelresults)),
                      selected = NULL) 
  }
  
})

# Observe event Slider

observeEvent(input$correlatieGrens, {
  if(input$CorrelationElem1 != "" || input$correlatieGrens != "" || input$mapCorrelations_geojson_click$properties != "" || input$filterCorrelation != ""){
    
    
    
    levelresults <- selecteerIndicatoren(input$CorrelationElem1, input$correlatieGrens, input$mapCorrelations_geojson_click$properties, input$filterCorrelation)
    sort(levelresults)
    updateSelectInput(session, "CorrelationElem2",
                      choices = c("", sort(levelresults)),
                      selected = NULL) 
  }
  
})

# Observe event Checkbox

observeEvent(input$filterCorrelation, {
  
  
  if(input$CorrelationElem1 != "" || input$correlatieGrens != "" || input$mapCorrelations_geojson_click$properties != "" || input$filterCorrelation != ""){
    
    
    
    levelresults <- selecteerIndicatoren(input$CorrelationElem1, input$correlatieGrens, input$mapCorrelations_geojson_click$properties, input$filterCorrelation)
    sort(levelresults)
    updateSelectInput(session, "CorrelationElem2",
                      choices = c("", sort(levelresults)),
                      selected = NULL) 
  }
  
})

# Observe event Graph list

observeEvent(input$CorrelationElem2, {
  
  
  
  
})
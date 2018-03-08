addToMap <- function(map, level, dataframe, minValue, maxValue, symbol) {
  if(length(dataframe) == 0){
    return()
  }
  json <- getGeoJSON(level)
  json$style  = list(
    weight = 3,
    color = "#555555",
    opacity = 0.85,
    fillOpacity = 0.85
  )
  if(symbol == "%"){
    pal <- colorNumeric("Reds", c(0, 100))
  } else {
    pal <- colorNumeric("Reds", c(minValue, maxValue))
  }
  
  json$features <- lapply(json$features, function(feat)
  {
    value <- dataframe %>% filter(gebiedcode == feat$properties$gebiedcode)
    feat$properties$style <- list(
      fillColor = pal(
        value$waarde
      )
    )
    feat
  })
  
  addGeoJSON(map, json)
  if(symbol == "%"){
    addLegend(map, pal = pal, values = c(0, 100))
  } else {
    addLegend(map, pal = pal, values = c(minValue, maxValue))
  }
}
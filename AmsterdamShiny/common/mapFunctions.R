clearMap <- function(map) {
  clearGeoJSON(map)
}

# Remove the wkt column en convert the list to a data frame (swap rows and cols)
renderSelectedAreaInfoTable <- function(properties) {
  # Postcode filter
  if(length(properties) == 11) {
    df = data.frame(matrix(unlist(properties[-c(3, 4, 6, 8, 9, 10, 11,12)]), nrow=4, byrow=TRUE))
  } else {
    df = data.frame(matrix(unlist(properties[-c(3, 5, 6, 8, 9, 10,11, 12, 13)]), nrow=4, byrow=TRUE))
  }
  
  row.names(df) <- c("Gebiedcode", "Niveau", "Stadsdeel", "Gebiednaam")
  renderTable(rownames = TRUE, colnames = FALSE, bordered = FALSE, striped = TRUE, hover = FALSE, df)
}

createLeafletMap <- function() {
  leaflet() %>%
    addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', group = "Amsterdam", options = providerTileOptions(opacity = 1)) %>%
    addProviderTiles(providers$CartoDB.DarkMatter, group = "Dark") %>%
    addProviderTiles(providers$CartoDB.Positron, group = "Light") %>%
    addTiles('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', group = "No map", options = providerTileOptions(opacity = 0)) %>%
    setView(4.895168, 52.370216, 11) %>%
    addLayersControl(baseGroups = c("Amsterdam", "Light", "Dark", "No map"), options = layersControlOptions(position = "bottomright"))
}
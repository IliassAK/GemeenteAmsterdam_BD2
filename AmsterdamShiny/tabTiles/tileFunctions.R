setBackButton <- function(themaname, icon) {
  thema$th <- themaname 
  output$textBackButton <<- renderText(themaname)
  output$iconBackButton <<- renderUI(span(class=icon, style="font-size:9em;"))
  updateTabsetPanel(session, "inTabset", selected = "mappanel")
}
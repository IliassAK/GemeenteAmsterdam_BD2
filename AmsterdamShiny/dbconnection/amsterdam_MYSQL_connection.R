library(DBI)
library(RMySQL)
library(rJava)
library(RJDBC)

# ----------------
# Database functions
# ----------------
connectDb <- function() {
  conn <- dbConnect(
    drv = RMySQL::MySQL(),
    dbname = "zdoornw001",
    host = "localhost",
    username = "root",
    password = "P@ssw0rd")
  return(conn)
}

disconnectDb <- function(conn) {
  dbDisconnect(conn)
}

getGebieden <- function(conn, q = "SELECT * FROM gebieden"){
  runQuery <- dbGetQuery(conn, q)
  return(runQuery)
}

getJSONGebieden <- function(conn, q = "SELECT * FROM gebiedenjson"){
  runQuery <- dbGetQuery(conn, q)
  return(runQuery)
}

getLeefbaarheidJSONGebieden <- function(conn, q = "SELECT * FROM gebiedenleefbaarheid"){
  runQuery <- dbGetQuery(conn, q)
  return(runQuery)
}

getMetadata <- function(conn, q = "SELECT * FROM metadata"){
  runQuery <- dbGetQuery(conn, q)
  return(runQuery)
}

getKerncijfers <- function(conn, q = "SELECT * FROM kerncijfer"){
  runQuery <- dbGetQuery(conn, q)
  return(runQuery)
}

vectorToMYSQLArray <- function(x){
  returnChar <- "("
  k <- length(x)
  i <- 1
  for (variable in x) {
    if (class(variable) == "character") {
      returnChar <- paste0(returnChar, "\"",variable,"\"")
    } else {
      returnChar <- paste0(returnChar, variable)
    }
    if (i < k) {
      returnChar <- paste0(returnChar, ", ")
    }
    i <- i+1
  }
  returnChar <- paste0(returnChar, ")")
  return(returnChar)
}

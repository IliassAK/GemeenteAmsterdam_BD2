library(DBI)
library(RMySQL)
library(rJava)
library(RJDBC)

# ----------------
# Database functions
# ----------------
connectDb <- function() {
  drv <- JDBC("com.mysql.jdbc.Driver", "C:/Users/Illia/Desktop/School/SNE Jaar 2/Big Data/Drivers/mysql-connector-java-5.1.45-bin.jar")
  conn <- dbConnect(drv, "jdbc:mysql://localhost/zdoornw001", "root", "P@ssw0rd", useSSL=FALSE)
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

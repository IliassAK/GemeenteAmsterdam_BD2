saveLocalCache <- function(offlineFolder = "./offline"){
  
  if (!file.exists(offlineFolder)) {
    dir.create(offlineFolder) 
  }
  
  saveRDS(dataTree, paste0(offlineFolder,"/dataTree"))
  saveRDS(gebieden, paste0(offlineFolder,"/gebieden"))
  saveRDS(gebiedenTree, paste0(offlineFolder,"/gebiedenTree"))
  saveRDS(metadataTree, paste0(offlineFolder,"/metadataTree"))
  saveRDS(Sys.time() ,paste0(offlineFolder,"/timestamp"))
}

loadLocalCache <- function(offlineFolder = "./offline"){
  if (!file.exists(offlineFolder)) {
      return(FALSE)  
  }
  
  result <- tryCatch({
    dataTree <<- readRDS(paste0(offlineFolder,"/dataTree"))
    gebieden <<- readRDS(paste0(offlineFolder,"/gebieden"))
    gebiedenTree <<- readRDS(paste0(offlineFolder,"/gebiedenTree"))
    metadataTree <<- readRDS(paste0(offlineFolder,"/metadataTree"))
    return(TRUE)
  },error=function(e){
    print("Error while loading local cache:")
    print(e)
    return(FALSE)
  })
  return(result)
}

isCacheValid <- function(offlineFolder = "./offline" ,cacheTimeOutHours = 24){
  
  #lees timestamp in van lokale cache
  cacheTime <- tryCatch({
    readRDS(paste0(offlineFolder,"/timestamp"))
  }, error = function(e){
    print("Error while loading timestamp from local cache:")
    print(e)
    return(FALSE)
  })
  
  #controleer of we de timestamp konden lezen
  if (cacheTime == FALSE) {
    return(FALSE)
  }
  #bereken timeout
  timeout <- cacheTime + cacheTimeOutHours * 60 * 60

  if(Sys.time() > timeout){
    FALSE
  } else {
    TRUE
  }
}
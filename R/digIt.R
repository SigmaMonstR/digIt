#######################################################
## DigIt - Datasets for Data Science + Public Policy ##
## Version 0.1 - Nov 2017                            ##
## Wrappers to access new example datasets           ##
#######################################################

# Libraries required for use
needed <- c("DT","rio","rgdal", "raster")
index <- !(needed %in% rownames(installed.packages()))
if(sum(index) > 0){install.packages(needed[index])} 
invisible(lapply(needed, require, character.only = TRUE))

# Load in base cache file
digit.cache <- import("https://s3.amazonaws.com/dspp/digit_index.csv")

# Function: Get list of data sets
digList <- function(detail = FALSE){
  # Returns list of available datasets 
  # 
  # Args: 
  #   detail = determines if description will be included
  #            (default = FALSE)
  #
  # Returns:
  #   List of example datasets
  #
  
  if(detail == TRUE){
    datatable(digit.cache[,c(1,4)])
  } else {
    print(digit.cache[,1])
  }
  
}


#Function: Retrieve data
digIt <- function(dataset, download = FALSE, readme = FALSE){
  # Retrieves example data, loads either to memory or downloads locally
  # 
  # Args: 
  #   dataset = string value containing name of dataset
  #   download = downloads a .zip file of data and readme into working directory,
  #              otherwise, loads data into memory. (default = FALSE)
  #   readme = prints readme (default = FALSE)
  #
  # Returns:
  #   dataset as a local download (download = TRUE) or in R environment (download = FALSE)
  #
  #Libraries
  require(raster)
  require(rgdal)
  require(rio)
  
  #Look up file
  base.path <- "https://s3.amazonaws.com/dspp/"
  index.pos <- grep(dataset, digit.cache$dataset)[1]*1
  
  #Construct URL
  if(length(index.pos) == 0){
    
    warning("Dataset not found. Look up datasets using digList()")
    
  } else {
    download.zip <- paste0(base.path, digit.cache$zip.package[index.pos])
    download.data <- paste0(base.path, digit.cache$file.name[index.pos])
    download.readme <- paste0(base.path, digit.cache$readme[index.pos])
    load.function <- digit.cache$func[index.pos]
  }
  
  
  #What to do with 
  if(download == TRUE && length(index.pos) > 0){ 
    download.file(download.zip, paste0(getwd(),"/compressed.zip"))
    message(paste0(dataset, " has been downloaded to ", paste0(getwd(),"/compressed.zip")))
  } else if(download == FALSE && length(index.pos) > 0)  {
    
    if(load.function == "import"){
      #TABULAR DATA
      #Load the data
      df <- rio::import(download.data)
      message(paste0(dataset, " has been loaded into memory."))
      message(paste0("Dimensions: n = ",nrow(df),", k = ", ncol(df)))
      
      #Get the readme file
      if(readme == TRUE){
        temp.file <- tempfile()
        download.file(download.readme, temp.file, quiet = TRUE)
        file.show(temp.file)
      }
      
      #Return result
      return(df)
    } else  if(load.function == "readLines"){
      #TEXTUAL DATA
      #Load the data
      df <- readLines(download.data)
      message(paste0(dataset, " has been loaded into memory."))
      message(paste0("Dimensions: # lines = ",length(df)))
      
      #Get the readme file
      if(readme == TRUE){
        temp.file <- tempfile()
        download.file(download.readme, temp.file, quiet = TRUE)
        file.show(temp.file)
      }
      
      #Return result
      return(df)
    } else if(load.function == "shp"  && length(index.pos) > 0){
      
      #SHAPE FILE
      
      #Get the readme file
      if(readme == TRUE){
        temp.file <- tempfile()
        download.file(download.readme, temp.file, quiet = TRUE)
        file.show(temp.file)
      }
      
      #load data
      temp.file <- tempfile()
      download.file(download.zip, temp.file, quiet = TRUE)
      temp.dir <- tempdir()
      unzip(temp.file, exdir = temp.dir)
      shape <- rgdal::readOGR(dsn = temp.dir, 
                       layer = gsub(".zip","",digit.cache$zip.package[index.pos]))
      message(paste0(dataset, " shapefile has been loaded into memory."))
      return(shape)
    } else if(load.function == "raster"  && length(index.pos) > 0){
      library(raster)
      temp.file <- tempfile()
      download.file(download.data, temp.file, quiet = TRUE)
      return(raster::brick(temp.file))
    }
    
  } 
}


setup <- function(){
        library(plyr)
        library(ggplot2)
        library(reshape2)
        # TO-DO:IMPROVEMENT: check if libraries already loaded
}

load_data <- function(){
        file_name <- "vehicles.csv"
        file_name <- get_file_path(file_name)
        return(read.csv(file_name, stringsAsFactors = F))       
}

load_labels <- function(){
        file_name <- "variables.txt"
        file_name <- get_file_path(file_name)
        result <- NULL
        
        #temp <- strsplit(readLines(file_name), " - ")
        #for(i in 1:length(temp)){
        #        result <- rbind(result, temp[[i]])
        #}                 
        #return(result)
        #same as -> more coincise way of doing it
        return(do.call(rbind, strsplit(readLines(file_name), " - ")))
        
}

## Supporting function return the file path 
## Assumption: the file is in the working directory
get_file_path <- function(fileName){
        file_path <- file.path(fileName)
        if(!file.exists(file_path)){
                stop(paste("The data file'", file_path, "'does not exist in the working directory..."))
        }
        return(file_path)
}

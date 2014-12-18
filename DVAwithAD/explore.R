explore_data <- function(vehicle_data){
        message("Exploring the data ...")
        
        message("(Unique) Years of Observations")
        print(unique(data$year))
        message(paste("First Year: "), min(data$year))
        message(paste("Last Year: "), max(data$year))
        
        #What type of fuels are used as fuel types for automobiles
        message("Fuel Types & usage (based on observations):")
        print(table(vehicle_data$fuelType1))
        
        #Check type of transmission (trany)
        message("Transmission Types:")
        message("Does all observations have a value?")
        print(paste("NA?", sum(is.na(vehicle_data$trany))))
        print(paste("NULL?", sum(is.null(vehicle_data$trany))))
        print(paste("'' (empty)?", sum(vehicle_data$trany == "")))
        
        #replace empty values with NA
        message("Replace empty values with NA...")
        vehicle_data$trany[vehicle_data$trany == ""] <- NA
        print(paste("NA?", sum(is.na(vehicle_data$trany))))
        print(paste("'' (empty)?", sum(vehicle_data$trany == "", na.rm = T)))
        
        #Process transmission info in order to extract if manual or automatic
        #add to a new entry in the data frame
        message("Type of transmission in observations")
        print(unique(vehicle_data$trany))
        #Adding metainfo if transmission is Manual or Automatic
        vehicle_data$trany2 <- ifelse(substr(vehicle_data$trany, 1, 4) == "Auto", "Auto", "Manual")
        message("Type of transmission (simplified) added in observations")
        print(unique(vehicle_data$trany2))
        
        trans_factors <- as.factor(vehicle_data$trany2)
        message("Total per Type of transmission")
        print(table(trans_factors))
        
        #Look at the number of automobile models with/without a supercharger per year
        message("Number of automobile models with/without a supercharger per year")
        print(with(vehicle_data, table(sCharger, year)))
        
}
how_mpg_change_over_time_on_average_ALL <- function(data){
        # Aggregate observations by year
        # and then for each group calculate mean highway, city, combine fuel efficiency
        # Split-Apply-Combine Pattern Applied (Using plyr.ddply)        
        mpgByYear <- ddply(data, ~year, summarise, avgMPG = mean(comb08), avgHghy = mean(highway08), avgCity = mean(city08))
        
        ggplot(mpgByYear, aes(year, avgMPG)) + 
                geom_point() + 
                geom_smooth() + 
                xlab("Year") + 
                ylab("Average MPG") + 
                ggtitle("All cars")
        
        # Looking at fuelType1 we can see that not only Gasoline is included in teh data
        #message("Report no of observation per fuelType")
        #print(table(data$fuelType1))
        #Generated graph is misleading because it is considering not only Gasoline
}

how_mpg_change_over_time_on_average_Gasoline <- function(data){
        # Aggregate observations by year
        # and then for each group calculate mean highway, city, combine fuel efficiency
        # Split-Apply-Combine Pattern Applied (Using plyr.ddply)        
        
        # Get the info connected only to GASOLINE type information
        gasCars <- subset(data, fuelType1 %in% c("Regular Gasoline", "Premium Gasoline", "Midgrade Gasoline") & fuelType2 == "" & atvType != "Hybrid")
        mpgByYear_gasoline <- ddply(gasCars, ~year, summarise, avgMPG = mean(comb08))
        
        # Visualize gasoline data
        ggplot(mpgByYear_gasoline, aes(year, avgMPG)) + 
                geom_point() + 
                geom_smooth() + 
                xlab("Year") + 
                ylab("Average MPG") + 
                ggtitle("Gasoline cars")
}

displacement_vs_mpg_Gasoline <- function(data){
        gasCars <- subset(data, fuelType1 %in% c("Regular Gasoline", "Premium Gasoline", "Midgrade Gasoline") & fuelType2 == "" & atvType != "Hybrid")
        gasCars$displ <- as.numeric(gasCars$displ)
        
        ggplot(gasCars, aes(displ, comb08)) +
                geom_point() +
                geom_smooth()
}

production_small_cars_by_year <- function(data){
        gasCars <- subset(data, fuelType1 %in% c("Regular Gasoline", "Premium Gasoline", "Midgrade Gasoline") & fuelType2 == "" & atvType != "Hybrid")
        gasCars$displ <- as.numeric(gasCars$displ)
        
        avgCarSize <- ddply(gasCars, ~year, summarise, avgDispl = mean(displ))
        
        ggplot(avgCarSize, aes(year, avgDispl)) +
                geom_point() +
                geom_smooth() +
                xlab("Year") +
                ylab("Average Engine Displacement(1)")
}



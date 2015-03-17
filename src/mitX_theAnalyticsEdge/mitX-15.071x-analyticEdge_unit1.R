####################################################
##Unit 1: Working with Data - An introduction to R##
####################################################

###############
### Part 01 ###
###############

## Use the "WHO.csv" file - located in this same directory
## data comes from the Global Health Observatory Data Repository
## http://apps.who.int/gho/data/node.main

#Remember to change the working directory in R environment
#to teh same place where the dataset file is located

#1. Loading external data file
who <- read.csv("WHO.csv")

# How to look into our data?
# structure function
str(who) #-> 194 obs of 13 variables with some extra details (Factor variables with no of levels)

#summary function -> some statistical information on the data
#reported info depends on the type of data
#Overview around missing data (NAs) is provided for each of teh variables & obs.
summary(who)

#Subsetting the data from the original dataset (dataframe)
#It is possible to create a new datafarme starting from the original dataset
#create a new dataframe with the Europe countries only
who_europe <- subset(who, Region == "Europe")
str(who_europe)

#Save this new dataframe to a csv file
write.csv(who_europe, "WHO_europe.csv") #creates a csv file in current working directory

##Which variable are available in memory of the R environment
ls()
##to remove a specific variable - e.g. who_europe
rm(who_europe) #who_europe variable disappeared from the enironment (memory)

######################
### End of Part 01 ###
######################

###############
### Part 02 ###
###############
#Some basic data analysis
#Access a specific variable withion a dataframe -> $
who$Under15 #Access variable Under15 in teh who dataframe -> return a vector

#we can compute some statistic
mean(who$Under15)
sd(who$Under15)

#or use the summary function on teh variable
summary(who$Under15) 
#1st quartile is the value for which 25% of the data is less than that value, 
#3rd quartile is the value for which 75% of the data is less than that value.

#which countries have the minimum vaule of population Under15?
which.min(who$Under15) #returns the row number of the obs.
who[which.min(who$Under15),] #show the observation for the country with min Under15 
who$Country[which.min(who$Under15)] #show just the country having the min Under15

#which countries have the max vaule of population Under15?
which.max(who$Under15) #returns the row number of the obs.
who[which.max(who$Under15),] #show the observation for the country with max Under15 
who$Country[which.max(who$Under15)] #show just the country having the max Under15

#Create a scatterplot for GNI versus fertility rate
plot(who$GNI, who$FertilityRate)
## Each point in the scatter plot is a country.
## We can see that most countries here either
## have a low GNI or a high GNI but a low fertility rate.
## However, there are a few countries
## for which both the GNI and the fertility rate are high.

# Investigate -> dentify the countries with a GNI greater than 10,000, 
# and a fertility rate greater than 2.5.
outliers <- subset(who, GNI > 10000 & FertilityRate > 2.5)
nrow(outliers) #no of rows in our subset 7 countries

##A quick way to visualize some of the variables in a dataset is to pass
##a vector containing the names of the variables (present in the dataframe)
outliers[c("Country", "GNI", "FertilityRate")] # see the countries for which the filtering condition is True

######################
### End of Part 02 ###
######################

###############
### Part 03 ###
###############
#Other plots in R

# create a histogram of CellularSubscribers
hist(who$CellularSubscribers) #distribution of teh variable
## we can see that the most frequent value of CellularSubscribers is around 100.

# create a boxplot for LifeExpectancy sorted (categorized) by Region
boxplot(who$LifeExpectancy ~ who$Region)
###A box plot is useful for understanding the statistical range of a variable.
###This box plot shows how life expectancy in countries
###varies according to the region the country is in.
###The box for each region shows the range
###between the first and third quartiles
###with the middle line marking the median value.
###The dashed lines at the top and bottom of the box,
###often called whiskers, show the range
###from the minimum to maximum values,
##excluding any outliers, which are plotted as circles.

###Outliers are defined by first computing
###the difference between the first and third quartiles, or the height of the box.
###This number is called the inter-quartile range.
###Any point that is greater than the third quartile
###plus the inter-quartile range, or any point that
###is less than the first quartile minus the inter-quartile range
###is considered an outlier.
###Europe has the highest life expectancies

###Add some annotation to teh plot while craeting the plot itself
boxplot(who$LifeExpectancy ~ who$Region, xlab = "", ylab="Life Expectancy", main="Life Expectancy of Countries by Region")

##Lets look at some summary table
table(who$Region) #counts the number of obs. in each category (region)

##Some nice ionformation about numerical variables
##can be obtained using the tapply function
## tapply X, INDEX, FUN, ...
## X -> an atomic object, typically a vector
## INDEX -> list of one or more factors
## Function to be applied
tapply(who$Over60, who$Region, mean) #split the obs by Region and then computes the mean for Over60 variable.
##This result tells us that the average percentage
##of the population over 60 in African countries is about 5%,
##while the average percentage of the population over 60
##in European countries is about 20%.

tapply(who$LiteracyRate, who$Region, min)
#Here the initial results is NAs (sth strange)
##This is because we have some missing values in our data for literacy rate.
##a common thing to do is to remove the NAs when performing the calculation
tapply(who$LiteracyRate, who$Region, min, na.rm = TRUE) #Remove NAs from computation

###By using some basic functions in R, plots, and summary tables
###we were able to get a better understanding of our data.
###You'll see more of this in the recitation and homework
###assignment.

######################
### End of Part 03 ###
######################

###############
### Part 04 ###
###############

#Saving with script files
#Scrip file - sut an paste the command types in the console window 
##CTRL-R to run highligthed lines in R script

##Comment can be added using #

######################
### End of Part 04 ###
######################
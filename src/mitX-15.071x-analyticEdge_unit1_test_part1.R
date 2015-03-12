# AN ANALYTICAL DETECTIVE
# 
# Crime is an international concern, but it is documented and handled in 
# very different ways in different countries. In the United States, violent 
# crimes and property crimes are recorded by the Federal Bureau of Investigation
# (FBI).  Additionally, each city documents crime, and some cities release
# data regarding crime rates. The city of Chicago, Illinois releases crime data
# from 2001 onward online.
# 
# Chicago is the third most populous city in the United States, with a population 
# of over 2.7 million people. The city of Chicago is shown in the map below, with
# the state of Illinois highlighted in red.

# There are two main types of crimes: violent crimes, and property crimes. 
# In this problem, we'll focus on one specific type of property crime, 
# called "motor vehicle theft" (sometimes referred to as grand theft auto).
# This is the act of stealing, or attempting to steal, a car. 
# In this problem, we'll use some basic data analysis in R to understand 
# the motor vehicle thefts in Chicago.

#Datasource https://courses.edx.org/c4x/MITx/15.071x_2/asset/mvtWeek1.csv
#mvtWeek1.csv

# descriptions of the variables:
# ID: a unique identifier for each observation
# Date: the date the crime occurred
# LocationDescription: the location where the crime occurred
# Arrest: whether or not an arrest was made for the crime (TRUE if an arrest was made, and FALSE if an arrest was not made)
# Domestic: whether or not the crime was a domestic crime, meaning that it was committed against a family member (TRUE if it was domestic, and FALSE if it was not domestic)
# Beat: the area, or "beat" in which the crime occurred. This is the smallest regional division defined by the Chicago police department.
# District: the police district in which the crime occured. Each district is composed of many beats, and are defined by the Chicago Police Department.
# CommunityArea: the community area in which the crime occurred. Since the 1920s, Chicago has been divided into what are called "community areas", of which there are now 77. The community areas were devised in an attempt to create socially homogeneous regions.
# Year: the year in which the crime occurred.
# Latitude: the latitude of the location at which the crime occurred.
# Longitude: the longitude of the location at which the crime occurred.

Sys.setlocale("LC_ALL", "C")

#Load the dataset into R as a dataframe
mvt <- read.csv("mvtWeek1.csv")

#HOW MANY OBS & Variables ARE IN THIS DATASET?
str(mvt) # 191641 ob. of 11 variables

#Using the "max" function, what is the maximum value of the variable "ID"?
max(mvt$ID) # [1] 9181151

#What is the minimum value of the variable "Beat"?
min(mvt$Beat) #[1] 111

#How many observations have value TRUE in the Arrest variable (this is the number of crimes for which an arrest was made)?
sum(mvt$Arrest == TRUE) #[1] 15536

#How many observations have a LocationDescription value of ALLEY?
sum(mvt$LocationDescription == "ALLEY") #[1] 2308

# Now, let's convert these characters into a Date object in R. 
# In your R console, type
# 
# DateConvert = as.Date(strptime(mvt$Date, "%m/%d/%y %H:%M"))
# 
# This converts the variable "Date" into a Date object in R. 
# Take a look at the variable DateConvert using the summary function.

# What is the month and year of the median date in our dataset? 
# Enter your answer as "Month Year", without the quotes. 
# (Ex: if the answer was 2008-03-28, you would give the answer "March 2008", without the quotes.)

dateConvert <- as.Date(strptime(mvt$Date, "%m/%d/%y %H:%M"))
summary(dateConvert)
#Median "May 2006"

# Now, let's extract the month and the day of the week, and add these variables to our data frame mvt. 
# We can do this with two simple functions. Type the following commands in R:
# 
# mvt$Month = months(DateConvert)
# mvt$Weekday = weekdays(DateConvert)
# 
# This creates two new variables in our data frame, Month and Weekday, and sets them equal to the month
# and weekday values that we can extract from the Date object. Lastly, replace the old Date variable 
# with DateConvert by typing:
# 
# mvt$Date = DateConvert

mvt$Month <- months(dateConvert)
mvt$Weekday <- weekdays(dateConvert)
mvt$Date <- dateConvert

# Using the table command, answer the following questions. 
# In which month did the fewest motor vehicle thefts occur?
x <- table(mvt$Month)
x[which.min(x)] # February 13511

#On which weekday did the most motor vehicle thefts occur?
x <- table(mvt$Weekday)
x[which.max(x)] # Friday 29284

# Each observation in the dataset represents a motor vehicle theft, and the Arrest variable 
# indicates whether an arrest was later made for this theft. 
# Which month has the largest number of motor vehicle thefts for which an arrest was made?
table(mvt$Arrest, mvt$Month) # January

# First, let's make a histogram of the variable Date. We'll add an extra argument, to specify the number of bars we want in our histogram. In your R console, type
# 
hist(mvt$Date, breaks=100)
# 
# Looking at the histogram, answer the following questions.
# In general, does it look like crime increases or decreases from 2002 - 2012?
# Decrease

# In general, does it look like crime increases or decreases from 2005 - 2008?
# Decrease

# In general, does it look like crime increases or decreases from 2009 - 2011?
# Increase


# Now, let's see how arrests have changed over time. Create a boxplot of the variable "Date",
#sorted by the variable "Arrest".

#In a boxplot, the bold horizontal line is the median value of the data, 
#the box shows the range of values between the first quartile and third quartile, 
#and the whiskers (the dotted lines extending outside the box) show the minimum 
#and maximum values, excluding any outliers (which are plotted as circles). 
#Outliers are defined by first computing the difference between the first and 
#third quartile values, or the height of the box. This number is called the 
#Inter-Quartile Range (IQR). 
#Any point that is greater than the third quartile plus the IQR or less than 
#the first quartile minus the IQR is considered an outlier.

# Does it look like there were more crimes for which arrests were made in 
# the first half of the time period or the second half of the time period? 
# (Note that the time period is from 2001 to 2012, 
# so the middle of the time period is the beginning of 2007.)

boxplot(mvt$Date ~ mvt$Arrest) # First half of the time period

# Let's investigate this further. Use the table function for the next few questions.
# For what proportion of motor vehicle thefts in 2001 was an arrest made?
# 
# Note: in this question and many others in the course, we are asking for an answer as a 
# proportion. Therefore, your answer should take a value between 0 and 1.

table(mvt$Year, mvt$Arrest)
table(mvt$Year, mvt$Arrest)[1,2]/ sum(table(mvt$Year, mvt$Arrest)[1,]) # 2001 -> 0.1041173
table(mvt$Year, mvt$Arrest)[7,2]/ sum(table(mvt$Year, mvt$Arrest)[7,]) # 2007 -> 0.08487395
table(mvt$Year, mvt$Arrest)[12,2]/ sum(table(mvt$Year, mvt$Arrest)[12,]) # 2012 -> 0.03902924


# POPULAR LOCATIONS
# Analyzing this data could be useful to the Chicago Police Department when deciding 
# where to allocate resources. If they want to increase the number of arrests that are 
# made for motor vehicle thefts, where should they focus their efforts?
# 
# We want to find the top five locations where motor vehicle thefts occur. 
# If you create a table of the LocationDescription variable, it is unfortunately very
# hard to read since there are 78 different locations in the data set.

# By using the sort function, we can view this same table, but sorted by
# the number of observations in each category. In your R console, type:        

sort(table(mvt$LocationDescription), decreasing=TRUE)[1:6]

# Which locations are the top five locations for motor vehicle thefts, 
# excluding the "Other" category?

# STREET 
# 156564 
# PARKING LOT/GARAGE(NON.RESID.) 
# 14852 
# OTHER 
# 4573 
# ALLEY 
# 2308 
# GAS STATION 
# 2111 
# DRIVEWAY - RESIDENTIAL 
# 1675 


# Create a subset of your data, only taking observations for which the theft happened
# in one of these five locations, and call this new data set "Top5". 
# To do this, you can use the | (OR) symbol. In lecture, we used the & (AND) symbol 
# to use two criteria to make a subset of the data. 
# To only take observations that have a certain value in one variable or the other, 
# the | character can be used in place of the & symbol. This is also called a logical
# "or" operation.
#  
# How many observations are in Top5?
x <- sort(table(mvt$LocationDescription), decreasing = TRUE)
top5_location <- names(x)[1:6] #6 inclusing OTHER
top5_location <- c(top5_location[1:2], top5_location[4:6]) #Removing OTHER
top5 <- subset(mvt, LocationDescription == top5_location[1] |
                        LocationDescription == top5_location[2] |
                        LocationDescription == top5_location[3] |
                        LocationDescription == top5_location[4] |
                        LocationDescription == top5_location[5])
nrow(top5) # -> no of observation in the selected subset

# R will remember the other categories of the LocationDescription variable 
# from the original dataset, so running 

table(top5$LocationDescription) 

# will have a lot of unnecessary output. To make our tables a bit nicer 
# to read, we can refresh this factor variable. In your R console, type:

top5$LocationDescription = factor(top5$LocationDescription)

# If you run the str function again on top5, you should see that 
# LocationDescription now only has 5 values, as we expect.
# 
# Use the top5 data frame to answer the remaining questions.
# 
# One of the locations has a much higher arrest rate than 
# the other locations. 
# Which is it? 
# Please enter the text in exactly the same way as how it looks
# in the answer options for Problem 4.1.
x <- table(top5$LocationDescription, top5$Arrest)
ar_alley <- x[1,2] / (x[1,1] + x[1,2]); print(ar_alley)
ar_driveway <- x[2,2] / (x[2,1] + x[2,2]); print(ar_driveway)
ar_gs <- x[3,2] / (x[3,1] + x[3,2]); print(ar_gs)
ar_park <- x[4,2] / (x[4,1] + x[4,2]); print(ar_park)
ar_street <- x[5,2] / (x[5,1] + x[5,2]); print(ar_street)

#Answer -> Gas Station

#On which day of the week do the most motor vehicle thefts 
# at gas stations happen?
gs_data <- subset(mvt, LocationDescription == "GAS STATION")
names(which.max(table(gs_data$Weekday))) # Saturday

# On which day of the week do the fewest motor vehicle thefts 
# in residential driveways happen?
gs_driveway <- subset(mvt, LocationDescription == "DRIVEWAY - RESIDENTIAL")
names(which.min(table(gs_driveway$Weekday))) # Saturday

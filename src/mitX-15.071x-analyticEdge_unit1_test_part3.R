Sys.setlocale("LC_ALL", "C") ##Set the Locale for the current session

# DEMOGRAPHICS AND EMPLOYMENT IN THE UNITED STATES
# 
# In the wake of the Great Recession of 2009, there has been a good deal 
# of focus on employment statistics, one of the most important metrics 
# policymakers use to gauge the overall strength of the economy. 
# In the United States, the government measures unemployment using the 
# Current Population Survey (CPS), which collects demographic and 
# employment information from a wide range of Americans each month. 

# In this exercise, we will employ the topics reviewed in the lectures 
# as well as a few new techniques using the September 2013 version 
# of this rich, nationally representative dataset (available online).
#
# The observations in the dataset represent people surveyed in the 
# September 2013 CPS who actually completed a survey. 
# While the full dataset has 385 variables, in this exercise we will use
# a more compact version of the dataset, CPSData.csv, which has the following
#variables:

#PeopleInHousehold: The number of people in the interviewee's household.
# Region: The census region where the interviewee lives.
# State: The state where the interviewee lives.
# MetroAreaCode: A code that identifies the metropolitan area in which the interviewee lives (missing if the interviewee does not live in a metropolitan area). The mapping from codes to names of metropolitan areas is provided in the file MetroAreaCodes.csv.
# Age: The age, in years, of the interviewee. 80 represents people aged 80-84, and 85 represents people aged 85 and higher.
# Married: The marriage status of the interviewee.
# Sex: The sex of the interviewee.
# Education: The maximum level of education obtained by the interviewee.
# Race: The race of the interviewee.
# Hispanic: Whether the interviewee is of Hispanic ethnicity.
# CountryOfBirthCode: A code identifying the country of birth of the interviewee. The mapping from codes to names of countries is provided in the file CountryCodes.csv.
# Citizenship: The United States citizenship status of the interviewee.
# EmploymentStatus: The status of employment of the interviewee.
# Industry: The industry of employment of the interviewee (only available if they are employed).


#Load the dataset from CPSData.csv into a data frame called CPS, 
#and view the dataset with the summary() and str() commands.
CPS <- read.csv("CPSData.csv")
#How many interviewees are in the dataset?
str(CPS)
nrow(CPS)
#131302 obs.

#Among the interviewees with a value reported for the Industry variable, 
#what is the most common industry of employment? 
#Please enter the name exactly how you see it.
table(CPS$Industry)
which.max(table(CPS$Industry))
# -> Educational and health services

#Recall from the homework assignment "The Analytical Detective" that 
#you can call the sort() function on the output of the table() function 
#to obtain a sorted breakdown of a variable. 
#For instance, sort(table(CPS$Region)) sorts the regions by the number 
#of interviewees from that region.

#Which state has the fewest interviewees?
sort(table(CPS$State))[1:5] #New Mexico
sort(table(CPS$State)) #California

#What proportion of interviewees are citizens of the United States?
sum(table(CPS$Citizenship)[1:2])/ sum(table(CPS$Citizenship))
#0.9421943

#The CPS differentiates between race (with possible values 
#American Indian, Asian, Black, Pacific Islander, White, or Multiracial) 
#and ethnicity. A number of interviewees are of Hispanic ethnicity, 
#as captured by the Hispanic variable. For which races are there 
#at least 250 interviewees in the CPS dataset of Hispanic ethnicity? 
#(Select all that apply.)

#To check the possible race value
unique(CPS$Race)
#[1] White            Black            Pacific Islander
#[4] Multiracial      American Indian  Asian    
nrow(subset(CPS, Race == "White" &  Hispanic == 1)) #16731
nrow(subset(CPS, Race == "Black" &  Hispanic == 1)) #621
nrow(subset(CPS, Race == "Pacific Islander" &  Hispanic == 1)) #77
nrow(subset(CPS, Race == "Multiracial" &  Hispanic == 1)) #448
nrow(subset(CPS, Race == "American Indian" &  Hispanic == 1)) #304
nrow(subset(CPS, Race == "Asian" &  Hispanic == 1)) #113


#EVALUATING MISSING VALUES
#Which variables have at least one interviewee with a missing (NA) value? 
#(Select all that apply.)
summary(CPS)
#look at the number of NAs in the summary for each variable


#Often when evaluating a new dataset, we try to identify if there is a 
#pattern in the missing values in the dataset. We will try to determine
#if there is a pattern in the missing values of the Married variable. 
#The function is.na(CPS$Married) returns a vector of TRUE/FALSE values 
#for whether the Married variable is missing. 
#We can see the breakdown of whether Married is missing based on the 
#reported value of the Region variable with the function 
table(CPS$Region, is.na(CPS$Married))
table(CPS$Sex, is.na(CPS$Married))
table(CPS$Age, is.na(CPS$Married))
table(CPS$Citizenship, is.na(CPS$Married))
#Which is the most accurate:
#The Married variable being missing is related to the Age value for the interviewee. 


#As mentioned in the variable descriptions, MetroAreaCode is missing if an 
#interviewee does not live in a metropolitan area. Using the same technique as 
#in the previous question, answer the following questions about people who live
#in non-metropolitan areas.

#How many states had all interviewees living in a non-metropolitan area 
#(aka they have a missing MetroAreaCode value)? 
#For this question, treat the District of Columbia as a state (even though it is
#not technically a state).
x <- table(CPS$State, is.na(CPS$MetroAreaCode))
which(x[,1] == 0) #Check which states have all obs. with MetroAreaCode = NA #2
which(x[,2] == 0) #Check which states have all obs. with MetroAreaCode != NA #3

#Which region of the United States has the largest proportion of interviewees 
#living in a non-metropolitan area?

y <- table(CPS$Region, is.na(CPS$MetroAreaCode))
y[1,2]/ sum(y[1,]) #Midwest
y[2,2]/ sum(y[2,]) #Northeast
y[3,2]/ sum(y[3,]) #South
y[4,2]/ sum(y[4,]) #West
#Midwest


#While we were able to use the table() command to compute the proportion of 
#interviewees from each region not living in a metropolitan area, 
#it was somewhat tedious (it involved manually computing the proportion for 
#each region) and isn't something you would want to do if there were a
#larger number of options. It turns out there is a less tedious way to compute
#the proportion of values that are TRUE. The mean() function, which takes 
#the average of the values passed to it, will treat TRUE as 1 and FALSE as 0, 
#meaning it returns the proportion of values that are true. 
#For instance, mean(c(TRUE, FALSE, TRUE, TRUE)) returns 0.75. 
#Knowing this, use tapply() with the mean function to answer the following questions:

#Which state has a proportion of interviewees living in a non-metropolitan area
#closest to 30%?
x <- table(CPS$State, is.na(CPS$MetroAreaCode))
for(i in 1:nrow(x)){
        avg <- x[i,2]/sum(x[i,])
        print(paste(dimnames(x)[[1]][i],": ", avg))
}

#The correct way to invoke tapply to answer these questions is:

tapply(is.na(CPS$MetroAreaCode), CPS$State, mean)

#It is actually easier to answer this question if the proportions are sorted, 
#which can be accomplished with:
        
sort(tapply(is.na(CPS$MetroAreaCode), CPS$State, mean))

#From this output, we can see that Wisconsin is the state closest to having 30% 
#of its interviewees from a non-metropolitan area (it has 29.933% non-metropolitan 
#interviewees) and Montana is the state with highest proportion of non-metropolitan
#interviewees without them all being non-metropolitan, at 83.608%.


#INTEGRATING METROPOLITAN AREA DATA
#Codes like MetroAreaCode and CountryOfBirthCode are a compact way to encode 
#factor variables with text as their possible values, and they are therefore 
#quite common in survey datasets. In fact, all but one of the variables in this
#dataset were actually stored by a numeric code in the original CPS datafile.

#When analyzing a variable stored by a numeric code, we will often want to convert
#it into the values the codes represent. To do this, we will use a dictionary, 
#which maps the the code to the actual value of the variable. 
#We have provided dictionaries MetroAreaCodes.csv and CountryCodes.csv, 
#which respectively map MetroAreaCode and CountryOfBirthCode into their true values. 
#Read these two dictionaries into data frames MetroAreaMap and CountryMap.

MetroAreaMap <- read.csv("MetroAreaCodes.csv")
CountryMap <- read.csv("CountryCodes.csv")


# To merge in the metropolitan areas, we want to connect the field MetroAreaCode 
#from the CPS data frame with the field Code in MetroAreaMap. The following command
#merges the two data frames on these columns, overwriting the CPS data frame with the
#result:

CPS <- merge(CPS, MetroAreaMap, by.x="MetroAreaCode", by.y="Code", all.x=TRUE)

# The first two arguments determine the data frames to be merged 
#(they are called "x" and "y", respectively, in the subsequent parameters 
#to the merge function). by.x="MetroAreaCode" means we're matching on the 
#MetroAreaCode variable from the "x" data frame (CPS), while by.y="Code" means 
#we're matching on the Code variable from the "y" data frame (MetroAreaMap). 
#Finally, all.x=TRUE means we want to keep all rows from the "x" data frame (CPS), 
#even if some of the rows' MetroAreaCode doesn't match any codes in MetroAreaMap
#(for those familiar with database terminology, this parameter makes the operation
#a left outer join instead of an inner join).

#Review the new version of the CPS data frame with the summary() and str() functions.
#What is the name of the variable that was added to the data frame by the merge() 
#operation?
str(CPS)
summary(CPS)
#MetroArea

#How many interviewees have a missing value for the new metropolitan area variable? Note that all of these interviewees would have been removed from the merged data frame if we did not include the all.x=TRUE parameter.
sum(is.na(CPS$MetroArea)) #34238

#Which of the following metropolitan areas has the largest number of interviewees?
#Atlanta-Sandy Springs-Marietta, GA 
#Baltimore-Towson, MD 
#Boston-Cambridge-Quincy, MA-NH 
#Boston-Cambridge-Quincy, MA-NH - 
#correct San Francisco-Oakland-Fremont, CA
#see th first entries and ....
sort(table(CPS$MetroArea), decreasing = TRUE)

# Which metropolitan area has the highest proportion of interviewees
# of Hispanic ethnicity? Hint: Use tapply() with mean, as in the 
# previous subproblem. Calling sort() on the output of tapply() 
# could also be helpful here.

sort(tapply(CPS$Hispanic, CPS$MetroArea, mean))
#Laredo, TX

#################
# Remembering that CPS$Race == "Asian" returns a TRUE/FALSE vector of
# whether an interviewee is Asian, determine the number of metropolitan
# areas in the United States from which at least 20% of interviewees 
# are Asian.

x <- which(tapply(CPS$Race == "Asian", CPS$MetroArea, mean) > 0.2)
# We can read from the sorted output that Honolulu, HI; 
# San Francisco-Oakland-Fremont, CA; San Jose-Sunnyvale-Santa Clara, CA; 
# and Vallejo-Fairfield, CA had at least 20% of their interviewees of 
# the Asian race.

#################
# Normally, we would look at the sorted proportion of interviewees 
# from each metropolitan area who have not received a high school 
# diploma with the command:
        
sort(tapply(CPS$Education == "No high school diploma", CPS$MetroArea, mean))

# However, none of the interviewees aged 14 and younger have an 
# education value reported, so the mean value is reported as NA for 
# each metropolitan area. To get mean (and related functions, like sum)
# to ignore missing values, you can pass the parameter na.rm=TRUE. 
# Passing na.rm=TRUE to the tapply function, determine which metropolitan
# area has the smallest proportion of interviewees who have received 
# no high school diploma.

sort(tapply(CPS$Education == "No high school diploma", CPS$MetroArea, mean, na.rm = TRUE))
# Iowa City, IA 
# 0.02912621 
# Bowling Green, KY 
# 0.03703704 
# Kalamazoo-Portage, MI 
# 0.05050505 
# ...

#################
#INTEGRATING COUNTRY OF BIRTH DATA  (2 points possible)
# Just as we did with the metropolitan area information, merge in 
# the country of birth information from the CountryMap data frame, 
# replacing the CPS data frame with the result. If you accidentally 
# overwrite CPS with the wrong values, remember that you can restore
# it by re-loading the data frame from CPSData.csv and then merging
# in the metropolitan area information using the command provided in
# the previous subproblem.

CPS <- merge(CPS, CountryMap, by.x="CountryOfBirthCode", by.y="Code", all.x=TRUE)
#Country variable has been added to the dataframe
sum(is.na(CPS$Country)) #176 obs have NA value for Country variable

#################
#Among all interviewees born outside of North America, which country was the most 
#common place of birth?
sort(table(CPS$Country), decreasing = TRUE)[1:5] # -> Philippines
# From the summary(CPS) output, or alternately sort(table(CPS$Country)),
# we see that the top two countries of birth were United States and Mexico, 
# both of which are in North America. The third highest value, 839, was for 
# the Philippines.

#################
# What proportion of the interviewees from the 
# "New York-Northern New Jersey-Long Island, NY-NJ-PA" metropolitan area have 
# a country of birth that is not the United States? For this computation, 
# don't include people from this metropolitan area who have a missing country 
# of birth.

#From table(CPS$MetroArea == "New York-Northern New Jersey-Long Island, NY-NJ-PA", 
# CPS$Country != "United States"), we can see that 1668 of interviewees from this 
# metropolitan area were born outside the United States and 3736 were born in the 
# United States (it turns out an additional 5 have a missing country of origin). 
# Therefore, the proportion is 1668/(1668+3736)=0.309.
# Or....
ny_data <- subset(CPS, MetroArea == "New York-Northern New Jersey-Long Island, NY-NJ-PA")
ny_data_f <- ny_data[!is.na(ny_data$Country),]
mean(ny_data_f$Country != "United States") # -> 0.3086603


###################
# Which metropolitan area has the largest number (note -- not proportion) of 
# interviewees with a country of birth in India? 
# Hint -- remember to include na.rm=TRUE if you are using tapply() to answer 
# this question.

y <- subset(CPS, CPS$Country == "India")
sort(table(y$MetroArea), decreasing = TRUE)[1:10]
# New York-Northern New Jersey-Long Island, NY-NJ-PA 
# 96 

y <- subset(CPS, CPS$Country == "Brazil")
sort(table(y$MetroArea), decreasing = TRUE)[1:10]
# Boston-Cambridge-Quincy, MA-NH 
# 18

y <- subset(CPS, CPS$Country == "Somalia")
sort(table(y$MetroArea), decreasing = TRUE)[1:10]
# Minneapolis-St Paul-Bloomington, MN-WI
# 17

#Answer
#To obtain the number of TRUE values in a vector of TRUE/FALSE values, 
#you can use the sum() function. For instance, sum(c(TRUE, FALSE, TRUE, TRUE)) is 3.
#Therefore, we can obtain counts of people born in a particular country living in 
#a particular metropolitan area with:
        
sort(tapply(CPS$Country == "India", CPS$MetroArea, sum, na.rm=TRUE))
sort(tapply(CPS$Country == "Brazil", CPS$MetroArea, sum, na.rm=TRUE))
sort(tapply(CPS$Country == "Somalia", CPS$MetroArea, sum, na.rm=TRUE))

#We see that New York has the most interviewees born in India (96), 
#Boston has the most born in Brazil (18), and Minneapolis has the most born in
#Somalia (17).



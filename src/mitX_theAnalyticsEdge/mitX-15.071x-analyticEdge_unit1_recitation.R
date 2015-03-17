#Unit1: Recitation (MIT15071X_unit1_recitation.txt)
#Case Analysis
#looking at nutritional data of over 7,000 foods distributed by
#the US Department of Agricultural.

# In this first recitation, we will
# try to understand various nutritional facts about food,
# while getting more practice using R
# The United States Department of Agricultural
# distributes nutritional information
# of over 7,000 food items including
# amount of calories, carbs, protein, fat,
# and sodium, among other nutrients.
# It is exactly this data that we will
# be analyzing in this recitation.

#DataSource (USDA.csv)
#USDA National Nutrient Database for Standard Reference
#http://ndb.nal.usda.gov/

############
## Part 1 ##
############

#Reading the dataset (csv) file
#Be sure about the working directory - same directory where
#the datasource file is located
usda <- read.csv("USDA.csv")

#Learn about the data
str(usda)
# gives us the following information.
# We have 7,058 observations, or foods in our dataset,
# along with 16 different variables.
# The first variable gives a unique identification number
# for each of the foods, starting with the number 1,001.
# The second variable gives a text description
# of each of the foods.
# The third variable is the amount of calories
# in 100 grams of these foods, and it's
# given to us in kilocalories.
# Then we also have information about the protein,
# total fat, carbohydrate, saturated fat,
# and sugar levels in grams, as well as
# the sodium, cholesterol, calcium, iron, potassium,
# and vitamin C levels, in milligrams.
# And finally, the amount of vitamin E and vitamin D in what
# is known as international units, and this
# is a standard measurement for drugs and vitamins.

#To obtain high level statistical info
summary(usda)
# The summary function gives us information
# such as the minimum, the maximum, and the mean values
# across all 7,058 foods for each of the 16 different variables.
# For instance, the maximum amount of cholesterol
# is 3,100 milligrams, whereas the mean is only 41.55 milligrams.
# We also have information about the number
# of non-available entries.
# For instance, we have 1,910 foods
# that are missing entries for their sugar levels.
# Now, scrolling through this information,
# a startling observation is the maximum level
# of sodium, which is 38,758 milligrams.
# This number is huge, given that the daily recommended maximum
# is only 2,300 milligrams.
# Let's investigate this variable further in our next video.

#to see all of names in the dataset
names(usda)

#Let'start to do some data analysis
#we would like ot see which food has the max value

usda$Sodium #Sodium values in the data set
which.max(usda$Sodium)#return the index of teh max entry
#265th food in our data set
usda$Description[which.max(usda$Sodium)] #To see which food is associated to max sodium value
usda[which.max(usda$Sodium),] #See all observation values for the food with the max sodium value

#which food comntains more than 10000 mg fo sodium?
#create a subset of the original dataset with only the fodd with sodium content more than 10000
high_sodium <- subset(usda, Sodium > 10000)
#To view the dataset the View function can be used
View(high_sodium)
nrow(high_sodium)#no of foods sattsfing that condition
#if I want to see the foods matching the provided condition
#being only 10 - we can see the Description
high_sodium$Description
#We can see tha SALT isoneof them but it is not the only one

#Caviar is one food with a high level of sodium...
#How much is the content fo sodium (in 100gr)?
#First we need to be able to get to the CAVIAR entry 
#We need to find the index - and we can start from the Description
match("CAVIAR", usda$Description) #Return the index of the matching entry in our dataset
usda$Sodium[match("CAVIAR", usda$Description)]#level of sodium 1500 mgr in 100gr of caviar

#Let's check the mean and stddev of the SOdium
summary(usda$Sodium) #for info around mean
sd(usda$Sodium, na.rm = TRUE) #Remember to remove NAs otherwise result will be NA

#mean is 322.1 (mg) and sd is 1045.417 (mg)
# mean + sd = 1367 (mg) still lower than the 1500 mg of CAVIAR
# it means that still CAVIAR is rich in SODIUM compared to most of the other foods.

############
## Part 2 ##
############

#Lets try to visualize the same information using plots/ graphs in R
#Visualization is a crutial steps for exploration of data
#create a scatterplot
plot(usda$Protein, usda$TotalFat)
#From the scatterplot we can see that there lot of foods just have low protein and low total fat
#Lets change some of the default setting associated with the plot
plot(usda$Protein, usda$TotalFat, xlab="Protein", ylab="Fat", main="Protein vs. Fat", col = "red")

#We can plot some histagrams
hist(usda$VitaminC, xlab="Vitamin C (mg)", main="Histagram Vitamin C levels")
#limit the x axis
hist(usda$VitaminC, xlab="Vitamin C (mg)", main="Histagram Vitamin C levels", xlim=c(0, 100))
#Only one big cell is visible - we need to break up this cell in smaller parts
hist(usda$VitaminC, xlab="Vitamin C (mg)", main="Histagram Vitamin C levels", xlim=c(0, 100), breaks = 100)
#Note Breaks/ cells is calculated using the full range of values
#Value range is 0 - 2000 in 100 breaks/ cells => 20 mg per cell
#Value range is 0 - 2000 in 2000 breaks/ cells => 1 mg per cell
hist(usda$VitaminC, xlab="Vitamin C (mg)", main="Histagram Vitamin C levels", xlim=c(0, 100), breaks = 2000)
#The distribution shows us that actually aorund 5000 foods have
#less than 1 mg of Vitamin C

#another way to visualize the data is to use boxplot
#boxplot function takes only one argument (a single vector)
#Create a boxplot for the sugar levels
boxplot(usda$Sugar, main = "Boxplot of Sugar level", ylab = "Sugar (gr)")
# What is it trying to tell us here?
# It looks a little bit strange.
# Well, the average of sugar across the data set
# seems to be pretty low.
# It's somewhere around five grams.
# But we have a lot of outliers with extremely high values
# of sugar.
# There exist some foods that have almost 100 grams of sugar
# in 100 grams.

############
## Part 3 ##
############

# how wecan add a new variable to our data frame.
# Suppose that we want to add a variable to our USDA data
# frame that takes a value 1 if the food has higher
# sodium than average, and 0 if the food has
# lower sodium than average.

#How to check for a food entry
#first food entry (it is TRUE)
usda$Sodium[1] > mean(usda$Sodium, na.rm = TRUE) #remember to remove NAs when calculating mean (otherwise NA)

#50th food entry (it is FALSE)
usda$Sodium[50] > mean(usda$Sodium, na.rm = TRUE) #remember to remove NAs when calculating mean (otherwise NA)

#If we cansider all of the entries (7000 foods) - (remember in the original Sodium vector we have some NAs)
high_sodium <- usda$Sodium > mean(usda$Sodium, na.rm = TRUE)
#lets look at the structure of this vector
str(high_sodium) #logicals - type of vector is logical
#Remember we want to have a vector of 0s and 1s
#0 if lower sodium
#1 if higher sodium
#we can use the as.numeric to conver the logical vector to
# a numeric vector of 0s and 1s
high_sodium <- as.numeric(high_sodium)
str(high_sodium) #numeric of 0s and 1s

#In order to add this info to the original dataset
usda$HighSodium <- high_sodium #lets create a new variable in the dataset ....
#if we check structure of usda
str(usda)
#WE CAN SEE THAT A new variable has been added - HighSodium to the dataset
# anumerical variable of 0s and 1s
#do the same for protein & totalFat & carbohydrates
usda$HighProtein <- as.numeric(usda$Protein > mean(usda$Protein, na.rm = TRUE))
usda$HighFat <- as.numeric(usda$TotalFat > mean(usda$TotalFat, na.rm = TRUE))
usda$HighCarbohydrate <- as.numeric(usda$Carbohydrate > mean(usda$Carbohydrate, na.rm = TRUE))

#check structure of dataset
str(usda)
#added these 3 new variables with extra info
#How we can find relationships between these new variables and original ones? 

############
## Part 4 ##
############

# we will try to understand
# our data and the relationships between our variables
# better, using the table and tapply functions.

#First we want to look at HighSodium variable and count the foods that have a value of 1
table(usda$HighSodium)
# Most of the foods in our data set,
# and precisely 4,800 of them, have lower sodium than average,
# and we have 2090 foods that have higher sodium
# content than average.
# Now let's see how many foods have
# both high sodium and high fat.
# Well, to do this we can also use the table function,
# but instead of giving it one input, now
# we can give it two inputs.
table(usda$HighSodium, usda$HighFat)  #rows to the first input, cols to second input
# So from the table we see that we have
# 3,529 foods with low sodium and low fat,
# 1,355 foods with low sodium and high fat, 1,378
# foods with high sodium but low fat,
# and finally 712 foods with both high sodium and high fat.

#lets compute the average amout of iron sorted by high and low protein?
#tapply at work
#look at Iron, grouping by HighProtein and calculate the mean
tapply(usda$Iron, usda$HighProtein, mean, na.rm = TRUE) #remember to remove NAs
# Foods with low protein content have
# on average 2.55 milligrams of iron
# and foods with high protein content
# have on average 3.2 milligrams of iron.

# Now how about the maximum level of vitamin C
# in foods with high and low carbs?
tapply(usda$VitaminC, usda$HighCarbohydrate, max, na.rm = TRUE)
# The maximum vitamin C level, which is 2,400 milligrams
# is actually present in a food that is high in carbs.

# Well, is it true that foods that are high in carbs
# have generally high vitamin C content?
tapply(usda$VitaminC, usda$HighCarbohydrate, summary, na.rm = TRUE)
# Now the statistical information that the summary function
# gives us pertains to the vitamin C levels.
# This means that we have on average 6.36 milligrams
# of vitamin C in foods with low carb content,
# and on average 16.31 milligrams of vitamin C in foods
# with high carb content.










# DETECTING FLU EPIDEMICS VIA SEARCH ENGINE QUERY DATA 
# 
# Flu epidemics constitute a major public health concern causing respiratory illnesses, 
# hospitalizations, and deaths. According to the National Vital Statistics Reports published 
# in October 2012, influenza ranked as the eighth leading cause of death in 2011 in the
# United States. Each year, 250,000 to 500,000 deaths are attributed to influenza related 
# diseases throughout the world.
# 
# The U.S. Centers for Disease Control and Prevention (CDC) and the European Influenza 
# Surveillance Scheme (EISS) detect influenza activity through virologic and clinical data, 
# including Influenza-like Illness (ILI) physician visits. Reporting national and regional data,
# however, are published with a 1-2 week lag.
# 
# The Google Flu Trends project was initiated to see if faster reporting can be made possible
# by considering flu-related online search queries -- data that is available almost immediately.

# PROBLEM 1.1 - UNDERSTANDING THE DATA  (6 points possible)
# We would like to estimate influenza-like illness (ILI) activity using Google web search logs. 
# Fortunately, one can easily access this data online:
#     
# ILI Data - The CDC publishes on its website the official regional and state-level percentage 
# of patient visits to healthcare providers for ILI purposes on a weekly basis.
# 
# Google Search Queries - Google Trends allows public retrieval of weekly counts for every 
# query searched by users around the world. For each location, the counts are normalized 
# by dividing the count for each query in a particular week by the total number of online 
# search queries submitted in that location during the week. Then, the values are adjusted
# to be between 0 and 1.
# 
# The csv file FluTrain.csv aggregates this data from January 1, 2004 until December 31, 2011 
# as follows:
#     
# "Week" - The range of dates represented by this observation, in year/month/day format.
# 
# "ILI" - This column lists the percentage of ILI-related physician visits for the corresponding week.
# 
# "Queries" - This column lists the fraction of queries that are ILI-related for the corresponding 
# week, adjusted to be between 0 and 1 (higher values correspond to more ILI-related search queries).
# 
# Before applying analytics tools on the training set, we first need to understand the data at hand.
# 
# Load "FluTrain.csv" into a data frame called FluTrain. Looking at the time period 2004-2011, 

FluTrain <- read.csv("FluTrain.csv")
str(FluTrain)
summary(FluTrain)

# which week corresponds to the highest percentage of ILI-related physician visits? 
# Select the day of the month corresponding to the start of this week.

FluTrain[which.max(FluTrain$ILI), ]
#                       Week      ILI       Queries
# 303 2009-10-18 - 2009-10-24 7.618892       1
#Please note that QUeries = 1 so 

# EXPLANATION
# 
# We can limit FluTrain to the observations that obtain the maximum ILI value with 
# subset(FluTrain, ILI == max(ILI)). From here, we can read information about the week at 
# which the maximum was obtained. Alternatively, you can use which.max(FluTrain$ILI) to find 
# the row number corresponding to the observation with the maximum value of ILI, which is 303. 
# Then, you can output the corresponding week using FluTrain$Week[303].


# Which week corresponds to the highest percentage of ILI-related query fraction?
# Same observation as before.
# EXPLANATION
# We can limit FluTrain to the observations that obtain the maximum ILI value with 
# subset(FluTrain, Queries == max(Queries)). From here, we can read information about the week at
# which the maximum was obtained. Alternatively, you can use which.max(FluTrain$Queries) to 
# find the row number corresponding to the observation with the maximum value of Queries, 
# which is 303. Then, you can output the corresponding week using FluTrain$Week[303].


# PROBLEM 1.2 - UNDERSTANDING THE DATA  (1 point possible)
# Let us now understand the data at an aggregate level. Plot the histogram of the dependent 
# variable, ILI. What best describes the distribution of values of ILI?

hist(FluTrain$ILI)
#Most of the ILI values are small, with a relatively small number of much larger values 
#(in statistics, this sort of data is called "skew right").


# PROBLEM 1.3 - UNDERSTANDING THE DATA  (1 point possible)
# When handling a skewed dependent variable, it is often useful to predict the logarithm of the 
# dependent variable instead of the dependent variable itself -- this prevents the small number
# of unusually large or small observations from having an undue influence on the sum of squared
# errors of predictive models. In this problem, we will predict the natural log of the ILI variable,
# which can be computed in R using the log() function.

#Plot the natural logarithm of ILI versus Queries. What does the plot suggest?
plot(FluTrain$Queries, log(FluTrain$ILI))
# EXPLANATION
# The plot can be obtained with plot(FluTrain$Queries, log(FluTrain$ILI)). Visually, there is a 
# positive, linear relationship between log(ILI) and Queries.

# PROBLEM 2.1 - LINEAR REGRESSION MODEL  (1 point possible)
# Based on the plot we just made, it seems that a linear regression model could be a good modeling
# choice. Based on our understanding of the data from the previous subproblem, which model best 
# describes our estimation problem?

# EXPLANATION
# From the previous subproblem, we are predicting log(ILI) using the Queries variable. From the plot 
# in the previous subproblem, we expect the coefficient on Queries to be positive.

# PROBLEM 2.2 - LINEAR REGRESSION MODEL  (2 points possible)
# Let's call the regression model from the previous problem (Problem 2.1) FluTrend1 and run it in R. 
# Hint: to take the logarithm of a variable Var in a regression equation, you simply use log(Var) 
# when specifying the formula to the lm() function.

FluTrend1 <- lm(log(ILI) ~ Queries, data = FluTrain)
summary(FluTrend1)

# What is the training set R-squared value for FluTrend1 model (the "Multiple R-squared")?
# Multiple R-squared:  0.709
# EXPLANATION
# The model can be trained with:
#     
#     FluTrend1 = lm(log(ILI)~Queries, data=FluTrain)
# 
# From summary(FluTrend1), we read that the R-squared value is 0.709.


# PROBLEM 2.3 - LINEAR REGRESSION MODEL  (1 point possible)
# For a single variable linear regression model, there is a direct relationship between the 
# R-squared and the correlation between the independent and the dependent variables. 
# What is the relationship we infer from our problem? 
# (Don't forget that you can use the cor function to compute the correlation between two variables.)

summary(FluTrend1)
cor(log(FluTrain$ILI), FluTrain$Queries)#0.8420333
#R^2: 0.709
cor(log(FluTrain$ILI), FluTrain$Queries) ^ 2
log(1 / cor(log(FluTrain$ILI), FluTrain$Queries))
exp(-0.5 * cor(log(FluTrain$ILI), FluTrain$Queries))
# > cor(log(FluTrain$ILI), FluTrain$Queries) ^ 2
# [1] 0.7090201

# EXPLANATION
# To test these hypotheses, we first need to compute the correlation between the independent 
# variable used in the model (Queries) and the dependent variable (log(ILI)). This can be done with
# Correlation = cor(FluTrain$Queries, log(FluTrain$ILI))
# 
# The values of the three expressions are then:
# Correlation^2 = 0.7090201
# log(1/Correlation) = 0.1719357
# exp(-0.5*Correlation) = 0.6563792
# 
# It appears that Correlation^2 is equal to the R-squared value. It can be proved that this 
# is always the case.

# PROBLEM 3.1 - PERFORMANCE ON THE TEST SET  (1 point possible)
# The csv file FluTest.csv provides the 2012 weekly data of the ILI-related search queries and
# the observed weekly percentage of ILI-related physician visits. Load this data into a data 
# frame called FluTest.
# Normally, we would obtain test-set predictions from the model FluTrend1 using the code

FluTest <- read.csv("FluTest.csv")
PredTest1 <- predict(FluTrend1, newdata=FluTest)

# However, the dependent variable in our model is log(ILI), so PredTest1 would contain predictions
# of the log(ILI) value. We are instead interested in obtaining predictions of the ILI value. 
# We can convert from predictions of log(ILI) to predictions of ILI via exponentiation, 
# or the exp() function. The new code, which predicts the ILI value, is
 
PredTest1 = exp(predict(FluTrend1, newdata=FluTest))

# What is our estimate for the percentage of ILI-related physician visits for the week of 
# March 11, 2012? 
# (HINT: You can either just output FluTest$Week to find which element corresponds 
#  to March 11, 2012, or you can use the "which" function in R. To learn more about the 
#  which function, type ?which in your R console.)

# FluTest$Week == "2012-03-11*" -> 11 observations
PredTest1[11] # 2.187378 

# EXPLANATION
# To obtain the predictions, we need can run
# PredTest1 = exp(predict(FluTrend1, newdata=FluTest))
# Next, we need to determine which element in the test set is for March 11, 2012. We can determine 
# this with:
# which(FluTest$Week == "2012-03-11 - 2012-03-17")
# Now we know we are looking for prediction number 11. This can be accessed with:
# PredTest1[11]

# PROBLEM 3.2 - PERFORMANCE ON THE TEST SET  (1 point possible)
# What is the relative error betweeen the estimate (our prediction) and the observed value
# for the week of March 11, 2012? Note that the relative error is calculated as
# (Observed ILI - Estimated ILI)/Observed ILI
(FluTest$ILI[11] - PredTest1[11])/ FluTest$ILI[11] #0.04623827

# PROBLEM 3.3 - PERFORMANCE ON THE TEST SET  (1 point possible)
# What is the Root Mean Square Error (RMSE) between our estimates and the actual observations 
# for the percentage of ILI-related physician visits, on the test set?
#RMSE = sqrt(SSE/N)
SSE <- sum((FluTest$ILI - PredTest1)^2) #Testing dataset
RMSE <- sqrt(SSE/ nrow(FluTest));RMSE
#0.7490645
# EXPLANATION
# The RMSE can be calculated by first computing the SSE:
#     SSE = sum((PredTest1-FluTest$ILI)^2)
# and then dividing by the number of observations and taking the square root:
#     RMSE = sqrt(SSE / nrow(FluTest))
# Alternatively, you could use the following command:
#     sqrt(mean((PredTest1-FluTest$ILI)^2)).

# PROBLEM 4.1 - TRAINING A TIME SERIES MODEL  (1 point possible)
# The observations in this dataset are consecutive weekly measurements of the dependent and 
# independent variables. This sort of dataset is called a "time series." Often, statistical 
# models can be improved by predicting the current value of the dependent variable using the
# value of the dependent variable from earlier weeks. In our models, this means we will predict
# the ILI variable in the current week using values of the ILI variable from previous weeks.

# First, we need to decide the amount of time to lag the observations. Because the ILI variable 
# is reported with a 1- or 2-week lag, a decision maker cannot rely on the previous week's ILI
# value to predict the current week's value. Instead, the decision maker will only have data 
# available from 2 or more weeks ago. We will build a variable called ILILag2 that contains
# the ILI value from 2 weeks before the current observation.

# To do so, we will use the "zoo" package, which provides a number of helpful methods for 
# time series models. While many functions are built into R, you need to add new packages to 
# use some functions. New packages can be installed and loaded easily in R, and we will do this
# many times in this class. Run the following two commands to install and load the zoo package. 
# In the first command, you will be prompted to select a CRAN mirror to use for your download. 
# Select a mirror near you geographically.

install.packages("zoo")
library(zoo)

# After installing and loading the zoo package, run the following commands to create the ILILag2
# variable in the training set:
    
ILILag2 <- lag(zoo(FluTrain$ILI), -2, na.pad=TRUE)
FluTrain$ILILag2 = coredata(ILILag2)

#In these commands, the value of -2 passed to lag means to return 2 observations before 
# the current one; a positive value would have returned future observations. The parameter 
# na.pad=TRUE means to add missing values for the first two weeks of our dataset, where we 
# can't compute the data from 2 weeks earlier.

#How many values are missing in the new ILILag2 variable?
summary(FluTrain$ILILag2) #NA's 2

# PROBLEM 4.2 - TRAINING A TIME SERIES MODEL  (1 point possible)
# Use the plot() function to plot the log of ILILag2 against the log of ILI. 
# Which best describes the relationship between these two variables?

plot(log(FluTrain$ILILag2), log(FluTrain$ILI))
#From plot(log(FluTrain$ILILag2), log(FluTrain$ILI)), we observe a strong positive relationship.

# PROBLEM 4.3 - TRAINING A TIME SERIES MODEL  (2 points possible)
# Train a linear regression model on the FluTrain dataset to predict the log of the 
# ILI variable using the Queries variable as well as the log of the ILILag2 variable. 
# Call this model FluTrend2.

FluTrend2 <- lm(log(ILI) ~ Queries + log(ILILag2), data = FluTrain) 
summary(FluTrend2)

# Which coefficients are significant at the p=0.05 level in this regression model? 
# (Select all that apply.)
# EXPLANATION
# The following code builds and summarizes the FluTrend2 model:
#     FluTrend2 = lm(log(ILI)~Queries+log(ILILag2), data=FluTrain)
# summary(FluTrend2)
# As can be seen, all three coefficients are highly significant, and the R^2 value is 0.9063.

summary(FluTrend1)
summary(FluTrend2)
# Note!! Moving from FluTrend1 to FluTrend2, in-sample R^2 improved from 0.709 to 0.9063, and
# the new variable is highly significant. As a result, there is no sign of overfitting, 
# and FluTrend2 is superior to FluTrend1 on the training set.

# PROBLEM 5.1 - EVALUATING THE TIME SERIES MODEL IN THE TEST SET (1 point possible)
# So far, we have only added the ILILag2 variable to the FluTrain data frame. To make 
# predictions with our FluTrend2 model, we will also need to add ILILag2 to the FluTest 
# data frame (note that adding variables before splitting into a training and testing set
# can prevent this duplication of effort).

# Modify the code from the previous subproblem to add an ILILag2 variable to the FluTest 
# data frame. How many missing values are there in this new variable?
ILILag2 <- lag(zoo(FluTest$ILI), -2, na.pad=TRUE)
FluTest$ILILag2 = coredata(ILILag2)
summary(FluTest$ILILag2) #NA's 2

# PROBLEM 5.2 - EVALUATING THE TIME SERIES MODEL IN THE TEST SET (2 points possible)
# In this problem, the training and testing sets are split sequentially -- the training set 
# contains all observations from 2004-2011 and the testing set contains all observations from 2012.
# There is no time gap between the two datasets, meaning the first observation in FluTest was 
# recorded one week after the last observation in FluTrain. From this, we can identify how to fill
# in the missing values for the ILILag2 variable in FluTest.
# Which value should be used to fill in the ILILag2 variable for the first observation in FluTest?

#The ILI value of the second-to-last observation in the FluTrain data frame
# EXPLANATION
# The time two weeks before the first week of 2012 is the second-to-last week of 2011. This corresponds
# to the second-to-last observation in FluTrain.

# Which value should be used to fill in the ILILag2 variable for the second observation in FluTest?

# The ILI value of the last observation in the FluTrain data frame.
# EXPLANATION
# The time two weeks before the second week of 2012 is the last week of 2011. This corresponds to the
# last observation in FluTrain.

# PROBLEM 5.3 - EVALUATING THE TIME SERIES MODEL IN THE TEST SET (2 points possible)
# Fill in the missing values for ILILag2 in FluTest. In terms of syntax, you could set the
# value of ILILag2 in row "x" of the FluTest data frame to the value of ILI in row "y" of the
# FluTrain data frame with "FluTest$ILILag2[x] = FluTrain$ILI[y]". Use the answer to 
# the previous questions to determine the appropriate values of "x" and "y". It may be helpful
# to check the total number of rows in FluTrain using str(FluTrain) or nrow(FluTrain).

nrow(FluTrain) #417

# What is the new value of the ILILag2 variable in the first row of FluTest?
FluTest$ILILag2[1] = FluTrain$ILI[416];FluTest$ILILag2[1]
# What is the new value of the ILILag2 variable in the second row of FluTest?
FluTest$ILILag2[2] = FluTrain$ILI[417];FluTest$ILILag2[2]

# EXPLANATION
# From nrow(FluTrain), we see that there are 417 observations in the training set. Therefore, 
# we need to run the following two commands:
#     FluTest$ILILag2[1] = FluTrain$ILI[416]
# FluTest$ILILag2[2] = FluTrain$ILI[417]

# PROBLEM 5.4 - EVALUATING THE TIME SERIES MODEL IN THE TEST SET (2 points possible)
# Obtain test set predictions of the ILI variable from the FluTrend2 model, again remembering 
# to call the exp() function on the result of the predict() function to obtain predictions 
# for ILI instead of log(ILI).

PredTest2 = exp(predict(FluTrend2, newdata=FluTest))
#RMSE = sqrt(SSE/N)
SSE <- sum((FluTest$ILI - PredTest2)^2) #Testing dataset
RMSE <- sqrt(SSE/ nrow(FluTest));RMSE

# What is the test-set RMSE of the FluTrend2 model?
#0.29442029

# EXPLANATION
# The test-set RMSE of FluTrend2 is 0.294, as opposed to the 0.749 value obtained
# by the FluTrend1 model.
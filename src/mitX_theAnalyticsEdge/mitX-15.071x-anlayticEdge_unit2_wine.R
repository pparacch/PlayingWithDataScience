#Unit2: Linear Regression models
#Supporting data in wine.csv, wine_test.csv files

# Read in data
wine = read.csv("wine.csv")
str(wine) #we can see the structure of the dataset
#dataframe with 25 obs. of 7 different variables
# Year gives the year the wine was produced, and it's just a unique identifier for each observation.
# Price is the dependent variable we're trying to predict.
# And WinterRain, AGST, HarvestRain, Age, and FrancePop are the independent variables we'll use to predict Price.

summary(wine)#to look the statistic info for the data

# Linear Regression (one variable AGST)
#lm -> lenear model -> dependentVariable ~ independentVariable
model1 = lm(Price ~ AGST, data=wine)

summary(model1)
# The first thing we see is a description
# of the function we used to build the model.
# Then we see a summary of the residuals or error terms.
# Following that is a description of the coefficients
# of our model.
# The first row corresponds to the intercept term,
# and the second row corresponds to our independent variable,
# AGST.
# The Estimate column gives estimates
# of the beta values for our model.
# So here beta 0, or the coefficient
# for the intercept term, is estimated to be -3.4.
# And beta 1, or the coefficient for our independent variable,
# is estimated to be 0.635.
# There's additional information in this table not relevant for now.
# Towards the bottom of the output,
# you can see Multiple R-squared, 0.435,
# which is the R-squared value that we
# discussed. Beside it is a number labeled Adjusted R-squared.
# In this case, it's 0.41. This number adjusts the R-squared value
# to account for the number of independent variables used
# relative to the number of data points.
# Multiple R-squared will always increase if you add more independent variables.
# But Adjusted R-squared will decrease if you add an independent variable that doesn't help the model.
# This is a good way to determine if an additional variable should even be included in the model.

# Sum of Squared Errors SSE
model1$residuals
SSE = sum(model1$residuals^2)
SSE

# Linear Regression (two variables)
# (dependentVariable) Price ~ AGST + HarvestRain (independentVariables)
#When you want to use more that a independent variable just separate them with a '+' sign.
model2 = lm(Price ~ AGST + HarvestRain, data=wine)
summary(model2)
# We have a third row in our Coefficients table now corresponding to HarvestRain.
# The coefficient estimate for this new independent variable is negative 0.00457.
# And if you look at the R-squared near the bottom of the output, you can see that this variable really helped our model.
# Our Multiple R-squared and Adjusted R-squared both increased significantly compared to the previous model.


# Sum of Squared Errors
SSE = sum(model2$residuals^2)
SSE
# If we type SSE, we can see that the sum of squared errors for model2 is 2.97, which is much better than the 
# sum of squared errors for model1.

# Linear Regression (all independent variables)
model3 = lm(Price ~ AGST + HarvestRain + WinterRain + Age + FrancePop, data=wine)
summary(model3)
# Now the Coefficients table has six rows, one for the intercept
# and one for each of the five independent variables.
# If we look at the bottom of the output,
# we can again see that the Multiple R-squared and Adjusted
# R-squared have both increased.


# Sum of Squared Errors
SSE = sum(model3$residuals^2)
SSE
# And if we type SSE, we can see that the sum of squared errors
# for model3 is 1.7, even better than before.

##Understanding the models and coefficients visible in teh summary()
# Linear Regression (all variables)
model3 = lm(Price ~ AGST + HarvestRain + WinterRain + Age + FrancePop, data=wine)
summary(model3)

# built a linear regression model,
# called model3, that used all of our independent variables
# to predict the dependent variable, Price.
# In our R Console, we can see the summary output of this model.

# As we just learned, both Age and FrancePopulation
# are insignificant in our model.
# Because of this, we should consider
# removing these variables from our model.
# Let's start by just removing FrancePopulation,
# which we intuitively don't expect
# to be predictive of wine price anyway.

# Remove FrancePop
model4 = lm(Price ~ AGST + HarvestRain + WinterRain + Age, data=wine)
summary(model4)

# Let's take a look at the summary of this new model, model4.
# We can see that the R-squared, for this model, is 0.8286 and our Adjusted R-squared is 0.79.
# If we scroll back up in our R Console, we can see that for model3, the R-squared was 0.8294, and the Adjusted R-squared was 0.7845.
# So this model is just as strong, if not stronger, than the previous model because our Adjusted R-squared actually increased by
# removing FrancePopulation.

#Note that according top the STAR SCHEME - Age has become almost significant.
# If we look at each of our independent variables
# in the new model, and the stars, we
# can see that something a little strange happened.
# Before, Age was not significant at all in our model.
# But now, Age has two stars, meaning that it's very significant in this new model.
# This is due to something called multicollinearity. Age and FrancePopulation are what we call highly correlated.


##Correlation and multicollinearity
# We can compute the correlation between a pair of variables
# in R by using the cor function.
# Let's compute the correlation between WinterRain and Price.
cor(wine$WinterRain, wine$Price)
#0.137

cor(wine$Age, wine$FrancePop)
#-0.994 HIGHLY CORRELATED

cor(wine)#Correlation between all of variables in our dataset
# The output is a grid of numbers with the rows and columns
# labeled with the variables in our data set.
# To find the correlation between two variables,
# you just need to find the row for one of them
# and the column for the other.
# For example, we can find the column for Age
# and then go down to the row for FrancePopulation
# to see the number that we just computed.

# So how does this information help
# us understand our linear regression model?
# We've confirmed that Age and FrancePopulation are definitely
# highly correlated.
# So we do have multicollinearity problems in our model
# that uses all of the available independent variables.
# Keep in mind that multicollinearity
# refers to the situation when two independent variables are
# highly correlated.

# A high correlation between an independent variable
# and the dependent variable is a good thing
# since we're trying to predict the dependent variable using
# the independent variables.
# Now due to the possibility of multicollinearity,
# you always want to remove the insignificant variables
# one at a time.

#Let's see what would have happened
# if we had removed both Age and FrancePopulation, since they
# were both insignificant in our model
# that used all of the independent variables.

# Remove Age and FrancePop
model5 = lm(Price ~ AGST + HarvestRain + WinterRain, data=wine)
summary(model5)
# If we take a look at the summary of this new model
# and look at the Coefficients table,
# we can see that AverageGrowingSeasonTemperature
# and HarvestRain are very significant,
# and WinterRain is almost significant.
# So this model looks pretty good,
# but if we look at our R-squared, we
# can see that it dropped to 0.75.
# The model that includes Age has an R-squared of 0.83.

# So if we had removed Age and FrancePopulation
# at the same time, we would have missed a significant variable,
# and the R-squared of our final model would have been lower.
# So why didn't we keep FrancePopulation
# instead of Age?
# Well, we expect Age to be significant.
# Older wines are typically more expensive,
# so Age makes more intuitive sense in our model.
# Multicollinearity reminds us that coefficients
# are only interpretable in the presence
# of other variables being used.
# High correlations can even cause coefficients
# to have an unintuitive sign.

# Do we have any other highly-correlated independent
# variables?
# There is no definitive cut-off value
# for what makes a correlation too high.
# But typically, a correlation greater than 0.7
# or less than -0.7 is cause for concern.



#Predictive Ability

# Read in test set (TEST data)
wineTest = read.csv("wine_test.csv")
str(wineTest)

# Make test set predictions based on a specific model 
# we use the predict function on model4
predictTest = predict(model4, newdata=wineTest)
predictTest
# If we take a look at our predictions,
# we can see that for the first data point we predict 6.7689,
# and for the second data point we predict 6.6849.
# If we look back at our str output,
# we can see that the actual Price for the first data point
# is 6.95, and the actual Price for the second data point
# is 6.5.
# So it looks like our predictions are pretty good,
# but we can quantify this by computing the R-squared value
# for our test set.

# Compute R-squared for the new data set
SSE = sum((wineTest$Price - predictTest)^2)
SST = sum((wineTest$Price - mean(wine$Price))^2) #base model is the average wine$price (old dataset - the TRAINING set)
1 - SSE/SST
# So the R-squared on our test set is 0.79.
# This is a pretty good out-of-sample R-squared.
# But while we do well on these two test points,
# keep in mind that our test set is really small.
# We should increase the size of our test set
# to be more confident about the out-of-sample accuracy
# of our model.
# We can compute the test set R-squared
# for several different models.


########
# Test #
########
#use the dataset wine.csv to create a linear regression model to predict 
#Price using HarvestRain and WinterRain as independent variables. 
#Using the summary output of this model, answer the following questions:

test_model <- lm(Price ~ HarvestRain + WinterRain, data = wine)
summary(test_model)

#What is the "Multiple R-squared" value of your model?
#What is the coefficient for HarvestRain?
#What is the intercept coefficient?
#Is the coefficient for HarvestRain significant?
#Is the coefficient for WinterRain significant?

#what is the correlation between HarvestRain and WinterRain?
cor(wine)
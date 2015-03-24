# READING TEST SCORES
# 
# The Programme for International Student Assessment (PISA) is a test given every three years to 15-year-old students from
# around the world to evaluate their performance in mathematics, reading, and science. This test provides a quantitative way
# to compare the performance of students from different parts of the world. In this homework assignment, we will predict the
# reading scores of students from the United States of America on the 2009 PISA exam.

# The datasets pisa2009train.csv and pisa2009test.csv contain information about the demographics and schools for American 
# students taking the exam, derived from 2009 PISA Public-Use Data Files distributed by the United States National Center for 
# Education Statistics (NCES). While the datasets are not supposed to contain identifying information about students taking
# the test, by using the data you are bound by the NCES data use agreement, which prohibits any attempt to determine the identity
# of any student in the datasets.
 
# Each row in the datasets pisa2009train.csv and pisa2009test.csv represents one student taking the exam. 
# The datasets have the following variables:
#   
# grade: The grade in school of the student (most 15-year-olds in America are in 10th grade)
# 
# male: Whether the student is male (1/0)
# 
# raceeth: The race/ethnicity composite of the student
# 
# preschool: Whether the student attended preschool (1/0)
# 
# expectBachelors: Whether the student expects to obtain a bachelor's degree (1/0)
# 
# motherHS: Whether the student's mother completed high school (1/0)
# 
# motherBachelors: Whether the student's mother obtained a bachelor's degree (1/0)
# 
# motherWork: Whether the student's mother has part-time or full-time work (1/0)
# 
# fatherHS: Whether the student's father completed high school (1/0)
# 
# fatherBachelors: Whether the student's father obtained a bachelor's degree (1/0)
# 
# fatherWork: Whether the student's father has part-time or full-time work (1/0)
# 
# selfBornUS: Whether the student was born in the United States of America (1/0)
# 
# motherBornUS: Whether the student's mother was born in the United States of America (1/0)
# 
# fatherBornUS: Whether the student's father was born in the United States of America (1/0)
# 
# englishAtHome: Whether the student speaks English at home (1/0)
# 
# computerForSchoolwork: Whether the student has access to a computer for schoolwork (1/0)
# 
# read30MinsADay: Whether the student reads for pleasure for 30 minutes/day (1/0)
# 
# minutesPerWeekEnglish: The number of minutes per week the student spend in English class
# 
# studentsInEnglish: The number of students in this student's English class at school
# 
# schoolHasLibrary: Whether this student's school has a library (1/0)
# 
# publicSchool: Whether this student attends a public school (1/0)
# 
# urban: Whether this student's school is in an urban area (1/0)
# 
# schoolSize: The number of students in this student's school
#
# readingScore: The student's reading score, on a 1000-point scale

# PROBLEM 1.1 - DATASET SIZE  (1 point possible)
# Load the training and testing sets using the read.csv() function, and save them as variables with the names pisaTrain and pisaTest.

training_dataset <- read.csv("pisa2009train.csv")
testing_dataset <- read.csv("pisa2009test.csv")

str(training_dataset) #3663 obs. of  24 variables
# How many students are there in the training set?
#3663

# PROBLEM 1.2 - SUMMARIZING THE DATASET  (2 points possible)
# Using tapply() on pisaTrain, 

tapply(training_dataset$readingScore, training_dataset$male, mean)

# What is the average reading test score of males? (Male = 1) 483.5325
# Of females? (Male = 0) 512.9406

# PROBLEM 1.3 - LOCATING MISSING VALUES  (1 point possible)
# Which variables are missing data in at least one observation in the training set? Select all that apply.

summary(training_dataset)
# We can read which variables have missing values from summary(pisaTrain). Because most variables are collected from 
# study participants via survey, it is expected that most questions will have at least one missing value.


# PROBLEM 1.4 - REMOVING MISSING VALUES  (2 points possible)
# Linear regression discards observations with missing data, so we will remove all such observations from the training and testing sets.
# Later in the course, we will learn about imputation, which deals with missing data by filling in missing values with plausible
# information.
# 
# Type the following commands into your R console to remove observations with any missing value from pisaTrain and pisaTest:

training_dataset = na.omit(training_dataset)
testing_dataset = na.omit(testing_dataset)
str(training_dataset)
str(testing_dataset)

# How many observations are now in the training set? 2414 obs.
# How many observations are now in the testing set? 990 obs.

# PROBLEM 2.1 - FACTOR VARIABLES  (2 points possible)
# Factor variables are variables that take on a discrete set of values, like the "Region" variable in the WHO dataset 
# from the second lecture of Unit 1. This is an unordered factor because there isn't any natural ordering between the levels. 
# An ordered factor has a natural ordering between the levels (an example would be the classifications "large," "medium," and "small").

summary(training_dataset$grade)
summary(training_dataset$male)
summary(training_dataset$raceeth)

# Which of the following variables is an unordered factor with at least 3 levels? (Select all that apply.)
# (grade male raceeth) Answer: raceeth 

# Which of the following variables is an ordered factor with at least 3 levels? (Select all that apply.)
# (grade male raceeth) Answer: grade

# Male only has 2 levels (1 and 0). There is no natural ordering between the different values of raceeth, 
# so it is an unordered factor. Meanwhile, we can order grades (8, 9, 10, 11, 12), so it is an ordered factor.

# PROBLEM 2.2 - UNORDERED FACTORS IN REGRESSION MODELS  (1 point possible)
# To include unordered factors in a linear regression model, we define one level as the "reference level" and add a 
# binary variable for each of the remaining levels. In this way, a factor with n levels is replaced by n-1 binary variables. 
# The reference level is typically selected to be the most frequently occurring level in the dataset.

# As an example, consider the unordered factor variable "color", with levels "red", "green", and "blue". 
# If "green" were the reference level, then we would add binary variables "colorred" and "colorblue" to a linear regression problem. 
# All red examples would have colorred=1 and colorblue=0. 
# All blue examples would have colorred=0 and colorblue=1. 
# All green examples would have colorred=0 and colorblue=0.

# Now, consider the variable "raceeth" in our problem, which has levels 
# American Indian/Alaska Native", "Asian", "Black", "Hispanic", "More than one race", "Native Hawaiian/Other Pacific Islander", 
# and "White". Because it is the most common in our population, we will select "White" as the reference level.

# Which binary variables will be included in the regression model?
# White (Default)
# American Indian/Alaska Native", 
# Asian", 
# "Black", 
# "Hispanic", 
# "More than one race", 
# "Native Hawaiian/Other Pacific Islander"

#We create a binary variable for each level except the reference level, so we would create all these variables except for raceethWhite.

# PROBLEM 2.3 - EXAMPLE UNORDERED FACTORS  (2 points possible)
# Consider again adding our unordered factor race to the regression model with reference level "White".

# For a student who is Asian, which binary variables would be set to 0? All remaining variables will be set to 1.
# American Indian/Alaska Native", 
# Asian", - the only one set to 1
# "Black", 
# "Hispanic", 
# "More than one race", 
# "Native Hawaiian/Other Pacific Islander"

# For a student who is white, which binary variables would be set to 0? All remaining variables will be set to 1. 
#All set to 0

# An Asian student will have raceethAsian set to 1 and all other raceeth binary variables set to 0. Because "White" is 
# the reference level, a white student will have all raceeth binary variables set to 0.

# PROBLEM 3.1 - BUILDING A MODEL  (2 points possible)
# Because the race variable takes on text values, it was loaded as a factor variable when we read in the dataset with read.csv() -- 
# you can see this when you run str(pisaTrain) or str(pisaTest). However, by default R selects the first level alphabetically
# ("American Indian/Alaska Native") as the reference level of our factor instead of the most common level ("White"). 

str(training_dataset$raceeth)
summary(training_dataset$raceeth)

#Set the reference level of the factor by typing the following two lines in your R console:
training_dataset$raceeth = relevel(training_dataset$raceeth, "White")
testing_dataset$raceeth = relevel(testing_dataset$raceeth, "White")

# Now, build a linear regression model (call it lmScore) using the training set to predict readingScore using all the 
# remaining variables.
# It would be time-consuming to type all the variables, but R provides the shorthand notation "readingScore ~ ." to mean 
# "predict readingScore using all the other variables in the data frame." The period is used to replace listing out all 
# of the independent variables. As an example, if your dependent variable is called "Y", your independent variables are called
# "X1", "X2", and "X3", and your training data set is called "Train", instead of the regular notation:
#   
#   LinReg = lm(Y ~ X1 + X2 + X3, data = Train)
# 
# You would use the following command to build your model:
#   
#   LinReg = lm(Y ~ ., data = Train)

lmScore <- lm(readingScore ~ ., data = training_dataset)
summary(lmScore)

# What is the Multiple R-squared value of lmScore on the training set? 0.3251

# Note that this R-squared is lower than the ones for the models we saw in the lectures and recitation. 
# This does not necessarily imply that the model is of poor quality. More often than not, it simply means that the prediction
# problem at hand (predicting a student's test score based on demographic and school-related variables) is more difficult than
# other prediction problems (like predicting a team's number of wins from their runs scored and allowed, or predicting the quality
# of wine from weather conditions).

# PROBLEM 3.2 - COMPUTING THE ROOT-MEAN SQUARED ERROR OF THE MODEL (1 point possible)
# What is the training-set root-mean squared error (RMSE) of lmScore? Answer: 73.36555

#RMSE = sqrt(SSE/ N)
#SSE = sum error^2
SSE <- sum(lmScore$residuals^2)
RMSE <- sqrt(SSE / nrow(training_dataset)); RMSE

# EXPLANATION
# 
# The training-set RMSE can be computed by first computing the SSE:
#   
#   SSE = sum(lmScore$residuals^2)
# 
# and then dividing by the number of observations and taking the square root:
#   
#   RMSE = sqrt(SSE / nrow(pisaTrain))
# 
# A alternative way of getting this answer would be with the following command:
#   
#   sqrt(mean(lmScore$residuals^2)).

# PROBLEM 3.3 - COMPARING PREDICTIONS FOR SIMILAR STUDENTS  (1 point possible)
# Consider two students A and B. They have all variable values the same, except that student A is in grade 11 and student B 
# is in grade 9. What is the predicted reading score of student A minus the predicted reading score of student B?

#readingScoreA = delta + 29.542707 * 11
#readingScoreB = delta + 29.542707 * 9
#readingScoreA - readingScoreB = (11 - 9) * 29.542707

# EXPLANATION
# 
# The coefficient 29.54 on grade is the difference in reading score between two students who are identical other than having a 
# difference in grade of 1. Because A and B have a difference in grade of 2, the model predicts that student A has a reading 
# score that is 2*29.54 larger.

# PROBLEM 3.4 - INTERPRETING MODEL COEFFICIENTS  (1/1 point)
# What is the meaning of the coefficient associated with variable raceethAsian?
#Predicted difference in the reading score between an Asian student and a white student who is otherwise identical

# EXPLANATION
# The only difference between an Asian student and white student with otherwise identical variables is that the former 
# has raceethAsian=1 and the latter has raceethAsian=0. The predicted reading score for these two students will differ
# by the coefficient on the variable raceethAsian.

# PROBLEM 3.5 - IDENTIFYING VARIABLES LACKING STATISTICAL SIGNIFICANCE (1 point possible)
# Based on the significance codes, which variables are candidates for removal from the model? Select all that apply. 
# (We'll assume that the factor variable raceeth should only be removed if none of its levels are significant.)

summary(lmScore)
#Explanation
# From summary(lmScore), we can see which variables were significant at the 0.05 level. Because several of the binary 
# variables generated from the race factor variable are significant, we should not remove this variable.

# PROBLEM 4.1 - PREDICTING ON UNSEEN DATA  (2 points possible)
# Using the "predict" function and supplying the "newdata" argument, use the lmScore model to predict the reading 
# scores of students in pisaTest. Call this vector of predictions "predTest". Do not change the variables in the model 
# (for example, do not remove variables that we found were not significant in the previous part of this problem). 
# Use the summary function to describe the test set predictions.

predTest <- predict(lmScore, newdata = testing_dataset)
summary(predTest)
# What is the range between the maximum and minimum predicted reading score on the test set?
#284.5

# EXPLANATION
# 
# We can obtain the predictions with:
#   
#   predTest = predict(lmScore, newdata=pisaTest)
# 
# From summary(predTest), we see that the maximum predicted reading score is 637.7, and the minimum predicted score is 353.2. 
# Therefore, the range is 284.5.

# PROBLEM 4.2 - TEST SET SSE AND RMSE  (2 points possible)
# What is the sum of squared errors (SSE) of lmScore on the testing set?
SSE <- sum((testing_dataset$readingScore - predTest)^2); SSE

# What is the root-mean squared error (RMSE) of lmScore on the testing set?
SST = sum((testing_dataset$readingScore - mean(training_dataset$readingScore))^2) #base model is the average - the TRAINING set
1 - SSE/SST #R^2
sqrt(SSE/ nrow(testing_dataset)) #RMSE

# EXPLANATION
# 
# This can be calculated with sqrt(mean((predTest-pisaTest$readingScore)^2)).

#Baseline Model for the predicted test scores
x <- mean(training_dataset$readingScore) #based on training data
#sum of squared errors of the baseline model on the testing set? HINT: We call the sum of squared errors 
# for the baseline model the total sum of squares (SST).
sum((testing_dataset$readingScore - x)^2)

# PROBLEM 4.4 - TEST-SET R-SQUARED  (1 point possible)
# What is the test-set R-squared value of lmScore?
SSE <- sum((testing_dataset$readingScore - predTest)^2); SSE
SST = sum((testing_dataset$readingScore - mean(training_dataset$readingScore))^2) #base model is the average - the TRAINING set
1 - SSE/SST #R^2

# EXPLANATION
# 
# The test-set R^2 is defined as 1-SSE/SST, where SSE is the sum of squared errors of the model on the test set and SST 
#is the sum of squared errors of the baseline model. For this model, the R^2 is then computed to be 1-5762082/7802354.

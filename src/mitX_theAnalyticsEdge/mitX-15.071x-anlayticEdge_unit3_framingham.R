# (See slides from the Framingham Heart Study)

# Now that we have identified a set of risk factors,
# let's use this data to predict the 10 year risk of CHD.

# First, we'll randomly split our patients
# into a training set and a testing set.

# Then, we'll use logistic regression
# to predict whether or not a patient experienced CHD
# within 10 years of the first examination.

# Keep in mind that all of the risk factors
# were collected at the first examination of the patients.

# After building our model, we'll evaluate the predictive power
# of the model on the test set.

# Let's go to R and create our logistic regression model.
# In our R console, we'll call our data set framingham
# and use the read.csv function to read in the data file
# "framingham.csv".

framingham <- read.csv("framingham.csv")

# Remember to navigate to the directory containing
# the file "framingham.csv" before reading in the data.
# Let's take a look at our data by using the str function.

str(framingham)

# We have data for 4,240 patients and 16 variables.
# We have the demographic risk factors male, age,
# and education; the behavioral risk
# factors currentSmoker and cigsPerDay;
# the medical history risk factors BPMeds, prevalentStroke,
# prevalentHyp, and diabetes; and the physical exam risk
# factors totChol, sysBP, diaBP, BMI, heartRate, and glucose
# level.

# The last variable is the outcome or dependent variable,
# whether or not the patient developed
# CHD in the next 10 years.

# Now let's split our data into a training set and a testing set
# using sample.split like we did in the previous lecture.
# We first need to load the library caTools.

library(caTools)

# Now, let's set our seed and create our split.
# We'll start by setting our seed to 1000,

set.seed(1000)

# and then use the sample.split function to create the split.

split <- sample.split(framingham$TenYearCHD, , SplitRatio = 0.65)

# The first argument is the outcome variable
# framingham$TenYearCHD.
# And the second argument is the percentage of data
# that we want in the training set or the SplitRatio.

# Here, we'll put 65% of the data in the training set.
# When you have more data like we do here,
# you can afford to put less data in the training set
# and more in the testing set.
# This will increase our confidence
# in the ability of the model to extend to new data
# since we have a larger test set, and still
# give us enough data in the training set
# to create our model.

# You typically want to put somewhere between 50% and 80%
# of the data in the training set.

# Now, let's split up our data using subset.
# We'll call our training set "train"
# and use the subset function to take a subset of framingham
# and take the observations for which split is equal to TRUE.
# We'll call our testing set "test"
# and again use the subset function
# to take a subset of framingham and take
# the observations for which split equals FALSE.

train <- subset(framingham, split == TRUE)
test <- subset(framingham, split == FALSE)

# Now we're ready to build our logistic regression
# model using the training set.

# Let's call it framinghamLog, and we'll use the glm function
# like we did in the previous lecture
# to create a logistic regression model.
# We'll use a nice little trick here
# where we predict our dependent variable
# using all of the other variables in the data set
# as independent variables.
# First, type the name of the dependent variable,
# TenYearCHD, followed by the tilde and then a period.
# This will use all of the other variables
# in the data set as independent variables
# and is used in place of listing out
# all of the independent variables' names separated
# by the plus sign.
# Be careful doing this with data sets
# that have identifying variables like a patient ID
# or name since you wouldn't want to use
# these as independent variables.
# Following the period, we need to give the argument
# that defines the data set to use, data = train.
# And then, the final argument for a logistic regression model
# is family = binomial.

framinghamLog <- glm(TenYearCHD ~ ., data = framingham, family = binomial)

# Let's take a look at the summary of our model.

summary(framinghamLog)

# It looks like male, age, prevalent stroke,
# total cholesterol, systolic blood pressure, and glucose
# are all significant in our model.
# Cigarettes per day and prevalent hypertension
# are almost significant.
# All of the significant variables have positive coefficients,
# meaning that higher values in these variables
# contribute to a higher probability
# of 10-year coronary heart disease.

# Now, let's use this model to make predictions
# on our test set.
# We'll call our predictions predictTest
# and use the predict function, which
# takes as arguments the name of our model, framinghamLog,
# then type = "response", which gives us probabilities,
# and lastly newdata = test, the name of our testing set.

predictTest <- predict(framinghamLog, type = "response", newdata = test)

# Now, let's use a threshold value of 0.5
# to create a confusion matrix.

# We'll use the table function and give as the first argument,
# the actual values, test$TenYearCHD,
# and then as the second argument our predictions,
# predictTest > 0.5.

table(test$TenYearCHD, predictTest > 0.5)

# With a threshold of 0.5, we predict an outcome of 1,
# the true column, very rarely.
# This means that our model rarely predicts a 10-year CHD
# risk above 50%.

# What is the accuracy of this model?
# Well, it's the sum of the cases we get right, 1070 plus 20,
# divided by the total number of observations in our data
# set, 1070 + 5 + 178 + 20.
(1070 + 20) / (1070 + 5 + 178 + 20)

# So the accuracy of our model is about 85.6%.
# We need to compare this to the accuracy of a simple baseline
# method.

# The more frequent outcome in this case is 0,
# so the baseline method would always predict 0 or no CHD.

# This baseline method would get an accuracy of 1070
# + 5-- this is the total number of true negative cases--
#     divided by the total number of observations in our data
# set, 1070 + 5 + 178 + 20.

(1070 + 5) / (1070 + 5 + 178 + 20)

# So the baseline model would get an accuracy of about 84.4%.
# So our model barely beats the baseline in terms of accuracy.

# But do we still have a valuable model by varying the threshold?
# Let's compute the out-of-sample AUC.

# To do this, we first need to load the ROCR package.
# And then, we'll use the prediction function
# of the ROCR package to make our predictions.

library(ROCR)
# Let's call the output of that ROCRpred and use the prediction
# function, which takes as a first argument our predictions,
# predictTest, and then as a second argument the true
# outcome, test$TenYearCHD.
# Then, we need to type as.numeric(performance(ROCRpred,
# "auc")@y.values).

ROCRpred <- prediction(predictTest, test$TenYearCHD)
as.numeric(performance(ROCRpred, "auc")@y.values)

# This will give us the AUC value on our testing set.
# So we have an AUC of about 75% on our test set,
# which means that the model can differentiate between low risk
# patients and high risk patients pretty well.

# As we saw in R, we were able to build a logistic regression
# model with a few interesting properties.
# It rarely predicted 10-year CHD risk above 50%.
# So the accuracy of the model was very close to the baseline
# model.
# However, the model could differentiate between low risk
# patients and high risk patients pretty well
# with an out-of-sample AUC of 0.75.
# Additionally, some of the significant variables
# suggest possible interventions to prevent CHD.
# We saw that more cigarettes per day, higher cholesterol, higher
# systolic blood pressure, and higher glucose levels
# all increased risk.
# Later in the lecture, we'll discuss
# some medical interventions that are currently
# used to prevent CHD.



# So far, we have used what is known as internal validation
# to test our model.
# This means that we took the data from one set of patients
# and split them into a training set and a testing set.
# While this confirms that our model is
# good at making predictions for patients in the Framingham
# Heart Study population, it's unclear
# if the model generalizes to other populations.
# The Framingham cohort of patients
# were white, middle class adults.
# To be sure that the model extends
# to other types of patients, we need
# to test on other populations.
# This is known as external validation.
# 
# There have been many studies to test the Framingham model
# from the influential 1998 paper on diverse cohorts.
# This table shows a sample of studies
# that tested the model on populations
# with different races.
# The researchers for each study collected the same risk
# factors used in the original study,
# predicted CHD using the Framingham Heart Study model,
# and then analyzed how accurate the model
# was for that population.
# For some populations, the Framingham model was accurate.
# For the ARIC study that tested the model with black men,
# this figure shows a bar graph of how the Framingham predictions
# compare with the actual results.
# The gray bars are the predictions.
# And the black bars are the actual outcomes.
# The patients are sorted on the x-axis by predicted risk
# and on the y-axis by the percentage of patients
# in each group who actually developed CHD.
# For the most part, the predictions are accurate.
# There's one group for which the model under-predicted the risk
# and one group for which the model over-predicted the risk.
# But for other populations, the Framingham model
# was not as accurate.
# For the HHS study with Japanese-American men,
# the Framingham model systematically
# over-predicts a risk of CHD.
# 
# The model can be recalibrated for this population
# by scaling down the predictions.
# This changes the predicted risk but not
# the order of the predictions.
# The high risk patients still have higher predictions
# than the lower risk patients.
# This allows the model to have more accurate risk estimates
# for populations not included in the original group of patients.
# For models that will be used on different populations
# than the one used to create the model,
# external validation is critical.



# We next discuss interventions suggested
# by the model developed for the Framingham Heart Study.
# 
# The first intervention has to do with drugs
# to lower blood pressure.
# In FDR's time, hypertension drugs
# were too toxic for practical use.
# But in the 1950s, the diuretic chlorothiazide was developed,
# and the Framingham Heart Study gave Ed Freis
# the evidence needed to argue for testing effects for blood
# pressure drugs.
# In fact, the Veterans Administration Trial
# was conducted.
# This was a randomized, double blind clinical trial,
# that found decreased risk of coronary heart disease.
# Now, the market for diuretics worldwide
# is more than a billion dollars.
# Another intervention had to do with-- to lower cholesterol.
# Despite the Framingham results, early cholesterol drugs
# were too toxic for practical use.
# But in the 1970s, the first statins were developed.
# The study of 4,444 patients with CHD
# revealed that statins cause a 37% risk
# reduction of a second heart attack.
# Furthermore, a study of 6,595 men with high cholesterol
# revealed that statins cause a 32% risk reduction in deaths.
# Now, the market for statins worldwide
# is more than $20 billion.


# Let us next examine the impact that the Framingham Heart
# Study had through the years.
# 
# So the graph on the right shows the number
# of papers written every year using data
# from the Framingham Study as a function of time,
# and we observe the very significant increase
# in the number of such publications.
# Altogether, there has been 2,400 studies
# written using the Framingham data.
# During the years, many other risk factors were evaluated.
# Obesity, exercise, psychological,
# and social issues.
# In fact, the Texas Heart Institute Journal
# named the Framingham Heart Study as the top 10 cardiology
# advance of the 20th century.
# 
# In addition to the study, there has
# been an online tool that assesses
# the risk for your 10-year risk of having a heart attack.
# So you input in this online tool your age, your gender,
# the total cholesterol, the HDL cholesterol,
# whether or not you are a smoker, the systolic blood pressure,
# and then it calculates your 10-year risk.
# So how about new research directions and challenges
# that the study is facing?
# 
# So currently, we are in the third generation that
# started in 2002, but there was also a second generation
# study of people enrolled in 1971,
# and the third started in 2002.
# As a result, this enables the study
# to examine family history as a risk factor.
# More diverse cohorts started in 1994 and 2003.
# In addition to the classical measures we have used so far,
# social network analysis of the participants
# has also been utilized.
# And additionally and quite importantly,
# genome -wide association study is underway linking genetics
# to heart conditions as a risk factor.
# Of course, many challenges are related to funding.
# Funding cuts in 1969 nearly closed the study,
# and the 2013 sequester is threatening
# to close the study as well.
# 
# A very important impact of the Framingham Heart Study
# is the development of clinical decision rules.
# The early work on the study paved the way
# for clinical decision rules as it is done today.
# And the graph shows the clinical prediction rules
# published as a function of the year from 1960s to today.
# And you observe that more than 70,000 published rules,
# clinical decision rules, have been published across medicine,
# and you observe that the rate of publication is increasing.
# So these clinical decision rules are
# developed using patient and disease characteristics,
# and then observed test results from patients
# that can assess the effectiveness of such rules.
# 

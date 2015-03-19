# The variables in the dataset quality.csv are as follows:    
# MemberID numbers the patients from 1 to 131, and is just an identifying number.
# InpatientDays is the number of inpatient visits, or number of days the person spent in the hospital.
# ERVisits is the number of times the patient visited the emergency room.
# OfficeVisits is the number of times the patient visited any doctor's office.
# Narcotics is the number of prescriptions the patient had for narcotics.
# DaysSinceLastERVisit is the number of days between the patient's last emergency room visit and the end of the study period (set to the length of the study period if they never visited the ER). 
# Pain is the number of visits for which the patient complained about pain.
# TotalVisits is the total number of times the patient visited any healthcare provider.
# ProviderCount is the number of providers that served the patient.
# MedicalClaims is the number of days on which the patient had a medical claim.
# ClaimLines is the total number of medical claims.
# StartedOnCombination is whether or not the patient was started on a combination of drugs to treat their diabetes (TRUE or FALSE).
# AcuteDrugGapSmall is the fraction of acute drugs that were refilled quickly after the prescription ran out.
# PoorCare is the outcome or dependent variable, and is equal to 1 if the patient had poor care, and equal to 0 if the patient had good care.

# In this video we learned how to use the sample.split() function from the caTools package to split data for a classification problem, balancing the positive and negative observations in the training and testing sets.
# 
# If you wanted to instead split a data frame data, where the dependent variable is a continuous outcome (this was the case for all the datasets we used last week), you could instead use the sample() function. Here is how to select 70% of observations for the training set (called "train") and 30% of observations for the testing set (called "test"):
#     
# spl = sample(1:nrow(data), size=0.7 * nrow(data))
# 
# train = data[spl,]
# 
# test = data[-spl,]


####################################
# (see slide) This plot shows two of our independent variables,
# the number of office visits on the x-axis
# and the number of narcotics prescribed on the y-axis.
# Each point is an observation or a patient in our data set.
# The red points are patients who received poor care,
# and the green points are patients
# who received good care.
# It's hard to see a trend in the data
# by just visually inspecting it.
# But it looks like maybe more office visits and more
# narcotics, or data points to the right of this line,
# are more likely to have poor care.
# Let's see if we can build a logistic regression model in R
# to better predict poor care.

# In our R console, let's start by reading
# our data set into R. Remember to navigate
# to the directory on your computer
# containing the file quality.csv.
# We'll call our data set "quality"
# and use the read.csv function to read in the data file
# quality.csv.

quality <- read.csv("quality.csv")

# Let's take a look at the structure
# of our data set by using the str function.

str(quality)

# We have 131 observations, one for each
# of the patients in our data set, and 14 different variables.
# MemberID just numbers the patients from 1 to 131.
# The 12 variables from InpatientDays
# to AcuteDrugGapSmall are the independent variables.

# We'll be using the number of office visits
# and the number of prescriptions for narcotics
# that the patient had.
# But you can read descriptions of all
# of the independent variables below this video.
# After the lecture, try building models
# with different subsets of independent variables
# to see what the best model is that you can find.
# The final variable, PoorCare, is our outcome
# or dependent variable and is equal to 1
# if the patient had poor care and equal to 0
# if the patient had good care.
# Let's see how many patients received poor care
# and how many patients received good care
# by using the table function.

# Let's make a table of our outcome variable PoorCare.

table(quality$PoorCare)

# We can see that 98 out of the 131 patients in our data set
# received good care, or 0, and 33 patients received poor care,
# or those labeled with 1.

# Before building any models, let's consider
# using a simple baseline method.
# Last week when we computed the R-squared
# for linear regression, we compared our predictions
# to the baseline method of predicting the average outcome
# for all data points.

# In a classification problem, a standard baseline method
# is to just predict the most frequent outcome
# for all observations.
# Since good care is more common than poor care, in this case,
# we would predict that all patients
# are receiving good care.
# If we did this, we would get 98 out
# of the 131 observations correct, or have
# an accuracy of about 75%.
# So our baseline model has an accuracy of 75%.
# This is what we'll try to beat with our logistic regression
# model.

# Last week, we always gave you the training data set
# and the testing data set in separate files.
# This week, we only have one data set.
# So we want to randomly split our data set into a training set
# and testing set so that we'll have a test set
# to measure our out-of-sample accuracy.
# To do this, we need to add a new package to R.
# There are many functions and algorithms built into R,
# but there are many more that you can install.
# We'll do this several times throughout this course.
# First, let's install the new package using
# the install.packages function and then give
# the name of the package we want to install in quotes.
# In this case, it's caTools.

install.packages("caTools")

# Use the library function.
# So type library and then in parentheses
# the name of our package, caTools.
# Sometimes you'll get a warning message
# based on the version of R that you're using.
# This can usually safely be ignored.

library(caTools)

# Now, let's use this package to randomly split our data
# into a training set and testing set.
# We'll do this using a function sample.split which
# is part of the caTools package.
# Since sample.split randomly splits your data,
# it could split it differently for each of us.
# To make sure that we all get the same split, we'll set our seed.
# This initializes the random number generator.

set.seed(88)

# Now, let's use sample.split.
# Type split = sample.split, and then
# in parentheses, we need to give two arguments.
# The first is our outcome variable or quality$PoorCare,
# and the second argument is the percentage of the data that we
# want in the training set.
# We type SplitRatio equals, and in this case,
# we'll put 75% of the data in the training set, which we'll
# use to build the model, and 25% of the data in the testing
# set to test our model.Sample.split randomly splits the data.

split = sample.split(quality$PoorCare, SplitRatio = 3/4)

# But it also makes sure that the outcome variable
# is well-balanced in each piece.

# We saw earlier that about 75% of our patients
# are receiving good care.
# This function makes sure that in our training set,
# 75% of our patients are receiving good care
# and in our testing set 75% of our patients
# are receiving good care.
# We want to do this so that our test set is representative
# of our training set.


# Let's take a look at split.

split

# There is a TRUE or FALSE value for each of our observations.
# TRUE means that we should put that observation
# in the training set, and FALSE means
# that we should put that observation in the testing set.

# So now let's create our training and testing
# sets using the subset function.
# We'll call our training set qualityTrain
# and use the subset function to take a subset of quality
# and only taking the observations for which
# split is equal to TRUE.

qualityTrain <- quality[split,] #or qualityTrain <- subset(quality, split == TRUE)

# We'll call our testing set qualityTest
# and, again, use the subset function
# to take the observations of quality,
# but this time those for which split is equal to FALSE.

qualityTest <- quality[!split,] #or qualityTest <- subset(quality, split == FALSE)

str(qualityTest)
str(qualityTrain)

# If you look at the number of rows in each of our data sets,
# the training set and then the testing set,
# you can see that there are 99 observations in the training
# set and 32 observations in the testing set.
# Now, we are ready to build a logistic regression
# model using OfficeVisits and Narcotics
# as independent variables.


# We'll call our model QualityLog and use the "glm" function
# for "generalized linear model" to build
# our logistic regression model.

QualityLog <- glm(PoorCare ~ OfficeVisits + Narcotics, data = qualityTrain, family= binomial)

# We start by giving the equation we
# want to build just like in linear regression.
# We start with the dependent variable, and then
# the tilde sign, and then the independent variables
# we want to use separated by the plus sign.
# We then give the name of the data
# set we want to use to build the model,
# in this case, qualityTrain.
# For a logistic regression model, we need one last argument,
# which is family=binomial.

# This tells the glm function to build a logistic regression
# model.
# Now, let's look at our model using the summary function.

summary(QualityLog)

# The output looks similar to that of a linear regression model.
# What we want to focus on is the coefficients table.
# This gives the estimate values for the coefficients,
# or the betas, for our logistic regression model.
# We see here that the coefficients for OfficeVisits
# and Narcotics are both positive, which
# means that higher values in these two variables
# are indicative of poor care as we
# suspected from looking at the data.
# We also see that both of these variables
# have at least one star, meaning that they're
# significant in our model.

# The last thing we want to look at in the output
# is the AIC value.
# This is a measure of the quality of the model
# and is like Adjusted R-squared in that it accounts
# for the number of variables used compared
# to the number of observations.
# Unfortunately, it can only be compared
# between models on the same data set.
# But it provides a means for model selection.
# The preferred model is the one with the minimum AIC.


# Now, let's make predictions on the training set.
# We'll call them predictTrain and use the predict function
# to make predictions using the model QualityLog,
# and we'll give a second argument,
# which is type="response".

predicTrain <- predict(QualityLog, type="response")

# This tells the predict function to give us probabilities.
# Let's take a look at the statistical summary
# of our predictions.

summary(predicTrain)

# Since we're expecting probabilities,
# all of the numbers should be between zero and one.
# And we see that the minimum value is about 0.07
# and the maximum value is 0.98.
# Let's see if we're predicting higher probabilities
# for the actual poor care cases as we expect.

# To do this, use the tapply function,
# giving as arguments predictTrain and then QualityTrain$PoorCare
# and then mean.
# This will compute the average prediction
# for each of the true outcomes.

tapply(predicTrain, qualityTrain$PoorCare, mean)

# So we see that for all of the true poor care cases,
# we predict an average probability of about 0.44.
# And all of the true good care cases,
# we predict an average probability of about 0.19.
# So this is a good sign, because it
# looks like we're predicting a higher
# probability for the actual poor care cases.

##### QUICK QUESTION
# In R, create a logistic regression model to predict "PoorCare" 
# using the independent variables "StartedOnCombination" and 
# "ProviderCount". Use the training set we created in the previous video 
# to build the model.

QualityLog2 <- glm(PoorCare ~ StartedOnCombination + ProviderCount, data=qualityTrain, family=binomial)
summary(QualityLog2)
#StartedOnCombination: 1.95230

# StartedOnCombination is a binary variable, which equals 1 if the patient
# is started on a combination of drugs to treat their diabetes, and equals
# 0 if the patient is not started on a combination of drugs. All else 
# being equal, does this model imply that starting a patient on a 
# combination of drugs is indicative of poor care, or good care?

# EXPLANATION
# The coefficient value is positive, meaning that positive values of the 
# variable make the outcome of 1 more likely. This corresponds to Poor Care.

# next:: we'll discuss how to assess the accuracy of our predictions.
#### THRESHOLDING

# (See slides) We saw in the previous video that the outcome
# of a logistic regression model is a probability.
# Often, we want to make an actual prediction.
# Should we predict 1 for poor care,
# or should we predict 0 for good care?
# We can convert the probabilities to predictions
# using what's called a threshold value, t.

# If the probability of poor care is greater than this threshold
# value, t, we predict poor quality care.
# But if the probability of poor care
# is less than the threshold value,
# t, then we predict good quality care.

# But what value should we pick for the threshold, t?
# The threshold value, t, is often selected
# based on which errors are better.

# You might be thinking that making no errors
# is better, which is, of course, true.
# But it's rare to have a model that predicts perfectly,
# so you're bound to make some errors.

# There are two types of errors that a model can make --
# ones where you predict 1, or poor care,
# but the actual outcome is 0, and ones where you predict 0,
# or good care, but the actual outcome is 1.
# If we pick a large threshold value t,
# then we will predict poor care rarely,
# since the probability of poor care
# has to be really large to be greater than the threshold.
# This means that we will make more errors where
# we say good care, but it's actually poor care.
# This approach would detect the patients receiving the worst
# care and prioritize them for intervention.
# On the other hand, if the threshold value, t, is small,
# we predict poor care frequently, and we predict good care
# rarely.
# This means that we will make more errors where
# we say poor care, but it's actually good care.
# This approach would detect all patients
# who might be receiving poor care.
# Some decision-makers often have a preference
# for one type of error over the other,
# which should influence the threshold value they pick.

# If there's no preference between the errors,
# the right threshold to select is t = 0.5,
# since it just predicts the most likely outcome.

# To make this discussion a little more quantitative,
# we use what's called a confusion matrix or classification
# matrix.
# This compares the actual outcomes
# to the predicted outcomes.
# The rows are labeled with the actual outcome,
# and the columns are labeled with the predicted outcome.
# Each entry of the table gives the number of data
# observations that fall into that category.
# So the number of true negatives, or TN,
# is the number of observations that are actually
# good care and for which we predict good care.
# The true positives, or TP, is the number
# of observations that are actually
# poor care and for which we predict poor care.
# These are the two types that we get correct.
# The false positives, or FP, are the number of data points
# for which we predict poor care, but they're actually good care.
# And the false negatives, or FN, are the number of data points
# for which we predict good care, but they're actually poor care.

# We can compute two outcome measures
# that help us determine what types of errors we are making.
# They're called sensitivity and specificity.
# 
# Sensitivity is equal to the true positives
# divided by the true positives plus the false negatives,
# and measures the percentage of actual poor care cases
# that we classify correctly.
# This is often called the true positive rate.

# Specificity is equal to the true negatives
# divided by the true negatives plus the false positives,
# and measures the percentage of actual good care cases
# that we classify correctly.
# This is often called the true negative rate.

# A model with a higher threshold will have a lower sensitivity
# and a higher specificity.
# A model with a lower threshold will have a higher sensitivity
# and a lower specificity.

# Let's compute some confusion matrices
# in R using different threshold values.
# In our R console, let's make some classification tables
# using different threshold values and the table function.

# First, we'll use a threshold value of 0.5.
# So type table, and then the first argument,
# or what we want to label the rows by, should be the true
# outcome, which is qualityTrain$PoorCare.
# And then the second argument, or what
# we want to label the columns by, will
# be predictTrain, or our predictions
# from the previous video, greater than 0.5.

table(qualityTrain$PoorCare, predicTrain > 0.5)

#     FALSE TRUE
# 0    70    4
# 1    15   10

# This will return TRUE if our prediction is greater than 0.5,
# which means we want to predict poor care,
# and it will return FALSE if our prediction is less than 0.5,
# which means we want to predict good care.
# If you hit Enter, we get a table where the rows are labeled
# by 0 or 1, the true outcome, and the columns
# are labeled by FALSE or TRUE, our predicted outcome.
# So you can see here that for 70 cases, we predict good care
# and they actually received good care, and for 10 cases,
# we predict poor care, and they actually received poor care.
# We make four mistakes where we say poor care
# and it's actually good care, and we make 15 mistakes where
# we say good care, but it's actually poor care.

# Let's compute the sensitivity, or the true positive rate,
# and the specificity, or the true negative rate.

sensitivity <- 10 /(10 + 15)

# The sensitivity here would be 10, our true positives,
# divided by 25 the total number of positive cases.
# So we have a sensitivity of 0.4.

specificty <- 70/ (4 + 70)

# Our specificity here would be 70, the true negative cases,
# divided by 74, the total number of negative cases.
# So our specificity here is about 0.95.

# Now, let's try increasing the threshold.
# Use the up arrow to get back to the table command,
# and change the threshold value to 0.7.

table(qualityTrain$PoorCare, predicTrain > 0.7)
#     FALSE TRUE
# 0    73    1
# 1    17    8

# Now, if we compute our sensitivity,
# we get a sensitivity of 8 divided by 25, which is 0.32.
# And if we compute our specificity,
# we get a specificity of 73 divided by 74,
# which is about 0.99.

# So by increasing the threshold, our sensitivity went down
# and our specificity went up.

# Now, let's try decreasing the threshold.
# Hit the up arrow again to get to the table function,
# and change the threshold value to 0.2.

table(qualityTrain$PoorCare, predicTrain > 0.2)
#    FALSE TRUE
# 0    54   20
# 1     9   16

# Now, if we compute our sensitivity,
# it's 16 divided by 25, or 0.64.
# And if we compute our specificity,
# it's 54 divided by 74, or about 0.73.
# So with the lower threshold, our sensitivity went up,
# and our specificity went down.

# But which threshold should we pick?
# Maybe 0.4 is better, or 0.6.
# How do we decide?
# Next:: we'll see a nice visualization
# to help us select a threshold.

###################
# (Slide) Picking a good threshold value is often challenging.
# A Receiver Operator Characteristic curve,
# or ROC curve, can help you decide
# which value of the threshold is best.
# The ROC curve for our problem is shown
# on the right of this slide.
# The sensitivity, or true positive rate of the model,
# is shown on the y-axis.
# And the false positive rate, or 1 minus the specificity,
# is given on the x-axis.

# The line shows how these two outcome measures
# vary with different threshold values.
# The ROC curve always starts at the point (0, 0).
# This corresponds to a threshold value of 1.
# If you have a threshold of 1, you
# will not catch any poor care cases,
# or have a sensitivity of 0.
# But you will correctly label of all the good care
# cases, meaning you have a false positive rate of 0.
# The ROC curve always ends at the point (1,1),
# which corresponds to a threshold value of 0.
# If you have a threshold of 0, you'll
# catch all of the poor care cases,
# or have a sensitivity of 1, but you'll
# label all of the good care cases as poor care cases
# too, meaning you have a false positive rate of 1.
# The threshold decreases as you move from (0,0) to (1,1).

# At the point (0, 0.4), or about here,
# you're correctly labeling about 40%
# of the poor care cases with a very small false positive rate.
# On the other hand, at the point (0.6, 0.9),
# you're correctly labeling about 90% of the poor care cases,
# but have a false positive rate of 60%.

# In the middle, around (0.3, 0.8),
# you're correctly labeling about 80% of the poor care cases,
# with a 30% false positive rate.


# The ROC curve captures all thresholds simultaneously.
# The higher the threshold, or closer to (0, 0),
# the higher the specificity and the lower the sensitivity.
# The lower the threshold, or closer to (1,1),
# the higher the sensitivity and lower the specificity.
# So which threshold value should you pick?

# You should select the best threshold
# for the trade-off you want to make.
# If you're more concerned with having a high specificity
# or low false positive rate, pick the threshold
# that maximizes the true positive rate
# while keeping the false positive rate really low.
# A threshold around (0.1, 0.5) on this ROC curve
# looks like a good choice in this case.
# On the other hand, if you're more concerned
# with having a high sensitivity or high true positive rate,
# pick a threshold that minimizes the false positive rate
# but has a very high true positive rate.
# A threshold around (0.3, 0.8) looks
# like a good choice in this case.
# You can label the threshold values in R
# by color-coding the curve.
# The legend is shown on the right.
# This shows us that-- say we want to pick a threshold
# value around here.
# This corresponds to between the aqua color and the green color.
# Or it looks like about a threshold of 0.3.
# Instead, if we wanted to pick a threshold around here,
# this looks like the start of the darker blue color,
# and looks like it's probably a threshold around 0.2.
# We can also add specific threshold labels
# to the curve in R. This helps you
# see which threshold value you want to use.

# Let's go into R and see how to generate these ROC curves.
# To generate ROC curves in R, we need to install a new package.
# We'll use the same two commands as we did earlier
# in the lecture, but this time the name of the package
# is ROCR.

install.packages("ROCR")

# Now let's load the package using the library function.

library(ROCR)

# Recall that we made predictions on our training set
# and called them predictTrain. We'll use these predictions to create our ROC curve.

# First, we'll call the prediction function of ROCR.
# We'll call the output of this function ROCRpred,
# and then use the prediction function.
# This function takes two arguments.
# The first is the predictions we made
# with our model, which we called predictTrain.
# The second argument is the true outcomes of our data points,
# which in our case, is qualityTrain$PoorCare.

ROCRpred <- prediction(predicTrain, qualityTrain$PoorCare)

# Now, we need to use the performance function.
# This defines what we'd like to plot
# on the x and y-axes of our ROC curve.
# We'll call the output of this ROCRperf,
# and use the performance function, which
# takes as arguments the output of the prediction function,
# and then what we want on the x and y-axes.
# In this case, it's true positive rate,
# or "tpr", and false positive rate, or "fpr".
# Now, we just need to plot the output of the performance
# function, ROCRperf.

ROCRperf <- performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf)

# You should see the ROC curve pop up in a new window.
# This should look exactly like the one we saw on the slides.
# Now, you can add colors by adding one additional argument
# to the plot function.
# So in your R console, hit the up arrow, and after ROCRperf,
# type colorize=TRUE, and hit Enter.

plot(ROCRperf, colorize = TRUE)

# If you go back to your plot window,
# you should see the ROC curve with the colors
# for the threshold values added.

# Now finally, let's add the threshold labels to our plot.
# Back in your R console, hit the up arrow again to get the plot
# function, and after colorize=TRUE,
# we'll add two more arguments.
# The first is print.cutoffs.at=seq(0,1,0.1),
# which will print the threshold values in increments of 0.1.

plot(ROCRperf, colorize = TRUE, print.cutoffs.at=seq(0,1,0.1))

# If you want finer increments, just decrease the value of 0.1.
# And then the final argument is text.adj=c(-0.2,1.7),
# and hit enter.

plot(ROCRperf, colorize = TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# If you go back to your plot window,
# you should see the ROC curve with threshold values added.
# Using this curve, we can determine which threshold value
# we want to use depending on our preferences
# as a decision-maker.
# Next:: discuss how to assess the strength of our model.

#############################


# (See Slides) Let us examine how to interpret the model we developed.
# One of the things we should look after
# is that there might be what is called multicollinearity.
# Multicollinearity occurs when the various independent
# variables are correlated, and this
# might confuse the coefficients-- the betas-- in the model.
# So tests to address that involve checking the correlations
# of independent variables.
# If they are excessively high, this
# would mean that there might be multicollinearity,
# and you have to potentially revisit the model,
# as well as whether the signs of the coefficients make sense.
# Is the coefficient beta positive or negative?
# If it agrees with intuition, then multicollinearity
# has not been a problem, but if intuition suggests
# a different sign, this might be a sign of multicollinearity.
# The next important element is significance.
# So how do we interpret the results,
# and how do we understand whether we have a good model or not?
# For that purpose, let's take a look
# at what is called Area Under the Curve, or AUC for short.
# So the Area Under the Curve shows an absolute measure
# of quality of prediction-- in this particular case, 77.5%,
# which means that, given that the perfect score is 100%,
# so this is like a B, whereas, as we'll see later,
# a 50% score, which is pure guessing,
# is a 50% rate of success.
# So the area under the curve gives an absolute measure
# of quality, and it's less affected by various benchmarks.
# 
# So it illustrates how accurate the model
# is on a more absolute sense.
# So what is a good AUC?
# The area on the right shows the maximum possible
# of a perfect prediction, whereas the area on this
# curve now-- it is 0.5, and it's pure guessing.
# Other outcome measures that are important for us to discuss
# is the so-called confusion matrix.
# So the matrix here is formulas for the various terms we use.
# 
# The actual class is 0-- means, in our example,
# good quality of care, and actual class = 1
# means poor quality of care, whereas the predicted class =
#     0 means that will predict good quality,
# and the predicted class = 1 mean that we predict poor quality.
# So we define true negatives, short by TN.
# False positives, short by FP.
# False negatives, FN, and true positives by TP.
# So if N is the number of observations,
# the overall accuracy is basically
# the number of true negatives and true positives divided by N.
# It's basically the terms in the diagonal of this two
# by two matrix divided by the total observations.
# The overall error rate is the terms off-diagonal--
# the false positives, plus the false negatives, divided
# by the total number of observations.
# That's the overall measure of an error rate.
# An important component is the so-called sensitivity,
# and sensitivity is TP, the true positives, whenever
# we predict poor quality, and indeed it
# is poor quality, divided by TP, these true positives, plus FN,
# which is the total number of cases of poor quality.
# So this is the total number of times
# that we predict poor quality, and it is, indeed,
# poor quality, versus the total number of times
# the actual quality is, in fact, poor.
# False negative rate is FN, the number of false negatives,
# divided by the number of true positives,
# plus the number of false negatives.
# And specificity is TN, true negatives,
# the number of times we predict the quality is good,
# and, in fact, the quality is good,
# divided by this number, TN, plus false positives.
# So specificity is the number of times
# we predict the quality is good, and it is indeed good,
# versus the total times we have good quality,
# and the false positive error rate is
# 1 minus the specificity.
# 
# So in this particular example that we have discussed,
# quality of care, just like in linear regression,
# we want to make predictions on a test set
# to compute out-of-sample metrics.
# We develop the logistic regression model using data,
# but would like to make predictions out-of-sample.
# So in our test, we utilized 32 cases,
# and the R command that makes the statements
# about the quality of a prediction out-of-sample
# is illustrated here in the slide.
# So in that way, we make predictions
# about probabilities, of course, simply
# because logistic regression makes predictions
# about probabilities, and then we transform them
# to a binary outcome-- the quality is good,
# or the quality is poor-- using a threshold.
# In this particular example, we used a threshold value of 0.3,
# and in doing so, we obtain the following confusion matrix.
# So there were, as I mentioned, there are 32 cases,
# out of which 24 of them are actually good care,
# and eight of them are actually poor care.
# We observe that the overall accuracy of the model
# is 19 plus 6, is 25, over 32.
# The false positive rate is, in this case, 5 over 24,
# 19 plus 5, whereas the true positive rate is 6 out of 8-- 6
# plus 2.
# Notice, if you compare this model with making always--
#     let's say one alternative is to say
# we predict good care all the time.
# In that situation, we will be correct 19
# plus 5, 24 times, versus 25 times, in our case.
# But notice that predicting always good care
# does not capture the dynamics of what is happening,
# versus the logistic regression model that
# is far more intelligent in capturing these effects.

# QUICK QUESTION  (1 point possible)
# IMPORTANT NOTE: This question uses the original model with the independent
# variables "OfficeVisits" and "Narcotics". Be sure to use this model, 
# instead of the model you built in Quick Question 4.
# 
# Compute the test set predictions in R by running the command:
    
predictTest <- predict(QualityLog, type="response", newdata=qualityTest)

#You can compute the test set AUC by running the following two commands 
#in R:
    
ROCRpredTest <- prediction(predictTest, qualityTest$PoorCare)
auc <- as.numeric(performance(ROCRpredTest, "auc")@y.values)

# What is the AUC of this model on the test set?
# 0.78
# The AUC of a model has the following nice interpretation: given a random patient 
# from the dataset who actually received poor care, and a random patient from the
# dataset who actually received good care, the AUC is the perecentage of time that our 
# model will classify which is which correctly.



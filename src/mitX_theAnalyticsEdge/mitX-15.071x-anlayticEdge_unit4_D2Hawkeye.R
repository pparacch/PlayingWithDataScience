# Unit 4 - "Keeping an Eye on Healthcare Costs" Lecture

# In the next few videos, we'll be using a data set published
# by the United States Centers for Medicare and Medicaid Services
# to practice creating CART models to predict health care cost.
# We unfortunately can't use the D2Hawkeye data
# due to privacy issues.
# The data set we'll be using instead,
# ClaimsData.csv, is structured to represent a sample of patients
# in the Medicare program, which provides
# health insurance to Americans aged 65 and older,
# as well as some younger people with certain medical
# conditions.
# To protect the privacy of patients represented
# in this publicly available data set, a number of steps
# are performed to anonymize the data.
# So we would need to retrain the models we develop
# in this lecture on de-anonymized data
# if we wanted to apply our models in the real world.
# Let's start by reading our data set into R
# and taking a look at its structure.
# We'll call our data set Claims, and we'll
# use the read.csv function to read in the data file
# ClaimsData.csv.
# 
# Make sure to navigate to the directory on your computer
# containing the file ClaimsData.csv first.
# Now let's take a look at the structure of our data frame
# using the str function.


# Read in the data
Claims = read.csv("ClaimsData.csv")
str(Claims)

# The observations represent a 1% random sample
# of Medicare beneficiaries, limited
# to those still alive at the end of 2008.
# Our independent variables are from 2008,
# and we will be predicting cost in 2009.
# Our independent variables are the patient's age
# in years at the end of 2008, and then several binary variables
# indicating whether or not the patient had
# diagnosis codes for a particular disease
# or related disorder in 2008: alzheimers, arthritis, cancer,
# chronic obstructive pulmonary disease, or copd, depression,
# diabetes, heart.failure, ischemic heart disease,
# or ihd, kidney disease, osteoporosis, and stroke.
# Each of these variables will take value 1 if the patient had
# a diagnosis code for the particular disease and value 0
# otherwise.
# Reimbursement2008 is the total amount
# of Medicare reimbursements for this patient in 2008.
# And reimbursement2009 is the total value
# of all Medicare reimbursements for the patient in 2009.
# Bucket2008 is the cost bucket the patient fell into in 2008,
# and bucket2009 is the cost bucket
# the patient fell into in 2009.
# These cost buckets are defined using the thresholds determined
# by D2Hawkeye.
# So the first cost bucket contains patients
# with costs less than $3,000, the second cost bucket
# contains patients with costs between $3,000 and $8,000,
# and so on.
# We can verify that the number of patients in each cost bucket
# has the same structure as what we
# saw for D2Hawkeye by computing the percentage of patients
# in each cost bucket.

# So we'll create a table of the variable bucket2009
# and divide by the number of rows in Claims.
# This gives the percentage of patients
# in each of the cost buckets.

# Percentage of patients in each cost bucket
table(Claims$bucket2009)/nrow(Claims)

# The first cost bucket has almost 70% of the patients.
# The second cost bucket has about 20% of the patients.
# And the remaining 10% are split between the final three cost
# buckets.
# So the vast majority of patients in this data set have low cost.

# Our goal will be to predict the cost bucket the patient fell
# into in 2009 using a CART model.
# But before we build our model, we
# need to split our data into a training set and a testing set.
# So we'll load the package caTools,
# and then we'll set our random seed to 88
# so that we all get the same split.
# And we'll use the sample.split function,
# where our dependent variable is Claims$bucket2009,
# and we'll set our SplitRatio to be 0.6.
# So we'll put 60% of the data in the training set.
# We'll call our training set ClaimsTrain,
# and we'll take the observations of Claims
# for which spl is exactly equal to TRUE.
# And our testing set will be called ClaimsTest,
# where we'll take the observations of Claims
# for which spl is exactly equal to FALSE.

# Split the data
library(caTools)
set.seed(88)
spl = sample.split(Claims$bucket2009, SplitRatio = 0.6)

ClaimsTrain = subset(Claims, spl==TRUE)
ClaimsTest = subset(Claims, spl==FALSE)

# Now that our data set is ready, we'll see in the next video
# how a smart baseline method would perform.


#Average age of patients in teh training dataset
mean(ClaimsTrain$age) # -> 72.63773

#Proportion of patients in training data set with diabetes condition 
table(ClaimsTrain$diabetes)/ nrow(ClaimsTrain)
#      0         1 
# 0.6191017 0.3808983 

# VIDEO 7

# Let's now see how the baseline method used by D2Hawkeye
# would perform on this data set.
# The baseline method would predict
# that the cost bucket for a patient in 2009
# will be the same as it was in 2008.
# So let's create a classification matrix to compute the accuracy
# for the baseline method on the test set.
# So we'll use the table function, where the actual outcomes are
# ClaimsTest$bucket2009, and our predictions are
# ClaimsTest$bucket2008.

# Baseline method
table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)

# The accuracy is the sum of the diagonal, the observations that
# were classified correctly, divided
# by the total number of observations in our test set.
# So we want to add up 110138 + 10721 + 2774 + 1539 + 104.
# And we want to divide by the total number
# of observations in this table, or the number of rows
# in ClaimsTest.
# 
# So the accuracy of the baseline method is 0.68.
(110138 + 10721 + 2774 + 1539 + 104)/nrow(ClaimsTest)

# Now how about the penalty error?
# To compute this, we need to first create a penalty matrix
# in R. Keep in mind that we'll put
# the actual outcomes on the left, and the predicted outcomes
# on the top.
# So we'll call it PenaltyMatrix, which
# will be equal to a matrix object in R.
# And then we need to give the numbers
# that should fill up the matrix: 0, 1, 2, 3, 4.
# That'll be the first row.
# And then 2, 0, 1, 2, 3.
# That'll be the second row.
# 4, 2, 0, 1, 2 for the third row.
# 6, 4, 2, 0, 1 for the fourth row.
# And finally, 8, 6, 4, 2, 0 for the fifth row.
# And then after the parentheses, type a comma,
# and then byrow = TRUE, and then add nrow = 5.
# Close the parentheses, and hit Enter.

# Penalty Matrix
PenaltyMatrix = matrix(c(0,1,2,3,4,2,0,1,2,3,4,2,0,1,2,6,4,2,0,1,8,6,4,2,0), byrow=TRUE, nrow=5)

# So what did we just create?
# Type PenaltyMatrix and hit Enter.

PenaltyMatrix

# So with the previous command, we filled up our matrix row
# by row.
# The actual outcomes are on the left,
# and the predicted outcomes are on the top.
# So as we saw in the slides, the worst outcomes
# are when we predict a low cost bucket,
# but the actual outcome is a high cost bucket.
# We still give ourselves a penalty
# when we predict a high cost bucket
# and it's actually a low cost bucket, but it's not as bad.


# So now to compute the penalty error of the baseline method,
# we can multiply our classification matrix
# by the penalty matrix.
# So go ahead and hit the Up arrow to get back
# to where you created the classification
# matrix with the table function.
# And we're going to surround the entire table function
# by as.matrix to convert it to a matrix
# so that we can multiply it by our penalty matrix.
# So now at the end, close the parentheses
# and then multiply by PenaltyMatrix and hit Enter.
# So what this does is it takes each number
# in the classification matrix and multiplies it
# by the corresponding number in the penalty matrix.
# So now to compute the penalty error,

# Penalty Error of Baseline Method
as.matrix(table(ClaimsTest$bucket2009, ClaimsTest$bucket2008))*PenaltyMatrix

# we just need to sum it up and divide
# by the number of observations in our test set.
# So scroll up once, and then we'll
# just surround our entire previous command
# by the sum function.
# 
# And we'll divide by the number of rows in ClaimsTest
# and hit Enter.

sum(as.matrix(table(ClaimsTest$bucket2009, ClaimsTest$bucket2008))*PenaltyMatrix)/nrow(ClaimsTest)

# So the penalty error for the baseline method is 0.74.
# In the next video, our goal will be
# to create a CART model that has an accuracy higher than 68%
# and a penalty error lower than 0.74.

#Question
# Suppose that instead of the baseline method discussed in the previous video, we used the 
# baseline method of predicting the most frequent outcome for all observations. This new 
# baseline method would predict cost bucket 1 for everyone.
# 
# What would the accuracy of this baseline method be on the test set?
ClaimsTest$newBaseline <- 1
table(ClaimsTest$bucket2009, ClaimsTest$newBaseline)
#accuracy will be
122978 / nrow(ClaimsTest) # -> 0.67127

# What would the penalty error of this baseline method be on the test set?
(122978 * 0 + 34840 * 2 + 16390 * 4 + 7937 * 6 + 1057 * 8) / nrow(ClaimsTest)

# EXPLANATION
# To compute the accuracy, you can create a table of the variable ClaimsTest$bucket2009:
#     
#     table(ClaimsTest$bucket2009)
# 
# According to the table output, this baseline method would get 122978 observations correct,
# and all other observations wrong. So the accuracy of this baseline method is 
# 122978/nrow(ClaimsTest) = 0.67127.
# 
# For the penalty error, since this baseline method predicts 1 for all observations, it would
# have a penalty error of:
#     
#     (0*122978 + 2*34840 + 4*16390 + 6*7937 + 8*1057)/nrow(ClaimsTest) = 1.044301


# VIDEO 8

# In this video, we'll build a CART model
# to predict healthcare cost.
# First, let's make sure the packages rpart and rpart.plot
# are loaded with the library function.
# 
# You should have already installed them
# in the previous lecture on predicting Supreme Court
# decisions.

# Load necessary libraries
library(rpart)
library(rpart.plot)

# Now, let's build our CART model.
# We'll call it ClaimsTree.
# And we'll use the rpart function to predict bucket2009,
# using as independent variables: age, arthritis, alzheimers,
# cancer, copd, depression, diabetes, heart.failure, ihd,
# kidney, osteoporosis, and stroke.
# We'll also use bucket2008 and reimbursement2008.
# The data set we'll use to build our model is ClaimsTrain.

# And then we'll add the arguments, method = "class",
# since we have a classification problem here, and cp = 0.00005.
# Note that even though we have a multi-class classification
# problem here, we build our tree in the same way
# as a binary classification problem.
# So go ahead and hit Enter.

# The cp value we're using here was
# selected through cross-validation
# on the training set.
# We won't perform the cross-validation here,
# because it takes a significant amount of time
# on a data set of this size.
# Remember that we have almost 275,000 observations
# in our training set.
# But keep in mind that the R commands
# needed for cross-validation here are the same as those used
# in the previous lecture on predicting Supreme Court
# decisions.

# CART model
ClaimsTree = rpart(bucket2009 ~ age + alzheimers + arthritis + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data=ClaimsTrain, method="class", cp=0.00005)

# So now that our model's done, let's
# take a look at our tree with the prp function.
# 
# It might take a while to load, because we
# have a huge tree here.
# This makes sense for a few reasons.
# One is the large number of observations in our training
# set.
# Another is that we have a five-class classification
# problem, so the classification is
# more complex than a binary classification case,
# like the one we saw in the previous lecture.
# The trees used by D2Hawkeye were also very large CART trees.
# While this hurts the interpretability of the model,
# it's still possible to describe each of the buckets of the tree
# according to the splits.

prp(ClaimsTree)

# So now, let's make predictions on the test set.
# So go back to your R console, and we'll call our predictions
# PredictTest, where we'll use the predict function for our model
# ClaimsTree, and our newdata is ClaimsTest.
# And we want to add type = "class"
# to get class predictions.

# Make predictions
PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type = "class")

# And we can make our classification matrix
# on the test set to compute the accuracy.
# So we'll use the table function, where the actual outcomes are
# ClaimsTest$bucket2009, and our predictions are PredictTest.

table(ClaimsTest$bucket2009, PredictTest)

# So to compute the accuracy, we need
# to add up the numbers on the diagonal
# and divide by the total number of observations in our test
# set.
# So we have 114141 + 16102 + 118 + 201 + 0.
# And we'll divide by the number of rows in ClaimsTest.
# 
# So the accuracy of our model is 0.713.
(114141 + 16102 + 118 + 201 + 0)/nrow(ClaimsTest)

# For the penalty error, we can use our penalty matrix
# like we did in the previous video.
# So scroll up to the classification matrix command
# and surround the table function by the as.matrix function,
# and then we'll multiply by PenaltyMatrix.
# 
# So remember that this takes each entry in our classification
# matrix and multiplies it by the corresponding number
# in the penalty matrix.
# So now we just need to add up all
# of the numbers in this matrix by surrounding it by the sum
# function and then dividing by the total number
# of observations in our test set, or nrow(ClaimsTest).

# Penalty Error
as.matrix(table(ClaimsTest$bucket2009, PredictTest))*PenaltyMatrix
sum(as.matrix(table(ClaimsTest$bucket2009, PredictTest))*PenaltyMatrix)/nrow(ClaimsTest)

# So our penalty error is 0.758.
# In the previous video, we saw that our baseline method
# had an accuracy of 68% and a penalty error of 0.74.
# So while we increased the accuracy,
# the penalty error also went up.
# Why?
# By default, rpart will try to maximize the overall accuracy,
# and every type of error is seen as having a penalty of one.
# Our CART model predicts 3, 4, and 5 so rarely
# because there are very few observations in these classes.
# So we don't really expect this model
# to do better on the penalty error than the baseline method.
# So how can we fix this?

# The rpart function allows us to specify
# a parameter called loss.
# This is the penalty matrix we want
# to use when building our model.
# So let's scroll back up to where we built our CART model.
# At the end of the rpart function,
# we'll add the argument params = list(loss=PenaltyMatrix).
# 
# This is the name of the penalty matrix we created.
# Close the parentheses and hit Enter.
# So while our model is being built,
# let's think about what we expect to happen.
# If the rpart function knows that we'll
# be giving a higher penalty to some types of errors
# over others, it might choose different splits
# when building the model to minimize
# the worst types of errors.
# We'll probably get a lower overall accuracy
# with this new model.
# But hopefully, the penalty error will be much lower too.


# New CART model with loss matrix
ClaimsTree = rpart(bucket2009 ~ age + alzheimers + arthritis + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data=ClaimsTrain, method="class", cp=0.00005, parms=list(loss=PenaltyMatrix))

# So now that our model is done, let's regenerate our test
# set predictions by scrolling up to where we created PredictTest
# and hitting Enter, and then recreating our classification
# matrix by scrolling up to the table function
# and hitting Enter again.
# Now let's add up the numbers on the diagonal, 94310 + 18942
# + 4692 + 636 + 2, and divide by the number of rows
# in ClaimsTest.

# Redo predictions and penalty error
PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type = "class")
table(ClaimsTest$bucket2009, PredictTest)
(94310 + 18942 + 4692 + 636 + 2)/nrow(ClaimsTest)

sum(as.matrix(table(ClaimsTest$bucket2009, PredictTest))*PenaltyMatrix)/nrow(ClaimsTest)


# So the accuracy of this model is 0.647.
# And we can scroll up and compute the penalty error here
# by going back to the sum command and hitting Enter.
# So the penalty error of our new model is 0.642.
# Our accuracy is now lower than the baseline method,
# but our penalty error is also much lower.
# Note that we have significantly fewer independent variables
# than D2Hawkeye had.
# If we had the hundreds of codes and risk factors
# available to D2Hawkeye, we would hopefully do even better.
# In the next video, we'll discuss the accuracy of the models
# used by D2Hawkeye and how analytics can provide an edge.
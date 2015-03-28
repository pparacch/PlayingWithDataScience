# Unit 4 - "Judge, Jury, and Classifier" Lecture

# In this video, we'll see how to build a CART model in R. Let's
# start by reading in the data file "stevens.csv".
# We'll call our data frame stevens
# and use the read.csv function to read in the data file
# "stevens.csv".

# Read in the data
stevens = read.csv("stevens.csv")
str(stevens)

# We have 566 observations, or Supreme Court cases,
# and nine different variables.
# Docket is just a unique identifier for each case,
# and Term is the year of the case.
# Then we have our six independent variables: the circuit
# court of origin, the issue area of the case,
# the type of petitioner, the type of respondent, the lower court
# direction, and whether or not the petitioner argued
# that a law or practice was unconstitutional.
# The last variable is our dependent variable,
# whether or not Justice Stevens voted
# to reverse the case: 1 for reverse, and 0 for affirm.

# Now before building models, we need
# to split our data into a training set and a testing set.
# We'll do this using the sample.split function,
# like we did last week for logistic regression.
# First, we need to load the package caTools
# with library(caTools).

# Now, let's create our split.
# We'll call it spl, and we'll use the sample.split function,
# where the first argument needs to be our outcome variable,
# stevens$Reverse, and then the second argument is
# the SplitRatio, or the percentage of data that we want
# to put in the training set.
# In this case, we'll put 70% of the data in the training set.
# Now, let's create our training and testing
# sets using the subset function.
# We'll call our training set Train,
# and we'll take a subset of stevens,
# only taking the observations for which spl is equal to TRUE.
# We'll call our testing set Test, and here
# take a subset of stevens, but this time,
# taking the observations for which spl is equal to FALSE.

# Split the data
library(caTools)
set.seed(3000)
spl = sample.split(stevens$Reverse, SplitRatio = 0.7)
Train = subset(stevens, spl==TRUE)
Test = subset(stevens, spl==FALSE)

# Now, we're ready to build our CART model.
# First we need to install and load
# the rpart package and the rpart plotting package.
# Remember that to install a new package,
# we use the install.packages function,
# and then in parentheses and quotes,
# give the name of the package we want to install.
# In this case, rpart.
# And then, when you're back to the blinking cursor,
# load the package with library(rpart).

# Install rpart library
install.packages("rpart")
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)

# Now we can create our CART model using the rpart function.
# We'll call our model StevensTree,
# and we'll use the rpart function, where
# the first argument is the same as if we were building
# a linear or logistic regression model.
# We give our dependent variable-- in our case,
# Reverse-- followed by a tilde sign,
# and then the independent variables
# separated by plus signs.
# So Circuit + Issue + Petitioner + Respondent
# + LowerCourt + Unconst.
# We also need to give our data set
# that should be used to build our model, which in our case
# is Train.
# Now we'll give two additional arguments here.
# The first one is method = "class".
# This tells rpart to build a classification tree, instead of
# a regression tree.
# You'll see how we can create regression trees in recitation.
# The last argument we'll give is minbucket = 25.
# This limits the tree so that it doesn't
# overfit to our training set.
# We selected a value of 25, but we
# could pick a smaller or larger value.
# We'll see another way to limit the tree later in this lecture.
# Now let's plot our tree using the prp function,
# where the only argument is the name of our model, StevensTree.

# CART model
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method="class", minbucket=25)
prp(StevensTree)

# You should see the tree pop up in the graphics window.
# The first split of our tree is whether or not
# the lower court decision is liberal.
# If it is, then we move to the left in the tree.
# And we check the respondent.
# If the respondent is a criminal defendant, injured person,
# politician, state, or the United States,
# we predict 0, or affirm.
# You can see here that the prp function abbreviates
# the values of the independent variables.
# If you're not sure what the abbreviations are,
# you could create a table of the variable
# to see all of the possible values.
# prp will select the abbreviation so
# that they're uniquely identifiable.
# So if you made a table, you could
# see that CRI stands for criminal defendant,
# INJ stands for injured person, etc.
# So now moving on in our tree, if the respondent is not
# one of these types, we move on to the next split,
# and we check the petitioner.
# If the petitioner is a city, employee, employer,
# government official, or politician,
# then we predict 0, or affirm.
# If not, then we check the circuit court of origin.
# If it's the 10th, 1st, 3rd, 4th, DC or Federal Court,
# then we predict 0.
# Otherwise, we predict 1, or reverse.
# We can repeat this same process on the other side of the tree
# if the lower court decision is not liberal.

# Comparing this to a logistic regression model,
# we can see that it's very interpretable.

# A CART tree is a series of decision rules
# which can easily be explained.

# Now let's see how well our CART model
# does at making predictions for the test set.
# So back in our R Console, we'll call our predictions
# PredictCART, and we'll use the predict function, where
# the first argument is the name of our model, StevensTree.

# Make predictions
PredictCART = predict(StevensTree, newdata = Test, type = "class")
table(Test$Reverse, PredictCART)

# Now let's compute the accuracy of our model
# by building a confusion matrix.
# So we'll use the table function, and first give the true outcome
# values-- Test$Reverse, and then our predictions, PredictCART.

# To compute the accuracy, we need to add up
# the observations we got correct, 41 plus 71, divided
# by the total number of observations in the table,
# or the total number of observations in our test set.
# So the accuracy of our CART model is 0.659.

(41+71)/(41+36+22+71)

# If you were to build a logistic regression model,
# you would get an accuracy of 0.665
# and a baseline model that always predicts
# Reverse, the most common outcome,
# has an accuracy of 0.547.
# So our CART model significantly beats the baseline
# and is competitive with logistic regression.
# It's also much more interpretable
# than a logistic regression model would be.

# Lastly, to evaluate our model, let's generate an ROC curve
# for our CART model using the ROCR package.
# First, we need to load the package with the library
# function, and then we need to generate our predictions again,
# this time without the type = "class" argument.
# We'll call them PredictROC, and we'll
# use the predict function, giving just
# as the two arguments StevensTree and newdata = Test.

# ROC curve
library(ROCR)

PredictROC = predict(StevensTree, newdata = Test)


# Let's take a look at what this looks
# like by just typing PredictROC and hitting Enter.

PredictROC

# For each observation in the test set,
# it gives two numbers which can be thought
# of as the probability of outcome 0
# and the probability of outcome 1.
# More concretely, each test set observation
# is classified into a subset, or bucket, of our CART tree.
# These numbers give the percentage of training
# set data in that subset with outcome 0
# and the percentage of data in the training set
# in that subset with outcome 1.

# We'll use the second column as our probabilities
# to generate an ROC curve.
# So just like we did last week for logistic regression,
# we'll start by using the prediction function.
# We'll call the output pred, and then use prediction,
# where the first argument is the second column of PredictROC,
# which we can access with square brackets,
# and the second argument is the true outcome values,
# Test$Reverse.

pred = prediction(PredictROC[,2], Test$Reverse)

# Now we need to use the performance function, where
# the first argument is the outcome of the prediction
# function, and then the next two arguments
# are true positive rate and false positive rate, what
# we want on the x and y-axes of our ROC curve.

perf = performance(pred, "tpr", "fpr")

# Now we can just plot our ROC curve by typing plot(perf).
plot(perf)

#To Compute the AUC of the CART model from the previous video, using the following command in your R console:
as.numeric(performance(pred, "auc")@y.values) # 0.6927105

# First build a CART model that is similar to the one we built in Video 4, except change the minbucket parameter to 5. Plot the tree.
# How many splits does the tree have?
StevensTree5miniBuckets = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method="class", minbucket=5)
prp(StevensTree5miniBuckets) #No of Splits -> 16

# Now build a CART model that is similar to the one we built in Video 4, except change the minbucket parameter to 100. Plot the tree.
# How many splits does the tree have?
StevensTree100miniBuckets = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method="class", minbucket=100)
prp(StevensTree100miniBuckets) #No of Splits -> 1


# VIDEO 5 - Random Forests


# In our R console, let's start by installing and loading
# the package "randomForest."
# We first need to install the package
# using the install.packages function for the package
# "randomForest."
# You should see a few lines run in your R console
# and then when you're back to the blinking cursor,
# load the package with the library command.


# Install randomForest package
install.packages("randomForest")
library(randomForest)

# Now we're ready to build our random forest model.
# We'll call it StevensForest and use the randomForest function,
# first giving our dependent variable,
# Reverse, followed by a tilde sign,
# and then our independent variables
# separated by plus signs.
# Circuit
# + Issue
# + Petitioner
# + Respondent
# 
# + LowerCourt
# 
# + Unconst
# We'll use the data set Train.
# 
# For random forests, we need to give two additional arguments.
# These are nodesize, also known as minbucket for CART,
# and we'll set this equal to 25, the same value we
# used for our CART model.
# And then we need to set the parameter ntree.
# This is the number of trees to build.
# And we'll build 200 trees here.
# Then hit Enter.

# Build random forest model
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, ntree=200, nodesize=25 )

# You should see an interesting warning message here.
# In CART, we added the argument method="class",
# so that it was clear that we're doing a classification problem.
# As I mentioned earlier, trees can also
# be used for regression problems, which
# you'll see in the recitation.
# The randomForest function does not have a method argument.
# So when we want to do a classification problem,
# we need to make sure outcome is a factor.
# Let's convert the variable Reverse to a factor variable
# in both our training and our testing sets.
# We do this by typing the name of the variable we want
# to convert-- in our case Train$Reverse--
#     and then type as.factor and then in parentheses the variable
# name, Train$Reverse.
# And just repeat this for the test set as well.
# Test$Reverse=as.factor(Test$Reverse)

# Convert outcome to factor
Train$Reverse = as.factor(Train$Reverse)
Test$Reverse = as.factor(Test$Reverse)

# Now let's try creating our random forest again.
# Just use the up arrow to get back to the random forest line
# and hit Enter.

# Try again
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, ntree=200, nodesize=25 )

# We didn't get a warning message this time
# so our model is ready to make predictions.
# Let's compute predictions on our test set.
# We'll call our predictions PredictForest and use
# the predict function to make predictions using our model,
# StevensForest, and the new data set Test.

# Make predictions
PredictForest = predict(StevensForest, newdata = Test)

# Let's look at the confusion matrix to compute our accuracy.
# We'll use the table function and first give the true outcome,
# Test$Reverse, and then our predictions, PredictForest.
table(Test$Reverse, PredictForest)

# Our accuracy here is (40+74)/(40+37+19+74).
(40+74)/(40+37+19+74)

# So the accuracy of our Random Forest model is about 67%.
# Recall that our logistic regression
# model had an accuracy of 66.5% and our CART model
# had an accuracy of 65.9%.
# So our random forest model improved our accuracy
# a little bit over CART.
# Sometimes you'll see a smaller improvement in accuracy
# and sometimes you'll see that random forests can
# significantly improve in accuracy over CART.
# We'll see this a lot in the recitation in the homework
# assignments.
# Keep in mind that Random Forests has a random component.
# You may have gotten a different confusion matrix than me
# because there's a random component to this method.

# Open Questions
# First, set the seed to 100, and the re-build the random forest model, exactly like we did
# in the previous video (Video 5). Then make predictions on the test set. 
# What is the accuracy of the model on the test set?
set.seed(100)
randomForest1 = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, ntree=200, nodesize=25 )
PredictForest1 = predict(randomForest1, newdata = Test)
table(Test$Reverse, PredictForest1)
#   PredictForest1
#    0  1
# 0 43 34
# 1 19 74

#Accuracy
#(TP + TN) / N -> 0.6882353
(43 + 74)/ nrow(Test)

#Now set the seed to 200 and repeat
set.seed(200)
randomForest2 = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, ntree=200, nodesize=25 )
PredictForest2 = predict(randomForest2, newdata = Test)
table(Test$Reverse, PredictForest2)
# PredictForest2
#    0  1
# 0 44 33
# 1 17 76

#Accuracy
#(TP + TN) / N -> 0.7058824
(44 + 76)/ nrow(Test)

# EXPLANATION
# You can create the models and compute the accurracies with the following commands in R:
#     
#     set.seed(100)
# 
# StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt +
# Unconst, data = Train, ntree=200, nodesize=25)
# 
# PredictForest = predict(StevensForest, newdata = Test)
# 
# table(Test$Reverse, PredictForest)
# 
# and then repeat it, but with set.seed(200) first.
# 
# As we see here, the random component of the random forest method can change the accuracy. 
# The accuracy for a more stable dataset will not change very much, but a noisy dataset can be 
# significantly affected by the random samples.




# VIDEO 6

#Slides
# In CART, the value of minbucket can
# affect the model's out-of-sample accuracy.
# As we discussed earlier in the lecture,
# if minbucket is too small, over-fitting might occur.
# But if minbucket is too large, the model might be too simple.
# So how should we set this parameter value?
# We could select the value that gives the best testing set
# accuracy, but this isn't right.
# The idea of the testing set is to measure model performance
# on data the model has never seen before.
# By picking the value of minbucket
# to get the best test set performance,
# the testing set was implicitly used to generate the model.
# Instead, we'll use a method called K-fold Cross Validation,
# which is one way to properly select the parameter value.
# This method works by going through the following steps.
# First, we split the training set into k
# equally sized subsets, or folds.
# In this example, k equals 5.
# Then we select k - 1, or four folds, to estimate the model,
# and compute predictions on the remaining one fold, which
# is often referred to as the validation set.
# We build a model and make predictions
# for each possible parameter value we're considering.
# Then we repeat this for each of the other folds,
# or pieces of our training set.
# So we would build a model using folds 1, 2, 3,
# and 5 to make predictions on fold 4,
# and then we would build a model using folds 1, 2, 4,
# and 5 to make predictions on fold 3, etc.
# So ultimately, cross validation builds
# many models, one for each fold and possible parameter value.
# Then, for each candidate parameter value,
# and for each fold, we can compute
# the accuracy of the model.
# This plot shows the possible parameter values on the x-axis,
# and the accuracy of the model on the y-axis.
# This line shows the accuracy of our model on fold 1.
# We can also compute the accuracy of the model using
# each of the other folds as the validation sets.
# We then average the accuracy over the k
# folds to determine the final parameter
# value that we want to use.
# Typically, the behavior looks like this--
#     if the parameter value is too small,
# then the accuracy is lower, because the model is probably
# over-fit to the training set.
# But if the parameter value is too large,
# then the accuracy is also lower, because the model
# is too simple.
# In this case, we would pick a parameter value around six,
# because it leads to the maximum average accuracy
# over all parameter values.
# 
# So far, we've used the parameter minbucket
# to limit our tree in R. When we use cross validation in R,
# we'll use a parameter called cp instead.
# This is the complexity parameter.
# It's like Adjusted R-squared for linear regression,
# and AIC for logistic regression, in that it measures
# the trade-off between model complexity and accuracy
# on the training set.
# A smaller cp value leads to a bigger tree,
# so a smaller cp value might over-fit the model
# to the training set.
# But a cp value that's too large might
# build a model that's too simple.


# Let's go to R, and use cross validation
# to select the value of cp for our CART tree.
# In our R console, let's try cross validation
# for our CART model.
# To do this, we need to install and load two new packages.
# First, we'll install the package "caret".
# 
# You should see some lines run in your R console,
# and then when you're back to the blinking cursor,
# load the package with library(caret).
# 
# Now, let's install the package "e1071".
# So again, install.packages("e1071").
# Again, you should see some lines run in your R console,
# and when you're back to the cursor,
# load the package with library(e1071).


# Install cross-validation packages
install.packages("caret")
library(caret)
install.packages("e1071")
library(e1071)

# Define cross-validation experiment
# Now, we'll define our cross validation experiment.
# First, we need to define how many folds we want.
# We can do this using the trainControl function.
# So we'll say numFolds = trainControl,
# and then in parentheses, method = "cv",
# for cross validation, and then number = 10, for 10 folds.
numFolds = trainControl( method = "cv", number = 10 )

# Then we need to pick the possible values for our cp
# parameter, using the expand.grid function.
# So we'll call it cpGrid, and then use expand.grid,
# where the only argument is .cp = seq(0.01,0.5,0.01).
# This will define our cp parameters
# to test as numbers from 0.01 to 0.5, in increments of 0.01.
cpGrid = expand.grid( .cp = seq(0.01,0.5,0.01)) 

# Now, we're ready to perform cross validation.
# We'll do this using the train function, where
# the first argument is similar to that
# when we're building models.
# It's the dependent variable, Reverse,
# followed by a tilde symbol, and then the independent variables
# separated by plus signs-- Circuit + Issue + Petitioner +
#     Respondent + LowerCourt + Unconst.
# Our data set here is Train, with a capital T,
# and then we need to add the arguments method = "rpart",
# since we want to cross validate a CART model,
# and then trControl = numFolds, the output
# of our trainControl function, and then tuneGrid = cpGrid,
# the output of the expand.grid function.
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = "rpart", trControl = numFolds, tuneGrid = cpGrid )

# If you hit Enter, it might take a little while,
# but after a few seconds, you should
# get a table describing the cross validation
# accuracy for different cp parameters.
# The first column gives the cp parameter that was tested,
# and the second column gives the cross validation
# accuracy for that cp value.
# The accuracy starts lower, and then increases,
# and then will start decreasing again, as we saw in the slides.
# At the bottom of the output, it says,
# "Accuracy was used to select the optimal model using the largest
# value.
# The final value used for the model was cp = 0.18."
# This is the cp value we want to use in our CART model.
# So now let's create a new CART model with this value of cp,
# instead of the minbucket parameter.

# We'll call this model StevensTreeCV,
# and we'll use the rpart function, like we did earlier,
# to predict Reverse using all of our independent variables:
#     Circuit, Issue, Petitioner, Respondent,
# LowerCourt, and Unconst.
# Our data set here is Train, and then we want method = "class",
# since we're building a classification tree, and cp
# = 0.18.

# Create a new CART model
StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method="class", cp = 0.18)

# Now, let's make predictions on our test set using this model.
# We'll call our predictions PredictCV,
# and we'll use the predict function
# to make predictions using the model StevensTreeCV,
# the newdata set Test, and we want to add type = "class",
# so that we get class predictions.

# Make predictions
PredictCV = predict(StevensTreeCV, newdata = Test, type = "class")

# Now let's create our confusion matrix,
# using the table function, where we first give the true outcome,
# Test$Reverse, and then our predictions, PredictCV.

table(Test$Reverse, PredictCV)
(59+64)/(59+18+29+64)

# So the accuracy of this model is 59 + 64,
# divided by the total number in this table, 59 + 18 + 29 +
#     64, the total number of observations in our test set.
# So the accuracy of this model is 0.724.
# Remember that the accuracy of our previous CART model
# was 0.659.
# Cross validation helps us make sure we're
# selecting a good parameter value,
# and often this will significantly
# increase the accuracy.
# If we had already happened to select a good parameter value,
# then the accuracy might not of increased that much.
# But by using cross validation, we
# can be sure that we're selecting a smart parameter value.

# Plot the tree that we created using cross-validation. How many splits does it have?
prp(StevensTreeCV) # no of splits -> 1


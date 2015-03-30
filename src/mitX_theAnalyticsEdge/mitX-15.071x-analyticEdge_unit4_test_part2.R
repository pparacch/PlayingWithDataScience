# LETTER RECOGNITION
# 
# One of the earliest applications of the predictive analytics methods we have studied so far in this class was 
# to automatically recognize letters, which post office machines use to sort mail. In this problem, we will build 
# a model that uses statistics of images of four letters in the Roman alphabet -- A, B, P, and R -- to predict which
# letter a particular image corresponds to.
# 
# Note that this is a multiclass classification problem. We have mostly focused on binary classification problems 
# (e.g., predicting whether an individual voted or not, whether the Supreme Court will affirm or reverse a case,
#  whether or not a person is at risk for a certain disease, etc.).
# In this problem, we have more than two classifications that are possible for each observation, 
# like in the D2Hawkeye lecture. 

# The file letters_ABPR.csv contains 3116 observations, each of which corresponds to a certain image of one of the four
# letters A, B, P and R. The images came from 20 different fonts, which were then randomly distorted to produce the final
# images; each such distorted image is represented as a collection of pixels, each of which is "on" or "off". 

# For each such distorted image, we have available certain statistics of the image in terms of these pixels, 
# as well as which of the four letters the image is. This data comes from the UCI Machine Learning Repository.
# 
# This dataset contains the following 17 variables:
#     
# letter = the letter that the image corresponds to (A, B, P or R)
# xbox = the horizontal position of where the smallest box covering the letter shape begins.
# ybox = the vertical position of where the smallest box covering the letter shape begins.
# width = the width of this smallest box.
# height = the height of this smallest box.
# onpix = the total number of "on" pixels in the character image
# xbar = the mean horizontal position of all of the "on" pixels
# ybar = the mean vertical position of all of the "on" pixels
# x2bar = the mean squared horizontal position of all of the "on" pixels in the image
# y2bar = the mean squared vertical position of all of the "on" pixels in the image
# xybar = the mean of the product of the horizontal and vertical position of all of the "on" pixels in the image
# x2ybar = the mean of the product of the squared horizontal position and the vertical position of all of the "on" pixels
# xy2bar = the mean of the product of the horizontal position and the squared vertical position of all of the "on" pixels
# xedge = the mean number of edges (the number of times an "off" pixel is followed by an "on" pixel, or the image boundary is hit) as the image is scanned from left to right, along the whole vertical length of the image
# xedgeycor = the mean of the product of the number of horizontal edges at each vertical position and the vertical position
# yedge = the mean number of edges as the images is scanned from top to bottom, along the whole horizontal length of the image
# yedgexcor = the mean of the product of the number of vertical edges at each horizontal position and the horizontal position

# PROBLEM 1.1 - PREDICTING B OR NOT B  (2 points possible)
# Let's warm up by attempting to predict just whether a letter is B or not. To begin, load the file letters_ABPR.csv into R, 
# and call it letters. 

letters <- read.csv("letters_ABPR.csv")

# Then, create a new variable isB in the dataframe, which takes the value "TRUE" if the observation corresponds to the letter B, 
# and "FALSE" if it does not. You can do this by typing the following command into your R console:

letters$isB = as.factor(letters$letter == "B")

# Now split the data set into a training and testing set, putting 50% of the data in the training set. 
# Set the seed to 1000 before making the split. The first argument to sample.split should be the dependent variable "letters$isB". 
# Remember that TRUE values from sample.split should go in the training set.

# Split the data
library(caTools)
set.seed(1000)
spl = sample.split(letters$isB, SplitRatio = 0.5)

train = subset(letters, spl==TRUE)
test = subset(letters, spl==FALSE)


# Before building models, let's consider a baseline method that always predicts the most frequent outcome, which is "not B". 
# What is the accuracy of this baseline method on the test set?

#Baseline Model - most frequent outcome "not B"
table(test$isB == FALSE)
# FALSE  TRUE 
# 383  1175 

1175/ nrow(test) # ACcuracy -> 0.754172
#Explanation
# To compute the accuracy of the baseline method on the test set, we first need to see which outcome value is more 
# frequent in the training set, by using the table function. The output of table(train$isB) tells us that "not B" is 
# more common. So our baseline method is to predict "not B" for everything. How well would this do on the test set? 
# We need to run the table command again, this time on the test set:
#     
#     table(test$isB)
# 
# There are 1175 observations that are not B, and 383 observations that are B. So the baseline method accuracy on the 
# test set would be 1175/(1175+383) = 0.754172


# PROBLEM 1.2 - PREDICTING B OR NOT B  (2 points possible)
# Now build a classification tree to predict whether a letter is a B or not, using the training set to build your model. 
# Remember to remove the variable "letter" out of the model, as this is related to what we are trying to predict! To just 
# remove one variable, you can either write out the other variables, or remember what we did in the Billboards problem in
# Week 3, and use the following notation:

library(rpart)
library(rpart.plot)

CARTb = rpart(isB ~ . - letter, data=train, method="class")

# We are just using the default parameters in our CART model, so we don't need to add the minbucket or cp arguments at all. 
# We also added the argument method="class" since this is a classification problem.
 
# What is the accuracy of the CART model on the test set? (Use type="class" when making predictions on the test set.)
predictIsB <- predict(CARTb, newdata = test, type = "class")

# confusion matrix
table(test$isB, predictIsB)
# predictIsB
#        FALSE TRUE
# FALSE  1118   57
# TRUE     43  340

(1118 + 340) / nrow(test) #Accuracy -> 0.9358151


# PROBLEM 1.3 - PREDICTING B OR NOT B  (2 points possible)
# Now, build a random forest model to predict whether the letter is a B or not (the isB variable) using the training set.
# You should use all of the other variables as independent variables, except letter (since it helped us define what we 
# are trying to predict!). Use the default settings for ntree and nodesize (don't include these arguments at all). Right 
# before building the model, set the seed to 1000. (NOTE: You might get a slightly different answer on this problem, even
# if you set the random seed. This has to do with your operating system and the implementation of the random forest algorithm.)

library(randomForest)
set.seed(1000)
isBforest = randomForest(isB ~ . - letter, data = train)
# Make predictions
PredictForest = predict(isBforest, newdata = test)
table(test$isB, PredictForest)

# What is the accuracy of the model on the test set?
(1165 + 374)/ nrow(test) #accuracy -> 0.9878049

# In lecture, we noted that random forests tends to improve on CART in terms of predictive accuracy. 
# Sometimes, this improvement can be quite significant, as it is here.

# EXPLANATION
# To build the random forest model, first set the seed to 1000:
#     
#     set.seed(1000)
# 
# Then you can build the model with one of the following two commands:
#     
#     RFb = randomForest(isB ~ xbox + ybox + width + height + onpix + xbar + ybar + x2bar + y2bar + xybar + 
#                            x2ybar + xy2bar + xedge + xedgeycor + yedge + yedgexcor, data=train)
# 
# RFb = randomForest(isB ~ . - letter, data=train)
# 
# We can make predictions with the predict function:
#     
#     predictions = predict(RFb, newdata=test)
# 
# And then generate our confusion matrix with the table function:
#     
#     table(test$isB, predictions)
# 
# The accuracy of the model on the test set is the sum of the true positives and true negatives, divided by the total
# number of observations in the test set:
#     
#     (1165+374)/nrow(test) = 0.9878049



# PROBLEM 2.1 - PREDICTING THE LETTERS A, B, P, R  (2 points possible)
# Let us now move on to the problem that we were originally interested in, which is to predict whether or not a letter is 
# one of the four letters A, B, P or R.

# As we saw in the D2Hawkeye lecture, building a multiclass classification CART model in R is no harder than building the 
# models for binary classification problems. Fortunately, building a random forest model is just as easy.

# The variable in our data frame which we will be trying to predict is "letter". Start by converting letter in the original 
# data set (letters) to a factor by running the following command in R:
    
letters$letter = as.factor( letters$letter )

# Now, generate new training and testing sets of the letters data frame using letters$letter as the first input to the 
# sample.split function. Before splitting, set your seed to 2000. Again put 50% of the data in the training set. 
set.seed(2000)
spl <- sample.split(letters$letter, SplitRatio = 0.5)

trainNew = subset(letters, spl==TRUE)
testNew = subset(letters, spl==FALSE)

# (Why do we need to split the data again? Remember that sample.split balances the outcome variable in the training and 
# testing sets. With a new outcome variable, we want to re-generate our split.)

# In a multiclass classification problem, a simple baseline model is to predict the most frequent class of all of the options.
# What is the baseline accuracy on the testing set?
which.max(table(trainNew$letter)) # letter P
table(testNew$letter == "P")
# FALSE  TRUE 
# 1157   401
401 / nrow(testNew) # Accuracy -> 0.2573813
# 
# Explanation
# to compute the accuracy of the baseline method on the test set, we need to first figure out the most common outcome
# in the training set. The output of table(train2$letter) tells us that "P" has the most observations. So we will 
# predict P for all letters. On the test set, we can run the table command table(test2$letter) to see that it has
# 401 observations that are actually P. So the test set accuracy of the baseline method is 401/nrow(test) = 0.2573813.

# PROBLEM 2.2 - PREDICTING THE LETTERS A, B, P, R  (2 points possible)
# Now build a classification tree to predict "letter", using the training set to build your model. You should use all
# of the other variables as independent variables, except "isB", since it is related to what we are trying to predict! 
# Just use the default parameters in your CART model. Add the argument method="class" since this is a classification 
# problem. Even though we have multiple classes here, nothing changes in how we build the model from the binary case.

CARTc = rpart(letter ~ . - isB, data=trainNew, method="class")
predictLetter <- predict(CARTc, newdata = testNew, type = "class")

# confusion matrix
table(testNew$letter, predictLetter)

# predictLetter
#     A   B   P   R
# A 377   4   0  14
# B   7 299  11  66
# P   7  25 367   2
# R   9  36   1 333

# What is the test set accuracy of your CART model? Use the argument type="class" when making predictions.

(377 + 299 + 367 + 333) / nrow(testNew) # Accuracy -> 0.8831836

# (HINT: When you are computing the test set accuracy using the confusion matrix, you want to add everything on the main 
#  diagonal and divide by the total number of observations in the test set, which can be computed with nrow(test), where
#  test is the name of your test set).

# EXPLANATION
# You can build the CART tree with the following command:
#     
#     CARTletter = rpart(letter ~ . - isB, data=train2, method="class")
# 
# Then, you can make predictions on the test set with the following command:
#     
#     predictLetter = predict(CARTletter, newdata=test2, type="class")
# 
# Looking at the confusion matrix, table(test2$letter, predictLetter), we want to sum the main diagonal 
# (the correct predictions) and divide by the total number of observations in the test set:
#     
#     (348+318+363+340)/nrow(test2) = 0.8786906


# PROBLEM 2.3 - PREDICTING THE LETTERS A, B, P, R  (2 points possible)
# Now build a random forest model on the training data, using the same independent variables as in the previous problem 
# -- again, don't forget to remove the isB variable. Just use the default parameter values for ntree and nodesize 
# (you don't need to include these arguments at all). Set the seed to 1000 right before building your model. 
# (Remember that you might get a slightly different result even if you set the random seed.)

set.seed(1000)
isLetter = randomForest(letter ~ . - isB, data = trainNew)
# Make predictions
PredictForestNew = predict(isLetter, newdata = testNew)
table(testNew$letter, PredictForestNew)

# PredictForestNew
#    A   B   P   R
# A 394   0   0   1
# B   0 375   1   7
# P   0   4 395   2
# R   0  16   0 363

# What is the accuracy of the model on the test set?
(394 + 375 + 395 + 363)/ nrow(testNew) #accuracy -> 0.9801027

# You should find this value rather striking, for several reasons. The first is that it is significantly higher than 
# the value for CART, highlighting the gain in accuracy that is possible from using random forest models. 
# The second is that while the accuracy of CART decreased significantly as we transitioned from the problem of 
# predicting B/not B (a relatively simple problem) to the problem of predicting the four letters (certainly a harder problem),
# the accuracy of the random forest model decreased by a tiny amount.


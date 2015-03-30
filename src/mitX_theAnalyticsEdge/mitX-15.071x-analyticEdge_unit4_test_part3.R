# PREDICTING EARNINGS FROM CENSUS DATA
# 
# The United States government periodically collects demographic information by conducting a census.
# 
# In this problem, we are going to use census information about an individual to predict how much a person earns 
# -- in particular, whether the person earns more than $50,000 per year. This data comes from the UCI 
# Machine Learning Repository.
# 
# The file census.csv contains 1994 census data for 31,978 individuals in the United States.
# 
# The dataset includes the following 13 variables:
#     
# age = the age of the individual in years
# workclass = the classification of the individual's working status (does the person work for the federal government, work 
# for the local government, work without pay, and so on)
# education = the level of education of the individual (e.g., 5th-6th grade, high school graduate, PhD, so on)
# maritalstatus = the marital status of the individual
# occupation = the type of work the individual does (e.g., administrative/clerical work, farming/fishing, sales and so on)
# relationship = relationship of individual to his/her household
# race = the individual's race
# sex = the individual's sex
# capitalgain = the capital gains of the individual in 1994 (from selling an asset such as a stock or bond for more than 
# the original purchase price)
# capitalloss = the capital losses of the individual in 1994 (from selling an asset such as a stock or bond for less than 
# the original purchase price)
# hoursperweek = the number of hours the individual works per week
# nativecountry = the native country of the individual
# over50k = whether or not the individual earned more than $50,000 in 1994


# PROBLEM 1.1 - A LOGISTIC REGRESSION MODEL  (1 point possible)
# Let's begin by building a logistic regression model to predict whether an individual's earnings are above $50,000 
# (the variable "over50k") using all of the other variables as independent variables. First, read the dataset census.csv 
# into R.

census <- read.csv("census.csv")

# Then, split the data randomly into a training set and a testing set, setting the seed to 2000 before creating the split. 
# Split the data so that the training set contains 60% of the observations, while the testing set contains 40% of
# the observations.

library(caTools)
set.seed(2000)
spl = sample.split(census$over50k, SplitRatio = 0.6)

train = subset(census, spl==TRUE)
test = subset(census, spl==FALSE)

# Next, build a logistic regression model to predict the dependent variable "over50k", using all of the other variables
# in the dataset as independent variables. Use the training set to build the model.

# Logistic Regression Model
over50kLog = glm(over50k ~ ., data=train, family=binomial)
summary(over50kLog)


# Which variables are significant, or have factors that are significant? (Use 0.1 as your significance threshold, 
# so variables with a period or dot in the stars column should be counted too. You might see a warning message
# here - you can ignore it and proceed. This message is a warning that we might be overfitting our model to the training set.) 
# Select all that apply.

# EXPLANATION
# To read census.csv, set your working directory to the same directory that census.csv is in, and run 
# the following command:
#     
#     census = read.csv("census.csv")
# 
# We now need to split the data. Load the caTools package, and set the seed to 2000:
#     
#     library(caTools)
#     set.seed(2000)
# 
# Split the data set according to the over50k variable:
#     
#     spl = sample.split(census$over50k, SplitRatio = 0.6)
#     train = subset(census, spl==TRUE)
#     test = subset(census, spl==FALSE)
# 
# We are now ready to run logistic regression. Build the logistic regression model:
#     
#     censusglm = glm( over50k ~ . , family="binomial", data = train)
# 
# Finally, look at the model summary to identify the significant factors:
#     
#     summary(censusglm)


# PROBLEM 1.2 - A LOGISTIC REGRESSION MODEL  (2 points possible)
# What is the accuracy of the model on the testing set? Use a threshold of 0.5. 
# (You might see a warning message when you make predictions on the test set - you can safely ignore it.)

predictOver50kLog <- predict(over50kLog, newdata = test, type="response")
# Confusion matrix for threshold of 0.5
table(test$over50k, predictOver50kLog > 0.5)

#       FALSE TRUE
# <=50K  9051  662
# >50K   1190 1888
(9051 + 1888) / nrow(test) # accuracy -> 0.8552107

# EXPLANATION
# Generate the predictions for the test set:
#     
#     predictTest = predict(censusglm, newdata = test, type = "response")
# 
# Then we can generate the confusion matrix:
#     
#     table(test$over50k, predictTest >= 0.5)
# 
# If we divide the sum of the main diagonal by the sum of all of the entries in the matrix, we obtain 
# the accuracy:
#     
#     (9051+1888)/(9051+662+1190+1888) = 0.8552107

# PROBLEM 1.3 - A LOGISTIC REGRESSION MODEL  (1 point possible)
# What is the baseline accuracy for the testing set?

table(train$over50k)
#simple baseline most common outcome -> <=50K
table(test$over50k)
# <=50K   >50K 
# 9713   3078 

#accuracy for the simple baseline
(9713)/ nrow(test) # -> 0.7593621

# EXPLANATION
# We need to first determine the most frequent outcome in the training set. To do that, we table the
# dependent variable in the training set:
#     
#     table(train$over50k)
# 
# "<=50K" is the more frequent outcome (14570 observations), so this is what the baseline predicts. 
# To generate the accuracy of the baseline on the test set, we can table the dependent variable in the
# test set:
#     
#     table(test$over50k)
# 
# The baseline accuracy is
# 9713/(9713+3078) = 0.7593621.

# PROBLEM 1.4 - A LOGISTIC REGRESSION MODEL  (2 points possible)
# What is the area-under-the-curve (AUC) for this model on the test set?

library(ROCR)
ROCRpred <- prediction(predictOver50kLog, test$over50k)
as.numeric(performance(ROCRpred, "auc")@y.values) # AUC -> 0.9061598

# EXPLANATION
# First, load the ROCR package:
#     library(ROCR)
# Then you can use the following commands to compute the AUC (assuming your test set predictions are called "predictTest"):
#     ROCRpred = prediction(predictTest, test$over50k)
#     as.numeric(performance(ROCpred, "auc")@y.values)


# PROBLEM 2.1 - A CART MODEL  (2 points possible)
# We have just seen how the logistic regression model for this data achieves a high accuracy. 
# Moreover, the significances of the variables give us a way to gauge which variables are relevant 
# for this prediction task. However, it is not immediately clear which variables are more important 
# than the others, especially due to the large number of factor variables in this problem.
 
# Let us now build a classification tree to predict "over50k". Use the training set to build the model,
# and all of the other variables as independent variables. Use the default parameters, so don't set a 
# value for minbucket or cp. Remember to specify method="class" as an argument to rpart, since this 
# is a classification problem. After you are done building the model, plot the resulting tree.

# How many splits does the tree have in total?

library(rpart)
library(rpart.plot)
CARTa = rpart(over50k ~ . , data=train, method="class")
prp(CARTa)

# looking at the diagram there are in total 4 splits


# PROBLEM 2.2 - A CART MODEL  (1 point possible)
# Which variable does the tree split on at the first level (the very first split of the tree)?
#Looking at the diagram -> relationship
#2nd level -> capitalgain, education

# PROBLEM 2.4 - A CART MODEL  (2 points possible)
# What is the accuracy of the model on the testing set? Use a threshold of 0.5. 
# (You can either add the argument type="class", or generate probabilities and use a 
#  threshold of 0.5 like in logistic regression.)

predictCARTa <- predict(CARTa, newdata = test, type = "class")
#confusuinMatrix
table(test$over50k, predictCARTa)
# predictCARTa
#        <=50K  >50K
# <=50K   9243   470
# >50K    1482  1596
(9243 + 1596)/ nrow(test) # accuracy -> 0.8473927

# This highlights a very regular phenomenon when comparing CART and logistic regression. CART often 
# performs a little worse than logistic regression in out-of-sample accuracy. However, as is the case 
# here, the CART model is often much simpler to describe and understand.

# PROBLEM 2.5 - A CART MODEL  (1 point possible)
# Let us now consider the ROC curve and AUC for the CART model on the test set. You will need to get 
# predicted probabilities for the observations in the test set to build the ROC curve and compute the AUC. 
# Remember that you can do this by removing the type="class" argument when making predictions, and taking
# the second column of the resulting object.

# Plot the ROC curve for the CART model you have estimated. Observe that compared to the logistic 
# regression ROC curve, the CART ROC curve is less smooth than the logistic regression ROC curve. 
# Which of the following explanations for this behavior is most correct? 
# (HINT: Think about what the ROC curve is plotting and what changing the threshold does.)

# EXPLANATION
# Choice 1 is on the right track, but is incorrect, because the number of variables that you use in a 
# model does not determine how the ROC curve looks. In particular, try fitting logistic regression with
# hourperweek as the only variable; you will see that the ROC curve is very smooth.
# 
# Choice 2 is not correct. The smoothness of the ROC curve will generally depend on the number of data
# points, but in the case of the particular CART model we have estimated, varying the amount of testing 
# set data will not change the qualitative behavior of the ROC curve.
# 
# Choice 3 is the correct answer. The breakpoints of the curve correspond to the false and true positive 
# rates when the threshold is set to the five possible probability values.
# 
# Choice 4 is also not correct. In logistic regression, the continuity of an independent variable means that you will have a large range of predicted class probabilities in your test set data; this, in turn, means that you will see a large range of true and false positive rates as you change the threshold for generating predictions. In CART, the continuity of the variables does not at all affect the continuity of the predicted class probabilities; for our CART tree, there are only five possible probability values.

# Calculate the AUC on the test set
predictCARTa_p <- predict(CARTa, newdata = test)
predictCARTa_p_over50 <- predictCARTa_p[,2]
library(ROCR)
ROCRpred <- prediction(predictCARTa_p_over50, test$over50k)
as.numeric(performance(ROCRpred, "auc")@y.values) # AUC -> 0.8470256

# EXPLANATION
# First, if you haven't already, load the ROCR package:
# library(ROCR)
# Generate the predictions for the tree. Note that unlike the previous question, when we call the predict
# function, we leave out the argument type = "class" from the function call. Without this extra part, 
# we will get the raw probabilities of the dependent variable values for each observation, which we need 
# in order to generate the AUC. We need to take the second column of the output:
# predictTest = predict(censustree, newdata = test)
# predictTest = predictTest[,2]
# Compute the AUC:
# ROCRpred = prediction(predictTest, test$over50k)
# as.numeric(performance(ROCRpred, "auc")@y.values)


# PROBLEM 3.1 - A RANDOM FOREST MODEL  (2 points possible)
# Before building a random forest model, we'll down-sample our training set. While some modern personal 
# computers can build a random forest model on the entire training set, others might run out of memory 
# when trying to train the model since random forests is much more computationally intensive than CART 
# or Logistic Regression. For this reason, before continuing we will define a new training set to be used 
# when building our random forest model, that contains 2000 randomly selected obervations from the original
# training set. Do this by running the following commands in your R console (assuming your training set 
# is called "train"):

set.seed(1)
trainSmall = train[sample(nrow(train), 2000), ]

# Let us now build a random forest model to predict "over50k", using the dataset "trainSmall" as the data 
# used to build the model. Set the seed to 1 again right before building the model, and use all of the other 
# variables in the dataset as independent variables. (If you get an error that random forest "can not handle 
# categorical predictors with more than 32 categories", re-build the model without the nativecountry variable
# as one of the independent variables.)

set.seed(1)
over50kForest = randomForest(over50k ~ . , data = trainSmall)

# Then, make predictions using this model on the entire test set. What is the accuracy of the model on the 
# test set, using a threshold of 0.5? (Remember that you don't need a "type" argument when making predictions
# with a random forest model if you want to use a threshold of 0.5. Also, note that your accuracy might be 
# different from the one reported here, since random forest models can still differ depending on your 
# operating system, even when the random seed is set. )

# Make predictions
predictForest <- predict(over50kForest, newdata = test)

table(test$over50k, predictForest)
predictForest
#         <=50K  >50K
# <=50K   9585   128
# >50K    1986  1092

(9585 + 1092) / nrow(test) # Accuracy -> 0.8347275

# EXPLANATION
# To generate the random forest model with all of the variables, just run:
#     set.seed(1)
#     censusrf = randomForest(over50k ~ . , data = trainSmall)
# And then you can make predictions on the test set by using the following command:
#     predictTest = predict(censusrf, newdata=test)
# And to compute the accuracy, you can create the confusion matrix:
#     table(test$over50k, predictTest)
# The accuracy of the model should be around
#     (9614+1050)/nrow(test) = 0.8337112


# PROBLEM 3.2 - A RANDOM FOREST MODEL  (1 point possible)
# As we discussed in lecture, random forest models work by building a large collection of trees. As 
# a result, we lose some of the interpretability that comes with CART in terms of seeing how predictions 
# are made and which variables are important. However, we can still compute metrics that give us insight 
# into which variables are important.

# One metric that we can look at is the number of times, aggregated over all of the trees in the random 
# forest model, that a certain variable is selected for a split. To view this metric, run the following 
# lines of R code (replace "MODEL" with the name of your random forest model):
    
vu = varUsed(over50kForest, count=TRUE)
vusorted = sort(vu, decreasing = FALSE, index.return = TRUE)
dotchart(vusorted$x, names(over50kForest$forest$xlevels[vusorted$ix]))

# This code produces a chart that for each variable measures the number of times that variable was selected 
# for splitting (the value on the x-axis). Which of the following variables is the most important in terms
# of the number of splits?
#Age (from the dotchart)

# PROBLEM 3.3 - A RANDOM FOREST MODEL  (1 point possible)
# A different metric we can look at is related to "impurity", which measures how homogenous each bucket or
# leaf of the tree is. In each tree in the forest, whenever we select a variable and perform a split, the 
# impurity is decreased. Therefore, one way to measure the importance of a variable is to average 
# the reduction in impurity, taken over all the times that variable is selected for splitting in all 
# of the trees in the forest. To compute this metric, run the following command in R
# (replace "MODEL" with the name of your random forest model):
    
varImpPlot(over50kForest)

# Which one of the following variables is the most important in terms of mean reduction in impurity?
# - occupation 

# EXPLANATION
# If you generate the plot with the command varImpPlot(MODEL), you can see that occupation gives a larger 
# reduction in impurity than the other variables.
# Notice that the importance as measured by the average reduction in impurity is in general different 
# from the importance as measured by the number of times the variable is selected for splitting. Although
# age and occupation are important variables in both metrics, the order of the variables is not the same 
# in the two plots.


# PROBLEM 4.1 - SELECTING CP BY CROSS-VALIDATION  (1 point possible)
# We now conclude our study of this data set by looking at how CART behaves with different choices of 
# its parameters.
# 
# Let us select the cp parameter for our CART model using k-fold cross validation, with k = 10 folds. 
# Do this by using the train function. Set the seed beforehand to 2. Test cp values from 0.002 to 0.1 
# in 0.002 increments, by using the following command:
#     
#     cartGrid = expand.grid( .cp = seq(0.002,0.1,0.002))
# 
# Also, remember to use the entire training set "train" when building this model. 
# The train function might take some time to run.

# Install cross-validation packages
library(caret)
library(e1071)
numFolds = trainControl( method = "cv", number = 10 )
cartGrid = expand.grid( .cp = seq(0.002,0.1,0.002))

# Now, we're ready to perform cross validation.
set.seed(2)
train(over50k ~ ., data = train, method = "rpart", trControl = numFolds, tuneGrid = cartGrid )

# Which value of cp does the train function recommend?
# Accuracy was used to select the optimal model using  the largest value.
# The final value used for the model was cp = 0.002

# EXPLANATION
# Before doing anything, load the caret package:
#     
#     library(caret)
# 
# Set the seed to 2:
#     
#     set.seed(2)
# 
# Specify that we are going to use k-fold cross validation with 10 folds:
#     
#     fitControl = trainControl( method = "cv", number = 10 )
# 
# Specify the grid of cp values that we wish to evaluate:
#     
#     cartGrid = expand.grid( .cp = seq(0.002,0.1,0.002))
# 
# Finally, run the train function and view the result:
#     
#     train( over50k ~ . , data = train, method = "rpart", trControl = fitControl, tuneGrid = cartGrid )
# 
# The final output should read
# Accuracy was used to select the optimal model using the largest value.
# The final value used for the model was cp = 0.002.
# In other words, the best value was cp = 0.002, corresponding to the lowest cp value. If we look more 
# closely at the accuracy at different cp values, we can see that it seems to be decreasing steadily as 
# the cp value increases. Often, the cp value needs to become quite low before the accuracy begins to 
# deteriorate.


# PROBLEM 4.2 - SELECTING CP BY CROSS-VALIDATION  (2 points possible)
# Fit a CART model to the training data using this value of cp. 
# What is the prediction accuracy on the test set?

CARTb = rpart(over50k ~ . , data=train, method="class", cp = 0.002)
predictCARTb <- predict(CARTb, newdata = test, type = "class")
#confusuinMatrix
table(test$over50k, predictCARTb)
# predictCARTb
#        <=50K  >50K
# <=50K   9178   535
# >50K    1240  1838
(9178 + 1838)/ nrow(test) # accuracy -> 0.8612306

# EXPLANATION
# You can create a CART model with the following command:
#     model = rpart(over50k~., data=train, method="class", cp=0.002)
# You can make predictions on the test set using the following command (where "model" is the name of your
# CART model):
#     predictTest = predict(model, newdata=test, type="class")
# Then you can generate the confusion matrix with the command
#     table(test$over50k, predictTest)
# The accuracy is (9178+1838)/(9178+535+1240+1838) = 0.8612306.



# PROBLEM 4.3 - SELECTING CP BY CROSS-VALIDATION  (1 point possible)
# Compared to the original accuracy using the default value of cp, this new CART model is an 
# improvement, and so we should clearly favor this new model over the old one -- or should we? 
# Plot the CART tree for this model. How many splits are there?
prp(CARTb)
 #-> 18 splits

# This highlights one important tradeoff in building predictive models. By tuning cp, we improved 
# our accuracy by over 1%, but our tree became significantly more complicated. In some applications, 
# such an improvement in accuracy would be worth the loss in interpretability. In others, we may 
# prefer a less accurate model that is simpler to understand and describe over a more accurate 
# -- but more complicated -- model.


# PREDICTING STOCK RETURNS WITH CLUSTER-THEN-PREDICT
# In the second lecture sequence this week, we heard about cluster-then-predict, a methodology in which you
# first cluster observations and then build cluster-specific prediction models. In the lecture sequence, 
# we saw how this methodology helped improve the prediction of heart attack risk. In this assignment, 
# we'll use cluster-then-predict to predict future stock prices using historical stock data.
# 
# When selecting which stocks to invest in, investors seek to obtain good future returns. In this problem, 
# we will first use clustering to identify clusters of stocks that have similar returns over time. Then, 
# we'll use logistic regression to predict whether or not the stocks will have positive future returns.
# 
# For this problem, we'll use StocksCluster.csv, which contains monthly stock returns from the NASDAQ stock
# exchange. The NASDAQ is the second-largest stock exchange in the world, and it lists many technology companies.
# The stock price data used in this problem was obtained from infochimps, a website providing access to 
# many datasets.
# 
# Each observation in the dataset is the monthly returns of a particular company in a particular year. 
# The years included are 2000-2009. The companies are limited to tickers that were listed on the exchange 
# for the entire period 2000-2009, and whose stock price never fell below $1. So, for example, one observation
# is for Yahoo in 2000, and another observation is for Yahoo in 2001. Our goal will be to predict whether 
# or not the stock return in December will be positive, using the stock returns for the first 11 months of
# the year.
# 
# This dataset contains the following variables:
# 
# ReturnJan = the return for the company's stock during January (in the year of the observation). 
# ReturnFeb = the return for the company's stock during February (in the year of the observation). 
# ReturnMar = the return for the company's stock during March (in the year of the observation). 
# ReturnApr = the return for the company's stock during April (in the year of the observation). 
# ReturnMay = the return for the company's stock during May (in the year of the observation). 
# ReturnJune = the return for the company's stock during June (in the year of the observation). 
# ReturnJuly = the return for the company's stock during July (in the year of the observation). 
# ReturnAug = the return for the company's stock during August (in the year of the observation). 
# ReturnSep = the return for the company's stock during September (in the year of the observation). 
# ReturnOct = the return for the company's stock during October (in the year of the observation). 
# ReturnNov = the return for the company's stock during November (in the year of the observation). 
# PositiveDec = whether or not the company's stock had a positive return in December (in the year of the observation). This variable takes value 1 if the return was positive, and value 0 if the return was not positive.
# 
# For the first 11 variables, the value stored is a proportional change in stock value during that month. 
# For instance, a value of 0.05 means the stock increased in value 5% during the month, while a value of
# -0.02 means the stock decreased in value 2% during the month.

stocks <- read.csv("StocksCluster.csv", header = TRUE)
str(stocks) # 11580 obs and 12 variables

# What proportion of the observations have positive returns in December?
table(stocks$PositiveDec)
# 1 -> 6324
# 0 -> 5256
6324 / (6324 + 5256) # -> 0.546114

# What is the maximum correlation between any two return variables in the dataset? You should look at the 
# pairwise correlations between ReturnJan, ReturnFeb, ReturnMar, ReturnApr, ReturnMay, ReturnJune, 
# ReturnJuly, ReturnAug, ReturnSep, ReturnOct, and ReturnNov.
correlationStocksVars <- cor(stocks[, -12])
correlationStocksVars
# the largest correlation coefficient is 0.19167279, between ReturnOct and ReturnNov.

# Which month (from January through November) has the largest mean return across all observations in the dataset?
which.max(colMeans(stocks[, -12]))
which.min(colMeans(stocks[, -12]))

# PROBLEM 2.1 - INITIAL LOGISTIC REGRESSION MODEL  (2 points possible)
# Run the following commands to split the data into a training set and testing set, putting 70% of the 
# data in the training set and 30% of the data in the testing set:
#     
#     set.seed(144)
# 
# spl = sample.split(stocks$PositiveDec, SplitRatio = 0.7)
# 
# stocksTrain = subset(stocks, spl == TRUE)
# 
# stocksTest = subset(stocks, spl == FALSE)
# 
# Then, use the stocksTrain data frame to train a logistic regression model (name it StocksModel) to predict 
# PositiveDec using all the other variables as independent variables. 
# Don't forget to add the argument family=binomial to your glm command.
# 
# What is the overall accuracy on the training set, using a threshold of 0.5?
library(caTools)
set.seed(144)
spl <- sample.split(stocks$PositiveDec, SplitRatio = 0.7)
stocksTrain <- subset(stocks, spl == TRUE)
stocksTest <- subset(stocks, spl == FALSE)

stockModel_LRM <-  glm(PositiveDec ~ ., data = stocksTrain, family = binomial)
summary(stockModel_LRM)
predictedTrainStocks <- predict(stockModel_LRM, type = "response") # Working on the Training data set
table(stocksTrain$PositiveDec, predictedTrainStocks > 0.5)

# FALSE TRUE
# 0   990 2689
# 1   787 3640
#Accuracy -> 0.5715026
(990 + 3640)/ (990 + 3640 + 787 + 2689)

# Now obtain test set predictions from StocksModel. What is the overall accuracy of the model on the test,
# again using a threshold of 0.5?

predictedTestStocks <- predict(stockModel_LRM, newdata = stocksTest, type = "response")
table(stocksTest$PositiveDec, predictedTestStocks > 0.5)

# FALSE TRUE
# 0   417 1160
# 1   344 1553

#Accuracy ->  0.5670697
(417 + 1553)/(417 + 1553 + 344 + 1160)

# What is the accuracy on the test set of a baseline model that always predicts the most common outcome
# (PositiveDec = 1)?

table(stocksTest$PositiveDec)
1897 / (1897 + 1577) # Accuracy -> 0.5460564

# Now, let's cluster the stocks. The first step in this process is to remove the dependent variable using
# the following commands:

limitedTrain <- stocksTrain
limitedTrain$PositiveDec <- NULL

limitedTest <- stocksTest
limitedTest$PositiveDec <- NULL

# Why do we need to remove the dependent variable in the clustering phase of the cluster-then-predict 
# methodology?

# EXPLANATION
# In cluster-then-predict, our final goal is to predict the dependent variable, which is unknown to us at 
# the time of prediction. Therefore, if we need to know the outcome value to perform the clustering, the 
# methodology is no longer useful for prediction of an unknown outcome value.
# 
# This is an important point that is sometimes mistakenly overlooked. If you use the outcome value to cluster, 
# you might conclude your method strongly outperforms a non-clustering alternative. However, this is because 
# it is using the outcome to determine the clusters, which is not valid.

# Normalization
# In the market segmentation assignment in this week's homework, you were introduced to the preProcess command 
# from the caret package, which normalizes variables by subtracting by the mean and dividing by the standard 
# deviation.

# In cases where we have a training and testing set, we'll want to normalize by the mean and standard deviation 
# of the variables in the training set. We can do this by passing just the training set to the preProcess 
# function:
    
library(caret)
preproc <- preProcess(limitedTrain)
normTrain <- predict(preproc, limitedTrain)
normTest <- predict(preproc, limitedTest)

# What is the mean of the ReturnJan variable in normTrain & normTest?
mean(normTrain$ReturnJan) # 2.100586e-17
mean(normTest$ReturnJan) # -0.0004185886

# From mean(stocksTrain$ReturnJan) and mean(stocksTest$ReturnJan), we see that the average return in January
# is slightly higher in the training set than in the testing set. Since normTest was constructed by subtracting
# by the mean ReturnJan value from the training set, this explains why the mean value of ReturnJan is slightly 
# negative in normTest.


# Set the random seed to 144 (it is important to do this again, even though we did it earlier). Run k-means 
# clustering with 3 clusters on normTrain, storing the result in an object called km.
# 
# Which cluster has the largest number of observations?
set.seed(144)
km <- kmeans(normTrain, 3)
clusters <- km$cluster
which.max(table(clusters)) # Cluster2

# Recall from the recitation that we can use the flexclust package to obtain training set and testing set cluster
# assignments for our observations (note that the call to as.kcca may take a while to complete):
install.packages("flexclust")    
library(flexclust)
km.kcca <- as.kcca(km, normTrain)
clusterTrain <- predict(km.kcca)
clusterTest <- predict(km.kcca, newdata=normTest)

# How many test-set observations were assigned to Cluster 2?
table(clusterTest)
# clusterTest
#   1    2    3 
# 1298 2080   96 
# Cluster 2-> 2080

# Using the subset function, build data frames stocksTrain1, stocksTrain2, and stocksTrain3, containing the
# elements in the stocksTrain data frame assigned to clusters 1, 2, and 3, respectively 
# (be careful to take subsets of stocksTrain, not of normTrain). Similarly build stocksTest1, stocksTest2, 
# and stocksTest3 from the stocksTest data frame.

stockTrain1 <- subset(stocksTrain, clusterTrain == 1)
stockTrain2 <- subset(stocksTrain, clusterTrain == 2)
stockTrain3 <- subset(stocksTrain, clusterTrain == 3)

stockTest1 <- subset(stocksTest, clusterTest == 1)
stockTest2 <- subset(stocksTest, clusterTest == 2)
stockTest3 <- subset(stocksTest, clusterTest == 3)

# Which training set data frame has the highest average value of the dependent variable?
mean(stockTrain1$PositiveDec)
mean(stockTrain2$PositiveDec)
mean(stockTrain3$PositiveDec)
# -> stockTrain1

#Logist Regression Models
# Build logistic regression models StocksModel1, StocksModel2, and StocksModel3, which predict PositiveDec
# using all the other variables as independent variables. StocksModel1 should be trained on stocksTrain1, 
# StocksModel2 should be trained on stocksTrain2, and StocksModel3 should be trained on stocksTrain3.

StockModel1 <- glm(PositiveDec ~ ., family = binomial, data = stockTrain1)
StockModel2 <- glm(PositiveDec ~ ., family = binomial, data = stockTrain2)
StockModel3 <- glm(PositiveDec ~ ., family = binomial, data = stockTrain3)

# Which variables have a positive sign for the coefficient in at least one of StocksModel1, StocksModel2, 
# and StocksModel3 and a negative sign for the coefficient in at least one of StocksModel1, StocksModel2, 
# and StocksModel3? Select all that apply.
summary(StockModel1)
summary(StockModel2)
summary(StockModel3)

# From summary(StocksModel1), summary(StocksModel2), and summary(StocksModel3), ReturnJan, 
# ReturnFeb, ReturnMar, ReturnJune, ReturnAug, and ReturnOct differ in sign between the models.

# Using StocksModel1, make test-set predictions called PredictTest1 on the data frame stocksTest1.
# Using StocksModel2, make test-set predictions called PredictTest2 on the data frame stocksTest2.
# Using StocksModel3, make test-set predictions called PredictTest3 on the data frame stocksTest3.

predictionTest1 <- stats::predict(StockModel1, newdata = stockTest1, type = "response")
predictionTest2 <- stats::predict(StockModel2, newdata = stockTest2, type = "response")
predictionTest3 <- stats::predict(StockModel3, newdata = stockTest3, type = "response")

# What is the overall accuracy of StocksModel1 on the test set stocksTest1, 
# using a threshold of 0.5?
table(stockTest1$PositiveDec, predictionTest1 > 0.5)
# FALSE TRUE
# 0    30  471
# 1    23  774
#Accuracy -> 0.6194145
(30 + 774)/ (30 + 774 + 23 + 471)

table(stockTest2$PositiveDec, predictionTest2 > 0.5)
# FALSE TRUE
# 0   388  626
# 1   309  757
(388 + 757)/(388+757+309+626) # 0.5504808

table(stockTest3$PositiveDec, predictionTest3 > 0.5)
# FALSE TRUE
# 0    49   13
# 1    21   13
(49+13)/(49+13+21+13) # -> 0.6458333

# To compute the overall test-set accuracy of the cluster-then-predict approach, we can combine all the 
# test-set predictions into a single vector and all the true outcomes into a single vector:
    
AllPredictions <- c(predictionTest1, predictionTest2, predictionTest3)
AllOutcomes <- c(stockTest1$PositiveDec, stockTest2$PositiveDec, stockTest3$PositiveDec)

# What is the overall test-set accuracy of the cluster-then-predict approach, again using a threshold of 0.5?
table(AllOutcomes, AllPredictions > 0.5)
# AllOutcomes FALSE TRUE
#          0   467 1110
#          1   353 1544
(467 + 1544) / (467 + 1544 + 353 + 1110) #0.5788716

# We see a modest improvement over the original logistic regression model. Since predicting stock returns is 
# a notoriously hard problem, this is a good increase in accuracy. By investing in stocks for which we are 
# more confident that they will have positive returns (by selecting the ones with higher predicted probabilities), 
# this cluster-then-predict model can give us an edge over the original logistic regression model.

# Language Setting
Sys.setlocale("LC_ALL", "C")

# SEPARATING SPAM FROM HAM (PART 1)
# 
# Nearly every email user has at some point encountered a "spam" email, which is an unsolicited message often advertising a product, 
# containing links to malware, or attempting to scam the recipient. Roughly 80-90% of more than 100 billion emails sent each day are
# spam emails, most being sent from botnets of malware-infected computers. The remainder of emails are called "ham" emails.
# 
# As a result of the huge number of spam emails being sent across the Internet each day, most email providers offer a spam filter that
# automatically flags likely spam messages and separates them from the ham. Though these filters use a number of techniques (e.g. looking 
# up the sender in a so-called "Blackhole List" that contains IP addresses of likely spammers), most rely heavily on the analysis of the 
# contents of an email via text analytics.
# 
# In this homework problem, we will build and evaluate a spam filter using a publicly available dataset first described in the 2006 
# conference paper "Spam Filtering with Naive Bayes -- Which Naive Bayes?" by V. Metsis, I. Androutsopoulos, and G. Paliouras. 
# The "ham" messages in this dataset come from the inbox of former Enron Managing Director for Research Vincent Kaminski, one of the
# inboxes in the Enron Corpus. One source of spam messages in this dataset is the SpamAssassin corpus, which contains hand-labeled 
# spam messages contributed by Internet users. The remaining spam was collected by Project Honey Pot, a project that collects spam 
# messages and identifies spammers by publishing email address that humans would know not to contact but that bots might target with spam.
# The full dataset we will use was constructed as roughly a 75/25 mix of the ham and spam messages.
# 
# The dataset contains just two fields:
#   
# - text: The text of the email.
# - spam: A binary variable indicating if the email was spam.


# PROBLEM 1.1 - LOADING THE DATASET  (1 point possible)
# Begin by loading the dataset emails.csv into a data frame called emails. Remember to pass the stringsAsFactors=FALSE option when
# loading the data.
# 
# How many emails are in the dataset?
emails <- read.csv("emails.csv", stringsAsFactors = FALSE)
str(emails) # -> 5728 obs./ emails

# PROBLEM 1.2 - LOADING THE DATASET  (1 point possible)
# How many of the emails are spam?
table(emails$spam) # -> 1368 (spam = 1)

# PROBLEM 1.3 - LOADING THE DATASET  (1 point possible)
# Which word appears at the beginning of every email in the dataset? Respond as a lower-case word with punctuation removed.
head(emails$text)
tail(emails$text)
# -> subject

# PROBLEM 1.4 - LOADING THE DATASET  (1 point possible)
# Could a spam classifier potentially benefit from including the frequency of the word that appears in every email?
# EXPLANATION
# We know that each email has the word "subject" appear at least once, but the frequency with which it appears might help us
# differentiate spam from ham. For instance, a long email chain would have the word "subject" appear a number of times, and this
# higher frequency might be indicative of a ham message.

# PROBLEM 1.5 - LOADING THE DATASET  (1 point possible)
# The nchar() function counts the number of characters in a piece of text. How many characters are in the longest email in the dataset
# (where longest is measured in terms of the maximum number of characters)?
max(nchar(emails$text)) # -> 43952

# PROBLEM 1.6 - LOADING THE DATASET  (1 point possible)
# Which row contains the shortest email in the dataset? (Just like in the previous problem, shortest is measured in terms of 
# the fewest number of characters.)
which.min(nchar(emails$text)) # -> 1992

# PROBLEM 2.1 - PREPARING THE CORPUS  (2 points possible)
# Follow the standard steps to build and pre-process the corpus:

library(tm)
library(SnowballC)

# 1) Build a new corpus variable called corpus.
corpus <- Corpus(VectorSource(emails$text))
# 2) Using tm_map, convert the text to lowercase.
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, PlainTextDocument)
# 3) Using tm_map, remove all punctuation from the corpus.
corpus <- tm_map(corpus, removePunctuation)
# 4) Using tm_map, remove all English stopwords from the corpus.
corpus <- tm_map(corpus, removeWords, stopwords("english"))
# 5) Using tm_map, stem the words in the corpus.
corpus <- tm_map(corpus, stemDocument)
# 6) Build a document term matrix from the corpus, called dtm.
dtm <- DocumentTermMatrix(corpus)

# If the code length(stopwords("english")) does not return 174 for you, then please run the line of code in this file, which will 
# store the standard stop words in a variable called sw. When removing stop words, use tm_map(corpus, removeWords, sw) instead of 
# tm_map(corpus, removeWords, stopwords("english")).
# 
# How many terms are in dtm?
dtm
# <<DocumentTermMatrix (documents: 5728, terms: 28687)>> -> 28687

# PROBLEM 2.2 - PREPARING THE CORPUS  (1 point possible)
# To obtain a more reasonable number of terms, limit dtm to contain terms appearing in at least 5% of documents, and store this 
# result as spdtm (don't overwrite dtm, because we will use it in a later step of this homework). How many terms are in spdtm?

spdtm <- removeSparseTerms(dtm, 0.95) # 5% sparsiness
spdtm # <<DocumentTermMatrix (documents: 5728, terms: 330)>> -> 330

# PROBLEM 2.3 - PREPARING THE CORPUS  (2 points possible)
# Build a data frame called emailsSparse from spdtm, and use the make.names function to make the variable names of emailsSparse valid.
# 
# colSums() is an R function that returns the sum of values for each variable in our data frame. Our data frame contains the number
# of times each word stem (columns) appeared in each email (rows). Therefore, colSums(emailsSparse) returns the number of times a 
# word stem appeared across all the emails in the dataset. What is the word stem that shows up most frequently across all the emails
# in the dataset? Hint: think about how you can use sort() or which.max() to pick out the maximum frequency.

# Since R struggles with variable names that start with a number,
# and we probably have some words here that start with a number,
# let's run the make.names function to make sure
# all of our words are appropriate variable names.
# To do this type colnames and then in parentheses the name
# of our data frame, tweetsSparse equals
emailsSparse <- as.data.frame(as.matrix(spdtm))
colnames(emailsSparse) <- make.names(colnames(emailsSparse))
which.max(colSums(emailsSparse)) # -> enron, 92

# EXPLANATION
# colSums(emailsSparse) contains the sum of all the values for each column in our data frame. Since the values in the data frame are the
# frequencies of the stem in the column for the email in the row, these column sums represent the frequencies of the stems across all 
# emails.
# We can either use sort() or which.max() to pick out the most common word:
# sort(colSums(emailsSparse))
# which.max(colSums(emailsSparse))

# PROBLEM 2.4 - PREPARING THE CORPUS  (1 point possible)
# Add a variable called "spam" to emailsSparse containing the email spam labels. You can do this by copying over the "spam" 
# variable from the original data frame (remember how we did this in the Twitter lecture).
# 
# How many word stems appear at least 5000 times in the ham emails in the dataset? Hint: in this and the next question, remember 
# not to count the dependent variable we just added.
emailsSparse$spam <- emails$spam
sum(emailsSparse$spam) #1368 that is < 5000
tmp <- emailsSparse[emailsSparse$spam == 0,]
sum(colSums(tmp) >= 5000) #6
which(colSums(tmp) >= 5000)#to see the details

# EXPLANATION
# We can read the most frequent terms in the ham dataset with sort(colSums(subset(emailsSparse, spam == 0))). 
# "enron", "ect", "subject", "vinc", "will", and "hou" appear at least 5000 times in the ham dataset.

# PROBLEM 2.5 - PREPARING THE CORPUS  (1 point possible)
# How many word stems appear at least 1000 times in the spam emails in the dataset?
tmp <- emailsSparse[emailsSparse$spam == 1,]
sum(colSums(tmp) >= 1000) #4 (3 without spam)
which(colSums(tmp) >= 1000)#to see the details

# EXPLANATION
# We can limit the dataset to the spam emails with subset(emailsSparse, spam == 1). Therefore, we can read the most frequent terms
# with sort(colSums(subset(emailsSparse, spam == 1))). "subject", "will", and "compani" are the three stems that appear at least
# 1000 times. Note that the variable "spam" is the dependent variable and is not the frequency of a word stem.

# PROBLEM 3.1 - BUILDING MACHINE LEARNING MODELS  (3 points possible)
# First, convert the dependent variable to a factor with "emailsSparse$spam = as.factor(emailsSparse$spam)".
emailsSparse$spam = as.factor(emailsSparse$spam)

# Next, set the random seed to 123 and use the sample.split function to split emailsSparse 70/30 into a training set called "train" and 
# a testing set called "test". Make sure to perform this step on emailsSparse instead of emails.
library(caTools)
set.seed(123)
spl <- sample.split(emailsSparse$spam, 0.7)

train <- subset(emailsSparse, spl == TRUE)
test <- subset(emailsSparse, spl == FALSE)

# Using the training set, train the following three machine learning models. The models should predict the dependent variable "spam", 
# using all other available variables as independent variables. Please be patient, as these models may take a few minutes to train.

# 1) A logistic regression model called spamLog. You may see a warning message here - we'll discuss this more later.
spamLog <- glm(spam ~ ., data = train, family = binomial)
# Warning messages:
# 1: glm.fit: algorithm did not converge 
# 2: glm.fit: fitted probabilities numerically 0 or 1 occurred 

# 2) A CART model called spamCART, using the default parameters to train the model (don't worry about adding minbucket or cp). 
# Remember to add the argument method="class" since this is a binary classification problem.
library(rpart)
library(rpart.plot)
spamCART <- rpart(spam ~ ., data=train, method="class")
prp(spamCART)

# 3) A random forest model called spamRF, using the default parameters to train the model 
# (don't worry about specifying ntree or nodesize). Directly before training the random forest model, set the random seed to 123 
# (even though we've already done this earlier in the problem, it's important to set the seed right before training the model so we
# all obtain the same results. Keep in mind though that on certain operating systems, your results might still be slightly different).
library(randomForest)
set.seed(123)
spamRF <- randomForest(spam ~ ., data=train)



# For each model, obtain the predicted spam probabilities for the training set. Be careful to obtain probabilities instead of predicted 
# classes, because we will be using these values to compute training set AUC values. Recall that you can obtain probabilities for CART
# models by not passing any type parameter to the predict() function, and you can obtain probabilities from a random forest by adding 
# the argument type="prob". For CART and random forest, you need to select the second column of the output of the predict() function, 
# corresponding to the probability of a message being spam.
trainPredictionLog <- predict(spamLog, type = "response")
trainPredictionCART <- predict(spamCART)[,2]
trainPredictionRF <- predict(spamRF, type = "prob")[,2]

# You may have noticed that training the logistic regression model yielded the messages "algorithm did not converge" and 
# "fitted probabilities numerically 0 or 1 occurred". Both of these messages often indicate overfitting and the first indicates 
# particularly severe overfitting, often to the point that the training set observations are fit perfectly by the model. Let's investigate
# the predicted probabilities from the logistic regression model.
                                                                                         
# How many of the training set predicted probabilities from spamLog are less than 0.00001?
sum(trainPredictionLog < 0.00001) #3046

# How many of the training set predicted probabilities from spamLog are more than 0.99999?
sum(trainPredictionLog > 0.99999) #954

#How many of the training set predicted probabilities from spamLog are between 0.00001 and 0.99999?
sum(trainPredictionLog <= 0.99999 & trainPredictionLog >= 0.00001 ) #10

# EXPLANATION
# To check the number of probabilities with these characteristics, we can use:
#   
# table(predTrainLog < 0.00001)
# table(predTrainLog > 0.99999)
# table(predTrainLog >= 0.00001 & predTrainLog <= 0.99999)
# 
# You might have gotten slightly different answers than the ones you see here, because the glm function has a hard time converging
# with this many independent variables. That's okay - your answers should still be marked as correct.

# PROBLEM 3.2 - BUILDING MACHINE LEARNING MODELS  (1 point possible)
# How many variables are labeled as significant (at the p=0.05 level) in the logistic regression summary output?

summary(spamLog)
# EXPLANATION
# From summary(spamLog), we see that none of the variables are labeled as significant (a symptom of the logistic regression algorithm
# not converging).

# PROBLEM 3.3 - BUILDING MACHINE LEARNING MODELS  (1 point possible)
# How many of the word stems "enron", "hou", "vinc", and "kaminski" appear in the CART tree? Recall that we suspect these word stems
# are specific to Vincent Kaminski and might affect the generalizability of a spam filter built with his ham data.
prp(spamCART) # 2
# EXPLANATION
# From prp(spamCART), we see that "vinc" and "enron" appear in the CART tree as the top two branches, but that "hou" and "kaminski" 
# do not appear.


# PROBLEM 3.4 - BUILDING MACHINE LEARNING MODELS  (1 point possible)
# What is the training set accuracy of spamLog, using a threshold of 0.5 for predictions?

table(train$spam, trainPredictionLog >= 0.5)
# FALSE TRUE
# 0  3052    0
# 1     4  954
#Accuracy
(3052 + 954)/ (3052 + 954 + 4) #0.9990025

# PROBLEM 3.5 - BUILDING MACHINE LEARNING MODELS  (1 point possible)
# What is the training set AUC of spamLog?
library(ROCR)
ROC.Pred = prediction(trainPredictionLog, train$spam)
ROC.Perf = performance(ROC.Pred, "tpr", "fpr")
plot(ROC.Perf)
as.numeric(performance(ROC.Pred, "auc")@y.values) # 0.9999959

# PROBLEM 3.6 - BUILDING MACHINE LEARNING MODELS  (1 point possible)
# What is the training set accuracy of spamCART, using a threshold of 0.5 for predictions? (Remember that if you used the type="class"
# argument when making predictions, you automatically used a threshold of 0.5. If you did not add in the type argument to the predict 
# function, the probabilities are in the second column of the predict output.)
table(train$spam, trainPredictionCART >= 0.5)
#   FALSE TRUE
# 0  2885  167
# 1    64  894
#Accuracy
(2885 + 894)/(2885 + 894 + 64 + 167) #0.942394

# PROBLEM 3.7 - BUILDING MACHINE LEARNING MODELS  (1 point possible)
# What is the training set AUC of spamCART? (Remember that you have to pass the prediction function predicted probabilities, 
# so don't include the type argument when making predictions for your CART model.)

ROC.Pred.CART <- prediction(trainPredictionCART, train$spam)
as.numeric(performance(ROC.Pred.CART, "auc")@y.values) # 0.9696044

# PROBLEM 3.8 - BUILDING MACHINE LEARNING MODELS  (1 point possible)
# What is the training set accuracy of spamRF, using a threshold of 0.5 for predictions? (Remember that your answer might not match
# ours exactly, due to random behavior in the random forest algorithm on different operating systems.)
table(train$spam, trainPredictionRF > 0.5)
#   FALSE TRUE
# 0  3013   39
# 1    44  914
#Accuracy
(3013 + 914)/(3013 + 914 + 44 + 39) #0.9793017

# PROBLEM 3.9 - BUILDING MACHINE LEARNING MODELS  (2 points possible)
# What is the training set AUC of spamRF? (Remember to pass the argument type="prob" to the predict function to get predicted 
# probabilities for a random forest model. The probabilities will be the second column of the output.)
ROC.Pred.RF <- prediction(trainPredictionRF, train$spam)
as.numeric(performance(ROC.Pred.RF, "auc")@y.values) # 0.9979116

# PROBLEM 4.1 - EVALUATING ON THE TEST SET  (1 point possible)
# Obtain predicted probabilities for the testing set for each of the models, again ensuring that probabilities instead of classes
# are obtained.
# What is the testing set accuracy of spamLog, using a threshold of 0.5 for predictions?
testPredictionLog <- predict(spamLog, newdata = test, type = "response")
table(test$spam, testPredictionLog > 0.5)
# FALSE TRUE
# 0  1257   51
# 1    34  376
#Accuracy 
(1257+376)/ (1257+376+51+34) # -> 0.9505239

# EXPLANATION
# The predicted probabilities can be obtained with:
# predTestLog = predict(spamLog, newdata=test, type="response")
# predTestCART = predict(spamCART, newdata=test)[,2]
# predTestRF = predict(spamRF, newdata=test, type="prob")[,2]

# What is the testing set AUC of spamLog?
ROC.Pred.test <- prediction(testPredictionLog, test$spam)
as.numeric(performance(ROC.Pred.test, "auc")@y.values) # 0.9627517

# What is the testing set accuracy of spamCART, using a threshold of 0.5 for predictions?
# What is the testing set AUC of spamCART?
testPredictionCART <- predict(spamCART, newdata = test)[,2]
table(test$spam, testPredictionCART > 0.5)
# FALSE TRUE
# 0  1228   80
# 1    24  386
#Accuracy 
(1228+386)/ (1228+386+80+24) # -> 0.9394645

ROC.Pred.CART.test <- prediction(testPredictionCART, test$spam)
as.numeric(performance(ROC.Pred.CART.test, "auc")@y.values) # 0.963176

# What is the testing set accuracy of spamRF, using a threshold of 0.5 for predictions?
# What is the testing set AUC of spamRF?
testPredictionRF <- predict(spamRF, type = "prob", newdata = test)[,2]
table(test$spam, testPredictionRF > 0.5)
# FALSE TRUE
# 0  1290   18
# 1    25  385
#Accuracy 
(1290+385)/ (1290+385+18+25) # -> 0.9749709

ROC.Pred.RF.test <- prediction(testPredictionRF, test$spam)
as.numeric(performance(ROC.Pred.RF.test, "auc")@y.values) # 0.9975656

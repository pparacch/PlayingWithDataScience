# IMPORTANT NOTE
# 
# In the following video, we ask you to install the "tm" package to perform the pre-processing steps. Due to function changes that occurred 
# after this video was recorded, you will need to run the following command immediately after converting all of the words to lowercase
# letters (it converts all documents in the corpus to the PlainTextDocument type):
#   
#   corpus = tm_map(corpus, PlainTextDocument)
# 
# Then you can continue with the R commands as they are in the video.


#Important Setting
sw = c("i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", 
       "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", 
       "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be",
       "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "would", "should", "could", "ought", 
       "i'm", "you're", "he's", "she's", "it's", "we're", "they're", "i've", "you've", "we've", "they've", "i'd", "you'd", 
       "he'd", "she'd", "we'd", "they'd", "i'll", "you'll", "he'll", "she'll", "we'll", "they'll", "isn't", "aren't", "wasn't", 
       "weren't", "hasn't", "haven't", "hadn't", "doesn't", "don't", "didn't", "won't", "wouldn't", "shan't", "shouldn't", "can't", 
       "cannot", "couldn't", "mustn't", "let's", "that's", "who's", "what's", "here's", "there's", "when's", "where's", "why's", 
       "how's", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with",
       "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", 
       "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where",
       "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only",
       "own", "same", "so", "than", "too", "very")

# Language Setting
Sys.setlocale("LC_ALL", "C")

# Unit 5 - Twitter

# Pre-processing the data can be difficult,
# but, luckily, R's packages provide easy-to-use functions
# for the most common tasks.

# Read in the data
# since we're working with text data here,
# we need one extra argument, which is
# stringsAsFactors=FALSE.
tweets = read.csv("tweets.csv", stringsAsFactors=FALSE)
str(tweets)

# we have 1,181 observations of two variables,
# the text of the tweet, called Tweet,
# and the average sentiment score, called Avg for average.
# The tweet texts are real tweets that we
# found on the internet directed to Apple with a few cleaned up
# words.

# We're more interested in being able to detect
# the tweets with clear negative sentiment,
# so let's define a new variable in our data
# set tweets called Negative.
# And we'll set this equal to as.factor(tweets$Avg <= -1).

# Create dependent variable
tweets$Negative = as.factor(tweets$Avg <= -1)

# This will set tweets$Negative equal to true if the average
# sentiment score is less than or equal to negative 1 and will
# set tweets$Negative equal to false if the average sentiment
# score is greater than negative 1.
# Let's look at a table of this new variable, Negative.

table(tweets$Negative)
# We can see that 182 of the 1,181 tweets, or about 15%,
# are negative.


# Now to pre-process our text data so
# that we can use the bag of words approach,
# we'll be using the tm text mining package.
# We'll need to install and load two packages to do this.
# Install new packages
install.packages("tm")
library(tm)

# Then we also need to install the package SnowballC.
# This package helps us use the tm package.
# And go ahead and load the snowball package as well.
install.packages("SnowballC")
library(SnowballC)

# One of the concepts introduced by the tm package
# is that of a corpus.
# A corpus is a collection of documents.
# We'll need to convert our tweets to a corpus for pre-processing.
# tm can create a corpus in many different ways,
# but we'll create it from the tweet column of our data frame
# using two functions, Corpus and VectorSource.
# We'll call our corpus "corpus" and then
# use the Corpus and the VectorSource functions
# called on our tweets variable of our tweets data set.
# So that's tweets$Tweet.

# Create corpus
corpus = Corpus(VectorSource(tweets$Tweet))

# Look at corpus
corpus

# And we can check that the documents match our tweets
# by using double brackets.
# So type corpus[[1]].
# 
# This shows us the first tweet in our corpus.
# Now we're ready to start pre-processing our data.

corpus[[1]]

# Pre-processing is easy in tm.
# Each operation, like stemming or removing stop words,
# can be done with one line in R, where
# we use the tm_map function.
# Let's try it out by changing all of the text in our tweets
# to lowercase.
# To do that, we'll replace our corpus
# with the output of the tm_map function, where
# the first argument is the name of our corpus
# and the second argument is what we want to do.
# In this case, tolower.
# tolower is a standard function in R,
# and this is like when we pass mean to the tapply function.
# We're passing the tm_map function
# a function to use on our corpus.

# Convert to lower-case
corpus = tm_map(corpus, tolower)
# Let's see what that did by looking at our first tweet
# again.
# Go ahead and hit the up arrow twice to get back
# to corpus[[1]] and now we can see that all of our letters are
# lowercase.
corpus[[1]]

# IMPORTANT NOTE: If you are using the latest version of the tm package, you will need to run the following line before continuing 
# (it converts corpus to a Plain Text Document). This is a recent change having to do with the tolower function that occurred after this video was recorded.
corpus = tm_map(corpus, PlainTextDocument)

# Now let's remove all punctuation.
# This is done in a very similar way,
# except this time we give the argument
# removePunctuation instead of tolower.
# Hit the up arrow twice, and in the tm_map function,
# delete tolower, and type removePunctuation.

# Remove punctuation
corpus = tm_map(corpus, removePunctuation)

# Let's see what this did to our first tweet again.
# Now the comma after "say", the exclamation point after
# "received", and the @ symbols before "Apple" are all gone.
corpus[[1]]

# Now we want to remove the stop words in our tweets.
# tm provides a list of stop words for the English language.
# We can check it out by typing stopwords("english") [1:10].
# Look at stop words 
stopwords("english")[1:10]

# Removing words can be done with the removeWords argument
# to the tm_map function, but we need one extra argument
# this time-- what the stop words are that we want to remove.
# We'll remove all of these English stop words,
# but we'll also remove the word "apple"
# since all of these tweets have the word "apple"
# and it probably won't be very useful in our prediction
# problem.

# Then we need to add one extra argument, c("apple").
# 
# This is us removing the word "apple."
# And then stopwords("english").


# Remove stopwords and apple
corpus = tm_map(corpus, removeWords, c("apple", stopwords("english")))

# So this will remove the word "apple"
# and all of the English stop words.
# Let's take a look at our first tweet
# again to see what happened.

corpus[[1]]

# Now we can see that we have significantly fewer words, only
# the words that are not stop words.

# Lastly, we want to stem our document with the stemDocument
# argument.

# Stem document 
corpus = tm_map(corpus, stemDocument)

corpus[[1]]

# we can see that this took off the ending of "customer,"
# "service," "received," and "appstore."

# In the next video, we'll investigate our corpus
# and prepare it for our prediction problem.


# Video 6

# In the previous video, we preprocessed our data,
# and we're now ready to extract the word frequencies to be
# used in our prediction problem.
# The tm package provides a function called
# DocumentTermMatrix that generates a matrix where
# the rows correspond to documents, in our case tweets,
# and the columns correspond to words in those tweets.
# The values in the matrix are the number
# of times that word appears in each document.
# Let's go ahead and generate this matrix
# and call it "frequencies."

# Create matrix
frequencies = DocumentTermMatrix(corpus)

frequencies

# So we'll use the DocumentTermMatrix function
# calls on our corpus that we created in the previous video.
# Let's take a look at our matrix by typing frequencies.
# We can see that there are 3,289 terms
# or words in our matrix and 1,181 documents
# or tweets after preprocessing.
# Let's see what this matrix looks like using
# the inspect function.

# Look at matrix 
inspect(frequencies[1000:1005,505:515])

# In this range we see that the word "cheer" appears
# in the tweet 1005, but "cheap" doesn't
# appear in any of these tweets.
# This data is what we call sparse.
# This means that there are many zeros in our matrix.
# We can look at what the most popular terms are,
# or words, with the function findFreqTerms.
# We want to call this on our matrix frequencies,
# and then we want to give an argument lowFreq, which
# is equal to the minimum number of times
# a term must appear to be displayed.
# Let's type 20.

# Check for sparsity
findFreqTerms(frequencies, lowfreq=20)
# findFreqTerms(frequencies, lowfreq=100) #at least 100 times

# We see here 56 different words.
# So out of the 3,289 words in our matrix,
# only 56 words appear at least 20 times in our tweets.
# This means that we probably have a lot of terms
# that will be pretty useless for our prediction model.
# The number of terms is an issue for two main reasons.
# One is computational.
# More terms means more independent variables,
# which usually means it takes longer to build our models.
# The other is in building models, as we mentioned
# before, the ratio of independent variables to observations
# will affect how good the model will generalize.
# So let's remove some terms that don't appear very often.
# We'll call the output sparse, and we'll use
# the removeSparseTerms(frequencies,
#                       0.98).
# The sparsity threshold works as follows.
# If we say 0.98, this means to only keep
# terms that appear in 2% or more of the tweets.
# If we say 0.99, that means to only keep
# terms that appear in 1% or more of the tweets.
# If we say 0.995, that means to only keep
# terms that appear in 0.5% or more of the tweets,
# about six or more tweets.
# We'll go ahead and use this sparsity threshold.

# Remove sparse terms
sparse = removeSparseTerms(frequencies, 0.995)
sparse


# If you type sparse, you can see that there's
# only 309 terms in our sparse matrix.
# This is only about 9% of the previous count of 3,289.
# Now let's convert the sparse matrix into a data frame
# that we'll be able to use for our predictive models.
# We'll call it tweetsSparse and use the as.data.frame function
# called on the as.matrix function called on our matrix sparse.
# This converts sparse to a data frame called tweetsSparse.

# Convert to a data frame
tweetsSparse = as.data.frame(as.matrix(sparse))

# Since R struggles with variable names that start with a number,
# and we probably have some words here that start with a number,
# let's run the make.names function to make sure
# all of our words are appropriate variable names.
# To do this type colnames and then in parentheses the name
# of our data frame, tweetsSparse equals

make.names(colnames(tweetsSparse))

# Make all variable names R-friendly
colnames(tweetsSparse) = make.names(colnames(tweetsSparse))

# This will just convert our variable names
# to make sure they're all appropriate names
# before we build our predictive models.
# You should do this each time you've
# built a data frame using text analytics.

# Now let's add our dependent variable to this data set.
# We'll call it tweetsSparse$Negative
# and set it equal to the original Negative variable from the tweets data frame.
# Add dependent variable
tweetsSparse$Negative = tweets$Negative

# Lastly, let's split our data into a training set
# and a testing set, putting 70% of the data in the training
# set.
# First we'll have to load the library caTools so that we
# can use the sample.split function.
# Then let's set the seed to 123 and create our split using
# sample.split where our dependent variable is
# tweetsSparse$Negative.
# 
# And then our split ratio will be 0.7.
# We'll put 70% of the data in the training set.
# Then let's just use subset to create a treating set called
# trainSparse, which will take a subset of the whole data set
# tweetsSparse, but always take the observations for which
# split is equal to TRUE.
# And we'll create our test set, testSparse,
# again using subset to take the observations of tweetsSparse,
# but this time for which split is equal to FALSE.

# Split the data
library(caTools)
set.seed(123)
split = sample.split(tweetsSparse$Negative, SplitRatio = 0.7)

trainSparse = subset(tweetsSparse, split==TRUE)
testSparse = subset(tweetsSparse, split==FALSE)

# Our data is now ready, and we can build our predictive model.
# In the next video, we'll use CART and logistic regression
# to predict negative sentiment.

# Video 7

# Now that we've prepared our data set,
# let's use CART to build a predictive model.
# First, we need to load the necessary packages in our R
# Console by typing library(rpart),
# and then library(rpart.plot).

# Build a CART model
library(rpart)
library(rpart.plot)

# Now let's build our model.
# We'll call it tweetCART, and we'll use the rpart function
# to predict Negative using all of the other variables
# as our independent variables and the data set trainSparse.
# We'll add one more argument here, which is method = "class"
# so that the rpart function knows to build a classification
# model.
# We're just using the default parameter settings
# so we won't add anything for minbucket or cp.


tweetCART = rpart(Negative ~ ., data=trainSparse, method="class") #classification
# Now let's plot the tree using the prp function.
prp(tweetCART)

# Our tree says that if the word "freak" is in the tweet,
# then predict TRUE, or negative sentiment.
# If the word "freak" is not in the tweet,
# but the word "hate" is, again predict TRUE.
# If neither of these two words are in the tweet,
# but the word "wtf" is, also predict TRUE, or negative
# sentiment.
# If none of these three words are in the tweet,
# then predict FALSE, or non-negative sentiment.
# This tree makes sense intuitively
# since these three words are generally
# seen as negative words.

# Now, let's go back to our R Console
# and evaluate the numerical performance of our model
# by making predictions on the test set.
# We'll call our predictions predictCART.
# 
# And we'll use the predict function
# to predict using our model tweetCART on the new data set
# testSparse.
# 
# We'll add one more argument, which is type = "class"
# to make sure we get class predictions.

# Evaluate the performance of the model
predictCART = predict(tweetCART, newdata=testSparse, type="class") #class prediction

# Now let's make our confusion matrix
# using the table function.
# We'll give as the first argument the actual outcomes,
# testSparse$Negative, and then as the second argument,
# our predictions, predictCART.
# 
# To compute the accuracy of our model,
# we add up the numbers on the diagonal, 294 plus 18--
#   these are the observations we predicted correctly--
#   and divide by the total number of observations in the table,
# or the total number of observations in our test set.
# 
# So the accuracy of our CART model is about 0.88.

table(testSparse$Negative, predictCART)
# Compute accuracy
(294+18)/(294+6+37+18)


# Let's compare this to a simple baseline model
# that always predicts non-negative.
# To compute the accuracy of the baseline model,
# let's make a table of just the outcome variable Negative.
# So we'll type table, and then in parentheses,
# testSparse$Negative.

# Baseline accuracy 
table(testSparse$Negative)

# This tells us that in our test set
# we have 300 observations with non-negative sentiment
# and 55 observations with negative sentiment.
# So the accuracy of a baseline model
# that always predicts non-negative
# would be 300 divided by 355, or 0.845.
# So our CART model does better than the simple baseline model.
300/(300+55)

# How about a random forest model?
# How well would that do?
# Let's first load the random forest package
# with library(randomForest), and then we'll
# set the seed to 123 so that we can
# replicate our model if we want to.
# Keep in mind that even if you set the seed to 123,
# you might get a different random forest model than me
# depending on your operating system.
# Now, let's create our model.
# We'll call it tweetRF and use the randomForest function
# to predict Negative again using all of our other variables
# as independent variables and the data set trainSparse.
# We'll again use the default parameter settings.

# Random forest model
library(randomForest)
set.seed(123)
tweetRF = randomForest(Negative ~ ., data=trainSparse)

# The random forest model takes significantly longer
# to build than the CART model.
# We've seen this before when building CART and random forest
# models, but in this case, the difference
# is particularly drastic.
# This is because we have so many independent variables,
# about 300 different words.
# So far in this course, we haven't seen data sets
# with this many independent variables.
# So keep in mind that for text analytics problems,
# building a random forest model will take significantly longer
# than building a CART model.
# So now that our model's finished,
# let's make predictions on our test set.
# We'll call them predictRF, and again, we'll
# use the predict function to make predictions
# using the model tweetRF this time,
# and again, the new data set testSparse.

# Make predictions:
predictRF = predict(tweetRF, newdata=testSparse)

# Now let's make our confusion matrix using the table
# function, first giving the actual outcomes,
# testSparse$Negative, and then giving our predictions,
# predictRF.

table(testSparse$Negative, predictRF)

# To compute the accuracy of the random forest model,
# we again sum up the cases we got right, 293 plus 21,
# and divide by the total number of observations in the table.
# 
# So our random forest model has an accuracy of 0.885.

# Accuracy:
(293+21)/(293+7+34+21)

# This is a little better than our CART model,
# but due to the interpretability of our CART model,
# I'd probably prefer it over the random forest model.
# If you were to use cross-validation to pick the cp
# parameter for the CART model, the accuracy
# would increase to about the same as the random forest model.
# So by using a bag-of-words approach and these models,
# we can reasonably predict sentiment even
# with a relatively small data set of tweets.

# Logistic Regression Model
negativeLog <- glm(Negative ~ ., data=trainSparse, family=binomial)
summary(negativeLog)

predictions = predict(negativeLog, newdata=testSparse, type="response")
table(testSparse$Negative, predictions > 0.5)
(257 + 34)/ nrow(testSparse) # -> 0.8197183

# EXPLANATION
# 
# You can build a logistic regression model in R by using the command:
#   
#   tweetLog = glm(Negative ~ ., data=trainSparse, family="binomial")
# 
# Then you can make predictions and build a confusion matrix with the following commands:
#   
#   predictLog = predict(tweetLog, newdata=testSparse, type="response")
# 
# table(testSparse$Negative, predictLog > 0.5)
# 
# The accuracy is (254+37)/(254+46+18+37) = 0.8197183, which is worse than the baseline. If you were to compute the accuracy on the training set instead, you would see that the model does really well on the training set - this is an example of over-fitting. The model fits the training set really well, but does not perform well on the test set. A logistic regression model with a large number of variables is particularly at risk for overfitting.
# 
# Note that you might have gotten a different answer than us, because the glm function struggles with this many variables. The warning messages that you might have seen in this problem have to do with the number of variables, and the fact that the model is overfitting to the training set. We'll discuss this in more detail in the Homework Assignment.
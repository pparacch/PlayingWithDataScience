# Language Setting
Sys.setlocale("LC_ALL", "C")

# DETECTING VANDALISM ON WIKIPEDIA
# 
# One of the consequences of being editable by anyone is that some people vandalize pages. 
# This can take the form of removing content, adding promotional or inappropriate content, 
# or more subtle shifts that change the meaning of the article. With this many articles and 
# edits per day it is difficult for humans to detect all instances of vandalism and revert
# (undo) them. As a result, Wikipedia uses bots - computer programs that automatically revert
# edits that look like vandalism. In this assignment we will attempt to develop a vandalism detector 
# that uses machine learning to distinguish between a valid edit and vandalism.
# 
# The data for this problem is based on the revision history of the page Language. Wikipedia 
# provides a history for each page that consists of the state of the page at each revision. 
# Rather than manually considering each revision, a script was run that checked whether edits 
# stayed or were reverted. If a change was eventually reverted then that revision is marked as vandalism. 
# This may result in some misclassifications, but the script performs well enough for our needs.
# 
# As a result of this preprocessing, some common processing tasks have already been done, including 
# lower-casing and punctuation removal. The columns in the dataset are:
#     
# - Vandal = 1 if this edit was vandalism, 0 if not.
# - Minor = 1 if the user marked this edit as a "minor edit", 0 if not.
# - Loggedin = 1 if the user made this edit while using a Wikipedia account, 0 if they did not.
# - Added = The unique words added.
# - Removed = The unique words removed.
# 
# Notice the repeated use of unique. The data we have available is not the traditional bag of words - 
# rather it is the set of words that were removed or added. For example, if a word was removed multiple
# times in a revision it will only appear one time in the "Removed" column.

# PROBLEM 1.1 - BAGS OF WORDS  (1 point possible)
# Load the data wiki.csv with the option stringsAsFactors=FALSE, calling the data frame "wiki". 
# Convert the "Vandal" column to a factor using the command wiki$Vandal = as.factor(wiki$Vandal).

# How many cases of vandalism were detected in the history of this page? -> 1815

wiki <- read.csv("wiki.csv", stringsAsFactors = FALSE)
wiki$Vandal <- as.factor(wiki$Vandal) #Covert the vandal to a factor
table(wiki$Vandal)

# 0    1 
# 2061 1815

# PROBLEM 1.2 - BAGS OF WORDS  (2 points possible)
# We will now use the bag of words approach to build a model. We have two columns of textual data, 
# with different meanings. For example, adding rude words has a different meaning to removing 
# rude words. We'll start like we did in class by building a document term matrix from the 
# Added column. The text already is lowercase and stripped of punctuation. So to pre-process 
# the data, just complete the following four steps:

# 1) Create the corpus for the Added column, and call it "corpusAdded".
# 2) Remove the English-language stopwords.
# 3) Stem the words.
# 4) Build the DocumentTermMatrix, and call it dtmAdded.

# If the code length(stopwords("english")) does not return 174 for you, then please run the line 
# of code in this file, which will store the standard stop words in a variable called sw. 
# When removing stop words, use tm_map(corpusAdded, removeWords, sw) instead of 
# tm_map(corpusAdded, removeWords, stopwords("english")).
# 
# How many terms appear in dtmAdded? -> 6675

# tm text mining package.
library(tm)

# Then we also need the package SnowballC.
# This package helps us use the tm package.
library(SnowballC)

# 1. Create corpus
corpusAdded <- Corpus(VectorSource(wiki$Added))

# 2. Remove English-language stopword
str(stopwords("english")) # Check if there are 174 entries

# if not comment out the following code lines
# sw = c("i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", 
#        "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", 
#        "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", 
#        "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", 
#        "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "would", 
#        "should", "could", "ought", "i'm", "you're", "he's", "she's", "it's", "we're", "they're", 
#        "i've", "you've", "we've", "they've", "i'd", "you'd", "he'd", "she'd", "we'd", "they'd", 
#        "i'll", "you'll", "he'll", "she'll", "we'll", "they'll", "isn't", "aren't", "wasn't", 
#        "weren't", "hasn't", "haven't", "hadn't", "doesn't", "don't", "didn't", "won't", 
#        "wouldn't", "shan't", "shouldn't", "can't", "cannot", "couldn't", "mustn't", "let's",
#        "that's", "who's", "what's", "here's", "there's", "when's", "where's", "why's", "how's", 
#        "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", 
#        "by", "for", "with", "about", "against", "between", "into", "through", "during", "before",
#        "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", 
#        "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", 
#        "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", 
#        "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very")

# Remove stopwords and apple
corpusAdded <- tm_map(corpusAdded, removeWords, stopwords("english"))

# 3. Stem words
corpusAdded <- tm_map(corpusAdded, stemDocument)

# Create matrix
dtmAdded <- DocumentTermMatrix(corpusAdded)
dtmAdded

# <<DocumentTermMatrix (documents: 3876, terms: 6675)>>
#     Non-/sparse entries: 15368/25856932
# Sparsity           : 100%
# Maximal term length: 784
# Weighting          : term frequency (tf)

# PROBLEM 1.3 - BAGS OF WORDS  (1 point possible)
# Filter out sparse terms by keeping only terms that appear in 0.3% or more of the revisions, 
# and call the new matrix sparseAdded. 
# How many terms appear in sparseAdded? -> 166

# Remove sparse terms
sparseAdded <- removeSparseTerms(dtmAdded, 0.997)
sparseAdded

# <<DocumentTermMatrix (documents: 3876, terms: 166)>>
#     Non-/sparse entries: 2681/640735
# Sparsity           : 100%
# Maximal term length: 28
# Weighting          : term frequency (tf)


# PROBLEM 1.4 - BAGS OF WORDS  (2 points possible)
# Convert sparseAdded to a data frame called wordsAdded, and then prepend all the words with 
# the letter A, by using the command:
#     
#     colnames(wordsAdded) = paste("A", colnames(wordsAdded))

# Now repeat all of the steps we've done so far (create a corpus, remove stop words, 
# stem the document, create a sparse document term matrix, and convert it to a data frame) 
# to create a Removed bag-of-words dataframe, called wordsRemoved, except this time, 
# prepend all of the words with the letter R:
# 
# colnames(wordsRemoved) = paste("R", colnames(wordsRemoved))

# How many words are in the wordsRemoved data frame? -> 162

# Create wordsAdded data frame
wordsAdded <- as.data.frame(as.matrix(sparseAdded))
colnames(wordsAdded) = paste("A", colnames(wordsAdded))

#Removed
# 1. Create corpus
corpusRemoved <- Corpus(VectorSource(wiki$Removed))

# 2. Remove English-language stopword
corpusRemoved <- tm_map(corpusRemoved, removeWords, stopwords("english"))

# 3. Stem words
corpusRemoved <- tm_map(corpusRemoved, stemDocument)

# Create matrix
dtmRemoved <- DocumentTermMatrix(corpusRemoved)

# Remove sparse terms
sparseRemoved <- removeSparseTerms(dtmRemoved, 0.997)
sparseRemoved
# Create wordsRemoved data frame
wordsRemoved <- as.data.frame(as.matrix(sparseRemoved))
colnames(wordsRemoved) = paste("R", colnames(wordsRemoved))
str(wordsRemoved)
# 'data.frame':    3876 obs. of  162 variables:

# To see that there are 162 words in the wordsRemoved data 
# frame, you can type ncol(wordsRemoved) in your R console.
ncol(wordsRemoved) # -> 162

# PROBLEM 1.5 - BAGS OF WORDS  (2 points possible)
# Combine the two data frames into a data frame called wikiWords with the following line of code:
#     
#     wikiWords = cbind(wordsAdded, wordsRemoved)
# 
# The cbind function combines two sets of variables for the same observations into one data frame.
# Then add the Vandal column (HINT: remember how we added the dependent variable back into our data
#                             frame in the Twitter lecture). Set the random seed to 123 and then

# split the data set using sample.split from the "caTools" package to put 70% in the training set.
# 
# What is the accuracy on the test set of a baseline method that always predicts "not vandalism" 
# (the most frequent outcome)? 0.5313844

wikiWords <- cbind(wordsAdded, wordsRemoved)
wikiWords$Vandal <- wiki$Vandal

library(caTools)
set.seed(123)
spl <- sample.split(wikiWords$Vandal, 0.7)

train <- subset(wikiWords, spl == TRUE)
test <- subset(wikiWords, spl == FALSE)

# baseline method that always predicts "not vandalism" (the most frequent outcome)
# What is the accuracy of the baseline method? # -> 0.5313844
# Baseline model accuracy
table(test$Vandal)
618/(618+545)


# PROBLEM 1.6 - BAGS OF WORDS  (2 points possible)
# Build a CART model to predict Vandal, using all of the other variables as independent variables. 
# Use the training set to build the model and the default parameters (don't set values for 
# minbucket or cp).

# What is the accuracy of the model on the test set, using a threshold of 0.5? (Remember that if 
# you add the argument type="class" when making predictions, the output of predict will automatically
# use a threshold of 0.5.)

#Accuracy -> 0.5417025

# Build a CART model
library(rpart)
library(rpart.plot)
wikiWordsCART <- rpart(Vandal ~ ., data=train, method="class")
prp(wikiWordsCART)
predictCART = predict(wikiWordsCART, newdata=test, type="class") #class prediction

table(test$Vandal, predictCART)
# Compute accuracy
(618+12)/(618+12+0+533) # 0.5417025



# PROBLEM 1.8 - BAGS OF WORDS  (1 point possible)
# Given the performance of the CART model relative to the baseline, what is the best explanation
# of these results?

#Answer -> Although it beats the baseline, bag of words is not very predictive for this problem. 
# There is no reason to think there was anything wrong with the split. CART did not overfit, 
# which you can check by computing the accuracy of the model on the training set. 
# Over-sparsification is plausible but unlikely, since we selected a very high sparsity parameter. 
# The only conclusion left is simply that bag of words didn't work very well in this case.

# PROBLEM 2.1 - PROBLEM-SPECIFIC KNOWLEDGE  (1 point possible)
# We weren't able to improve on the baseline using the raw textual information. More specifically, 
# the words themselves were not useful. There are other options though, and in this section we 
# will try two techniques - identifying a key class of words, and counting words.
# 
# The key class of words we will use are website addresses. "Website addresses" (also known as URLs 
# - Uniform Resource Locators) are comprised of two main parts. An example would be 
# "http://www.google.com". The first part is the protocol, which is usually "http" 
# (HyperText Transfer Protocol). The second part is the address of the site, e.g. "www.google.com". 
# We have stripped all punctuation so links to websites appear in the data as one word, e.g. 
# "httpwwwgooglecom". We hypothesize that given that a lot of vandalism seems to be adding links
# to promotional or irrelevant websites, the presence of a web address is a sign of vandalism.
# 
# We can search for the presence of a web address in the words added by searching for "http" in 
# the Added column. The grepl function returns TRUE if a string is found in another string, e.g.
# 
# grepl("cat","dogs and cats",fixed=TRUE) # TRUE
# 
# grepl("cat","dogs and rats",fixed=TRUE) # FALSE
# 
# Create a copy of your dataframe from the previous question:
# 
# wikiWords2 = wikiWords
# 
# Make a new column in wikiWords2 that is 1 if "http" was in Added:
# 
# wikiWords2$HTTP = ifelse(grepl("http",wiki$Added,fixed=TRUE), 1, 0)
# 
# Based on this new column, how many revisions added a link? -> 217

wikiWords2 <- wikiWords
wikiWords2$HTTP = ifelse(grepl("http",wiki$Added,fixed=TRUE), 1, 0)
table(wikiWords2$HTTP)
# 0    1 
# 3659  217 

# PROBLEM 2.2 - PROBLEM-SPECIFIC KNOWLEDGE  (2 points possible)
# In problem 1.5, you computed a vector called "spl" that identified the observations to put 
# in the training and testing sets. Use that variable (do not recompute it with sample.split)
# to make new training and testing sets:
    
wikiTrain2 <- subset(wikiWords2, spl==TRUE)
wikiTest2 <- subset(wikiWords2, spl==FALSE)

# Then create a new CART model using this new variable as one of the independent variables.
# 
# What is the new accuracy of the CART model on the test set, using a threshold of 0.5?

wikiWords2CART <- rpart(Vandal ~ ., data=wikiTrain2, method="class")
prp(wikiWords2CART)
predict2CART <- predict(wikiWords2CART, newdata=wikiTest2, type="class") #class prediction

table(wikiTest2$Vandal, predict2CART)
# Compute accuracy
(609+57)/(609 + 57 + 9 + 488) # 0.5726569


# PROBLEM 2.3 - PROBLEM-SPECIFIC KNOWLEDGE  (1 point possible)
# Another possibility is that the number of words added and removed is predictive, 
# perhaps more so than the actual words themselves. We already have a word count available 
# in the form of the document-term matrices (DTMs).
# 
# Sum the rows of dtmAdded and dtmRemoved and add them as new variables in your data 
# frame wikiWords2 (called NumWordsAdded and NumWordsRemoved) by using the following commands:
    
wikiWords2$NumWordsAdded <- rowSums(as.matrix(dtmAdded))
wikiWords2$NumWordsRemoved <- rowSums(as.matrix(dtmRemoved))

#What is the average number of words added?
summary(wikiWords2$NumWordsAdded) # -> 4.05

# PROBLEM 2.4 - PROBLEM-SPECIFIC KNOWLEDGE  (2 points possible)
# In problem 1.5, you computed a vector called "spl" that identified the observations to put 
# in the training and testing sets. Use that variable (do not recompute it with sample.split) 
# to make new training and testing sets with wikiWords2. Create the CART model again 
# (using the training set and the default parameters).
# 
# What is the new accuracy of the CART model on the test set? -> 0.6552021

wikiTrain3 <- subset(wikiWords2, spl==TRUE)
wikiTest3 <- subset(wikiWords2, spl==FALSE)

wikiWords3CART <- rpart(Vandal ~ ., data=wikiTrain3, method="class")
prp(wikiWords3CART)
predict3CART <- predict(wikiWords3CART, newdata=wikiTest3, type="class") #class prediction

table(wikiTest3$Vandal, predict3CART)
# Compute accuracy
(514+248)/(514+248+297+104) # 0.6552021


# PROBLEM 3.1 - USING NON-TEXTUAL DATA  (2 points possible)
# We have two pieces of "metadata" (data about data) that we haven't yet used. 
# Make a copy of wikiWords2, and call it wikiWords3:

wikiWords3 <- wikiWords2

# Then add the two original variables Minor and Loggedin to this new data frame:

wikiWords3$Minor = wiki$Minor
wikiWords3$Loggedin = wiki$Loggedin

# In problem 1.5, you computed a vector called "spl" that identified the observations to put 
# in the training and testing sets. Use that variable (do not recompute it with sample.split)
# to make new training and testing sets with wikiWords3.
# 
# Build a CART model using all the training data. 
# What is the accuracy of the model on the test set? -> 0.7188306

wikiTrain3 <- subset(wikiWords3, spl==TRUE)
wikiTest3 <- subset(wikiWords3, spl==FALSE)

wikiWords31CART <- rpart(Vandal ~ ., data=wikiTrain3, method="class")
prp(wikiWords31CART)

# EXPLANATION
# You can plot the tree with prp(wikiCART4). The first split is on the variable "Loggedin", the second split 
# is on the number of words added, and the third split is on the number of words removed.
# 
# By adding new independent variables, we were able to significantly improve our accuracy
# without making the model more complicated!

predict31CART <- predict(wikiWords31CART, newdata=wikiTest3, type="class") #class prediction

table(wikiTest3$Vandal, predict31CART)
# Compute accuracy
(595+241)/(595+304+23+241) # 0.7188306


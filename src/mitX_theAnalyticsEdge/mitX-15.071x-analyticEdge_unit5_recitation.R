# Let's begin by creating a data frame called emails
# using the read.csv function.
# And loading up energy_bids.csv.
# 
# And as always, in the text analytics week,
# we're going to pass stringsAsFactors=FALSE to this
# function.
# So we can take a look at the structure of our new data frame
# using the str function.

# Load the dataset
emails = read.csv("energy_bids.csv", stringsAsFactors=FALSE)

# We can see that there are 855 observations.
# This means we have 855 labeled emails in the data set.
# And for each one we have the text of the email
# and whether or not it's responsive to our query
# about energy schedules and bids.
str(emails)

# So let's take a look at a few example emails in the data set,
# starting with the first one.
# So the first email can be accessed with emails$email[1],
# and we'll select the first one.
# Note use the strwrap function and pass it the long string you
# want to print out, in this case emails$email.
# Now we can see that this has broken down our long string
# into multiple shorter lines that are much easier to read.

# Look at emails

# So let's take a look now at this email,
# now that it's a lot easier to read.
# We can see just by parsing through the first couple
# of lines that this is an email that's
# talking about a new working paper,
# "The Environmental Challenges and Opportunities
# in the Evolving North American Electricity Market"
# is the name of the paper.
# And it's being released by the Commission
# for Environmental Cooperation, or CEC.
# So while this certainly deals with electricity markets,
# it doesn't have to do with energy schedules or bids.
# So it is not responsive to our query.
# So we can take a look at the value in the responsive
# variable for this email using emails$responsive and selecting
# the first one.
# And we have value 0 there.
emails$email[1]
strwrap(emails$email[1])
emails$responsive[1]

# And scrolling up to the top here we can
# see that the original message is actually very short,
# it just says FYI (For Your Information),
# and most of it is a forwarded message.
# So we have all the people who originally
# received the message.
# And then down at the very bottom is the message itself.
# "Attached is my report prepared on behalf of the California
# State auditor."
# And there's an attached report, ca report new.pdf.
# Now our data set contains just the text of the emails
# and not the text of the attachments.
# But it turns out, as we might expect,
# that this attachment had to do with Enron's electricity bids
# in California,
# and therefore it is responsive to our query.
emails$email[2]
strwrap(emails$email[2])
emails$responsive[2]

# So now let's look at the breakdown
# of the number of emails that are responsive to our query using
# the table function.
# We're going to pass it emails$responsive.
# 
# And as we can see the data set is unbalanced,
# with a relatively small proportion of emails responsive
# to the query.
# And this is typical in predictive coding problems.

# Responsive emails
table(emails$responsive)

# Now it's time to construct and preprocess the corpus.
# So we'll start by loading the tm package with library(tm).

# Load tm package
install.packages("tm")
library(tm)

# Then we also need to install the package SnowballC.
# This package helps us use the tm package.
# And go ahead and load the snowball package as well.
install.packages("SnowballC")
library(SnowballC)

# we'll construct a variable called corpus using the Corpus
# and VectorSource functions and passing in all the emails
# in our data set, which is emails$email.

# Create corpus
corpus = Corpus(VectorSource(emails$email))

# So now that we've constructed the corpus,
# we can output the first email in the corpus.
# We'll start out by calling the strwrap function to get it
# on multiple lines, and then we can select the first element
# in the corpus using the double square bracket notation
# and selecting element 1.

strwrap(corpus[[1]])

# And we can see that this is exactly
# the same email that we saw originally,
# the email about the working paper.

# So now we're ready to preprocess the corpus using the tm_map
# function.
# So first, we'll convert the corpus
# to lowercase using tm_map and the tolower function.
# So we'll have corpus = tm_map(corpus, tolower).

# Pre-process data
corpus = tm_map(corpus, tolower)
strwrap(corpus[[1]])

# IMPORTANT NOTE: If you are using the latest version of the tm package, 
# you will need to run the following line before continuing (it converts corpus to a Plain Text Document).
# This is a recent change having to do with the tolower function that occurred after this video
# was recorded.
corpus = tm_map(corpus, PlainTextDocument)
strwrap(corpus[[1]])

# And then we'll do the exact same thing except removing
# punctuation, so we'll have corpus = tm_map(corpus,
#                                            removePunctuation).
corpus = tm_map(corpus, removePunctuation)
strwrap(corpus[[1]])

# We'll remove the stop words with removeWords function
# and we'll pass along the stop words of the English language
# as the words we want to remove.
corpus = tm_map(corpus, removeWords, stopwords("english"))
strwrap(corpus[[1]])

# And lastly, we're going to stem the document.
# So corpus = tm_map(corpus, stemDocument).
corpus = tm_map(corpus, stemDocument)

# And now that we've gone through those four preprocessing steps,
# we can take a second look at the first email in the corpus.
# So again, call strwrap(corpus[[1]]).
strwrap(corpus[[1]])

# And now it looks quite a bit different.
# We can come up to the top here.
# It's a lot harder to read now that we removed
# all the stop words and punctuation and word stems,
# but now the emails in this corpus
# are ready for our machine learning algorithms.


# BAG OF WORDS
# Now let's build the document-term matrix
# for our corpus.
# So we'll create a variable called
# dtm that contains the DocumentTermMatrix(corpus).


# Create matrix
dtm = DocumentTermMatrix(corpus)
dtm

# The corpus has already had all the pre-processing run on it.
# So to get the summary statistics about the document-term matrix,
# we'll just type in the name of our variable, dtm.
# And what we can see is that even though we
# have only 855 emails in the corpus,
# we have over 22,000 terms that showed up at least once,
# which is clearly too many variables
# for the number of observations we have.
# So we want to remove the terms that
# don't appear too often in our data set,
# and we'll do that using the removeSparseTerms function.
# And we're going to have to determine the sparsity,
# so we'll say that we'll remove any term that doesn't appear
# in at least 3% of the documents.
# To do that, we'll pass 0.97 to removeSparseTerms.

# Remove sparse terms
dtm = removeSparseTerms(dtm, 0.97)
dtm

# Now we can take a look at the summary statistics
# for the document-term matrix, and we
# can see that we've decreased the number of terms
# to 788, which is a much more reasonable number.
# So let's build a data frame called labeledTerms out
# of this document-term matrix.
# So to do this, we'll use as.data.frame
# of as.matrix applied to dtm, the document-term matrix.
# So this data frame is only including right now
# the frequencies of the words that appeared in at least 3%
# of the documents, 

# Create data frame
labeledTerms = as.data.frame(as.matrix(dtm))

# But in order to run our text analytics
# models, we're also going to have the outcome variable, which
# is whether or not each email was responsive.
# So we need to add in this outcome variable.
# So we'll create labeledTerms$responsive,
# and we'll simply copy over the responsive variable from
# the original emails data frame so it's equal
# to emails$responsive.

# Add in the outcome variable
labeledTerms$responsive = emails$responsive

# So finally let's take a look at our newly constructed data
# frame with the str function.
# 
# So as we expect, there are an awful lot of variables, 789 in total.
# 788 of those variables are the frequencies
# of various words in the emails, and the last one is responsive,
# the outcome variable.
str(labeledTerms)

# At long last, we're ready to split our data into a training
# and testing set, and to actually build a model.
# So we'll start by loading the caTools package,
# so that we can split our data.
# So we'll do library(caTools).

# Split the data
library(caTools)

# And then, as usual, we're going to set our random seed so
# that everybody has the same results.
# So use set.seed and we'll pick the number 144.
# Again, the number isn't particularly important.
# The important thing is that we all use the same one.
# So as usual, we're going to obtain the split variable.
# We'll call it spl, using the sample.split function.
# The outcome variable that we pass is
# labeledTerms$responsive.
# And we'll do a 70/30 split.
# So we'll pass 0.7 here.
# So then train, the training data frame,
# can be obtained using subset on the labeled terms where
# spl is TRUE.
# And test is the subset when spl is FALSE.

set.seed(144)
spl = sample.split(labeledTerms$responsive, 0.7)

train = subset(labeledTerms, spl == TRUE)
test = subset(labeledTerms, spl == FALSE)

# So now we're ready to build the model.
# And we'll build a simple CART model
# using the default parameters.
# But a random forest would be another good choice
# from our toolset.
# So we'll start by loading up the packages for the CART model.
# We'll do library(rpart).
# 
# And we'll also load up the rpart.plot package, so
# that we can plot the outcome.

# Build a CART model
library(rpart)
library(rpart.plot)

# So we'll create a model called emailCART,
# using the rpart function.
# We're predicting responsive.
# And we're predicting it using all
# of the additional variables.
# All the frequencies of the terms that are included.
# Obviously tilde period is important here,
# because there are 788 terms.
# Way too many to actually type out.
# The data that we're using to train the model
# is just our training data frame, train.
# And then the method is class, since we
# have a classification problem here.
emailCART = rpart(responsive~., data=train, method="class")

# And once we've trained the CART model,
# we can plot it out using prp.
prp(emailCART)

# So we can see at the very top is the word California.
# If California appears at least twice in an email,
# we're going to take the right part over here and predict
# that a document is responsive.
# It's somewhat unsurprising that California shows up,
# because we know that Enron had a heavy involvement
# in the California energy markets.
# So further down the tree, we see a number of other terms
# that we could plausibly expect to be related
# to energy bids and energy scheduling,
# like system, demand, bid, and gas.
# Down here at the bottom is Jeff, which is perhaps
# a reference to Enron's CEO, Jeff Skillings, who ended up
# actually being jailed for his involvement
# in the fraud at the company.

# Now that we've trained a model, we
# need to evaluate it on the test set.
# So let's build an object called pred
# that has the predicted probabilities
# for each class from our CART model.
# So we'll use predict of emailCART, our CART model,
# passing it newdata=test, to get test set predicted
# probabilities.

# Make predictions on the test set
pred = predict(emailCART, newdata=test)

# So to recall the structure of pred,
# we can look at the first 10 rows with pred[1:10,].
pred[1:10,]

# So this is the rows we want.
# We want all the columns.
# So we'll just leave a comma and nothing else afterward.
# So the left column here is the predicted probability
# of the document being non-responsive.
# And the right column is the predicted probability
# of the document being responsive.
# They sum to 1.
# So in our case, we want to extract
# the predicted probability of the document being responsive.
# So we're looking for the rightmost column.
# So we'll create an object called pred.prob.
# And we'll select the rightmost or second column.
# So pred.prob now contains our test set
# predicted probabilities.
pred.prob = pred[,2]

# And we're interested in the accuracy
# of our model on the test set.
# So for this computation, we'll use a cutoff of 0.5.
# And so we can just table the true outcome,
# which is test$responsive against the predicted outcome,
# which is pred.prob >= 0.5.
# What we can see here is that in 195 cases,
# we predict false when the left column and the true outcome
# was zero, non-responsive.
# So we were correct.
# And in another 25, we correctly identified a responsive
# document.
# In 20 cases, we identified a document as responsive,
# but it was actually non-responsive.
# And in 17, the opposite happened.
# We identified a document as non-responsive,
# but it actually was responsive.

# Compute accuracy
table(test$responsive, pred.prob >= 0.5)
(195+25)/(195+25+17+20)

# So we have an accuracy in the test set of 85.6%.
# And now we want to compare ourselves
# to the accuracy of the baseline model.

# As we've already established, the baseline model
# is always going to predict the document is non-responsive.
# So if we table test$responsive, we see that it's going to be
# correct in 215 of the cases.
# So then the accuracy is 215 divided
# by the total number of test set observations.
# So that's 83.7% accuracy.
# So we see just a small improvement
# in accuracy using the CART model, which, as we know,
# is a common case in unbalanced data sets.


# Baseline model accuracy
table(test$responsive)
215/(215+42)

# However, as in most document retrieval applications,
# there are uneven costs for different types of errors here.
# Typically, a human will still have to manually review
# all of the predicted responsive documents
# to make sure they are actually responsive.
# Therefore, if we have a false positive,
# in which a non-responsive document is labeled
# as responsive, the mistake translates
# to a bit of additional work in the manual review
# process but no further harm, since the manual review process
# will remove this erroneous result.
# But on the other hand, if we have a false negative,
# in which a responsive document is labeled as non-responsive
# by our model, we will miss the document entirely
# in our predictive coding process.
# Therefore, we're going to assign a higher cost to false negatives
# than to false positives, which makes this a good time to look
# at other cut-offs on our ROC curve.


# Now let's look at the ROC curve so we
# can understand the performance of our model
# at different cutoffs.
# We'll first need to load the ROCR package
# with a library(ROCR).


# ROC curve
library(ROCR)

# Next, we'll build our ROCR prediction object.
# So we'll call this object predROCR =
#     prediction(pred.prob, test$responsive).
predROCR = prediction(pred.prob, test$responsive)

# So now we want to plot the ROC curve
# so we'll use the performance function to extract
# the true positive rate and false positive rate.
# So create something called perfROCR =
# performance(predROCR, "tpr", "fpr").
perfROCR = performance(predROCR, "tpr", "fpr")

# And then we'll plot(perfROCR, colorize=TRUE),
# so that we can see the colors for the different cutoff
# thresholds.
plot(perfROCR, colorize=TRUE)

# Now, of course, the best cutoff to select
# is entirely dependent on the costs assigned by the decision
# maker to false positives and true positives.
# However, again, we do favor cutoffs
# that give us a high sensitivity.
# We want to identify a large number of the responsive
# documents.
# So something that might look promising
# might be a point right around here,
# in this part of the curve, where we
# have a true positive rate of around 70%,
# meaning that we're getting about 70%
# of all the responsive documents, and a false positive rate
# of about 20%, meaning that we're making mistakes
# and accidentally identifying as responsive 20%
# of the non-responsive documents.
# Now, since, typically, the vast majority of documents
# are non-responsive, operating at this cutoff
# would result, perhaps, in a large decrease
# in the amount of manual effort needed
# in the eDiscovery process.
# And we can see from the blue color
# of the plot at this particular location
# that we're looking at a threshold around maybe 0.15
# or so, significantly lower than 50%, which is definitely
# what we would expect since we favor
# false positives to false negatives.

# So lastly, we can use the ROCR package
# to compute our AUC value.
# So, again, call the performance function
# with our prediction object, this time extracting the AUC value
# and just grabbing the y value slot of it.
# We can see that we have an AUC in the test set of 79.4%, which
# means that our model can differentiate
# between a randomly selected responsive and non-responsive
# document about 80% of the time.


# Compute AUC
performance(predROCR, "auc")@y.values


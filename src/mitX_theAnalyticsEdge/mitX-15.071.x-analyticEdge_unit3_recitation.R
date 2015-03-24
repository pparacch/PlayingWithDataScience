

# Recitation this week.
# We'll be using polling data from the months leading up
# to a presidential election to predict that election's winner.
# We'll go over how to build logistic regression
# models in R, how to select the variables to include
# in those models, and how to evaluate the model predictions.
# Let's get started.

# The topic of this recitation is election forecasting,
# which is the art and science of predicting
# the winner of an election before any votes are actually
# cast using polling data from likely voters.

# In this recitation, we are going to look at the United States
# presidential election.

# In the United States, a president
# is elected every four years.
# And while there are a number of different political parties
# in the US, generally there are only two
# competitive candidates.
# There's the Republican candidate,
# who tends to be more conservative,
# and the Democratic candidate, who's more liberal.

# So for instance a recent Republican president
# was George W. Bush, and a recent Democratic president
# was Barack Obama.

# Now while in many countries the leader of the country
# is elected using the simple candidate who
# receives the largest number of votes across the entire country
# is elected, in the United States it's
# significantly more complicated.

# There are 50 states in the United States,
# and each is assigned a number of electoral votes
# based on its population.

# So for instance, the most populous state, California,
# in 2012 had nearly 20 times the number of electoral votes
# as the least populous states.
# And these number of electoral votes
# are reassigned periodically based
# on changes of populations between states.

# Within a given state in general, the system
# is winner take all in the sense that the candidate who receives
# the most vote in that state gets all of its electoral votes.
# And then across the entire country,
# the candidate who receives the most electoral votes
# wins the entire presidential election.

# Now while it seems like a somewhat subtle distinction,
# the electoral college versus the simple popular vote model,
# it can have very significant consequences
# on the outcome of the election.

# As an example, let's look at the 2000 presidential election
# between George W. Bush and Al Gore.

# As we can see on the right here, Al Gore
# received more than 500,000 more votes across the entire country
# than George W. Bush in terms of the popular vote.

# But in terms of the electoral vote,
# because of how those votes were distributed,
# George Bush actually won the election
# because he received five more electoral votes than Al Gore.

# So our goal will be to use polling data that's
# collected from likely voters before the election
# to predict the winner in each state,
# and therefore to enable us to predict
# the winner of the entire election
# in the electoral college system.

# While election prediction has long attracted some attention,
# there's been a particular interest
# in the problem for the 2012 presidential election,
# when then-New York Times columnist Nate
# Silver took on the task of predicting
# the winner in each state.

# To carry out this prediction task,
# we're going to use some data from RealClearPolitics.com that
# basically represents polling data that was collected
# in the months leading up to the 2004, 2008, and 2012 US
# presidential elections.

# Each row in the data set represents a state
# in a particular election year.
# And the dependent variable, which is called Republican,
# is a binary outcome.
# It's 1 if the Republican won that state
# in that particular election year,
# and a 0 if a Democrat won.

# The independent variables, again,
# are related to polling data in that state.
# So for instance, the Rasmussen and SurveyUSA variables
# are related to two major polls that
# are assigned across many different states in the United
# States.
# And it represents the percentage of voters
# who said they were likely to vote Republican
# minus the percentage who said they
# were likely to vote Democrat.
# So for instance, if the variable SurveyUSA in our data set
# has value -6, it means that 6% more voters
# said they were likely to vote Democrat
# than said they were likely to vote Republican in that state.

# We have two additional variables that
# capture polling data from a wider range of polls.
# Rasmussen and SurveyUSA are definitely not the only polls
# that are run on a state by state basis.

# DiffCount counts the number of all the polls leading up
# to the election that predicted a Republican winner in the state,
# minus the number of polls that predicted a Democratic winner.

# And PropR, or proportion Republican,
# has the proportion of all those polls leading up
# to the election that predicted a Republican winner.


# As usual, we will start by reading in our data
# and looking at it in the R console.
# So we can create a data frame called polling
# using the read.csv function for our PollingData.csv file.
# And we can take a look at its structure with the str command.

polling <- read.csv("PollingData.csv")
str(polling)

# And what we can see is that as expected,
# we have a state and a year variable for each observation,
# as well as some polling data and the outcome
# variable, Republican.

# So something we notice right off the bat
# is that even though there are 50 states and three election
# years, so we would expect 150 observations,
# we actually only have 145 observations in the data frame.

table(polling$Year)

# So using the table function, we can
# look at the breakdown of the polling data frame's Year
# variable.
# And what we see is that while in the 2004 and 2008 elections,
# all 50 states have data reported, in 2012, only 45
# of the 50 states have data.
# And actually, what happened here is
# that pollsters were so sure about the five missing states
# that they didn't perform any polls in the months leading up
# to the 2012 election.

# So since these states are particularly easy to predict,
# we feel pretty comfortable moving forward, making
# predictions just for the 45 remaining states.

# So the second thing that we notice
# is that there are these NA values, which
# signify missing data.
# So to get a handle on just how many values are missing,
# we can use our summary function on the polling data frame.

summary(polling)

# And what we see is that while for the majority
# of our variables, there's actually no missing data,
# we see that for the Rasmussen polling data
# and also for the SurveyUSA polling data,
# there are a decent number of missing values.
# So let's take a look at just how we
# can handle this missing data.
# There are a number of simple approaches
# to dealing with missing data.
# One would be to delete observations
# that are missing at least one variable value.
# Unfortunately, in this case, that
# would result in throwing away more than 50%
# of the observations.
# And further, we want to be able to make predictions
# for all states, not just for the ones that
# report all of their variable values.

# Another approach would be to remove the variables that
# have missing values, in this case, the Rasmussen
# and SurveyUSA variables.
# However, we expect Rasmussen and SurveyUSA
# to be qualitatively different from aggregate variables,
# such as DiffCount and PropR, so we
# want to retain them in our data set.

# A third approach would be to fill the missing data
# points with average values.
# So for Rasmussen and SurveyUSA, the average value for a poll
# would be very close to zero across all the times
# with it reported, which is roughly a tie
# between the Democrat and Republican candidate.

# However, if PropR is very close to one or zero,
# we would expect the Rasmussen or SurveyUSA
# values that are currently missing
# to be positive or negative, respectively.

# This leads to a more complicated approach
# called multiple imputation in which we fill in the missing
# values based on the non-missing values for an observation.

# So for instance, if the Rasmussen variable is reported
# and is very negative, then a missing SurveyUSA value
# would likely be filled in as a negative value as well.

# Just like in the sample.split function,
# multiple runs of multiple imputation
# will in general result in different missing values being
# filled in based on the random seed that is set.

# Although multiple imputation is in general
# a mathematically sophisticated approach,
# we can use it rather easily through pre-existing R
# libraries.

# We will use the Multiple Imputation
# by Chained Equations, or mice package.
# So just like we did in lecture with the ROCR package,
# we're going to install and then load
# a new package, the "mice" package.
# So we run install.packages, and we
# pass it "mice", which is the name of the package we
# want to install.
# So after it's installed, we still
# need to load it so that we can actually use it,
# so we do that with the library command.
# If you have to use it in the future, all you'll have to do
# is run library instead of installing and then running
# library.

# Install and load mice package
install.packages("mice")
library(mice)

# So for our multiple imputation to be useful,
# we have to be able to find out the values of our missing
# variables without using the outcome of Republican.
# So, what we're going to do here is
# we're going to limit our data frame to just
# the four polling related variables
# before we actually perform multiple imputation.
# So we're going to create a new data frame called simple,
# and that's just going to be our original polling data
# frame limited to Rasmussen, SurveyUSA, PropR,
# and DiffCount.

# Multiple imputation
simple = polling[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount")]
summary(simple)
# We can take a look at the simple data
# frame using the summary command.
# What we can see is that we haven't
# done anything fancy yet.
# We still have our missing values.
# All that's changed is now we have
# a smaller number of variables in total.

# So again, multiple imputation, if you ran it twice,
# you would get different values that were filled in.
# So, to make sure that everybody following along
# gets the same results from imputation,
# we're going to set the random seed to a value.
# It doesn't really matter what value
# we pick, so we'll just pick my favorite number, 144.

set.seed(144)

# And now we're ready to do imputation,
# which is just one line.
# So we're going to create a new data frame called imputed,
# and we're going to use the function complete,
# called on the function mice, called on simple.
imputed = complete(mice(simple))
summary(imputed)

# So the output here shows us that five rounds of imputation
# have been run, and now all of the variables
# have been filled in.
# So there's no more missing values,
# and we can see that using the summary function on imputed.
# So Rasmussen and SurveyUSA both have no more
# of those NA or missing values.
# So the last step in this imputation process
# is to actually copy the Rasmussen and SurveyUSA
# variables back into our original polling data frame, which
# has all the variables for the problem.
# And we can do that with two simple assignments.
# So we'll just copy over to polling$Rasmussen, the value
# from the imputed data frame, and then we'll
# do the same for the SurveyUSA variable.

polling$Rasmussen = imputed$Rasmussen
polling$SurveyUSA = imputed$SurveyUSA
summary(polling)

# And we'll use one final check using summary
# on the final polling data frame.
# And as we can see, Rasmussen and SurveyUSA
# are no longer missing values.


# Now, we're ready to actually start building models.
# So as usual, the first thing we're going to do
# is split our data into a training and a testing set.
# And for this problem, we're actually
# going to train on data from the 2004 and 2008 elections,
# and we're going to test on data from the 2012
# presidential election.
# So to do that, we'll create a data frame
# called Train, using the subset function that breaks down
# the original polling data frame and only
# stores the observations when either the Year was 2004
# or when the Year was 2008.
# And to obtain the testing set, we're
# going to use subset to create a data frame called Test that
# saves the observations in polling where
# the year was 2012.

# Subset data into training set and test set
Train = subset(polling, Year == 2004 | Year == 2008)
Test = subset(polling, Year == 2012)

# So now that we've broken it down into a training and a testing
# set, we want to understand the prediction of our baseline
# model against which we want to compare
# a later logistic regression model.
# So to do that, we'll look at the breakdown
# of the dependent variable in the training
# set using the table function.

# Smart Baseline
table(Train$Republican)

# What we can see here is that in 47 of the 100 training
# observations, the Democrat won the state,
# and in 53 of the observations, the Republican won the state.

# So our simple baseline model is always
# going to predict the more common outcome, which
# is that the Republican is going to win the state.

# And we see that the simple baseline model
# will have accuracy of 53% on the training set.
# Now, unfortunately, this is a pretty weak model.
# It always predicts Republican, even for a very landslide
# Democratic state, where the Democrat was polling
# by 15% or 20% ahead of the Republican.
# So nobody would really consider this to be a credible model.
# So we need to think of a smarter baseline model against which
# we can compare our logistic regression models that we're
# going to develop later.
# So a reasonable smart baseline would
# be to just take one of the polls-- in our case,
# we'll take Rasmussen-- and make a prediction
# based on who poll said was winning in the state.
# So for instance, if the Republican is polling ahead,
# the Rasmussen smart baseline would just
# pick the Republican to be the winner.
# If the Democrat was ahead, it would pick the Democrat.
# And if they were tied, the model would not
# know which one to select.
# So to compute this smart baseline,
# we're going to use a new function called the sign
# function.
# And what this function does is, if it's
# passed a positive number, it returns the value 1.
# If it's passed a negative number, it returns negative 1.
# And if it's passed 0, it returns 0.

# So if we passed the Rasmussen variable into sign,
# whenever the Republican was winning the state, meaning
# Rasmussen is positive, it's going to return a 1.
# So for instance, if the value 20 is
# passed, meaning the Republican is polling 20 ahead,
# it returns 1.
# So 1 signifies that the Republican is predicted to win.
# If the Democrat is leading in the Rasmussen poll,
# it'll take on a negative value.
# So if we took for instance the sign of -10, we get -1.
# So -1 means this smart baseline is
# predicting that the Democrat won the state.
# And finally, if we took the sign of 0,
# meaning that the Rasmussen poll had a tie,
# it returns 0, saying that the model is
# inconclusive about who's going to win the state.

sign(20)
sign(-10)
sign(0)

# So now, we're ready to actually compute
# this prediction for all of our training set.
# And we can take a look at the breakdown
# of that using the table function applied
# to the sign of the training set's Rasmussen variable.

table(sign(Train$Rasmussen))

# And what we can see is that in 56 of the 100 training set
# observations, the smart baseline predicted
# that the Republican was going to win.
# In 42 instances, it predicted the Democrat.
# And in two instances, it was inconclusive.
# So what we really want to do is to see the breakdown of how
# the smart baseline model does, compared to the actual result
# -- who actually won the state.
# So we want to again use the table function,
# but this time, we want to compare the training set's
# outcome against the sign of the polling data.

table(Train$Republican, sign(Train$Rasmussen))

#   -1  0  1
# 0 42  2  3
# 1  0  1 52

# So in this table, the rows are the true outcome --
# 1 is for Republican, 0 is for Democrat --
# and the columns are the smart baseline predictions, -1, 0,
# or 1.
# What we can see is in the top left corner over here,
# we have 42 observations where the Rasmussen smart baseline
# predicted the Democrat would win,
# and the Democrat actually did win.
# There were 52 observations where the smart baseline predicted
# the Republican would win, and the Republican actually
# did win.
# Again, there were those 3 (in my example 2 + 1) inconclusive observations.
# And finally, there were 3 mistakes.
# There were 3 times where the smart baseline model predicted
# that the Republican would win, but actually the Democrat
# won the state.
# So as we can see, this model, with four mistakes
# and two inconclusive results out of the 100 training
# set observations is doing much, much better than the naive
# baseline, which simply was always predicting
# the Republican would win and made
# 47 mistakes on the same data.
# So we see that this is a much more reasonable baseline model
# to carry forward, against which we can compare
# our logistic regression-based approach.


# Now, as we start to think about building regression models
# with this data set, we need to consider the possibility
# that there is multicollinearity within
# the independent variables.

# And there's a good reason to suspect
# that there would be multicollinearity amongst
# the variables, because in some sense,
# they're all measuring the same thing, which
# is how strong the Republican candidate is performing
# in the particular state.

# So while normally, we would run the correlation function
# on the training set, in this case, it doesn't work.
# It says, x must be numeric.
# And if we go back and look at the structure of the training
# set, it jumps out why we're getting this issue.
# It's because we're trying to take
# the correlations of the names of states,
# which doesn't make any sense.

# Multicollinearity
cor(Train)
str(Train)


# So to compute the correlation, we're
# going to want to take the correlation amongst just
# the independent variables that we're
# going to be using to predict, and we can also
# add in the dependent variable to this correlation matrix.
# So I'll take cor of the training set
# but just limit it to the independent variables--
#   Rasmussen, SurveyUSA, PropR, and DiffCount.
# And then also, we'll add in the dependent variable, Republican.

cor(Train[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount", "Republican")])

# So there we go.
# We're seeing a lot of big values here.
# For instance, SurveyUSA and Rasmussen
# are independent variables that have a correlation of 0.94,
# which is very, very large and something
# that would be concerning.
# It means that probably combining them
# together isn't going to do much to produce a working regression
# model.

# So let's first consider the case where
# we want to build a logistic regression model with just one
# variable.

# So in this case, it stands to reason
# that the variable we'd want to add
# would be the one that is most highly
# correlated with the outcome, Republican.
# So if we read the bottom row, which
# is the correlation of each variable to Republican,
# we see that PropR is probably the best candidate
# to include in our single-variable model,
# because it's so highly correlated,
# meaning it's going to do a good job of predicting
# the Republican status.

# So let's build a model.

# We can call it mod1.
# So we'll call the glm function, predicting Republican,
# using PropR alone.
# As always, we'll pass along the data
# to train with as our training set.
# And because we have logistic regression,
# we need family = "binomial".
# 
# And we can take a look at this model using the summary
# function.

mod1 = glm(Republican~PropR, data=Train, family="binomial")
summary(mod1)

# And we can see that it looks pretty
# nice in terms of its significance
# and the sign of the coefficients.
# We have a lot of stars over here.
# PropR is the proportion of the polls
# that said the Republican won.
# We see that that has a very high coefficient in terms
# of predicting that the Republican will win
# in the state, which makes a lot of sense.
# And we'll note down that the AIC measuring
# the strength of the model is 19.8.
# So this seems like a very reasonable model.
# Let's see how it does in terms of actually predicting
# the Republican outcome on the training set.

# So first, we want to compute the predictions,
# the predicted probabilities that the Republican
# is going to win on the training set.
# So we'll create a vector called pred1, prediction one,
# then we'll call the predict function.
# We'll pass it our model one.
# And we're not going to pass it newdata,
# because we're just making predictions
# on the training set right now.

pred1 = predict(mod1, type="response")

# We're not looking at test set predictions.
# But we do need to pass it type = "response" to get probabilities
# out as the predictions.

# And now, we want to see how well it's doing.
# So if we used a threshold of 0.5,
# where we said if the probability is at least 1/2,
# we're going to predict Republican,
# otherwise, we'll predict Democrat.
# Let's see how that would do on the training set.

# So we'll want to use the table function
# and look at the training set Republican value
# against the logical of whether pred1
# is greater than or equal to 0.5.

table(Train$Republican, pred1 >= 0.5)
#     FALSE TRUE
# 0    45    2
# 1     2   51


# So here, the rows, as usual, are the outcome -- 1 is Republican,
# 0 is Democrat.
# And the columns-- TRUE means that we predicted
# Republican, FALSE means we predicted Democrat.
# So we see that on the training set,
# this model with one variable as a prediction
# makes four mistakes, which is just
# about the same as our smart baseline model.

# So now, let's see if we can improve on this performance
# by adding in another variable.

# So if we go back up to our correlations here,
# we're going to be searching, since there's
# so much multicollinearity, we might be searching
# for a pair of variables that has a relatively lower correlation
# with each other, because they might kind of work together
# to improve the prediction overall
# of the Republican outcome.

# If two variables are highly, highly correlated,
# they're less likely to improve predictions together,
# since they're so similar in their correlation structure.
# So it looks like, just looking at this top left four by four
# matrix, which is the correlations between all
# the independent variables, basically the least correlated
# pairs of variables are either Rasmussen and DiffCount,
# or SurveyUSA and DiffCount.
# So the idea would be to try out one
# of these pairs in our two-variable model.
# So we'll go ahead and try out SurveyUSA and DiffCount
# together in our second model.

# In this case, we're now using SurveyUSA plus DiffCount.
# We'll also need to remember to change the name of our model
# from mod1 to mod2.

mod2 = glm(Republican~SurveyUSA+DiffCount, data=Train, family="binomial")

# And now, just like before, we're going
# to want to compute out our predictions.
# So we'll say pred2 is equal to the predict of our model 2,
# again, with type = "response", because we
# need to get those probabilities.

pred2 = predict(mod2, type="response")

# Again, we're not passing in newdata.
# This is a training set prediction.
# 
# And finally, we can use the up arrows
# to see how our second model's predictions are doing
# at predicting the Republican outcome in the training set.

table(Train$Republican, pred2 >= 0.5)

# And we can see that we made one less mistake.
# We made three mistakes instead of four on the training
# set-- so a little better than the smart baseline
# but nothing too impressive.
# And the last thing we're going to want to do
# is to actually look at the model and see if it makes sense.
# So we can run summary of our model two.

summary(mod2)

# And we can see that there are some things that are pluses.
# For instance, the AIC has a smaller value,
# which suggests a stronger model.
# And the estimates have, again, the sign we would expect.
# So SurveyUSA and DiffCount both have positive coefficients
# in predicting if the Republican wins
# the state, which makes sense.

# But a weakness of this model is that neither of these variables
# has a significance of a star or better,
# which means that they are less significant statistically.

# So there are definitely some strengths and weaknesses
# between the two-variable and the one-variable model.
# We'll go ahead and use the two-variable model
# when we make our predictions on the testing set.


# Now it's time to evaluate our models on the testing set.
# So the first model we're going to want to look at
# is that smart baseline model that basically just took
# a look at the polling results from the Rasmussen poll
# and used those to determine who was
# predicted to win the election.

# So it's very easy to compute the outcome
# for this simple baseline on the testing set.
# We're going to want to table the testing set outcome
# variable, Republican, and we're going
# to compare that against the actual outcome
# of the smart baseline, which as you recall
# would be the sign of the testing set's Rasmussen variables.

table(Test$Republican, sign(Test$Rasmussen))

# And we can see that for these results,
# there are 18 times where the smart baseline predicted
# that the Democrat would win and it's correct,
# 21 where it predicted the Republican would win
# and was correct, two times when it was inconclusive,
# and four times where it predicted Republican
# but the Democrat actually won.

# So that's four mistakes and two inconclusive results
# on the testing set.
# So this is going to be what we're
# going to compare our logistic regression-based model against.
# So we need to obtain final testing set prediction
# from our model.
# So we selected mod2, which was the two variable model.
# So we'll say, TestPrediction is equal to the predict
# of that model that we selected.
# Now, since we're actually making testing set predictions,
# we'll pass in newdata = Test, and again,
# since we want probabilities to be returned,
# we're going to pass type="response".

TestPrediction = predict(mod2, newdata=Test, type="response")

# And the moment of truth, we're finally going to table
# the test set Republican value against the test prediction
# being greater than or equal to 0.5, at least a 50% probability
# of the Republican winning.

table(Test$Republican, TestPrediction >= 0.5)

# And we see that for this particular case, in all but one
# of the 45 observations in the testing set, we're correct.

# Now, we could have tried changing this threshold
# from 0.5 to other values and computed out an ROC curve,
# but that doesn't quite make as much sense in this setting
# where we're just trying to accurately predict
# the outcome of each state and we don't care more
# about one sort of error-- when we predicted Republican
# and it was actually Democrat-- than the other,
# where we predicted Democrat and it was actually Republican.

# So in this particular case, we feel OK just
# using the cutoff of 0.5 to evaluate our model.
# So let's take a look now at the mistake we made
# and see if we can understand what's going on.

# So to actually pull out the mistake we made,
# we can just take a subset of the testing set
# and limit it to when we predicted true,
# but actually the Democrat won, which
# is the case when that one failed.

# So this would be when TestPrediction
# is greater than or equal to 0.5, and it was not a Republican.
# So Republican was equal to zero.

subset(Test, TestPrediction >= 0.5 & Republican == 0)

# So here is that subset, which just
# has one observation since we made just one mistake.
# So this was for the year 2012, the testing set year.
# This was the state of Florida.

# And looking through these predictor variables,
# we see why we made the mistake.
# The Rasmussen poll gave the Republican a two percentage
# point lead, SurveyUSA called a tie,
# DiffCount said there were six more polls that
# predicted Republican than Democrat,
# and two thirds of the polls predicted
# the Republican was going to win.
# But actually in this case, the Republican didn't win.
# Barack Obama won the state of Florida
# in 2012 over Mitt Romney.

# So the models here are not magic,
# and given this sort of data, it's pretty unsurprising
# that our model actually didn't get Florida
# correct in this case and made the mistake.

# However, overall, it seems to be outperforming
# the smart baseline that we selected,
# and so we think that maybe this would be a nice model
# to use in the election prediction.
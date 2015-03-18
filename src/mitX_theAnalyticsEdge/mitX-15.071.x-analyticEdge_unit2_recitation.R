# In this recitation we will apply some
# of the ideas from Moneyball to data from the National
# Basketball Association-- that is, the NBA.
# So the first thing we'll do is read in the data
# and learn about it.
# The data we have is located in the file NBA_train.csv
# and contains data from all teams in season since 1980,
# except for ones with less than 82 games.
# So I'll read this in to the variable NBA,
NBA = read.csv("NBA_train.csv")

# OK.
# So we've read it in.
# And let's explore it a little bit using
# the str command, 
str(NBA)

# All right.
# So this is our data frame.
# We have 835 observations of 20 variables.
# Let's take a look at what some of these variables are.
# SeasonEnd is the year the season ended.
# Team is the name of the team.
# And playoffs is a binary variable for whether or not
# a team made it to the playoffs that year.
# If they made it to the playoffs it's a 1, if not it's a 0.
# W stands for the number of regular season wins.
# PTS stands for points scored during the regular season.
# oppPTS stands for opponent points
# scored during the regular season.
# And then we've got quite a few variables that
# have the variable name and then the same variable
# with an 'A' afterwards.
# So we've got FG and FGA, X2P, X2PA, X3P, X3PA, FT, and FTA.
# So what this notation is, is it means
# if there is an 'A' it means the number that were attempted.
# And if not it means the number that were successful.
# So for example FG is the number of successful field goals,
# including two and three pointers.
# Whereas FGA is the number of field goal attempts.
# So this also contains the number of unsuccessful field goals.
# So FGA will always be a bigger number than FG.
# The next pair is for two pointers.
# The number of successful two pointers and the number
# attempted.
# The pair after that, right down here, is for three pointers,
# the number successful and the number attempted.
# And the next pair is for free throws,
# the number successful and the number attempted.
# Now you'll notice, actually, that the two pointer and three
# pointer variables have an 'X' in front of them.
# Well, this isn't because we had an 'X' in the original data.
# In fact, if you were to open up the csv
# file of the original data, it would just say, 2P and 2PA,
# and, 3P and 3PA, without the 'X' in front.
# The reason there's an 'X' in front of it
# is because when we load it into R,
# R doesn't like it when a variable begins with a number.
# So if a variable begins with a number
# it will put an 'X' in front of it.
# This is fine.
# It's just something we need to be
# mindful of when we're dealing with variables in R.
# So moving on to the rest of our variables.
# We've got ORB and DRB.
# These are offensive and defensive rebounds.
# AST stands for assists.
# STL stands for steals.
# BLK stands for blocks.
# And TOV stands for turnovers.

# But we just wanted to familiarize you
# with some common basketball statistics that are recorded,
# and explain the labeling notation
# that we use in our data.



# Recall that in the lecture we found this number
# by looking at a graph.
# Here in R, let's use the table command
# to figure this out for the NBA.
# So that's just

table(NBA$W, NBA$Playoffs)

# So our table pops up.
# Let's scroll to the top so we see what's going on.
# OK so as we typed in, we've got the number of wins
# here as the rows.
# And 0 if a team didn't make the playoffs, 1 if a team did
# make the playoffs in the columns.
# So for all of our data, for example,
# consider all the times that a team won 17 games.
# So this happened 11 times in total.
# And all 11 times the teams didn't make it to the playoffs
# when they won 17 games.
# Let's scroll down and look at a much higher number
# for contrast.
# For example, 61 wins.
# If a team won 61 games then 10 of those times they made it
# to the playoffs, and 0 times they didn't.
# So it seems like if you win 61 games
# you are definitely going to make it to the playoffs.
# But I'm sure we can find a much better threshold.
# Let's take a look at the table, say around the middle section.

# OK, so here we can see that a team who
# wins say about 35 games or fewer almost never
# makes it to the playoffs.
# We see a lot of 0s and 1s in this column up until 35.
# After 35 we start seeing some numbers over here.
# So teams are starting to make it to the playoffs.
# And if we scroll down, we see that after about 45 wins,
# teams almost always make it to the playoffs.
# We see very few 1s and 0s in the category of not making it.
# So it seems like a good goal would
# be to try to win about 42 games.
# If a team can win about 42 games then
# they have a very good chance of making it to the playoffs.

# So in basketball, games are won by scoring more points
# than the other team.
# Can we use the difference between points scored
# and points allowed throughout the regular season in order
# to predict the number of games that a team will win?
# Let's give it a try.
# First we add a variable that is the difference between points
# scored and points allowed.
# Let's call this NBA$PTSdiff.
# 
# And that's just the difference between points scored,
# which is PTS, and points allowed, which
# is oppPTS (opponents point).

NBA$PTSdiff <- NBA$PTS - NBA$oppPTS

# All right, so we've created our variable.
# Let's first make a scatter plot to see
# if it looks like there's a linear relationship
# between the number of wins that a team wins
# and the point difference.
# So this is easy to do just with the plot command.
# NBA$PTSdiff and NBA$W.

plot(NBA$PTSdiff, NBA$W)

# So our graph pops up and it looks
# like there's an incredibly strong linear relationship
# between these two variables.
# So it seems like linear regression
# is going to be a good way to predict how many wins
# a team will have given the point difference.
# Let's try to verify this.

# So we're going to have PTSdiff
# as our independent variable in our regression,
# and W for wins as the dependent variable.
# So let's call this WinsReg.

WinsReg <- lm(W ~ PTSdiff, data = NBA)

# And we just use the lm command as before, regressing W
# on the PTSdiff and using the NBA data.
# All right, so we've created our regression.
# Let's take a look at the summary.

summary(WinsReg)

OK, so the first thing that we notice
# is that we've got very significant variables
# over here.
# And an R squared of 0.9423, which is very high.
# And this is verifying the scatter plot
# we saw before that there's a very strong linear relationship
# between the wins and the points difference.

# So let's write down the regression
# equation that we found.
# We see that the number of wins, W, is equal to 41.
# That's coming from the coefficient estimate
# for the intercept.
# Plus 0.0326*PTSdiff.
# And that 0.0326 is coming from the coefficient estimate
# for PTSdiff.

# So we saw earlier with the table that a team
# would want to win about at least 42 games
# in order to have a good chance of making it to the playoffs.
# So what does this mean in terms of their points difference?
# Well, we can calculate it.
# If we want this to be greater than or equal to 42,
# that means that the PTSdiff
# would need to be greater than or equal to 42 minus 41
# divided by 0.0326.
# So if we actually do that calculation,
# we see that this is equal to 30.67.
# So we need to score at least 31 more points
# than we allow in order to win at least 42 games.


# So now let's build an equation to predict points scored
# using some common basketball statistics.
# So our dependent variable would now be PTS,
# and our independent variables would
# be some of the common basketball statistics
# that we have in our data set.
# So for example, the number of two-point field goal attempts,
# the number of three-point field goal attempts,
# offensive rebounds, defensive rebounds,
# assists, steals, blocks, turnovers,
# free throw attempts-- we can use all of these.
# So let's build this regression and call it PointsReg.

# And that will just be equal to lm of PTS regressing
# on all those variables we just talked about.
# So X2PA for two-point attempts, plus X3PA
# for three-point attempts, plus FTA for free throw attempts,
# AST for assists, ORB offensive rebounds,
# DRB for defensive rebounds, TOV for turnovers,
# and STL for steals.
# 
# And let's also throw in blocks, BLK.

# Okay.
# And as always, the data is from the NBA data set.
# 
# So we can go ahead and run this command.

PointsReg <- lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + TOV + STL + BLK, data = NBA)

# So now that we've created our points regression model,
# let's take a look at the summary.
# This is always the first thing you should do.

summary(PointsReg)

# Okay, so taking a look at this, we
# can see that some of our variables are indeed very,
# very, significant.
# Others are less significant.
# For example, steals only has one significance star.
# And some don't seem to be significant at all.
# For example, defensive rebounds, turnovers, and blocks.
# We do have a pretty good R-squared value, 0.8992,
# so it shows that there really is a linear relationship
# between points and all of these basketball statistics.
# Let's compute the residuals here.
# We can just do that by directly calling them,
# so that's 

PointsReg$residuals

# So there's this giant list of them,
# and we'll use this to compute the sum of squared errors.
# SSE, standing for sum of squared errors,
# is just equal to the

SSE <- sum(PointsReg$residuals^2)

# So what is the sum of squared errors here?
# 
# It's quite a lot-- 28,394,314.
# So the sum of squared errors number
# is not really a very interpretable quantity.
# But remember, we can also calculate
# the root mean squared error, which
# is much more interpretable.
# It's more like the average error we make in our predictions.
# So the root mean squared error, RMSE-- let's calculate it here.
# So RMSE is just equal to the square root
# of the sum of squared errors divided by n,
# where n here is the number of rows in our data set.

RMSE <- sqrt(SSE/nrow(NBA))

# So the RMSE in our case is 184.4.
# So on average, we make an error of about 184.4 points.
# That seems like quite a lot, until you remember that
# the average number of points in a season is, let's see,

mean(NBA$PTS)

# This will give us the average number of points in a season,
# and it's 8,370.
# So, okay, if we have an average number of points of 8,370,
# being off by about 184.4 points is really not so bad.
# But I think we still have room for improvement in this model.
# If you recall, not all the variables were significant.
# Let's see if we can remove some of the insignificant variables
# one at a time.
# We'll take a look again at our model,

summary(PointsReg)

# , in order to figure out
# which variable we should remove first.
# 
# The first variable we would want to remove
# is probably turnovers.
# And why do I say turnovers?
# It's because the p value for turnovers, which you see here
# in this column, 0.6859, is the highest of all of the p values.
# So that means that turnovers is the least statistically
# significant variable in our model.
# So let's create a new regression model without turnovers.
# An easy way to do this is just to use your up
# arrow on your keyboard, and scroll up
# through all of your previous commands
# until you find the command where you defined the regression
# model.
# 
# Okay, so this is the command where we defined the model.
# Now let's delete turnovers, and then we can rename the model,
# and we'll call this one just PointsReg2.

PointsReg2 <- lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + STL + BLK, data = NBA)

# So in our first regression model, PointsReg,
# we had an R-squared of 0.8992.
# Let's take a look at the R-squared of PointsReg2.

summary(PointsReg2)

# And we see that it's 0.8991.
# So almost exactly identical.
# It does go down, as we would expect, but very, very
# slightly.
# So it seems that we're justified in removing turnovers.
# Let's see if we can remove another one
# of the insignificant variables.
# The next one, based on p-value, that we would want to remove
# is defensive rebounds.
# So again, let's create our model,
# taking out defensive rebounds, and calling this PointsReg3.
# We'll just scroll up again.
# Take out DRB, for defensive rebounds,
# and change the name of this to PointsReg3
# so we don't overwrite PointsReg2.

PointsReg3 <- lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + STL + BLK, data = NBA)

# Let's look at the summary again to see
# if the R-squared has changed.

summary(PointsReg3)

# And it's the same, it's 0.8991.
# So I think we're justified again in removing defensive rebounds.
# Let's try this one more time and see if we can remove blocks.
# So we'll remove blocks, and call it PointsReg4.

PointsReg4 <- lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + STL, data = NBA)

# Take a look at the summary of PointsReg4.
summary(PointsReg4)

# And again, the R-squared value stayed the same.
# So now we've gotten down to a model which is a bit simpler.
# All the variables are significant.
# We've still got an R-squared 0.899.
# And let's take a look now at the sum of squared errors
# and the root mean square error, just
# to make sure we didn't inflate those
# too much by removing a few variables.
# 
# So, remember that the sum of squared errors that we
# had in the original model was this giant number, 28,394,314.
# And the root mean squared error, the much more interpretable
# number, was 184.4.
# So those are the numbers we'll be comparing against when
# we calculate the new sum of squared errors
# of the new model, PointsReg4.
# # So let's call this SSE_4.
# And that will just be equal to 
SSE4 <- sum(PointsReg4$residuals^2)

# And then RMSE_4 will just be the square root of SSE_4 divided
# by n, the number of rows in our data set.
RMSE4 <- sqrt(SSE4/nrow(NBA))

# Okay, so let's take a look at these.
# 
# The new sum of squared errors is now 28,421,465.
# Again, I find this very difficult to interpret.
# I like to look at the root mean squared error instead.
# So the root mean squared error here is just RMSE_4,
# and so it's 184.5.
# So although we've increased the root mean squared error
# a little bit by removing those variables,
# it's really a very, very, small amount.
# Essentially, we've kept the root mean squared error the same.
# So it seems like we've narrowed down on a much better model
# because it's simpler, it's more interpretable,
# and it's got just about the same amount of error.



# In this video we'll try to make predictions for the 2012-2013
# season.
# We'll need to load our test set because our training set only
# included data from 1980 up until the 2011-2012 season.
# So let's call it NBA_test.
# 
# And we'll read it in the same way as always,

NBA_test <- read.csv("NBA_test.csv")

# All right, so now let's try to predict using our model
# that we made in the previous video, how many points we'll
# see in the 2012-2013 season.
# Let's call this PointsPrediction.

PointsPredictions <- predict(PointsReg4, newdata = NBA_test)


# And so we use the predict command here.
# And we give it the previous model that we made.
# 
# We'll give it PointsReg4, because that
# was the model we determined at the end to be the best one.
# And the new data which is NBA_test.
# 
# OK, so now that we have our prediction, how good is it?
# We can compute the out of sample R-squared.
# This is a measurement of how well
# the model predicts on test data.
# The R-squared value we had before from our model,
# the 0.8991, you might remember, is the measure
# of an in-sample R-squared, which is
# how well the model fits the training data.
# But to get a measure of the predictions goodness of fit,
# we need to calculate the out of sample R-squared.
# So let's do that here.
# We need to compute the sum of squared errors.

# And so this here is just the sum of the predicted amount
# minus the actual amount of points squared and summed.
# And we need the total sums of squares,
# which is just the sum of the average number of points
# minus the test actual number of points.

SSE <- sum((PointsPredictions - NBA_test$PTS)^2)
SST <- sum((mean(NBA$PTS) - NBA_test$PTS)^2)

R2 <- 1 - SSE/ SST
R2

# So the R-squared here then is calculated
# as usual, 1 minus the sum of squared errors divided
# by total sums of squares.
# And we see that we have an R-squared value of 0.8127.
# We can also calculate the root mean squared error the same way
# as before, root mean squared error
# is going to be the square root of the sum of squared errors
# divided by n, which is the number of rows in our test data
# set.

RMSE <- sqrt(SSE/nrow(NBA_test))
RMSE

# OK and the root mean squared error here is 196.37.
# So it's a little bit higher than before.
# But it's not too bad.
# We're making an average error of about 196 points.
# We'll stop here for now.
# Good luck with the homework.
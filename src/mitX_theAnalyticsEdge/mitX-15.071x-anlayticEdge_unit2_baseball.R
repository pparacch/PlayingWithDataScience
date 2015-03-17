#Unit2: Linear Regression models
#Supporting data in baseball.csv

# Read in data
baseball = read.csv("baseball.csv")
str(baseball) #we can see the structure of the dataset 1232 obs. of 15 vars.
# This data set includes an observation
# for every team and year pair from 1962 to 2012
# for all seasons with 162 games.

# We have 15 variables in our data set, including Runs Scored, RS,
# Runs Allowed, RA, and Wins, W. We also
# have several other variables that we'll
# use when building models later on in the lecture.
# Since we're confirming the claims made in Moneyball,
# we want to build models using data Paul DePodesta had
# in 2002, so let's start by subsetting our data
# to only include the years before 2002.

moneyball <- subset(baseball, Year < 2002)
str(moneyball) #902 obs. of  15 variables

# So we want to build a linear regression equation
# to predict wins using the difference between runs
# scored and runs allowed.

moneyball$RD <- moneyball$RS - moneyball$RA #RD: Run Difference, RS: Run Scrored, RA: Run Allowed
str(moneyball) #New Variable is addedd to the dataframe

# Now, before we build the linear regression equation,
# let's visually check to see if there's
# a linear relationship between Run Difference and Wins.
# We'll do that by creating a scatter plot with the plot
# function.
# On the x-axis, we'll put RD, Run Difference, and on the y-axis,
# we'll put W, Wins.
plot(moneyball$RD, moneyball$W)
#Looking at the scatterplot we can see that there is a strong linear relationship beetween these two

WinReg <- lm(W ~RD, data = moneyball)
summary(WinReg)
# We can take a look at the summary of our regression
# equation using the summary function, which shows us
# that RD is very significant with three stars,
# and the R-squared of our model is 0.88.
# So we have a strong model to predict wins
# using the difference between runs scored and runs allowed.

# Now, let's see if we can use this model
# to confirm the claim made in Moneyball that a team needs
# to score at least 135 more runs than they
# allow to win at least 95 games.

# If a baseball team scores 713 runs and allows 614 runs, how many games do we expect the team to win?
# Using the linear regression model constructed during the lecture, enter the number of games we expect the team to win: (correct answer 91,3556)


################
#Scoring Runs
# In our R Console, let's take a look
# at the structure of our data, again, using the str function.
# Our data set has many variables, including runs scored, RS,
# on-base percentage, OBP, slugging percentage, SLG,
# and batting average, BA.
str(moneyball)

# We want to see if we can use linear regression to predict
# runs scored, RS, using these three hitting statistics--
#   on-base percentage OBP, slugging percentage SLG and batting average BA.
# So let's build a linear regression equation.
RunsReg <- lm(RS ~ OBP + SLG + BA, data = moneyball)
summary(RunsReg)
# we can see that all of our independent variables
# are significant, and our R-squared is 0.93.
# But if we look at our coefficients,
# we can see that the coefficient for batting average is negative.
# This implies that, all else being equal,
# a team with a lower batting average will score more runs, which is a little counterintuitive.
# SPECIAL CASE -> What's going on here is a case of multicollinearity.

# These three hitting statistics are highly correlated,
# so it's hard to interpret the coefficients of our model.
# Let's try removing batting average, the variable
# with the least significance, to see what happens to our model.
RunsReg <- lm(RS ~ OBP + SLG, data = moneyball)
summary(RunsReg)
# We can see that our independent variables are still
# very significant, the coefficients are both positive
# as we expect, and our R-squared is still about 0.93.
# So this model is simpler, with only two independent variables,
# and has about the same R-squared.
# Overall a better model.
# You could experiment and see that if we'd
# removed on-base percentage or slugging percentage instead
# of batting average, our R-squared would have decreased.

# If we look at the coefficients of our model,
# we can see that on-base percentage has a larger
# coefficient than slugging percentage.
# Since these variables are on about the same scale,
# this tells us that on-base percentage is probably
# worth more than slugging percentage.

#### CONCLUSION
# So by using linear regression, we're
# able to verify the claims made in Moneyball:
# that batting average is overvalued,
# on-base percentage is the most important, and slugging
# percentage is important for predicting runs scored.


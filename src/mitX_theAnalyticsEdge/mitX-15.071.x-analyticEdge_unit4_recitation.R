# Unit 4, Recitation
# VIDEO 2

# Before we jump into R, let's understand the data.
# Each entry of this data set corresponds
# to a census tract, a statistical division of the area that
# is used by researchers to break down towns and cities.
# As a result, there will usually be multiple census tracts
# per town.
# LON and LAT are the longitude and latitude
# of the center of the census tract.
# MEDV is the median value of owner-occupied homes, measured
# in thousands of dollars.
# CRIM is the per capita crime rate.
# ZN is related to how much of the land
# is zoned for large residential properties.
# INDUS is the proportion of the area used for industry.
# CHAS is 1 if a census tract is next to the Charles
# River, which I drew before.
# NOX is the concentration of nitrous oxides
# in the air, a measure of air pollution.
# RM is the average number of rooms per dwelling.
# AGE is the proportion of owner-occupied units
# built before 1940.
# DIS is a measure of how far the tract is
# from centers of employment in Boston.
# RAD is a measure of closeness to important highways.
# TAX is the property tax per $10,000 of value.
# And PTRATIO is the pupil to teacher ratio by town.

# Let's switch over to R now.
# So let's begin to analyze our data set with R. First of all,
# we'll load the data set into the Boston variable.

# Read in data
boston = read.csv("boston.csv")
str(boston)

# If we look at the structure of the Boston data set,
# we can see all the variables we talked about before.
# There are 506 observations corresponding
# to 506 census tracts in the Greater Boston area.
# We are interested in building a model initially
# of how prices vary by location across a region.

# So let's first see how the points are laid out.
# Using the plot commands, we can plot the latitude and longitude
# of each of our census tracts.

# Plot observations
plot(boston$LON, boston$LAT)

# This picture might be a little bit meaningless to you
# if you're not familiar with the Massachusetts-Boston area,
# but I can tell you that the dense central core of points
# corresponds to Boston city, Cambridge
# city, and other close urban cities.
# Still, let's try and relate it back to that picture
# we saw in the first video, where I showed you the river
# and where MIT was.
# So we want to show all the points that lie along
# the Charles River in a different color.
# We have a variable, CHAS, that tells us
# if a point is on the Charles River or not.
# So to put points on an already-existing plot,
# we can use the points command, which
# looks very similar to the plot command,
# except it operates on a plot that already exists.
# So let's plot just the points where the Charles River
# variable is set to one.
# 
# Up to now it looks pretty much like the plot command,
# but here's where it's about to get interesting.
# We can pass a color, such as blue,
# to plot all these points in blue.
# And this would plot blue hollow circles
# on top of the black hollow circles.
# Which would look all right, but I
# think I'd much prefer to have solid blue dots.
# To control how the points are plotted,
# we use the pch option, which you can read about more in the help
# documentation for the points command.
# But I'm going to use pch 19, which
# is a solid version of the dots we already have on our plot.


# Tracts alongside the Charles River
points(boston$LON[boston$CHAS==1], boston$LAT[boston$CHAS==1], col="blue", pch=19)


# So by running this command, you see
# we have some blue dots in our plot now.
# These are the census tracts that lie along the Charles River.
# But maybe it's still a little bit confusing,
# and you'd like to know where MIT is in this picture.
# So we can do that too.
# I looked up which census tract MIT is in,
# and it's census tract 3531.
# So let's plot that.
# We add another point, the longitude of MIT,
# which is in tract 3531, and the latitude of MIT,
# which is in census tract 3531.
# I'm going to plot this one in red,
# so we can tell it apart from the other Charles River dots.
# And again, I'm going to use a solid dot to do it.
# Can you see it on the little picture?
# It's a little red dot, right in the middle.
# That's exactly what we were looking
# at from the picture in Video 1.

# Plot MIT
points(boston$LON[boston$TRACT==3531],boston$LAT[boston$TRACT==3531],col="red", pch=20)

# What other things can we do?
# Well, this data set was originally constructed
# to investigate questions about how
# air pollution affects prices.
# So the air pollution variable is this NOX variable.
# Let's have a look at a distribution of NOX.
# boston$NOX.

# Plot polution
summary(boston$NOX)

# So we see that the minimum value is 0.385,
# the maximum value is 0.87 and the median
# and the mean are about 0.53, 0.55.
# So let's just use the value of 0.55,
# as it's kind of in the middle.
# And we'll look at just the census
# tracts that have above-average pollution.

# So we'll use the points command again
# to plot just those points.

# So, points, the latitude--no the longitude first.
# So we want the census tracts with NOX levels
# greater than or equal to 0.55.
# We want the latitude of those same census tracks.
# Again, only if the NOX is greater than 0.55.
# And I guess a suitable color for nasty pollution
# would be a bright green.
# And again, we'll use the solid dots.
# So you can see it is pretty much the same as the other commands.
# Wow okay.
# So those are all the points that have got above-average pollution.
# Looks like my office is right in the middle.
# Now it kind of makes sense, though,
# because that's the dense urban core of Boston.
# If you think of anywhere where pollution would be,
# you'd think it'd be where the most cars and the most people
# are.

points(boston$LON[boston$NOX>=0.55], boston$LAT[boston$NOX>=0.55], col="green", pch=20)

# So that's kind of interesting.
# Now, before we do anything more, we
# should probably look at how prices vary over the area
# as well.
# So let's make a new plot.
# This one's got a few too many things on it.
# So we'll just plot again the longitude
# and the latitude for all census tracts.
# That kind of resets our plot.

# Plot prices
plot(boston$LON, boston$LAT)

# If we look at the distribution of the housing prices (boston$MEDV),
# we see that the minimum price --
#     and remember the units are thousands of dollars,
# so the median value of owner-occupied homes
# in thousands of dollars -- so the minimum is around five,
# the maximum is around 50.

summary(boston$MEDV)

# So let's plot again only the above-average price points.
# So we'll go:  points(boston$LON[boston$MEDV>=21.2].
#                      We can also plot the latitude: boston$LATboston$LAT[boston$MEDV>=21.2].
#                      We'll reuse that red color we used for MIT.

points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=20)

# So what we see now are all the census tracts
# with above-average housing prices.
# As you can see, it's definitely not simple.
# The census tracts of above-average and below-average
# are mixed in between each other.
# But there are some patterns.
# For example, look at that dense black bit in the middle.
# That corresponds to most of the city of Boston,
# especially the southern parts of the city.
# Also, on the Cambridge side of the river,
# there's a big chunk there of dots that are black,
# that are not red, that are also presumably below average.
# So there's definitely some structure to it,
# but it's certainly not simple in relation
# to latitude and longitude at least.
# We will explore this more in the next video. 


# VIDEO 3

# So, we saw in the previous video that the house prices
# were distributed over the area in an interesting way,
# certainly not the kind of linear way.
# And we wouldn't necessarily expect linear regression
# to do very well at predicting house price,
# just given latitude and longitude.
# We can kind of develop that intuition more
# by plotting the relationship between latitude and house
# prices-- which doesn't look very linear-- or the longitude
# and the house prices, which also looks pretty nonlinear.

# Linear Regression using LAT and LON
plot(boston$LAT, boston$MEDV)
plot(boston$LON, boston$MEDV)

# So, we'll try fitting a linear regression anyway.
# So, let's call it latlonlm.
# And we'll use the lm command, linear model,
# to predict house prices based on latitude and longitude using
# the boston data set.

latlonlm = lm(MEDV ~ LAT + LON, data=boston)

# If we take a look at our linear regression,
# we see the R-squared is around 0.1, which is not great.
# The latitude is not significant, which
# means the north-south differences aren't
# going to be really used at all.
# Longitude is significant, and it's negative.
# Which we can interpret as, as we go towards the ocean--
#     as we go towards the east-- house prices decrease linearly.
# So this all seems kind of unlikely,
# but let's work with it.

summary(latlonlm)

# So let's see how this linear regression
# model looks on a plot.
# So let's plot the census tracts again.
# OK.

# Visualize regression output
plot(boston$LON, boston$LAT)

# Now, remember before, we had-- from the previous video--
#     we plotted the above-median house prices.
# So we're going to do that one more time.
# The median was 21.2.
# We had-- the color was red.
# And we used solid dots.
# Ha.
# Oops.
# See what I did there?
# I used the plot command, instead of the points command,
# and it plotted just the new points.
# I meant to plot the original points
# and use the points command to plot it
# on top of the existing plot.
# OK.

points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=20)

# So that's more like it.
# So now we have the median values with the above median value
# census tracts.
# So, OK, we want to see, now, the question
# we're going to ask, and then plot,
# is what does the linear regression model think is above median.
# So we could just do this pretty easily.
# We have latlonlm$fitted.values and this is what the linear
# regression model predicts for each of the 506 census tracts.
# So we'll plot these on top.
# boston$LON-- take all the census tracts,
# such that the latlonlm's fitted values are above the median.
# Take the latitudes, too.

# And I'm going to make them blue, but let's pause for a moment
# and think.
# If we use the dots again, we'll cover up the red dots
# and cover up some of the black dots.
# What we won't be able to see is where
# the red dots and the blue dots match up.
# You know, we're interested in seeing
# how the linear regression matches up with the truth.
# So it'd be ideal if we could plot
# the linear regression blue dots on top of the red dots,
# in some way that we can still see the red dots.
# It turns out that you can actually
# pass in characters to this PCH option.
# So since we're talking about money,
# let's plot dollar signs instead of points.
# And there you have it.

latlonlm$fitted.values
points(boston$LON[latlonlm$fitted.values >= 21.2], boston$LAT[latlonlm$fitted.values >= 21.2], col="blue", pch="$")

# So, the linear regression model has plotted a dollar sign
# for every time it thinks the census
# tract is above median value.
# And you can see that, indeed, it's
# almost as-- you can see the sharp line
# that the linear regression defines.
# And how it's pretty much vertical,
# because remember before, the latitude variable
# was not very significant in the regression.
# So that's interesting and pretty wrong.
# One thing that really stands out is
# how it says Boston is mostly above median.
# Even knowing-- we saw it right from the start--
# there's a big non-red spot, right
# in the middle of Boston, where the house
# prices were below the median.
# So the linear regression model isn't really doing a good job.
# And it's completely ignored everything
# to the right side of the picture.


# Video 4

# Let's see how regression trees do.
# We'll first load the rpart library
# and also load the rpart plotting library.

# Load CART packages
library(rpart)
library(rpart.plot)

# We build a regression tree in the same way
# we would build a classification tree, using the rpart command.
# We predict MEDV as a function of latitude and longitude,
# using the boston dataset.

# CART model
latlontree = rpart(MEDV ~ LAT + LON, data=boston)
prp(latlontree)

# If we now plot the tree using the prp command, which
# is defined in rpart.plot, we can see it makes a lot of splits
# and is a little bit hard to interpret.
# But the important thing is to look at the leaves.
# In a classification tree, the leaves
# would be the classification we assign
# that these splits would apply to.
# But in regression trees, we instead predict the number.
# That number is the average of the median house
# prices in that bucket or leaf.
# So let's see what that means in practice.
# So we'll plot again the latitude of the points.

# And we'll again plot the points with above median prices.
# I just scrolled up from my command history to do that.
# Now we want to predict what the tree thinks
# is above median, just like we did with linear regression.
# So we'll say the fitted values we
# can get from using the predict command on the tree we just
# built.

# Visualize output
plot(boston$LON, boston$LAT)
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=20)

# And we can do another points command,
# just like we did before.
# The fitted values are greater than 21.2, the color is blue,
# and the character is a dollar sign.

fittedvalues = predict(latlontree)
points(boston$LON[fittedvalues>21.2], boston$LAT[fittedvalues>=21.2], col="blue", pch="$")

# Now we see that we've done a much better job
# than linear regression was able to do.
# We've correctly left the low value area in Boston
# and below out, and we've correctly
# managed to classify some of those points
# in the bottom right and top right.
# We're still making mistakes, but we're
# able to make a nonlinear prediction
# on latitude and longitude.
# So that's interesting, but the tree was very complicated.
# So maybe it's drastically overfitting.
# Can we get most of this effect with a much simpler tree?
# We can.
# We would just change the minbucket size.

# So let's build a new tree using the rpart command again:
#     MEDV as a function of LAT and LON, the data=boston.
# But this time we'll say the minbucket size must be 50.

# Simplify tree by increasing minbucket
latlontree = rpart(MEDV ~ LAT + LON, data=boston, minbucket=50)

# prp(latlontree)

# We'll use the other way of plotting trees, plot,
# and we'll add text to the text command.

plot(latlontree)
text(latlontree)

# And we see we have far fewer splits,
# and it's far more interpretable.
# The first split says if the longitude
# is greater than or equal to negative 71.07--
#     so if you're on the right side of the picture.
# 
# So the left-hand branch is on the left-hand side
# of the picture and the right-hand--
#     So the left-hand side of the tree
# corresponds to the right-hand side of the map.
# And the right side of the tree corresponds
# to the left side of the map.
# That's a little bit of a mouthful.
# Let's see what it means visually.

# So we'll remember these values, and we'll
# plot the longitude and latitude again.
# So here's our map.
# OK.

# Visualize Output
plot(boston$LON,boston$LAT)
abline(v=-71.07)
abline(h=42.21)
abline(h=42.17)

points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=20)


# So the first split was on longitude,
# and it was negative 71.07.
# So there's a very handy command, "abline,"
# which can plot horizontal or vertical lines easily.
# So we're going to plot a vertical line, so v,
# and we wanted to plot it at negative 71.07.
# OK.
# So that's that first split from the tree.
# It corresponds to being on either the left or right-hand
# side of this tree.
# We'll plot the-- what we want to do is, we'll focus on one area.
# We'll focus on the lowest price prediction, which
# is in the bottom left corner of the tree,
# right down at the bottom left after all those splits.
# So that's where we want to get to.
# So let's plot again the points.
# Plot a vertical line.
# The next split down towards that bottom left corner
# was a horizontal line at 42.21.
# So I put that in.
# That's interesting.
# So that line corresponds pretty much to where
# the Charles River was from before.
# The final split you need to get to that bottom left corner I
# was pointing out is 42.17.
# It was above this line.
# And now that's interesting.
# If we look at the right side of the middle of the three
# rectangles on the right side, that
# is the bucket we were predicting.
# And it corresponds to that rectangle, those areas.
# That's the South Boston low price area we saw before.
# So maybe we can make that more clear by plotting, now,
# the high value prices.
# So let's go back up to where we plotted all the red dots
# and overlay it.
# So this makes it even more clear.
# We've correctly shown how the regression tree carves out
# that rectangle in the bottom of Boston
# and says that is a low value area.
# So that's actually very interesting.
# It's shown us something that regression trees can
# do that we would never expect linear regression to be
# able to do.
# So the question we're going to answer in the next video
# is given that regression trees can do these fancy things
# with latitude and longitude, is it
# actually going to help us to be able to build
# a predictive model, predicting house prices?
# Well, we'll have to see.




# VIDEO 5

# In the previous video, we got a feel for how regression trees
# can do things linear regression cannot.
# But what really matters at the end of the day
# is whether it can predict things better than linear regression.
# And so let's try that right now.
# We're going to try to predict house prices using
# all the variables we have available to us.
# So we'll load the caTools library.
# That will help us do a split on the data.
# We'll set the seed so our results are reproducible.
# And we'll say our split will be on the Boston house prices
# and we'll split it 70% training, 30% test.
# So our training data is a subset of the boston data
# where the split is TRUE.
# And the testing data is the subset of the boston data
# where the split is FALSE.

# Let's use all the variables
# Split the data
library(caTools)
set.seed(123)

split = sample.split(boston$MEDV, SplitRatio = 0.7)
train = subset(boston, split==TRUE)
test = subset(boston, split==FALSE)

# OK, first of all, let's make a linear regression model,
# nice and easy.
# It's a linear model and the variables
# are latitude, longitude, crime, zoning, industry, whether it's
# on the Charles River or not, air pollution, rooms, age,
# distance, another form of distance, tax rates,
# and the pupil-teacher ratio.
# The data is training data.

# Create linear regression
linreg = lm(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data=train)

# OK, let's see what our linear regression looks like.
# So we see that the latitude and longitude are not
# significant for the linear regression, which is perhaps
# not surprising because linear regression didn't seem
# to be able to take advantage of them.
# Crime is very important.
# The residential zoning might be important.
# Whether it's on the Charles River
# or not is a useful factor.
# Air pollution does seem to matter--
#   the coefficient is negative, as you'd expect.
# The average number of rooms is significant.
# The age is somewhat important.
# Distance to centers of employment (DIS),
# is very important.
# Distance to highways and tax is somewhat important,
# and the pupil-teacher ratio is also very significant.
# Some of these might be correlated,
# so we can't put too much stock in necessarily interpreting
# them directly, but it's interesting.
# The adjusted R squared is 0.65, which is pretty good.

summary(linreg)

# So because it's kind of hard to compare out
# of sample accuracy for regression,
# we need to think of how we're going to do that.
# With classification, we just say, this method got X% correct
# and this method got Y% correct.
# Well, since we're doing continuous variables,
# let's calculate the sum of squared error, which
# we discussed in the original linear regression video.
# So let's say the linear regression's predictions are
# predict(linreg, newdata=test) and the linear regression sum
# of squared errors is simply the sum of the predicted values
# versus the actual values squared.
# So let's see what that number is-- 3,037.008.

# Make predictions
linreg.pred = predict(linreg, newdata=test)
linreg.sse = sum((linreg.pred - test$MEDV)^2)
linreg.sse

# OK, so you know what we're interested to see
# now is, can we beat this using regression trees?
# So let's build a tree.
# The tree -- rpart command again.
# Actually to save myself from typing it all up again,
# I'm going to go back to the regression command
# and just change "lm" to "rpart" and change
# "linreg" to "tree"-- much easier.
# All right.
# So we've built our tree-- let's have a look at it using
# the "prp" command from "rpart.plot."
# And here we go.

# Create a CART model
tree = rpart(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data=train)
prp(tree)

# So again, latitude and longitude aren't really important
# as far as the tree's concerned.
# The rooms are the most important split.
# Pollution appears in there twice, so it's, in some sense,
# nonlinear on the amount of pollution--
# if it's greater than a certain amount
# or less than a certain amount, it does different things.
# Crime is in there, age is in there.
# Room appears three times, actually-- sorry.
# That's interesting.
# So it's very nonlinear on the number of rooms.
# Things that were important for the linear regression that
# don't appear in ours include pupil-teacher ratio.
# The DIS variable doesn't appear in our regression tree at all,
# either.
# So they're definitely doing different things,
# but how do they compare?
# So we'll predict, again, from the tree.
# "tree.pred" is the prediction of the tree on the new data.

# And the tree sum of squared errors
# is the sum of the tree's predictions
# versus what they really should be.
# And then the moment of truth-- 4,328.

# So, simply put, regression trees are not as good
# as linear regression for this problem.
# What this says to us, given what we saw with the latitude
# and longitude, is that latitude and longitude are nowhere near
# as useful for predicting, apparently,
# as these other variables are.
# That's just the way it goes, I guess.
# It's always nice when a new method does better,
# but there's no guarantee that's going to happen.
# We need a special structure to really be useful.


# Make predictions
tree.pred = predict(tree, newdata=test)
tree.sse = sum((tree.pred - test$MEDV)^2)
tree.sse

# Let's stop here with the R and go back to the slides
# and discuss how CP works and then we'll
# apply cross validation to our tree.
# And we'll see if maybe we can improve in our results.



# Video 7

# OK, so now we know what CP is, we can go ahead and build
# one last tree using cross validation.
# So we need to make sure first we have the required
# libraries installed and in use.
# So the first package is the "caret" package.
# 
# And the second one we need is the "e1071" package.
# OK.

# Load libraries for cross-validation
install.packages("caret")
library(caret)
install.packages("e1071")
library(e1071)

So we need to tell the caret package how exactly we
# want to do our parameter tuning.
# There are actually quite a few ways of doing it.
# But we're going to restrict ourselves in this course
# to just 10-fold cross validation,
# as was explained in the lecture.
# So let's say  tr.control=trainControl(method="cv",
#                                       number=10).

# Number of folds
tr.control = trainControl(method = "cv", number = 10)

# OK, that was easy enough.
# Now we need to tell caret which range of cp parameters
# to try out.
# Now remember that cp varies between 0 and 1.
# It's likely for any given problem
# that we don't need to explore the whole range.
# I happen to know, by the fact that I
# made this presentation ahead of time, that the value of cp
# we're going to pick is very small.
# So what I want to do is make a grid of cp values to try.
# And it will be over the range of 0 to 0.01.
# OK, so how does what I wrote led to that?
# Well, 1 times 0.001 is obviously 0.001.
# And 10 times 0.001 is obviously 0.01.
# 0 to 5, or 0 to 10, means the numbers
# 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10.
# So 0 to 10 times 0.001 is those numbers scaled by 0.001.
# So those are the values of cp that caret will try.
# So let's store the results of the cross validation fitting
# in a variable called tr.


# cp values
cp.grid = expand.grid( .cp = (0:10)*0.001)


# What did we just do?
1*0.001 
10*0.001 
0:10
0:10 * 0.001


# And we'll use the train function.
# Predicting MEDV based on LAT, LON, CRIM, zoning, industry,
# Charles River, pollution, rooms, age, distance,
# distance from highways, tax, and pupil-teacher ratio.
# OK, we're using the train data set.
# We're using trees (rpart), our train control
# is what we just made before, and our tuning grid
# is the other thing we just made, which we called cp.grid.
# And it whirrs away.
# And what its doing there is it's trying all the different values
# of cp that we asked it to.
# So we can see what it's done but typing tr.

# Cross-validation
tr = train(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data = train, method = "rpart", trControl = tr.control, tuneGrid = cp.grid)
tr

# You can see it tried 11 different values of cp.
# And it decided that cp equals 0.001 was the best because it
# had the best RMSE-- Root Mean Square Error.
# And it was 5.03 for 0.001.
# You see that it's pretty insensitive to a particular value of cp.
# So it's maybe not too important.
# It's interesting though that the numbers are so low.
# I tried it for a much larger range of cp values,
# and the best solutions are always very close to 0.
# So it wants us to build a very detail-rich tree.
# So let's see what the tree that that value of cp corresponds to
# is.

# And we can plot that tree.
# So that's the model that corresponds to 0.001.
# Plot it.
# Wow, OK, so that's a very detailed tree.
# You can see that it looks pretty much like the same tree we
# had before, initially.
# But then it starts to get much more detailed at the bottom.
# And in fact if you can see close enough,
# there's actually latitude and longitude in there
# right down at the bottom as well.
# So maybe the tree is finally going
# to beat the linear regression model.

# So we can get that from going best.tree=tr$finalModel.

# Extract tree
best.tree = tr$finalModel
prp(best.tree)

# Well, we can test it out the same way as we did before.
# best.tree.pred=predict(best.tree,  newdata=test).

# best.tree.sse, the Sum of Squared Errors,
# is the sum of the best tree's predictions
# less the true values squared.
# That number is 3,675.

# Make predictions
best.tree.pred = predict(best.tree, newdata=test)
best.tree.sse = sum((best.tree.pred - test$MEDV)^2)
best.tree.sse

# So if you can remember from the last video,
# the tree from the previous video actually only got something
# in the 4,000s.
# So not very good.
# So we have actually improved.
# This tree is better on the testing set
# than the original tree we created.
# But, you may also remember that the linear regression
# model did actually better than that still.
# The linear regression SSE was more around 3,030.
# So the best tree is not as good as the linear regression model.
# But cross validation did improve performance.
# So the takeaway is, I guess, that trees
# aren't always the best method you have available to you.
# But you should always try cross validating
# them to get as much performance out of them as you can.
# And that's the end of the presentation. Thank you.

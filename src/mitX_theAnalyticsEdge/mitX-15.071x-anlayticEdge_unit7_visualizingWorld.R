# Let's start by reading in our data.
# We'll be using the same data set we
# used during week one, WHO.csv.
# So let's call it WHO and use the read.csv function
# to read in the data file WHO.csv.

# Read in data
WHO = read.csv("WHO.csv")
str(WHO)

# Now, let's take a look at the structure of the data
# using the str function.
# We can see that we have 194 observations, or countries,
# and 13 different variables-- the name of the country, the region
# the country's in, the population in thousands,
# the percentage of the population under 15 or over 60,
# the fertility rate or average number of children per woman,
# the life expectancy in years, the child mortality rate,
# which is the number of children who die by age five per 1,000
# births, the number of cellular subscribers per 100 population,
# the literacy rate among adults older than 15,
# the gross national income per capita,
# the percentage of male children enrolled in primary school,
# and the percentage of female children enrolled
# in primary school.

# In week one, the very first plot we made in R
# was a scatterplot of fertility rate
# versus gross national income.
# Let's make this plot again, just like we did in week one.
# So we'll use the plot function and give as the first variable
# WHO$GNI, and then give as the second variable,
# WHO$FertilityRate.

# Plot from Week 1
plot(WHO$GNI, WHO$FertilityRate)

# This plot shows us that a higher fertility rate
# is correlated with a lower income.

# Now, let's redo this scatterplot,
# but this time using ggplot.
# We'll see how ggplot can be used to make more visually
# appealing and complex scatterplots.
# First, we need to install and load the ggplot2 package.
# So first type install.packages("ggplot2").

# Let's redo this using ggplot 
# Install and load the ggplot2 library:
install.packages("ggplot2")
library(ggplot2)

# Now, remember we need at least three things
# to create a plot using ggplot-- data, an aesthetic mapping
# of variables in the data frame to visual output,
# and a geometric object.
# So first, let's create the ggplot
# object with the data and the aesthetic mapping.
# We'll save it to the variable scatterplot,
# and then use the ggplot function, where
# the first argument is the name of our data set, WHO,
# which specifies the data to use, and the second argument
# is the aesthetic mapping, aes.
# In parentheses, we have to decide
# what we want on the x-axis and what we want on the y-axis.
# We want the x-axis to be GNI, and we
# want the y-axis to be FertilityRate.
# Go ahead and close both sets of parentheses, and hit Enter.

# Create the ggplot object with the data and the aesthetic mapping:
scatterplot = ggplot(WHO, aes(x = GNI, y = FertilityRate))

# Now, we need to tell ggplot what geometric
# objects to put in the plot.
# We could use bars, lines, points, or something else.
# This is a big difference between ggplot and regular plotting
# in R. You can build different types of graphs
# by using the same ggplot object.
# There's no need to learn one function for bar
# graphs, a completely different function for line graphs, etc.
# So first, let's just create a straightforward scatterplot.
# So the geometry we want to add is points.
# We can do this by typing the name of our ggplot object,
# scatterplot, and then adding the function, geom_point().


# Add the geom_point geometry
scatterplot + geom_point()

# We could have made a line graph just as easily
# by changing point to line.
# So in your R console, hit the up arrow, and then just
# delete "point" and type "line" and hit Enter.
# Now, you can see a line graph in the Graphics window.

# Make a line graph instead:
scatterplot + geom_line()

# However, a line doesn't really make sense
# for this particular plot, so let's switch back
# to our points, just by hitting the up arrow twice and hitting
# Enter.

# Switch back to our points:
scatterplot + geom_point()

# In addition to specifying that the geometry we want is points,
# we can add other options, like the color, shape,
# and size of the points.
# Let's redo our plot with blue triangles instead of circles.
# To do that, go ahead and hit the up arrow in your R console,
# and then in the empty parentheses for geom_point,
# we're going to specify some properties of the points.
# We want the color to be equal to "blue", the size to equal 3--
#   we'll make the points a little bigger --
# and the shape equals 17.
# This is the shape number corresponding to triangles.
# If you hit Enter, you should now see in your plot
# blue triangles instead of black dots.
# Let's try another option.
# Hit the up arrow again, and change "blue" to "darkred",
# and change shape to 8.
# Now, you should see dark red stars.
# There are many different colors and shapes
# that you can specify.
# We've provided some information in the text below this video.
# Now, let's add a title to the plot.
# You can do that by hitting the up arrow,
# and then at the very end of everything, add ggtitle,
# and then in parentheses and quotes, the title
# you want to give your plot.
# In our case, we'll call it "Fertility Rate vs. Gross National Income".

# Redo the plot with blue triangles instead of circles:
scatterplot + geom_point(color = "blue", size = 3, shape = 17) 

# Another option:
scatterplot + geom_point(color = "darkred", size = 3, shape = 8) 

# Add a title to the plot:
scatterplot + geom_point(colour = "blue", size = 3, shape = 17) + ggtitle("Fertility Rate vs. Gross National Income")
scatterplot + geom_point(colour = "blue", size = 3, shape = 15) + ggtitle("Fertility Rate vs. Gross National Income")

# Save our plot:
fertilityGNIplot = scatterplot + geom_point(colour = "blue", size = 3, shape = 15) + ggtitle("Fertility Rate vs. Gross National Income")

# If you look at your plot again, you
# should now see that it has a nice title at the top.

# Now, let's save our plot to a file.
# We can do this by first saving our plot to a variable.
# So in your R console, hit the up arrow,
# and scroll to the beginning of the line.
# Before scatterplot, type fertilityGNIplot
# = and then everything else.
# This will save our scatterplot to the variable,
# fertilityGNIplot.
# 
# Now, let's create a file we want to save our plot to.
# We can do that with the pdf function.
# And then in parentheses and quotes, type the name
# you want your file to have.
# We'll call it MyPlot.pdf.
# 
# Now, let's just print our plot to that file with the print
# function -- so print(fertilityGNIplot).

pdf("MyPlot.pdf")
print(fertilityGNIplot)

# And lastly, we just have to type dev.off() to close the file.
dev.off()

# Now, if you look at the folder where WHO.csv is,
# you should see another file called MyPlot.pdf,
# containing the plot we made.
# In the next video, we'll see how to create
# more advanced scatterplots using ggplot.

# we'll see how to color our points by region
# and how to add a linear regression line to our plot.
# Here we have our plot from the last video,
# where we've colored the points dark red.
# Now, let's color the points by region instead.
# This time, we want to add a color option to our aesthetic,
# since we're assigning a variable in our data set to the colors.
# To do this, we can type ggplot, and then first give
# the name of our data, like before,
# WHO, and then in our aesthetic, we again specify that x = GNI
# and y = FertilityRate.
# But then we want to add the option color = Region,
# which will color the points by the Region variable.
# And then we just want to add the geom_point function and hit
# Enter.

# Color the points by region: 
ggplot(WHO, aes(x = GNI, y = FertilityRate, color = Region)) + geom_point()

# Now, in our plot, we should see that each point is colored
# corresponding to the region that country belongs in.
# So the countries in Africa are colored red,
# the countries in the Americas are colored gold,
# the countries in the Eastern Mediterranean
# are colored green, etc.
# This really helps us see something
# that we didn't see before.
# The points from the different regions
# are really located in different areas on the plot.
# Let's now instead color the points
# according to the country's life expectancy.
# To do this, we just have to hit the up arrow
# to get back to our ggplot line, and then
# delete Region and type LifeExpectancy.

# Color the points according to life expectancy:
ggplot(WHO, aes(x = GNI, y = FertilityRate, color = LifeExpectancy)) + geom_point()

# Now, we should see that each point is colored according
# to the life expectancy in that country.
# Notice that before, we were coloring
# by a factor variable, Region.
# So we had exactly seven different colors
# corresponding to the seven different regions.
# Here, we're coloring by LifeExpectancy instead,
# which is a numerical variable, so we get a gradient of colors,
# like this.
# Lighter blue corresponds to a higher life expectancy,
# and darker blue corresponds to a lower life expectancy.

# Let's take a look at a different plot now.
# Suppose we were interested in seeing whether the fertility
# rate of a country was a good predictor of the percentage
# of the population under 15.
# Intuitively, we would expect these variables
# to be highly correlated.
# But before trying any statistical models,
# let's explore our data with a plot.
# So now, let's use the ggplot function on the WHO data again,
# but we're going to specify in our aesthetic
# that the x variable should be FertilityRate,
# and the y variable should be the variable, Under15.
# Again, we want to add geom_point,
# since we want a scatterplot.

# Is the fertility rate of a country was a good predictor of the percentage of the population under 15?
ggplot(WHO, aes(x = FertilityRate, y = Under15)) + geom_point()

# This is really interesting.
# It looks like the variables are certainly correlated,
# but as the fertility rate increases, the variable,
# Under15 starts increasing less.
# So this doesn't really look like a linear relationship.
# But we suspect that a log transformation of FertilityRate
# will be better.
# Let's give it a shot.
# So go ahead and scroll up in your R console
# to the previous line, and instead of x = FertilityRate,
# we want x = log(FertilityRate).

# Let's try a log transformation:
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point()

# Now this looks like a linear relationship.
# Let's try building in a simple linear regression model
# to predict the percentage of the population under 15,
# using the log of the fertility rate.
# So let's call our model, model, and use the lm function
# to predict Under15 using as an independent variable
# log(FertilityRate). And our data set will be WHO.
# Let's look at the summary of our model.


# Simple linear regression model to predict the percentage of the population under 15, using the log of the fertility rate:
mod = lm(Under15 ~ log(FertilityRate), data = WHO)
summary(mod)

# It looks like the log of FertilityRate
# is indeed a great predictor of Under15.
# The variable is highly significant,
# and our R-squared is 0.9391.
# Visualization was a great way for us
# to realize that the log transformation would be better.
# If we instead had just used the FertilityRate,
# the R-squared would have been 0.87.
# That's a pretty significant decrease in R-squared.
# So now, let's add this regression line to our plot.
# This is pretty easy in ggplot.
# We just have to add another layer.
# So use the up arrow in your R console to get back
# to the plotting line, and then add stat_smooth(method = "lm"),
# and hit Enter.

# Add this regression line to our plot:
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm")

# Now, you should see a blue line going through the data.
# This is our regression line.
# By default, ggplot will draw a 95% confidence
# interval shaded around the line.
# We can change this by specifying options
# within the statistics layer.
# So go ahead and scroll up in the R console,
# and after method = "lm", type level = 0.99, and hit Enter.

# 99% confidence interval
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", level = 0.99)

# No confidence interval in the plot
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", se = FALSE)

# Change the color of the regression line:
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", colour = "orange")

# This will give a 99% confidence interval.
# We could instead take away the confidence interval altogether
# by deleting level = 0.99 and typing se = FALSE.
# Now, we just have the regression line in blue.
# We could also change the color of the regression line
# by typing as an option, color = "orange".
# Now, we have an orange linear regression line.
# As we've seen in this lecture, scatterplots
# are great for exploring data.

# However, there are many other ways
# to represent data visually, such as box plots, line charts,
# histograms, heat maps, and geographic maps.
# In some cases, it may be better to choose
# one of these other ways of visualizing your data.
# Luckily, ggplot makes it easy to go
# from one type of visualization to another, simply
# by adding the appropriate layer to the plot.
# We'll learn more about other types of visualizations
# and how to create them in the next lecture.
# So what is the edge of visualizations?
# The WHO data that we used here is
# used by citizens, policymakers, and organizations
# around the world.
# Visualizing the data facilitates the understanding
# of global health trends at a glance.
# By using ggplot in R, we're able to visualize data
# for exploration, modeling, and sharing analytics results.

scale_color_brewer(palette="Dark2") 
ggplot(WHO, aes(x = FertilityRate, y = Under15, color = Region)) + geom_point()
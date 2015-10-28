# Unit 7 - Lecture 2, Predictive Policing


Sys.setlocale("LC_ALL", "C")
# Load our data:
mvt = read.csv("mtv.csv", stringsAsFactors=FALSE)

str(mvt)

# Convert the Date variable to a format that R will recognize:
mvt$Date = strptime(mvt$Date, format="%m/%d/%y %H:%M")

# Extract the hour and the day of the week:
mvt$Weekday = weekdays(mvt$Date)
mvt$Hour = mvt$Date$hour

# Let's take a look at the structure of our data again:
str(mvt)

# Create a simple line plot - need the total number of crimes on each day of the week. We can get this information by creating a table:
table(mvt$Weekday)

# Save this table as a data frame:
WeekdayCounts = as.data.frame(table(mvt$Weekday))

str(WeekdayCounts) 


# Load the ggplot2 library:
library(ggplot2)

# Create our plot
ggplot(WeekdayCounts, aes(x=Var1, y=Freq)) + geom_line(aes(group=1))  

# Make the "Var1" variable an ORDERED factor variable
WeekdayCounts$Var1 = factor(WeekdayCounts$Var1, ordered=TRUE, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday","Saturday"))

# Try again:
ggplot(WeekdayCounts, aes(x=Var1, y=Freq)) + geom_line(aes(group=1))

# Change our x and y labels:
ggplot(WeekdayCounts, aes(x=Var1, y=Freq)) + geom_line(aes(group=1)) + xlab("Day of the Week") + ylab("Total Motor Vehicle Thefts")

################################################
################################################
################################################
# In this video, we'll add the hour of the day
# to our line plot, and then create
# an alternative visualization using a heat map.
# We can do this by creating a line for each day of the week
# and making the x-axis the hour of the day.
# We first need to create a counts table
# for the weekday, and hour.

# So we'll use the table function and give as the first variable,
# the Weekday variable in our data frame.
# and as the second variable, the Hour variable.
# This table gives, for each day of the week and each hour,
# the total number of motor vehicle thefts that occurred.
# For example, on Friday at 4 AM, there
# were 473 motor vehicle thefts, whereas on Saturday
# at midnight, there were 2,050 motor vehicle thefts.

# Create a counts table for the weekday and hour:
table(mvt$Weekday, mvt$Hour)

# Let's save this table to a data frame
# so that we can use it in our visualizations.

# Save this to a data frame:
DayHourCounts = as.data.frame(table(mvt$Weekday, mvt$Hour))
str(DayHourCounts)

# We can see that we have 168 observations-- one
# for each day of the week and hour pair,
# and three different variables.
# The first variable, Var1, gives the day of the week.
# The second variable, Var2, gives the hour of the day.
# And the third variable, Freq for frequency,
# gives the total crime count.
# Let's convert the second variable, Var2,
# to actual numbers and call it Hour,
# since this is the hour of the day,
# and it makes sense that it's numerical.
# So we'll add a new variable to our data frame called Hour =
# as.numeric(as.character(DayHourCounts$Var2)).
# This is how we convert a factor variable to a numeric variable.

# Convert the second variable, Var2, to numbers and call it Hour:
DayHourCounts$Hour = as.numeric(as.character(DayHourCounts$Var2))

# Now we're ready to create our plot.
# We just need to change the group to Var1,
# which is the day of the week.
# So we'll use the ggplot function where
# our data frame is DayHourCounts, and then in our aesthetic,
# we want the x-axis to be Hour this time,
# the y-axis to be Freq, and then in the geom_line option,
# like we used in the previous video,
# we want the aesthetic to have the group equal to Var1,
# which is the day of the week.
# Go ahead and hit Enter.

# Create out plot:
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1))

# You should see a new plot show up in the graphics window.
# It has seven lines, one for each day of the week.
# While this is interesting, we can't
# tell which line is which day, so let's change
# the colors of the lines to correspond
# to the days of the week.
# To do that, just scroll up in your R console,
# and after group = Var1, add color = Var1.
# This will make the colors of the lines
# correspond to the day of the week.
# After that parenthesis, go ahead and type comma,
# and then size = 2.
# We'll make our lines a little thicker.

# Now in our plot, each line is colored corresponding
# to the day of the week.
# This helps us see that on Saturday and Sunday,
# for example, the green and the teal lines,
# there's less motor vehicle thefts in the morning.
# While we can get some information from this plot,
# it's still quite hard to interpret.
# Seven lines is a lot.

# Change the colors
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1, color=Var1), size=2)

# Separate the weekends from the weekdays:
DayHourCounts$Type = ifelse((DayHourCounts$Var1 == "Sunday") | (DayHourCounts$Var1 == "Saturday"), "Weekend", "Weekday")

# Redo our plot, this time coloring by Type:
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1, color=Type), size=2) 


# Make the lines a little transparent:
ggplot(DayHourCounts, aes(x=Hour, y=Freq)) + geom_line(aes(group=Var1, color=Type), size=2, alpha=0.5) 


# Let's instead visualize the same information with a heat map.
# To make a heat map, we'll use our data
# in our data frame DayHourCounts.
# First, though, we need to fix the order of the days
# so that they'll show up in chronological order
# instead of in alphabetical order.
# We'll do the same thing we did in the previous video.
# So for DayHourCounts$Var1, which is the day of the week,
# we're going to use the factor function where the first
# argument is our variable, DayHourCounts$Var1,
# the second argument is ordered = TRUE,
# and the third argument is the order we want the days
# of the week to show up in.
# So we'll set levels, equals, and then c,
# and then list your days of the week.
# Let's put the weekdays first and the weekends at the end.
# So we'll start with Monday, and then Tuesday, then
# Wednesday, then Thursday, Friday, Saturday and Sunday.


# Fix the order of the days:
DayHourCounts$Var1 = factor(DayHourCounts$Var1, ordered=TRUE, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# Now let's make our heat map.
# We'll use the ggplot function like we always do,
# and give our data frame name, DayHourCounts.
# Then in our aesthetic, we want the x-axis
# to be the hour of the day, and the y-axis
# to be the day of the week, which is Var1.
# Then we're going to add geom_tile.

# This is the function we use to make a heat map.
# And then in the aesthetic for our tiles,
# we want the fill to be equal to Freq.
# This will define the colors of the rectangles in our heat map
# to correspond to the total crime.
# You should see a heat map pop up in your graphics window.
# So how do we read this?

# Make a heatmap:
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq))

# For each hour and each day of the week,
# we have a rectangle in our heat map.
# The color of that rectangle indicates the frequency,
# or the number of crimes that occur in that hour
# and on that day.
# Our legend tells us that lighter colors
# correspond to more crime.
# So we can see that a lot of crime
# happens around midnight, particularly on the weekends.
# We can change the label on the legend,
# and get rid of the y label to make our plot a little nicer.
# We can do this by just scrolling up to our previous command
# in our R console and then adding scale_fill_gradient.

# This defines properties of the legend,
# and we want name = "Total MV Thefts",
# for total motor vehicle thefts.
# 
# Then let's add, in the theme(axis.title.y =
# element_blank()).


# Change the label on the legend, and get rid of the y-label:
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq)) + scale_fill_gradient(name="Total MV Thefts") + theme(axis.title.y = element_blank())

# We can also change the color scheme.
# We can do this by scrolling up in our R console,
# and going to that scale_fill_gradient function,
# the one that defines properties of our legend,
# and after name = "Total MV Thefts",
# low = "white", high = "red".
# We'll make lower values correspond
# to white colors and higher values
# correspond to red colors.

# Change the color scheme
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq)) + scale_fill_gradient(name="Total MV Thefts", low="white", high="red") + theme(axis.title.y = element_blank())

# This is a common color scheme in policing.
# It shows the hot spots, or the places with more crime, in red.
# So now the most crime is shown by the red spots
# and the least crime is shown by the lighter areas.
# It looks like Friday night is a pretty common time
# for motor vehicle thefts.
# We saw something that we didn't really see in the heat map
# before.
# It's often useful to change the color scheme depending
# on whether you want high values or low values
# to pop out, and the feeling you want the plot to portray.


# Plot crime on a map of Chicago.
# First, we need to install and load two new packages, the maps
# package and the ggmap package.
# So start by installing and load the packages maps and ggmap.


# Install and load two new packages:
install.packages("maps")
install.packages("ggmap")
library(maps)
library(ggmap)

# Now, let's load a map of Chicago into R.
# We can easily do this by using the get_map function.
# So we'll call it chicago = get_map(location = "chicago",
#                                    zoom = 11).
# 
# Let's take a look at the map by using the ggmap function.

# Load a map of Chicago into R:
chicago = get_map(location = "chicago", zoom = 11)

# Now, in your R graphics window, you
# should see a geographical map of the city of Chicago.

# Look at the map
ggmap(chicago)

# Now let's plot the first 100 motor vehicle
# thefts in our data set on this map.
# To do this, we start by typing ggmap(chicago).

# we want to add geom_point, and here, we'll
# define our data set to be equal to motor vehicle thefts, where
# we'll take the first through 100th observations,
# and in our aesthetic, we'll define our x-axis
# to be the longitude of the points and our y-axis
# to be the latitude of the points.

# Plot the first 100 motor vehicle thefts:
ggmap(chicago) + geom_point(data = mvt[1:100,], aes(x = Longitude, y = Latitude))

# Now, in your R graphics window, you
# should see the map of Chicago with black points marking where
# the first 100 motor vehicle thefts were.
# If we plotted all 190,000 motor vehicle thefts,
# we would just see a big black box,
# which wouldn't be helpful at all.
# We're more interested in whether or not
# an area has a high amount of crime,
# so let's round our latitude and longitude
# to two digits of accuracy and create a crime counts data
# frame for each area.
# We'll call it LatLonCounts, and use the as.data.frame function
# run on the table that compares the latitude and longitude
# rounded to two digits of accuracy.
# So our first argument to table is round(mvt$Longitude, 2).
# 
# And our second argument is round(mvt$Latitude, 2).
# 
# This gives us the total crimes at every point on a grid.
# Let's take a look at our data frame using the str function.


# Round our latitude and longitude to 2 digits of accuracy, and create a crime counts data frame for each area:
LatLonCounts = as.data.frame(table(round(mvt$Longitude,2), round(mvt$Latitude,2)))
str(LatLonCounts)


# We have 1,638 observations and three variables.
# The first two variables, Var1 and Var2,
# are the latitude and longitude coordinates,
# and the third variable is the number of motor vehicle thefts
# that occur in that area.
# Let's convert our longitude and latitude variables to numbers
# and call them Lat and Long.

# Convert our Longitude and Latitude variable to numbers:
LatLonCounts$Long = as.numeric(as.character(LatLonCounts$Var1))
LatLonCounts$Lat = as.numeric(as.character(LatLonCounts$Var2))

# Now, let's plot these points on our map,
# making the size and color of the points
# depend on the total number of motor vehicle thefts.
# So first, again we type ggmap(chicago) +
# geom_point(LatLonCounts, aes(x = Long, y = Lat, color = Freq,
# size = Freq)).

# Plot these points on our map:
ggmap(chicago) + geom_point(data = LatLonCounts, aes(x = Long, y = Lat, color = Freq, size=Freq))

# Now, in our R graphics window, our plot
# should have a point for every area defined by our latitude
# and longitude areas, and the points
# have a size and color corresponding
# to the number of crimes in that area.
# So we can see that the lighter and larger points correspond
# to more motor vehicle thefts.
# This helps us see where in Chicago more crimes occur.
# If we want to change the color scheme,
# we can do that too by just hitting the up arrow in our R
# console and then adding  scale_color_gradient(low="yellow",
#                                               high="red").

# Change the color scheme:
ggmap(chicago) + geom_point(data = LatLonCounts, aes(x = Long, y = Lat, color = Freq, size=Freq)) + scale_colour_gradient(low="yellow", high="red")

# We can also use the geom_tile geometry
ggmap(chicago) + geom_tile(data = LatLonCounts, aes(x = Long, y = Lat, alpha = Freq), fill="red")

# We've created a geographical heat map, which in our case
# shows a visualization of the data,
# but it could also show the predictions of a model.
# Now that our heat map is loaded, let's take a look.
# In each area of Chicago, now that area
# is colored in red by the amount of crime there.
# This looks more like a map that people
# use for predictive policing.

LatLonCounts2 <- subset(LatLonCounts, Freq > 0)
ggmap(chicago) + geom_tile(data = LatLonCounts2, aes(x = Long, y = Lat, alpha = Freq), fill="red")


# Geographical Map on US

# create a heat map
# on a map of the United States.
# We'll be using the data set murders.csv, which
# is data provided by the FBI giving
# the total number of murders in the United States by state.
# Let's start by reading in our data set.
# We'll call it murders, and we'll use the read.csv function
# to read in the data file murders.csv.

# Load our data:
murders = read.csv("murders.csv")
str(murders)

# We have 51 observations for the 50 states
# plus Washington, DC, and six different variables:
#     the name of the state, the population, the population
# density, the number of murders, the number
# of murders that used guns, and the rate of gun ownership.

# A map of the United States is included
# in R. Let's load the map and call it statesMap.
# We can do so using the map_data function,
# where the only argument is "state" in quotes.
# Let's see what this looks like by typing in str(statesMap).

# Load the map of the US
statesMap = map_data("state")
str(statesMap)

# This is just a data frame summarizing
# how to draw the United States.
# To plot the map, we'll use the polygons geometry of ggplot.
# So type ggplot, and then in parentheses, our data frame
# is statesMap, and then our aesthetic is x = long,
# the longitude variable in statesMap, y = lat,
# the latitude variable, and then group = group.
# This is the variable defining how
# to draw the United States into groups by state.
# Then close both parentheses here,
# and we'll add geom_polygon where our arguments here will be
# fill="white"-- we'll just fill all states in white--
# and color="black" to outline the states in black.

# Plot the map:
ggplot(statesMap, aes(x = long, y = lat, group = group)) + geom_polygon(fill = "white", color = "black") 

# Now in your R graphics window, you
# should see a map of the United States.
# Before we can plot our data on this map,
# we need to make sure that the state names are
# the same in the murders data frame
# and in the statesMap data frame.
# In the murders data frame, our state names
# are in the State variable, and they
# start with a capital letter.
# But in the statesMap data frame, our state names
# are in the region variable, and they're all lowercase.
# So let's create a new variable called region in our murders
# data frame to match the state name variable in the statesMap
# data frame.
# So we'll add to our murders data frame the variable region,
# which will be equal to the lowercase version--
# using the tolower function that we used in the text analytics
# lectures-- and the argument will be murders$State.
# 
# This will just convert the State variable
# to all lowercase letters and store it
# as a new variable called region.

# Create a new variable called region with the lowercase names to match the statesMap:
murders$region = tolower(murders$State)

# Now we can join the statesMap data frame with the murders
# data frame by using the merge function, which
# matches rows of a data frame based on a shared identifier.
# We just defined the variable region,
# which exists in both data frames.
# So we'll call our new data frame murderMap,
# and we'll use the merge function,
# where the first argument is our first data frame, statesMap,
# the second argument is our second data frame, murders,
# and the third argument is by="region".
# This is the identifier to use to merge the rows.
# Let's take a look at the data frame
# we just created using the str function.

# Join the statesMap data and the murders data into one dataframe:
murderMap = merge(statesMap, murders, by="region")
str(murderMap)

# We have the same number of observations
# here that we had in the statesMap data frame,
# but now we have both the variables from the statesMap
# data frame and the variables from the murders data
# frame, which were matched up based on the region variable.
# So now, let's plot the number of murders
# on our map of the United States.
# We'll again use the ggplot function, but this time,
# our data frame is murderMap, and in our aesthetic we want
# to again say x=long, y=lat, and group=group,
# but we'll add one more argument this time,
# which is fill=Murders so that the states will be colored
# according to the Murders variable.
# Then we need to add the polygon geometry where the only
# argument here will be color="black"
# to outline the states in black, like before.
# And lastly, we'll add scale_fill_gradient where
# the arguments here, we'll put low="black" and high="red"
# to make our color scheme range from black to red,
# and then guide="legend" to make sure we get a legend
# on our plot.

# Plot the number of murder on our map of the United States:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = Murders)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend")

# should see that each of the states
# is colored by the number of murders in that state.
# States with a larger number of murders are more red.
# So it looks like California and Texas
# have the largest number of murders.
# But is that just because they're the most populous states?
# Let's create a map of the population of each state
# to check.
# So back in the R Console, hit the Up arrow, and then,
# instead of fill=Murders, we want to put fill=Population to color
# each state according to the Population variable.
# If you look at the graphics window,
# we have a population map here which
# looks exactly the same as our murders map.

# Plot a map of the population:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = Population)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend")

# So we need to plot the murder rate instead
# of the number of murders to make sure we're not just
# plotting a population map.
# So in our R Console, let's create
# a new variable for the murder rate.
# So in our murderMap data frame, we'll create the MurderRate
# variable, which is equal to murderMap$Murders--
# the number of murders-- divided by murderMap$Population times
# 100,000.
# So we've created a new variable that's
# the number of murders per 100,000 population.
# Now let's redo our plot with the fill equal to MurderRate.
# So hit the Up arrow twice to get back to the plotting command,
# and instead of fill=Population, this time we'll put
# fill=MurderRate.

# Create a new variable that is the number of murders per 100,000 population:
murderMap$MurderRate = murderMap$Murders / murderMap$Population * 100000

# Redo our plot with murder rate:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = MurderRate)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend")

# If you look at your graphics window now,
# you should see that the plot is surprisingly maroon-looking.
# There aren't really any red states.
# Why?
# It turns out that Washington, DC is
# an outlier with a very high murder rate,
# but it's such a small region on the map
# that we can't even see it.
# So let's redo our plot, removing any observations
# with murder rates above 10, which
# we know will only exclude Washington, DC.
# Keep in mind that when interpreting and explaining
# the resulting plot, you should always
# note what you did to create it: removed
# Washington, DC from the data.

# So in your R Console, hit the Up arrow again, and this time,
# after guide="legend", we'll type limits=c(0,10) and hit Enter.

# Redo the plot, removing any states with murder rates above 10:
ggplot(murderMap, aes(x = long, y = lat, group = group, fill = MurderRate)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend", limits = c(0,10))

# Now if you look back at your graphics window,
# you can see a range of colors on the map.
# In this video, we saw how we can make a heat map
# on a map of the United States, which
# is very useful for organizations like the World Health
# Organization or government entities who want to show data
# to the public organized by state or country.

ggplot(murderMap, aes(x = long, y = lat, group = group, fill = GunOwnership)) + geom_polygon(color = "black") + scale_fill_gradient(low = "black", high = "red", guide = "legend")
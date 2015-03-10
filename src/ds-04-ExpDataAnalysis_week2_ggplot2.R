############
## Part 1 ##
############

# 1. ggplot2 -> a third graphic system for R (base and lattice)

library(ggplot2) #Load ggplot2 library -> install the package if not available
##more infor are available at http://ggplot2.org
## Metaphor: think of a graph as a "verb", "noun" and "adjectives"

ls(package:ggplot2) #list functions in the package


##The basics: qplot()
### same as the plot function in the base system
### looks for data in a dataframe or environment
### plots are made of aesthetics (size, shape, color) and geoms(points, lines)
### ggplot() is the core function behind qplot() - it is very flexible for doing
###     specific things that the qplot() cannot do

str(mpg) ## basic data set present in the library
# A data frame with 234 rows and 11 variables
# Details
# manufacturer.
# model.
# displ. engine displacement, in litres
# year.
# cyl. number of cylinders
# trans. type of transmission
# drv. f = front-wheel drive, r = rear wheel drive, 4 = 4wd
# cty. city miles per gallon
# hwy. highway miles per gallon
# fl.
# class

## a simple ggplot2
qplot(displ, hwy, data = mpg) #create a plot that is very different from the traditional plots

## how we cam modify the aesthetics
qplot(displ, hwy, data = mpg, color = drv) #color aesthetic using drv (factor) for grouping the data

## Adding a geom
qplot(displ, hwy, data = mpg, geom = c("point", "smooth")) 
# adding geom: 
# 1. "point" adds the points and 
# 2. "smooth" adds a smmoth line (with a 95% confidence interval)

## Other functions: histograms (for only one variable)
qplot(hwy, data = mpg, fill=drv) #histograms categorized by drv

## Another function: Facets
##scatterplot
qplot(displ, hwy, data = mpg, facets = . ~ drv) #. rows and 3 cols (as levels in drv factor)
## syntax for facets -> . (rows) ~ drv (cols)

##scatterplot
qplot(displ, hwy, data = mpg, facets = drv ~ ., binwidth = 2) #3 rows (as levels in drv factor) and . cols 
##Histogram
qplot(hwy, data = mpg, facets = drv ~ ., binwidth = 2) #3 rows (as levels in drv factor) and . cols 

##Other examples -> histograms
qplot(hwy, data = mpg) #simple histogram
qplot(hwy, data = mpg, fill = drv) #histogram by groups (fill)
qplot(hwy, data = mpg, geom = "density") #add a density smooth
qplot(hwy, data = mpg, geom = "density", color = drv) #add a density smooth by drv (factor)

##Other examples -> scatterplot
qplot(displ, hwy, data = mpg) #simple scatterplot (default)
qplot(displ, hwy, data = mpg, shape = drv) #scatterplot customizing shapes by drv (factor)
qplot(displ, hwy, data = mpg, color = drv) #scatterplot customizing colrs by drv (factor)
#scatterplot customizing shapes by drv (factor)
#adding a linera regression line
qplot(displ, hwy, data = mpg, color = drv, geom = c("point", "smooth"), method = "lm") 
#scatterplot customizing shapes by drv (factor)
#adding a linear regression line
#in different plots
qplot(displ, hwy, data = mpg, color = drv, geom = c("point", "smooth"), method = "lm", facets = . ~ drv) 

############
## Part 1 ##
############

# 1. The Lattice Plotting System in R
# It is implemented on "grid", a graphic system independednt from the "base" system
# All plotting & annotations are done at once (no two-phase process)
# (there is no opportunity to annotate after creation)
library(datasets) #load datasets library
library(lattice) #load the package
ls(package:lattice) #list all of functions available in the package

# Interested in
# xyplot
# bwplot
# histogram
# stripplot
# dotplot
# splom
# levelplot, contourplot

## lattice function generally take  formula for their first argument
### For the functions documented here, the formula is generally of the 
### form y ~ x | g1 * g2 * ... (or equivalently, y ~ x | g1 + g2 + ...), 
### indicating that plots of y (on the y-axis) versus x (on the x-axis) 
### should be produced conditional on the variables g1, g2, .... 
### Here x and y are the primary variables, and 
### g1, g2, ... are the conditioning variables. 
### The conditioning variables may be omitted to give a formula of the 
### form y ~ x, in which case the plot will consist of a single panel
### with the full dataset. 

# a simple lattice plot: a simple scatterplot
str(airquality)
xyplot(Ozone ~ Wind, airquality) #No conditioning variables

# plot the Ozone vs. Wind by Months in different panels
#Lets add a conditioning variable -> Month
## Convert Month variable to a factor variable
airquality <- transform(airquality, Month = factor(Month))
xyplot(Ozone ~ Wind | Month, airquality, layout = c(5,1))
#Month conditioning variable, note it was transformed to a factor type
#layout sets to 5 panels as no of cols, no of rows and no of pages (optional)

# Invisibel Behavior of Lattice functions
# 2. Lattice graphic functions returns an object of class trellis
p <- xyplot(Ozone ~ Wind, data = airquality) #when running this line of code nothing happens.
class(p) #trellis
print(p) #to force the plotting of the graph

#when running the following line of code the auto-print mechanism kicks in
#in the console (Be aware of forcing the printing when running scripts!)
xyplot(Ozone ~ Wind, data = airquality)

# Another example - with focus on teh panel function
# 3. Lattice Panel Function
set.seed(10)
x <- rnorm(100)
f <- rep(0:1, each = 50)
y <- x + f - f * x + rnorm(100, sd = 0.5)
f <- factor(f, labels = c("Group 1", "Group 2"))
xyplot(y ~ x | f, layout = c(2,1)) #Plot with 2 panels (same as the number of levels in teh factor variable)

# Customizing the Lattice Panel function to add a regression line :)
xyplot(y ~ x | f, panel = function(x, y, ...){
        panel.xyplot(x, y, ...) #First call teh default panel function
        panel.lmline(x, y, col = 2) #Add/ overlay a simple linear regression line
})

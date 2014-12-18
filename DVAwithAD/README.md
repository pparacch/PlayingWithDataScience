------------------------------------------------
-   Based "Practical Data Science Cookbook"    -
------------------------------------------------
Driving Visual Analysis with Automobile Data (R)
------------------------------------------------
Analysis of automobile fuel economy data using the following process
(alias Data Science Pipeline)

* Acquisition
* Exploration and understanding
* Munging, wrangling and manipualtion
* Communication & Operalization

The process uses the Split-Apply-Combine data analysis pattern.

R -> Installing packages needed for the project
-----------------------------------------------
1 - Install the following packages install.packages
* plyr
* ggplot2
* reshape2

2 - Load the packages using library()

Acquire automobile fuel efficiency data
---------------------------------------
data -> 
contains fuel efficiency performance metrics, measured in miles per gallon (MPG)
for different models of automobiles available in the U.S. since 1984.

labels -> contains labels for the vehicles.csv file

Load the Data & Labels
----------------------
stringsAsFactors = F
by defualt R converts strings to factors (a R datatype). Factor is a kind of label 
or tag applied to to the data. Internally R stores factors as integers with a mapping
to the appropiate label.

Exploring and describing fuel efficiency data
---------------------------------------------
* get observations available in the data set

** dim(data) -> nrow, ncol
** nrow(data) -> nrow, ncol(data) -> ncol
** names(data) -> column names


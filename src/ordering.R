##Reference vector
unmow <- c(8,9,7,9,NA)

#Reference data.frame
#Create X dataframe with 3 variables (var1, var2, var3) & 5 observations
#using the random generator
set.seed(13435) #Setting the random number seed to ensure reproducibility
X <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X <- X[sample(1:5),]
X$var2[c(1,3)] = NA

#########
##Vector#
#########

#Ordering - order{base} retun the index of ordered elements 
#By default: ascending aorder, NAs accepted and last 
order(unmow)

#ordering descending (default - NAs accepted & last)
order(unmow, decreasing = T)

#in order to change the NAs management use na.last
# na.last = T: NAs are last
order(unmow, na.last = T)
# na.last = F: NAs are first
order(unmow, na.last = F)
# na.last = NA: NAs are omitted
order(unmow, na.last = NA)

#############
##data.frame#
#############

order(X$var1)
#order the data.frame according to values for the variable "var1"
X[order(X$var1),]
#order can be done provided multiple variables
#var3 is going to be used if there are more than one observation with
#the same var1 value
X[order(X$var1, X$var3),]

#Please note oder can be applied to the data.frame
#X is going to be treated as a vector (colum wise)
#What is going to appen when different modes applied in teh dataframe?
order(X) 

#######
##plyr#
#######
library (plyr)
#order X in ascending order according to values of var1
#by default NAs are allowed and added last
arrange(X, var1)

#order X in descending order according to values of var1
#by default NAs are allowed and added last
arrange(X, desc(var1))
arrange(X, var2)

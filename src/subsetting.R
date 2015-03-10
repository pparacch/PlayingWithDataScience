#Create X dataframe with 3 variables (var1, var2, var3) & 5 observations
#using the random generator
set.seed(13435) #Setting the random number seed to ensure reproducibility
X <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X <- X[sample(1:5),]
X$var2[c(1,3)] = NA

##########################
#Subsetting by rows & cols
##########################
X[,1] #Subset -> 1st column
X[,"var1"] #Subset -> "var1" column
X[1:2, "var2"] #Subset -> first two observation from the second column

#Subsetting using Logical conditions
X[X$var1 <= 3,] #subset -> all observations where var1 <=3 or NA
class(X[X$var1 <= 3,]) #data.frame

#Note what it happens when the variable used for subsetting has NAs
X[X$var2 >= 9,] #subset -> all observations where var2 >= 9 or NA
#NA values are not removed but see below how they are treated....
# > X[X$var2 >= 9,]
# var1 var2 var3
# NA     NA   NA   NA
# 4       1   10   11
# NA.1   NA   NA   NA
# 5       4    9   13


X[(X$var1 <= 3 & X$var3 > 11),] #subset -> all observations where var1 <=3 (or NA) & var3 > 11 (or NA)
X[(X$var1 <= 3 | X$var3 > 11),] #subset -> all observations where var1 <=3 (or NA) | var3 > 11 (or NA)

#Dealing with missing values: which (NAs are allowed but are omitted)
which(X$var1 >= 3) #return the index of rows that satisfy the provided condition
which(X$var2 >= 9) #return the index of rows that satisfy the provided condition

X[which(X$var2 <= 20),]
X[X$var2 <= 20,] #for comparison without which (NAs are allowed and returned)
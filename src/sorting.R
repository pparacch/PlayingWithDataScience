##Sorting a vector
unmow <- c(8,9,7,9, NA)

#Sorting in ascending order omitting NA
sort(unmow) #by default sort in acending order and NAs are omitted (na.last = NA)

#Sorting in descending order omitting NAS
sort(unmow, decreasing = TRUE)

#Not omitting NAa and adding them at the beginning
sort(unmow, na.last = FALSE)

#Not omitting NAa and adding them at the end
sort(unmow, na.last = TRUE)

##Sorting a data.frame
#Reference data.frame
#Create X dataframe with 3 variables (var1, var2, var3) & 5 observations
#using the random generator
set.seed(13435) #Setting the random number seed to ensure reproducibility
X <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X <- X[sample(1:5),]
X$var2[c(1,3)] = NA

#not possible to sort a dataframe
sort(X) #generate an error

#sort the values of variable in the "var1" col - ascending and omitting NAs
sort(X$var1) 

#sort the values of variable in the "var2" col - ascending and omitting NAs
sort(X$var2)
#do not omitt the NAs but add tehm at the beginning of the sorted output
sort(X$var2, na.last = FALSE)
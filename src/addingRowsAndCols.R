#Reference data.frame
#Create X dataframe with 3 variables (var1, var2, var3) & 5 observations
#using the random generator
set.seed(13435) #Setting the random number seed to ensure reproducibility
X <- data.frame("var1" = sample(1:5), "var2" = sample(6:10), "var3" = sample(11:15))
X <- X[sample(1:5),]
X$var2[c(1,3)] = NA

#Adding a new col/variable
#Note that if the no of observation (rows) is different an error is thrown
Y <- X
Y$var4 <- rnorm(5)
#another way to add a new col is to use cbind
Y <- cbind(X, rnorm(5))

#for adding new observatiosn (rows) rbind can be used
Y <- rbind(X, c(9, 1, 9))

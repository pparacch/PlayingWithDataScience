###########################################
###########################################
##Create a vector
##using the concatenate function
##c()

x <- c(0.5, 0.6) ##numeric
class(x); typeof(x)
x <- c(TRUE, FALSE) ##logic
x <- c("a", "b", "c") ##character
x <- c(1, 2, 3)
class(x); typeof(x)

##Using the vector() function
x <- vector(mode = "numeric", length = 10)
x ##default value is 0
x <- vector(mode = "logical", length = 10)
x ##default value is FALSE


##Using the : operator to create integer vector
x <- 1:5
x
class(x); typeof(x)

x <- pi:7
x
class(x); typeof(x)

##Using the seq() function
x <- seq(1, 9, by = 2)     # matches 'end'
class(x); typeof(x);

x <- seq(10)
class(x); typeof(x);

x <- seq(from = 1, to = 9)     # matches 'end'
class(x); typeof(x);

##Using rep() to create a new vector
rep(1:4, times = 2)
rep(1:4, each = 2)
rep(1:4, each = 2, len = 4)    # first 4 only.
rep(1:4, each = 2, len = 10)   # 8 integers plus two recycled 1's.
rep(1:4, each = 2, times = 3)  # length 24, 3 complete replications

###########################################
###########################################
##Adding element to a vector
x <- c(1,2,3,4,5)
y <- c(x, 6,7,8) ##create a new vector from x adding new elements
x; y

###########################################
###########################################
##Removing elements from a vector
x <- c(1,2,3,4,5)
y <- c(x[1:2], x[4:5]) ##create a new vector from x adding new elements
x; y

###########################################
###########################################
##Use of the length of a vector to write general function
##Loop through the elements of the vector
first1 <- function(x){
        for(i in 1:length(x)){
                if(x[i] == 1) break
        }
        return(i)
}
first1(c(2,3,4,5,1))

##Traps with empty vectors
x <- c() ##an empty vector
x ##content of x
length(x) ##length of the empty vector

##What does it happen if we create a vector using
1:length(x)

##An approach when delaing with vector is to use seq()
x <- c(1,2,3)
for(i in seq(x)) print(i)

x <- c()
for(i in seq(x)) print(i)

###########################################
###########################################
##Recycling
c(1,2,3,4) + c(10,20)

###########################################
###########################################
###Arithmetic Operations: element-based, 1st element with 1st element .. etc
x <- c(10,20,30)
y <- c(1,2,3)
x + y 
x * y
x / y

###########################################
###########################################
## Subsetting
x <- c(1,2,3,4,5,6,7,8,9,10,11,12,13)
x[c(1,3,1,3)] #A new vector of 4 elements, the 1st & 3rd, & the 1st & 3rd 
x[2:3] #A new vector of 2 elements, the 2nd & 3rd

indices <- c(2:3)
x[indices]

x[-1] #All except the 1st element
x[-length(x)] #All except the last
x[-c(1:10)] #All except the first 10 elements


###########################################
###########################################
##all() & any()
x <- 1:10
any(x > 5)
any(x > 88)

all(x > 10)
all(x > 0)

x <- c(x, NA, 12,13)
any(x > 5)
all(x > 10)

x <- 1:10
x > 5

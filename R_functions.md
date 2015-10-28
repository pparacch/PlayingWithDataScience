#Functions

##Introduction to Functions
The heart of R programming consists on writing functions. A function is _"a group of instructions that takes inputs, uses the inputs to compute other values, and returns a result"_.

An example 

```
# Counts the number of odds integers in x (vector)
oddcount <- function(x){
  k <- 0 #  assign 0 to k
  for(n in x){
    
    if(n %% 2 == 1) k <- k + 1 # %% modulo operator
  
  }
  return(k) # return number of odd integer 
}

> oddcount(c(1,3,5,7,9))
[1] 5

> oddcount(c(1,3,2,7,4))
[1] 3
```

In `oddcount <- function(x)`, __x__ is called the  __formal argument__ (or __formal parameter__). When calling the function `oddcount(c(1,2,3,4,5))`, __c(1,2,3,4,5)__ is referred as the __actual argument__.

### Variable Scope & Scoping Rules
A variable that is visible only within a function body is said to be local to the function. Note that __formal arguments__ in a function are __local variables__. 

```
# Remove specified element from the given vector
> removeElement <- function(fromVector, elementIndex){
+   print(fromVector)
+   fromVector <- fromVector[-elementIndex]
+   print(fromVector)
+ }

> z <- c(1,2,3,4,5)
#z is passed as actual argument to the function
# a local variable is created and assigned the same value as z
> removeElement(z, 2) 
[1] 1 2 3 4 5
[1] 1 3 4 5

# Changing the local variable does not have any consequence
# outside of the function.
> z
[1] 1 2 3 4 5
```

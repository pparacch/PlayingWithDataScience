#########################
#scalar & mode of numbers
#########################
x <- 1 # default behaviour
print(x)
mode(x)
class(x)
typeof(x)

y <- 1L # forced to be an integer
print(y)
mode(y)
class(y)
typeof(y)

## attributes
x <- 1
attributes(x)

##Vectors: scalar & character strings
text <- "message"
print(text)
length(text)
mode(text)

##Matrices
m <- rbind(c(1,2), c(3,4))
m
attributes(m)

m <- matrix(nrow = 2, ncol = 2)
m
dim(m)
attributes(m)

##Lists
x <- list(1, "a", TRUE, 1+4i)
x
attributes(x)

x <- list(x = 1, y = "abc", d = c(1,2,3))
x

##Complex example
z <- hist(Nile)
class(z)
attributes(z)
str(z)
summary(z)

##Data Frames
d <- data.frame(list(sensor = c("temperature", "pressure")), value=c(10, 15))
d

x <- data.frame(foo = 1:4, bar = c(T, T, F, F))
x

##Factors
x <- factor(c("yes", "yes", "no", "yes", "no"))
x
class(x)
y <- unclass(x)
y

#Order levels in factors
x <- factor(c("yes", "yes", "no", "yes", "no"), levels = c("yes", "no"))
x
unclass(x)

##Implicit Coercion in Vector
y <- c(1.7, "a")
class(y)
y

y <- c(T, 2)
class(y)
y

y <- c("a", T)
class(y)
y

##Explicit Coercion
x <- 0:6
class(x)
x1 <- as.numeric(x)
class(x1)
x2 <- as.logical(x)
class(x2)
x3 <- as.character(x)
class(x3)

##Explicit Coercion - Non-Sense
x <- c("a", "b", "c")
class(x)
x1 <- as.numeric(x)
x1
class(x1)
x2 <- as.logical(x)
x2
class(x2)
x3 <- as.complex(x)
x3
class(x3)






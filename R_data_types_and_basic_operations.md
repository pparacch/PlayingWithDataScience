# Data Types & Basic Operations

[Data Types Overview: Modes](#modes)  
[Data Types Overview: Data Structures in R](#dataStructures)  
[Basic Operations](#basicOperations)  
[Special Values: `NA`, `NaN` & `Null`](#specialValues)




## Data Types Overview

### <a id="modes">Modes</a>
Basic or “atomic” classes of objects or __modes__ in R:

-   __character__

-   __numeric__
	-   __numeric (real numbers)__
	-   __integer__

-   __complex__

-   __logical (True/False)__

#### Some more info on Numbers
Numbers in R are generally treated as __numeric__ (real numbers). If you explicitly want an integer the ___L suffix___ must be used.

```
> x <- 1 # Default behaviour
> print(x)
[1] 1
> mode(x)
[1] "numeric"
>class(x)
[1] "numeric"
>typeof(x)
[1] "double"
```
```	
> y <- 1L # forced to be an integer
> print(y)
[1] 1
> mode(y)
[1] "numeric"
> class(y)
[1] "integer"
>typeof(y)
[1] "integer"
```
Special numbers to be aware of `Inf` (e.g. `1/0`) or `NaN` (not a number, e.g. `0/0`). __Note!__ `NaN` can also be thought as a missing value.

#### Useful Commands
Command | Description
------------ | ---------
`typeof()` | Determine the (R internal) type or storage mode of any object.
`mode()` | Get the type or storage mode of an object.
`class()`| Many R objects have a __class__ attribute, a character vector giving the names of the classes from which the object inherits. If the object does not have a __class__ attribute, it has an implicit class, "matrix", "array" or the result of `mode(x)` (except that integer vectors have implicit class "integer").

### <a id="dataStructures">Some R Data Structure</a>

#### Attributes
R objects can have attributes

- names, dimnames
- dimensions
- class
- length
- other user-defined attributes/ metadat

Command | Description
------------ | ---------
`attributes()` | Return the object's attribute list as a vector. `NULL` if attributes are not available. 


#### Vector
The most basic object is a vector

-   it can only contain objects/ elements of the same mode or __elements of a vector must have all of the same mode/ data type__.

##### Scalars & Character Strings
Scalars & Caharacter Strings do not exist in R - what appear to be an individual number or a string is actuallly a _one-element_ vector.

```
> x <- 1 # Appear to be a scalar but
> print(x)
[1] 1   
# [1] indicates that the following row of numbers 
# begins with element 1 of the x vector 
```

```
text <- "message"
> print(text)
[1] "message"
# [1] indicates that the following row of numbers 
# begins with element 1 of the text vector
> length(text)
[1] 1
# length of the text vector
> mode(text)
[1] "character"
```

Command | Description
------------ | ---------
`length()` | Return the length of the vector.

#### Matrices
Matrices are vectors with a __dimension__ attribute. The __dimension attribute is an integer vector of length 2 (nrow, ncol). __Note!__ Being a vector, a matrix can contain only element of the same mode/ data type.

```
#Create a matrix with a row bind of two vectors
> m <- rbind(c(1,2), c(3,4))
> m
     [,1] [,2]
[1,]    1    2
[2,]    3    4
> attributes(m)
$dim
[1] 2 2
```

```
> m <- matrix(nrow = 2, ncol = 2)
> m
     [,1] [,2]
[1,]   NA   NA
[2,]   NA   NA
> dim(m)
[1] 2 2
> attributes(m)
$dim
[1] 2 2
```

Command | Description
------------ | ---------
`dim()` | Return the __dimension__ attribute. `NULL` if __dimension__ does not exist.


#### Lists
A __list__ is a container for values but its content __can be__ ___items of different modes/ data types___.

```
# Create a list containing items of different modes/ data type
# numeric, character, logical, complex
x <- list(1, "a", TRUE, 1+4i)
> x
[[1]]
[1] 1

[[2]]
[1] "a"

[[3]]
[1] TRUE

[[4]]
[1] 1+4i
```

```
> x <- list(x = 1, y = "abc", d = c(1,2,3))
> x
$x
[1] 1

$y
[1] "abc"

$d
[1] 1 2 3
```

#### Data Frames
A typical data set containing data of different modes/ data types, used to store tabular data.

A __Data Frame__ is a __list__ with each component of the list being a vector corresponding to a "column" in our tabular data.

- a special type of list where every element of the list has to have the same length
- each element of the list can be thought of as a column, and its lenght has the number of rows
- able to store different classes of objects in each columns - but within the same column elements must have the same mode/ data type.

```
> d <- data.frame(list(sensor = c("temperature", "pressure")), value=c(10, 15))
> d
       sensor value
1 temperature    10
2    pressure    15
```

```
> x <- data.frame(foo = 1:4, bar = c(T, T, F, F))
> x
  foo   bar
1   1  TRUE
2   2  TRUE
3   3 FALSE
4   4 FALSE
```

Note! Typically data frames are created by reading a data set from a specific source e.g. file, database, etc.

#### Factors
Factors are used to represent categorical data, ordered or unordered. A factor is like an integer vector where each integer has a label.

- Factors are treated specially by modelling functions e.g. `lm()`, etc
- Factors are self-describing.

```
> x <- factor(c("yes", "yes", "no", "yes", "no"))
> x
[1] yes yes no  yes no 
Levels: no yes
> class(x)
[1] "factor"
> y <- unclass(x)
> y
[1] 2 2 1 2 1
attr(,"levels")
[1] "no"  "yes"
```

__Note!__ The order of the levels in factors can be set using `levels` argument in `factors()`.

```
> x <- factor(c("yes", "yes", "no", "yes", "no"), levels = c("yes", "no"))
> x
[1] yes yes no  yes no 
Levels: yes no
> unclass(x)
[1] 1 1 2 1 2
attr(,"levels")
[1] "yes" "no" 
```

#### Note on Classes
R is an object-oriented language and most of the R language is based on S3 classes (S language, version 3). Instances of classes are lists with an extra attribute, the __class name__.

Classes are a fundamental concept when working with __generic__ functions.

_"A **generic function** stands for a family of functions, all serving a similar purpose but each appropiate to a specific class."_

#### Usefull Commands for R Data Sructures
Command | Description
------------ | ---------
`str()` | Return the __structure__ of provided R data structure (__generic function__).
`summary()` | Return the __summary__ of provided R data structure (__generic function__).
`class()`| Many R objects have a __class__ attribute, a character vector giving the names of the classes from which the object inherits. If the object does not have a __class__ attribute, it has an implicit class, "matrix", "array" or the result of `mode(x)` (except that integer vectors have implicit class "integer").
`unclass()` | Return (a copy of) its argument with its class attribute removed. (It is not allowed for objects which cannot be copied, namely environments and external pointers.)

An example...

```
z <- hist(Nile)
> class(z)
[1] "histogram"
> attributes(z)
$names
[1] "breaks"   "counts"   "density"  "mids"     "xname"    "equidist"

$class
[1] "histogram"

> str(z)
List of 6
 $ breaks  : num [1:11] 400 500 600 700 800 900 1000 1100 1200 1300 ...
 $ counts  : int [1:10] 1 0 5 20 25 19 12 11 6 1
 $ density : num [1:10] 0.0001 0 0.0005 0.002 0.0025 0.0019 0.0012 0.0011 0.0006 0.0001
 $ mids    : num [1:10] 450 550 650 750 850 950 1050 1150 1250 1350
 $ xname   : chr "Nile"
 $ equidist: logi TRUE
 - attr(*, "class")= chr "histogram"
 - > summary(z)
         Length Class  Mode     
breaks   11     -none- numeric  
counts   10     -none- numeric  
density  10     -none- numeric  
mids     10     -none- numeric  
xname     1     -none- character
equidist  1     -none- logical
```
 
 
---
## <a id="basicOperations">Basic Operations</a>

Command | Description
------------ | ---------
`<-` | The __assignment operator__. `=` could be used but _"it does not work in some special situations"_. E.g. `x <- 15`
`>x` or `c(12,11)` vs. `print(x)` | __Auto-Printing__  vs. __Explicit-Printing__. __Auto-Printing__ works in the interactive mode (not in the batch mode).
__implicit coercion__ | When elements of different modes/ data types are mixed in a vector, coercion occurs so that elements are of the same mode/ data type.
__explicit coercion__ | Forcing elements from one mode/ data type to another mode/ data type using the `as.*` function (if available).

### Implicit Coercion

```
> y <- c(1.7, "a")
> class(y)
[1] "character"
> y
[1] "1.7" "a"  
> 
> y <- c(T, 2)
> class(y)
[1] "numeric"
> y
[1] 1 2
> 
> y <- c("a", T)
> class(y)
[1] "character"
> y
[1] "a"    "TRUE"
```
### Explicit Coercion

```
> x <- 0:6
> class(x)
[1] "integer"
> x1 <- as.numeric(x)
> class(x1)
[1] "numeric"
> x2 <- as.logical(x)
> class(x2)
[1] "logical"
> x3 <- as.character(x)
> class(x3)
[1] "character"
```
Explicit Coercion __failures__ result in __NA__s.

```
> x <- c("a", "b", "c")
> class(x)
[1] "character"
> x1 <- as.numeric(x)
Warning message:
NAs introduced by coercion 
> x1
[1] NA NA NA
> class(x1)
[1] "numeric"
> x2 <- as.logical(x)
> x2
[1] NA NA NA
> class(x2)
[1] "logical"
> x3 <- as.complex(x)
Warning message:
NAs introduced by coercion 
> x3
[1] NA NA NA
> class(x3)
[1] "complex"
```
---
## <a id="specialValues">Special Values: `NA`, `NaN` & `Null`</a>

In statistical dataset often missing values are found. Those missing values in R are represented with a `NA` (Not Avalilable), `NaN` (Not a Number) or `NULL`.

- `NA` values are connected to the mode; integer `NA`, character `NA`, etc
- `NaN` is a `NA`but __`NA` is not a `NaN`__

Some basic examples

```
> ## NAs with different modes
> x <- c(1, NA)
> y <- c("a", NA)
> x;y
[1]  1 NA
[1] "a" NA 
> mode(x[2]);typeof(x[2])
[1] "numeric"
[1] "double"

> mode(y[2]); typeof(y[2])
[1] "character"
[1] "character"
```

```
> x <- c(1, 2, NaN, NA, 4)
> x
[1]   1   2 NaN  NA   4
> is.na(x)
[1] FALSE FALSE  TRUE  TRUE FALSE
> is.nan(x)
[1] FALSE FALSE  TRUE FALSE FALSE
```

### How to check for missing values

Command | Description
------------ | ---------
`is.na()` | Test if is `NA`.
`is.nan()` | Test if is `NaN`
`is.null()` | Tets if is `NULL`

```
> x <- c(1:3, NA, 4:7)
> x
[1]  1  2  3 NA  4  5  6  7
> is.na(x)
[1] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
```

```
> x <- c(1:3, NaN, 4:7)
> x
[1]   1   2   3 NaN   4   5   6   7
> is.nan(x)
[1] FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
```

```
> x <- NULL
> is.null(x)
[1] TRUE
> ##is.null() is not a vectorized function (be careful)
> x <- c(1,2,3,NULL)
> is.null(x)
[1] FALSE
```

Be carefulf if using `==` operator with `NA`

```
> x <- c(1:3, NA, 4:7)
> x == NA
[1] NA NA NA NA NA NA NA NA
```
### Managing `NA`s and `NULL`s values

#### Using `NA`s

Many of the statistical functions in R can be set to skip over `NA`s. __Remember__ `NaN` is a `NA`.

```
> x <- c(NA, 1,2,3, NaN)
> mean(x) ## By default uses all values so
[1] NA ## mean refused to calculate because of the missing values
> mean(x, na.rm = T) ## Instructed to remove missing values (`NA` and `NaN`)
[1] 2
```

#### Using `NULL`s
There is a big difference between `NA` and `NULL`. `NULL` is a psecial object with no __mode__ , `NULL` values are counted as non existent values.

```
> x <- NULL
> length(x)
[1] 0
> 
> y <- NA
> length(y)
[1] 1
``` 
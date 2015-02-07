# Vectors

[Creating Vectors](#cv)  
[Adding & Deleting Vector elements](#modVect)  
[Length of a Vector](#length)  
[Recycling](#recy)  
[Common Vector Operations](#vectOpe)  
[Use `all()` & `any()`](#allAny)    
[Vectorized Operations](#vectOps)

The fundamental data type in R is the __vector__.

Important topics:

- __recycling__, the automatic lengthening of vectors in certain setting
- __filtering__, the extraction of subsets of vectors
- __vectorization__, functions applied element-wise to vectors 

---

## <a id="cv">Creating vectors</a>
The size of a vector is determined at its creation through the number of elements or the `length` attribute.

Command | Description
------------ | ---------
`c()` | the __concatenate__ function to create vectors.
`vector()` | produce a vector of the given length and mode. Arguments: `mode`, a character string naming the mode - `numeric`, `logical`, `character`; `length`, an integer specifying the desired length.
`:` | the `:` operator can be used to create a vector from a range of number - e.g. `1:20`, `pi:10`.
`seq()` | Generate regular sequences. Relevant arguments `from`, `to`, `by`, `lenght.out` & `along.with`.
`rep()` | Replicate or repeat the provided vector. Arguments: `times`; `each`

Examples using the concatenate function, `c()`:
 
```
> x <- c(0.5, 0.6) ##numeric
> class(x); typeof(x)
[1] "numeric"
[1] "double"
> x <- c(TRUE, FALSE) ##logic
> x <- c("a", "b", "c") ##character
> x <- c(1, 2, 3)
> class(x); typeof(x)
[1] "numeric"
[1] "double"
```

Examples using the vector function, `vector()`:

```
> ##Using the vector() function
> x <- vector(mode = "numeric", length = 10)
> x ##default value is 0
 [1] 0 0 0 0 0 0 0 0 0 0
> x <- vector(mode = "logical", length = 10)
> x ##default value is FALSE
 [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
```
Examples using the `:` operator:

```
> ##Using the : operator to create
> x <- 1:5 #integer vector
> x
[1] 1 2 3 4 5
> class(x); typeof(x)
[1] "integer"
[1] "integer"
> 
> x <- pi:7 #numeric vector
> x
[1] 3.141593 4.141593 5.141593 6.141593
> class(x); typeof(x)
[1] "numeric"
[1] "double"
```

Example using `seq()` function:

```
>seq(0, 1, length.out = 11)
 [1] 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0

>seq(1, 9, by = 2)     # matches 'end'
[1] 1 3 5 7 9

>seq(1, 9, by = pi)    # stays below 'end'
[1] 1.000000 4.141593 7.283185

>seq(1, 6, by = 3)
[1] 1 4

>seq(1.575, 5.125, by = 0.05)
 [1] 1.575 1.625 1.675 1.725 1.775 1.825 1.875 1.925 1.975 2.025 2.075
[12] 2.125 2.175 2.225 2.275 2.325 2.375 2.425 2.475 2.525 2.575 2.625
[23] 2.675 2.725 2.775 2.825 2.875 2.925 2.975 3.025 3.075 3.125 3.175
[34] 3.225 3.275 3.325 3.375 3.425 3.475 3.525 3.575 3.625 3.675 3.725
[45] 3.775 3.825 3.875 3.925 3.975 4.025 4.075 4.125 4.175 4.225 4.275
[56] 4.325 4.375 4.425 4.475 4.525 4.575 4.625 4.675 4.725 4.775 4.825
[67] 4.875 4.925 4.975 5.025 5.075 5.125

>seq(17) # same as 1:17, or even better seq_len(17)
 [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17
 
##Note the mode associated to the elements
> x <- seq(1, 9, by = 2) #numeric mode
> class(x); typeof(x);
[1] "numeric"
[1] "double"
> 
> x <- seq(10) #integer mode
> class(x); typeof(x);
[1] "integer"
[1] "integer"
> 
> x <- seq(from = 1, to = 9) #integer mode
> class(x); typeof(x);
[1] "integer"
[1] "integer"
```

Examples using `rep()` function:

```
> ##Using rep() to create a new vector
> rep(1:4, times = 2)
[1] 1 2 3 4 1 2 3 4
> rep(1:4, each = 2)
[1] 1 1 2 2 3 3 4 4
> rep(1:4, each = 2, len = 4)    # first 4 only.
[1] 1 1 2 2
> rep(1:4, each = 2, len = 10)   # 8 integers plus two recycled 1's.
 [1] 1 1 2 2 3 3 4 4 1 1
> rep(1:4, each = 2, times = 3)  # length 24, 3 complete replications
 [1] 1 1 2 2 3 3 4 4 1 1 2 2 3 3 4 4 1 1 2 2 3 3 4 4
```

---

## <a id="modVect">Adding and Deleting Vector elements</a>
Based on the fact that the size of a vector is set at its creation, if you wish to add or delete elements from the vector you need to __reassign__ the vector.

```
> ##Adding elements to a vector
> x <- c(1,2,3,4,5)
> y <- c(x, 6,7,8) ##create a new vector from x adding new elements
> x; y
[1] 1 2 3 4 5
[1] 1 2 3 4 5 6 7 8
```


```
> ##Removing an element from the vector
> x <- c(1,2,3,4,5)
> y <- c(x[1:2], x[4:5]) ##Remove 4rd element
> x; y
[1] 1 2 3 4 5
[1] 1 2 4 5
```

---

## <a id="length">Length of a vector</a>

Command | Description
------------ | ---------
`length()` | return the number of elements in the vector.

The length of a vector is used for writing a general function code. For example

```
> first1 <- function(x){
+         for(i in 1:length(x)){
+                 if(x[i] == 1) break
+         }
+         return(i)
+ }
> first1(c(2,3,4,5,1))
[1] 5
```

__Be aware of the `length()` trap__ when dealing with an empty vector

```
> x <- c() ##an empty vector
> x ##content of x
NULL
> length(x) ##length of the empty vector
[1] 0
> 
> ##What does it happen if we create a vector using
> 1:length(x) ## Look at the content of the vector
[1] 1 0
```

```
> ##An approach when dealing with vector is to use seq()
> x <- c(1,2,3)
> for(i in seq(x)) print(i)
[1] 1
[1] 2
[1] 3
> 
> x <- c()
> for(i in seq(x)) print(i)
```

### Using `NULL` to build Vectors
```
> ##Using NULL to cbuild a vector
> x <- NULL
> for (i in 1:3) x <- c(x, i)
> x
[1] 1 2 3
```

---

## <a id="recy">Recycling</a>
When applying opeartions to vectors - if the vectors do nothave the same length than R automatically repeats the shortest vector until the have the same length.

__Example__

```
> ##Recycling
> c(1,2,3,4) + c(10,20)
[1] 11 22 13 24 ## recycling -> c(1,2,3,4) + c(10,20,10,20)
```

The shortest vector `c(10,20)` was recycled in order to have the same length. The actual vector used in the operation was `c(10,20,10,20)`

---

## <a id="vectOpe">Common Vector Operations</a>

### Vector Arithmetic and Logical Operations

Arithmetic operations are applied at the element level - if vectors have different lenghts __recycling__ is applied.

```
> ###Arithmetic Operations: element-based, 1st element with 1st element .. etc
> x <- c(10,20,30)
> y <- c(1,2,3)
> x + y 
[1] 11 22 33
> x * y
[1] 10 40 90
> x / y
[1] 10 10 10
```

### Vector Indexing or Subsetting
Indexing is used for creating a new vector based on specific elements of the original vector (by indices).

```
> x <- c(1,2,3,4,5,6,7,8,9,10,11,12,13)
> x[c(1,3,1,3)] #Vector of 4 elements, the 1st & 3rd, & the 1st & 3rd 
[1] 1 3 1 3

> x[2:3] #Vector of 2 elements, the 2nd & 3rd
[1] 2 3

> indices <- c(2:3) #Vector of 2 elements, the 2nd & 3rd
> x[indices]
[1] 2 3

> x[-1] #All except the 1st element
 [1]  2  3  4  5  6  7  8  9 10 11 12 13

> x[-length(x)] #All except the last
 [1]  1  2  3  4  5  6  7  8  9 10 11 12

> x[-c(1:10)] #All except the first 10 elements
[1] 11 12 13
```

---
## <a id="allAny">Using `all()` and `any()`</a>
ommand | Description
------------ | ---------
`all()` | Are all values true?.
`any()` | Is any value True?.

```
> ##all() & any()
> x <- 1:10
> any(x > 5)
[1] TRUE
> any(x > 88)
[1] FALSE
> 
> all(x > 10)
[1] FALSE
> all(x > 0)
[1] TRUE
```

__Note!__ Check out what's the outcome of `x > 5`

```
> x <- 1:10
> x > 5
 [1] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE
```
`any(x > 5)` just check if there is at least a `TRUE` in the logical vector `x > 5`. `all(x > 5)` check if all elements are `TRUE` in the logical vector `x > 5`. 

---

## <a id="vectOps">Vectorized Operations</a>
A __vectorized function/ operation__ is a function/ operation that is applied to each element of the vector.

Surprisingly most of the operators and functions in R are vectorized - e.g. `+`, `-`, `/`, `%`, `sqrt()`, etc ...

### Vector In, Vector Out: a view from a vectorized world

```
> ##1st example
> x <- 1:4 # Vector x
> y <- 2:5 # Vector y
> x > y 
[1] FALSE FALSE FALSE FALSE
> ## ">" is a vectorized function
> ## ">" is applied to: x[1] y[1], x[2] y[2], etc 
> ">"(x,y) ## Same as before
[1] FALSE FALSE FALSE FALSE

> ## Another example
> x
[1] 1 2 3 4
> sqrt(x) ## vectorized function - see how it is applied to each element
[1] 1.000000 1.414214 1.732051 2.000000
```

__Important__! If a R function uses vectorized oprations then the function is __vectorized__. 

```
> ##2nd example
> x <- 1:10
> x
 [1]  1  2  3  4  5  6  7  8  9 10
> incrementMe <- function(x){return(x + 1)}
> ## incrementMe uses just vectorized operations `+`
> incrementMe(x)
 [1]  2  3  4  5  6  7  8  9 10 11
> 
> ## "+" is vectorized? Verify it
> x <- 1:4 # Vector x
> y <- 2:5 # Vector y
> x + y
[1] 3 5 7 9
```

```
> ## Another example
> x <- 1:3
> c <- 1
> f <- function(x,c){return((x+c)^2)}
> f(x, c)
[1]  4  9 16
> ## When applying the function the following is happeneing behind teh scenes
> ## 1. recycling
> ##      c from 1 -> 1,1,1 (in order to have the same length as x)
> ##      2 from 2 -> 2,2,2 ((in order to have the same length as x and c)
> ## 2. vectorizing

> ## Another example
> x <- 1:3
> c <- 1:3
> e <- 1:3
> f <- function(x,c,e){return((x+c)^e)}
> f(x, c, e)
[1]   2  16 216
```

---



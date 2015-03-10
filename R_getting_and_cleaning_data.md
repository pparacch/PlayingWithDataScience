# Getting and Cleaning Data

## Motivation
TBD
## Raw Data vs. Processed Data
TBD
## The Components of Tidy Data
TBD

## Getting the Raw Data
### Downloading files
TBD
### Reading local flat files
TBD
### Reading Excel files
TBD
### Reading XML
TBD
### Reading JSON
TBD
### Using __data.table__
TBD
### Reading mySQL
TBD
### Reading HDF5
TBD
### Reading data from the web
TBD
### Reading data from APIs
TBD
### Reading from other sources
TBD

## Subsetting
Often you want to look at subsets of a dataset.

Given X, a dataframe with 3 variables ("var1", "var2", "var3") and 5 observations

	> X
  		var1 var2 var3
	1    2   NA   15
	4    1   10   11
	2    3   NA   12
	3    5    6   14
	5    4    9   13

### Subsetting - quick review
|Command | Description|
|--------|------------|
|`X[,1]`|Extract the first column (by index). Return a vector.|
|`X[,"var1"]`|Extract the first column (by column name). Return a vector.|
|`X[c(1:2),"var2"]`|Extract the first two rows (by index) of the second column (by column name). Return a vector.|
|`X[X$var1 > 3,]`|Extract all the rows where (X$var1 > 3) of dataframe. Return a dataframe. __Note! By default NA values are returned.__|
|`X[(X$var1 <= 3 & X$var3 > 11),]`|Extract all the rows where (X$var1 <= 3 & X$var3 > 11) of dataframe. Return a dataframe. __Note! By default NA values are returned.__|
|`X[(X$var1 <= 3 &#124; X$var3 > 11),]`|Extract all the rows where (X$var1 <= 3 &#124; X$var3 > 11) of dataframe. Return a dataframe. __Note! By default NA values are returned.__|

When subsetting using logical conditions if you want to deal with missing values use `which()`. `which` - NAs are allowed in the dataset but NAs are omitted from the subset.

	> X[which(X$var2 <= 20),]
  		var1 var2 var3
	4    1   10   11
	3    5    6   14
	5    4    9   13


	> X[X$var2 <= 20,] #compare to the previous result
     	var1 var2 var3
	NA     NA   NA   NA (*)
	4       1   10   11
	NA.1   NA   NA   NA (*)
	3       5    6   14
	5       4    9   13

### Sorting

### Ordering
### Adding Rows & Columns
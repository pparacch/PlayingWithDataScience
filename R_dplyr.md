# Data Frame Management using dplyr
ppar  
28 Oct 2015  

#A grammar for data manipulation
The **dplyr** package is an important tool for dealing and managing data frames. It does not provide any news functionality to R, everything that can be done with **dplyr** can be done with base R but **dplyr** does **greatly simplify** existing functionality in R.

The **dplyr** package provides a "vocabulary"/ "grammar" used for data manipulation and for operating on data frames. And **dplyr** functions are faster and more performant than base R.

##The **vocabulary**/ **grammar**: the basic elements

* [`select`](#sel)
* [`filter`](#fil) (`slice`)
* [`arrange`](#arr)
* [`rename`](#ren)
* [`mutate`](#mut)
* [`group_by`](#gro)
* [`summarize`](#gro)
* [`%>%`](#pip)

##Installing the **dplyr** package

```r
install.packages("dplyr")
```

##Loading the **dplyr** package & the data

```r
library(dplyr)
```

```r
packageVersion("dplyr")
## [1] '0.4.3'
```

Loading the data used for the code chunks.

```r
rawData <- read.csv("./data/stormData.csv", stringsAsFactors = FALSE)
str(rawData)
## 'data.frame':	107168 obs. of  37 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000 ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : chr  "AL" "AL" "AL" "AL" ...
##  $ EVTYPE    : chr  "TORNADO" "TORNADO" "TORNADO" "TORNADO" ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : logi  NA NA NA NA NA NA ...
##  $ BGN_LOCATI: logi  NA NA NA NA NA NA ...
##  $ END_DATE  : logi  NA NA NA NA NA NA ...
##  $ END_TIME  : logi  NA NA NA NA NA NA ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : logi  NA NA NA NA NA NA ...
##  $ END_LOCATI: logi  NA NA NA NA NA NA ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: chr  "K" "K" "K" "K" ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: logi  NA NA NA NA NA NA ...
##  $ WFO       : chr  "" "" "" "" ...
##  $ STATEOFFIC: logi  NA NA NA NA NA NA ...
##  $ ZONENAMES : logi  NA NA NA NA NA NA ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : logi  NA NA NA NA NA NA ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
```

Preparing the data - specifically extracting the `BGN_DATE` (begin date) in order to transform it to a `Date` format, and adding a `TMP_BGN_YEAR` variable.


```r
#BGN_DATE seems to have the following format
#d(max 2)/d(max2)/d(4) 0:00:00

#Verify that it is a correct assumption -> assumption evaluation should be TRUE
all(grepl("^\\d{1,2}\\/\\d{1,2}\\/\\d{4}\\s0:00:00$", rawData$BGN_DATE))
## [1] TRUE

#Create a new col (temp feature): TMP_BGN_DATE
rawData$TMP_BGN_DATE <- gsub("\\s0:00:00$", "", rawData$BGN_DATE)
head(rawData[,c("BGN_DATE", "TMP_BGN_DATE")])
##             BGN_DATE TMP_BGN_DATE
## 1  4/18/1950 0:00:00    4/18/1950
## 2  4/18/1950 0:00:00    4/18/1950
## 3  2/20/1951 0:00:00    2/20/1951
## 4   6/8/1951 0:00:00     6/8/1951
## 5 11/15/1951 0:00:00   11/15/1951
## 6 11/15/1951 0:00:00   11/15/1951
tail(rawData[,c("BGN_DATE", "TMP_BGN_DATE")])
##                 BGN_DATE TMP_BGN_DATE
## 107163 5/29/1967 0:00:00    5/29/1967
## 107164 6/25/1967 0:00:00    6/25/1967
## 107165 6/25/1967 0:00:00    6/25/1967
## 107166 7/11/1967 0:00:00    7/11/1967
## 107167 7/14/1967 0:00:00    7/14/1967
## 107168 7/16/1967 0:00:00    7/16/1967

#Transform TMP_BGN_DATE (character) to (Date)
rawData$TMP_BGN_DATE <- as.Date(rawData$TMP_BGN_DATE, format = "%m/%d/%Y")
head(rawData[,c("BGN_DATE", "TMP_BGN_DATE")])
##             BGN_DATE TMP_BGN_DATE
## 1  4/18/1950 0:00:00   1950-04-18
## 2  4/18/1950 0:00:00   1950-04-18
## 3  2/20/1951 0:00:00   1951-02-20
## 4   6/8/1951 0:00:00   1951-06-08
## 5 11/15/1951 0:00:00   1951-11-15
## 6 11/15/1951 0:00:00   1951-11-15
tail(rawData[,c("BGN_DATE", "TMP_BGN_DATE")])
##                 BGN_DATE TMP_BGN_DATE
## 107163 5/29/1967 0:00:00   1967-05-29
## 107164 6/25/1967 0:00:00   1967-06-25
## 107165 6/25/1967 0:00:00   1967-06-25
## 107166 7/11/1967 0:00:00   1967-07-11
## 107167 7/14/1967 0:00:00   1967-07-14
## 107168 7/16/1967 0:00:00   1967-07-16
summary(rawData$TMP_BGN_DATE)
##         Min.      1st Qu.       Median         Mean      3rd Qu. 
## "1950-01-03" "1972-04-21" "1982-04-16" "1979-04-22" "1988-05-10" 
##         Max. 
## "1992-12-30"

#Adding a TMP_BGN_YEAR variable
rawData$TMP_BGN_YEAR <- as.POSIXlt(rawData$TMP_BGN_DATE)$year + 1900
summary(rawData$TMP_BGN_YEAR)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1950    1972    1982    1979    1988    1992
```

##<a id="sel">`select`verb</a>
The `select` function is used to select the columns of a data frame that you want to focus on.

###Select cols by col numbers  

```r
#Select only the following columns 
#STATE__(1), BGN_DATE(2), BGN_TIME(3), TIME_ZONE(4), 
#COUNTY(5), COUNTYNAME(6), STATE(7), EVTYPE(8)

#Provide the column numbers
rawData.s <- select(rawData, 1:8)
str(rawData.s)
## 'data.frame':	107168 obs. of  8 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000 ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : chr  "AL" "AL" "AL" "AL" ...
##  $ EVTYPE    : chr  "TORNADO" "TORNADO" "TORNADO" "TORNADO" ...
```

An alternative way...

```r
#Select only the following columns 
#BGN_DATE(2), BGN_TIME(3), TIME_ZONE(4), 
#COUNTYNAME(6), STATE(7), EVTYPE(8)

#Provide the column numbers
rawData.s <- select(rawData, c(2,3,4,6,7,8))
str(rawData.s)
## 'data.frame':	107168 obs. of  6 variables:
##  $ BGN_DATE  : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000 ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : chr  "AL" "AL" "AL" "AL" ...
##  $ EVTYPE    : chr  "TORNADO" "TORNADO" "TORNADO" "TORNADO" ...
```

###Select cols by col names  

```r
#Select only the following columns 
#STATE__(1), BGN_DATE(2), BGN_TIME(3), TIME_ZONE(4), 
#COUNTY(5), COUNTYNAME(6), STATE(7), EVTYPE(8)

#Provide the column names
rawData.s <- select(rawData, STATE__:EVTYPE)
str(rawData.s)
## 'data.frame':	107168 obs. of  8 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000 ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : chr  "AL" "AL" "AL" "AL" ...
##  $ EVTYPE    : chr  "TORNADO" "TORNADO" "TORNADO" "TORNADO" ...
```

An alternative way...

```r
#Select only the following columns 
#STATE__(1), BGN_DATE(2) 
#EVTYPE(8)

#Provide the column names
rawData.s <- select(rawData, c(STATE__, BGN_DATE, EVTYPE))
str(rawData.s)
## 'data.frame':	107168 obs. of  3 variables:
##  $ STATE__ : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE: chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ EVTYPE  : chr  "TORNADO" "TORNADO" "TORNADO" "TORNADO" ...
```

An alternative way...

```r
#Remove the following columns 
#STATE__(1), BGN_DATE(2) 
#EVTYPE(8)

#Provide the column names or column numbers
#-(minus) is used to tell to remove a specific element
rawData.s <- select(rawData, c(-STATE__, -BGN_DATE, -EVTYPE))
str(rawData.s)
## 'data.frame':	107168 obs. of  36 variables:
##  $ BGN_TIME    : int  130 145 1600 900 1500 2000 100 900 2000 2000 ...
##  $ TIME_ZONE   : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY      : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME  : chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE       : chr  "AL" "AL" "AL" "AL" ...
##  $ BGN_RANGE   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI     : logi  NA NA NA NA NA NA ...
##  $ BGN_LOCATI  : logi  NA NA NA NA NA NA ...
##  $ END_DATE    : logi  NA NA NA NA NA NA ...
##  $ END_TIME    : logi  NA NA NA NA NA NA ...
##  $ COUNTY_END  : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN  : logi  NA NA NA NA NA NA ...
##  $ END_RANGE   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI     : logi  NA NA NA NA NA NA ...
##  $ END_LOCATI  : logi  NA NA NA NA NA NA ...
##  $ LENGTH      : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH       : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F           : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG         : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES  : num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES    : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG     : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP  : chr  "K" "K" "K" "K" ...
##  $ CROPDMG     : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP  : logi  NA NA NA NA NA NA ...
##  $ WFO         : chr  "" "" "" "" ...
##  $ STATEOFFIC  : logi  NA NA NA NA NA NA ...
##  $ ZONENAMES   : logi  NA NA NA NA NA NA ...
##  $ LATITUDE    : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE   : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E  : num  3051 0 0 0 0 ...
##  $ LONGITUDE_  : num  8806 0 0 0 0 ...
##  $ REMARKS     : logi  NA NA NA NA NA NA ...
##  $ REFNUM      : num  1 2 3 4 5 6 7 8 9 10 ...
##  $ TMP_BGN_DATE: Date, format: "1950-04-18" "1950-04-18" ...
##  $ TMP_BGN_YEAR: num  1950 1950 1951 1951 1951 ...
```

###Select cols whose col names start with  

```r
#Select the columns whose names start with "BGN")

#starts_with is a special function
rawData.s <- select(rawData, starts_with("BGN"))
str(rawData.s)
## 'data.frame':	107168 obs. of  5 variables:
##  $ BGN_DATE  : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ BGN_TIME  : int  130 145 1600 900 1500 2000 100 900 2000 2000 ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : logi  NA NA NA NA NA NA ...
##  $ BGN_LOCATI: logi  NA NA NA NA NA NA ...
```

###Select cols whose col names end with  

```r
#Select the columns whose names end with "DATE")

#ends_with is a special function
rawData.s <- select(rawData, ends_with("DATE"))
str(rawData.s)
## 'data.frame':	107168 obs. of  3 variables:
##  $ BGN_DATE    : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ END_DATE    : logi  NA NA NA NA NA NA ...
##  $ TMP_BGN_DATE: Date, format: "1950-04-18" "1950-04-18" ...
```

##<a id="fil">`filter`verb</a>
The `filter` function is used to extract a subset of rows from a data frame based on a specific logic condition.

A simple filtering ....

```r
#Unique EVTYPE values
unique(rawData$EVTYPE)
## [1] "TORNADO"   "TSTM WIND" "HAIL"

#Original dimension raw dataset
dim(rawData)
## [1] 107168     39

#Getting all of the observation connecte with a "TORNADO" EVTYPE
rawData.f <- filter(rawData, EVTYPE == "TORNADO")

#Unique EVTYPE values
unique(rawData.f$EVTYPE)
## [1] "TORNADO"

#Dimension filtered dataset
dim(rawData.f)
## [1] 20851    39
```

A more complex filtering ....

```r
#Unique EVTYPE values
unique(rawData$EVTYPE)
## [1] "TORNADO"   "TSTM WIND" "HAIL"

#Unique COUNTYNAME values (first 10 ...)
unique(rawData$COUNTYNAME)[1:10]
##  [1] "MOBILE"     "BALDWIN"    "FAYETTE"    "MADISON"    "CULLMAN"   
##  [6] "LAUDERDALE" "BLOUNT"     "TALLAPOOSA" "TUSCALOOSA" "JEFFERSON"

#Original dimension raw dataset
dim(rawData)
## [1] 107168     39

#Getting all of the observation connecte with a "TORNADO" EVTYPE and "MOBILE" COUNTYNAME
rawData.f <- filter(rawData, EVTYPE == "TORNADO" & COUNTYNAME == "MOBILE")

#Unique EVTYPE values
unique(rawData.f$EVTYPE)
## [1] "TORNADO"

#Unique COUNTYNAME values
unique(rawData.f$COUNTYNAME)
## [1] "MOBILE"

#Dimension filtered dataset
dim(rawData.f)
## [1] 50 39
```

##<a id="arr">`arrange`verb</a>
The `arrange` function is used to reorder rows of a data frame according to one of the col/ feature, preserving observations.


```r
head(rawData$TMP_BGN_DATE, 10)
##  [1] "1950-04-18" "1950-04-18" "1951-02-20" "1951-06-08" "1951-11-15"
##  [6] "1951-11-15" "1951-11-16" "1952-01-22" "1952-02-13" "1952-02-13"

tail(rawData$TMP_BGN_DATE, 10)
##  [1] "1967-05-20" "1967-05-20" "1967-05-20" "1967-05-29" "1967-05-29"
##  [6] "1967-06-25" "1967-06-25" "1967-07-11" "1967-07-14" "1967-07-16"
```
###Order ascending
Order the observations by `TMP_BGN_DATE` in ascending order (default).

```r
rawData.order.asc.by.TMP_BNG_DATE <- arrange(rawData, TMP_BGN_DATE)
```
Verify that observations have been actually ordered as expected.

```r
head(rawData.order.asc.by.TMP_BNG_DATE$TMP_BGN_DATE, 10)
##  [1] "1950-01-03" "1950-01-03" "1950-01-03" "1950-01-13" "1950-01-25"
##  [6] "1950-01-25" "1950-02-12" "1950-02-12" "1950-02-12" "1950-02-12"

tail(rawData.order.asc.by.TMP_BNG_DATE$TMP_BGN_DATE, 10)
##  [1] "1992-12-15" "1992-12-15" "1992-12-15" "1992-12-15" "1992-12-15"
##  [6] "1992-12-17" "1992-12-17" "1992-12-17" "1992-12-29" "1992-12-30"
```
###Order descending
Order the observations by `TMP_BGN_DATE` in descending order.

```r
rawData.order.desc.by.TMP_BNG_DATE <- arrange(rawData, desc(TMP_BGN_DATE))
```
Verify that observations have been actually ordered as expected.

```r
head(rawData.order.desc.by.TMP_BNG_DATE$TMP_BGN_DATE, 10)
##  [1] "1992-12-30" "1992-12-29" "1992-12-17" "1992-12-17" "1992-12-17"
##  [6] "1992-12-15" "1992-12-15" "1992-12-15" "1992-12-15" "1992-12-15"

tail(rawData.order.desc.by.TMP_BNG_DATE$TMP_BGN_DATE, 10)
##  [1] "1950-02-12" "1950-02-12" "1950-02-12" "1950-02-12" "1950-01-25"
##  [6] "1950-01-25" "1950-01-13" "1950-01-03" "1950-01-03" "1950-01-03"
```
##<a id="ren">`rename`verb</a>
The `rename` function is used to rename a variable in a data frame.


```r
#print out the names of the variables (cols)
names(rawData)[1:5]
## [1] "STATE__"   "BGN_DATE"  "BGN_TIME"  "TIME_ZONE" "COUNTY"
```


```r
rawData.r <- rename(rawData, STATE_ID = STATE__, BEGIN_DATE = BGN_DATE, BEGIN_TIME = BGN_TIME)
```


```r
#print out the names of the variables (cols)
names(rawData.r)[1:5]
## [1] "STATE_ID"   "BEGIN_DATE" "BEGIN_TIME" "TIME_ZONE"  "COUNTY"
```

##<a id="mut">`mutate`verb</a>
The `mutate` function is used to compute transformation of variables in a data frame. In other words to create new variables that are derived from existing variables.

Adding a new variable `TOTAL_VICTIMS` as the sum of `FATALITIES`and `INJURIES`.


```r
#print out the names of the variables (cols)
#check that TOTAL_VICTIMS does not exist.
names(rawData)
##  [1] "STATE__"      "BGN_DATE"     "BGN_TIME"     "TIME_ZONE"   
##  [5] "COUNTY"       "COUNTYNAME"   "STATE"        "EVTYPE"      
##  [9] "BGN_RANGE"    "BGN_AZI"      "BGN_LOCATI"   "END_DATE"    
## [13] "END_TIME"     "COUNTY_END"   "COUNTYENDN"   "END_RANGE"   
## [17] "END_AZI"      "END_LOCATI"   "LENGTH"       "WIDTH"       
## [21] "F"            "MAG"          "FATALITIES"   "INJURIES"    
## [25] "PROPDMG"      "PROPDMGEXP"   "CROPDMG"      "CROPDMGEXP"  
## [29] "WFO"          "STATEOFFIC"   "ZONENAMES"    "LATITUDE"    
## [33] "LONGITUDE"    "LATITUDE_E"   "LONGITUDE_"   "REMARKS"     
## [37] "REFNUM"       "TMP_BGN_DATE" "TMP_BGN_YEAR"
```


```r
rawData <- mutate(rawData, TOTAL_VICTIMS = FATALITIES + INJURIES)
```


```r
#print out some of the data
head(rawData[,c("FATALITIES", "INJURIES", "TOTAL_VICTIMS")], 10)
##    FATALITIES INJURIES TOTAL_VICTIMS
## 1           0       15            15
## 2           0        0             0
## 3           0        2             2
## 4           0        2             2
## 5           0        2             2
## 6           0        6             6
## 7           0        1             1
## 8           0        0             0
## 9           1       14            15
## 10          0        0             0
```

##<a id="gro">`group_by`verb</a>
The `group_by` function is used to generate summary statistics from the data frame within strata defined by a variable.


```r
rawData.group.by.TMP_BGN_YEAR <- group_by(rawData, TMP_BGN_YEAR)
#Note the object implementing the returned objected implemented group_by 
typeof(rawData.group.by.TMP_BGN_YEAR)
## [1] "list"
```

Then the `summarize` function is used to perform some statistical computation on the data structur (`list`) created by `group_by`.

```r
summarize(rawData.group.by.TMP_BGN_YEAR, 
          HEALTH_COST = mean(TOTAL_VICTIMS, na.rm = TRUE))
```

```
## Source: local data frame [43 x 2]
## 
##    TMP_BGN_YEAR HEALTH_COST
##           (dbl)       (dbl)
## 1          1950   3.2500000
## 2          1951   2.0714286
## 3          1952   7.6228571
## 4          1953  12.8286604
## 5          1954   1.2789474
## 6          1955   0.7144593
## 7          1956   1.0272727
## 8          1957   1.1055556
## 9          1958   0.2300275
## 10         1959   0.5348214
## ..          ...         ...
```

##<a id="pip">`%>%`: the pipeline operator</a>
The **pipeline operator** allows to combine together multiple `dplyr` functions in a sequence

`first(data) %>% second %>% third`

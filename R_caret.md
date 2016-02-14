# Caret Package
Pier Lorenzo Paracchini  
February 9, 2016  

The `caret` package is a set of functions that attemt to streamline the process of creating predictive models. It includes functions to:

* preprocess the data
* split the data
* train models (fit) and test nodels
* comparison of models

`caret` acts as a **wrapper** around other packages used for predictive models.

##Packages, Installations (with Dependencies)


```r
#The caret package
install.packages("caret", dependencies = c("Depends", "Suggests"))

#Binning Support
install.packages("Hmisc")

#Multiple plots in same grid
install.packages("gridExtra")

#Data
install.packages("ISLR")
install.packages("AppliedPredictiveModeling")
install.packages("kernlab")
```




##The datasets  
The `ISLR::Wage` dataset:  

```
## 'data.frame':	3000 obs. of  12 variables:
##  $ year      : int  2006 2004 2003 2003 2005 2008 2009 2008 2006 2004 ...
##  $ age       : int  18 24 45 43 50 54 44 30 41 52 ...
##  $ sex       : Factor w/ 2 levels "1. Male","2. Female": 1 1 1 1 1 1 1 1 1 1 ...
##  $ maritl    : Factor w/ 5 levels "1. Never Married",..: 1 1 2 2 4 2 2 1 1 2 ...
##  $ race      : Factor w/ 4 levels "1. White","2. Black",..: 1 1 1 3 1 1 4 3 2 1 ...
##  $ education : Factor w/ 5 levels "1. < HS Grad",..: 1 4 3 4 2 4 3 3 3 2 ...
##  $ region    : Factor w/ 9 levels "1. New England",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ jobclass  : Factor w/ 2 levels "1. Industrial",..: 1 2 1 2 2 2 1 2 2 2 ...
##  $ health    : Factor w/ 2 levels "1. <=Good","2. >=Very Good": 1 2 1 2 1 2 2 1 2 2 ...
##  $ health_ins: Factor w/ 2 levels "1. Yes","2. No": 2 2 1 1 1 1 1 1 1 1 ...
##  $ logwage   : num  4.32 4.26 4.88 5.04 4.32 ...
##  $ wage      : num  75 70.5 131 154.7 75 ...
```

```
##       year           age               sex                    maritl    
##  Min.   :2003   Min.   :18.00   1. Male  :3000   1. Never Married: 648  
##  1st Qu.:2004   1st Qu.:33.75   2. Female:   0   2. Married      :2074  
##  Median :2006   Median :42.00                    3. Widowed      :  19  
##  Mean   :2006   Mean   :42.41                    4. Divorced     : 204  
##  3rd Qu.:2008   3rd Qu.:51.00                    5. Separated    :  55  
##  Max.   :2009   Max.   :80.00                                           
##                                                                         
##        race                   education                     region    
##  1. White:2480   1. < HS Grad      :268   2. Middle Atlantic   :3000  
##  2. Black: 293   2. HS Grad        :971   1. New England       :   0  
##  3. Asian: 190   3. Some College   :650   3. East North Central:   0  
##  4. Other:  37   4. College Grad   :685   4. West North Central:   0  
##                  5. Advanced Degree:426   5. South Atlantic    :   0  
##                                           6. East South Central:   0  
##                                           (Other)              :   0  
##            jobclass               health      health_ins      logwage     
##  1. Industrial :1544   1. <=Good     : 858   1. Yes:2083   Min.   :3.000  
##  2. Information:1456   2. >=Very Good:2142   2. No : 917   1st Qu.:4.447  
##                                                            Median :4.653  
##                                                            Mean   :4.654  
##                                                            3rd Qu.:4.857  
##                                                            Max.   :5.763  
##                                                                           
##       wage       
##  Min.   : 20.09  
##  1st Qu.: 85.38  
##  Median :104.92  
##  Mean   :111.70  
##  3rd Qu.:128.68  
##  Max.   :318.34  
## 
```

The `iris` dataset:  

```
## 'data.frame':	150 obs. of  5 variables:
##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
##  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
```

```
##   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
##  Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
##  1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
##  Median :5.800   Median :3.000   Median :4.350   Median :1.300  
##  Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
##  3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
##  Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
##        Species  
##  setosa    :50  
##  versicolor:50  
##  virginica :50  
##                 
##                 
## 
```

The `spam` dataset:  

```
## 'data.frame':	4601 obs. of  58 variables:
##  $ make             : num  0 0.21 0.06 0 0 0 0 0 0.15 0.06 ...
##  $ address          : num  0.64 0.28 0 0 0 0 0 0 0 0.12 ...
##  $ all              : num  0.64 0.5 0.71 0 0 0 0 0 0.46 0.77 ...
##  $ num3d            : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ our              : num  0.32 0.14 1.23 0.63 0.63 1.85 1.92 1.88 0.61 0.19 ...
##  $ over             : num  0 0.28 0.19 0 0 0 0 0 0 0.32 ...
##  $ remove           : num  0 0.21 0.19 0.31 0.31 0 0 0 0.3 0.38 ...
##  $ internet         : num  0 0.07 0.12 0.63 0.63 1.85 0 1.88 0 0 ...
##  $ order            : num  0 0 0.64 0.31 0.31 0 0 0 0.92 0.06 ...
##  $ mail             : num  0 0.94 0.25 0.63 0.63 0 0.64 0 0.76 0 ...
##  $ receive          : num  0 0.21 0.38 0.31 0.31 0 0.96 0 0.76 0 ...
##  $ will             : num  0.64 0.79 0.45 0.31 0.31 0 1.28 0 0.92 0.64 ...
##  $ people           : num  0 0.65 0.12 0.31 0.31 0 0 0 0 0.25 ...
##  $ report           : num  0 0.21 0 0 0 0 0 0 0 0 ...
##  $ addresses        : num  0 0.14 1.75 0 0 0 0 0 0 0.12 ...
##  $ free             : num  0.32 0.14 0.06 0.31 0.31 0 0.96 0 0 0 ...
##  $ business         : num  0 0.07 0.06 0 0 0 0 0 0 0 ...
##  $ email            : num  1.29 0.28 1.03 0 0 0 0.32 0 0.15 0.12 ...
##  $ you              : num  1.93 3.47 1.36 3.18 3.18 0 3.85 0 1.23 1.67 ...
##  $ credit           : num  0 0 0.32 0 0 0 0 0 3.53 0.06 ...
##  $ your             : num  0.96 1.59 0.51 0.31 0.31 0 0.64 0 2 0.71 ...
##  $ font             : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ num000           : num  0 0.43 1.16 0 0 0 0 0 0 0.19 ...
##  $ money            : num  0 0.43 0.06 0 0 0 0 0 0.15 0 ...
##  $ hp               : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ hpl              : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ george           : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ num650           : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ lab              : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ labs             : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ telnet           : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ num857           : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ data             : num  0 0 0 0 0 0 0 0 0.15 0 ...
##  $ num415           : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ num85            : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ technology       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ num1999          : num  0 0.07 0 0 0 0 0 0 0 0 ...
##  $ parts            : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ pm               : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ direct           : num  0 0 0.06 0 0 0 0 0 0 0 ...
##  $ cs               : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ meeting          : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ original         : num  0 0 0.12 0 0 0 0 0 0.3 0 ...
##  $ project          : num  0 0 0 0 0 0 0 0 0 0.06 ...
##  $ re               : num  0 0 0.06 0 0 0 0 0 0 0 ...
##  $ edu              : num  0 0 0.06 0 0 0 0 0 0 0 ...
##  $ table            : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ conference       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ charSemicolon    : num  0 0 0.01 0 0 0 0 0 0 0.04 ...
##  $ charRoundbracket : num  0 0.132 0.143 0.137 0.135 0.223 0.054 0.206 0.271 0.03 ...
##  $ charSquarebracket: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ charExclamation  : num  0.778 0.372 0.276 0.137 0.135 0 0.164 0 0.181 0.244 ...
##  $ charDollar       : num  0 0.18 0.184 0 0 0 0.054 0 0.203 0.081 ...
##  $ charHash         : num  0 0.048 0.01 0 0 0 0 0 0.022 0 ...
##  $ capitalAve       : num  3.76 5.11 9.82 3.54 3.54 ...
##  $ capitalLong      : num  61 101 485 40 40 15 4 11 445 43 ...
##  $ capitalTotal     : num  278 1028 2259 191 191 ...
##  $ type             : Factor w/ 2 levels "nonspam","spam": 2 2 2 2 2 2 2 2 2 2 ...
```

```
##       make           address            all             num3d         
##  Min.   :0.0000   Min.   : 0.000   Min.   :0.0000   Min.   : 0.00000  
##  1st Qu.:0.0000   1st Qu.: 0.000   1st Qu.:0.0000   1st Qu.: 0.00000  
##  Median :0.0000   Median : 0.000   Median :0.0000   Median : 0.00000  
##  Mean   :0.1046   Mean   : 0.213   Mean   :0.2807   Mean   : 0.06542  
##  3rd Qu.:0.0000   3rd Qu.: 0.000   3rd Qu.:0.4200   3rd Qu.: 0.00000  
##  Max.   :4.5400   Max.   :14.280   Max.   :5.1000   Max.   :42.81000  
##       our               over            remove          internet      
##  Min.   : 0.0000   Min.   :0.0000   Min.   :0.0000   Min.   : 0.0000  
##  1st Qu.: 0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.: 0.0000  
##  Median : 0.0000   Median :0.0000   Median :0.0000   Median : 0.0000  
##  Mean   : 0.3122   Mean   :0.0959   Mean   :0.1142   Mean   : 0.1053  
##  3rd Qu.: 0.3800   3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.: 0.0000  
##  Max.   :10.0000   Max.   :5.8800   Max.   :7.2700   Max.   :11.1100  
##      order              mail            receive             will       
##  Min.   :0.00000   Min.   : 0.0000   Min.   :0.00000   Min.   :0.0000  
##  1st Qu.:0.00000   1st Qu.: 0.0000   1st Qu.:0.00000   1st Qu.:0.0000  
##  Median :0.00000   Median : 0.0000   Median :0.00000   Median :0.1000  
##  Mean   :0.09007   Mean   : 0.2394   Mean   :0.05982   Mean   :0.5417  
##  3rd Qu.:0.00000   3rd Qu.: 0.1600   3rd Qu.:0.00000   3rd Qu.:0.8000  
##  Max.   :5.26000   Max.   :18.1800   Max.   :2.61000   Max.   :9.6700  
##      people            report           addresses           free        
##  Min.   :0.00000   Min.   : 0.00000   Min.   :0.0000   Min.   : 0.0000  
##  1st Qu.:0.00000   1st Qu.: 0.00000   1st Qu.:0.0000   1st Qu.: 0.0000  
##  Median :0.00000   Median : 0.00000   Median :0.0000   Median : 0.0000  
##  Mean   :0.09393   Mean   : 0.05863   Mean   :0.0492   Mean   : 0.2488  
##  3rd Qu.:0.00000   3rd Qu.: 0.00000   3rd Qu.:0.0000   3rd Qu.: 0.1000  
##  Max.   :5.55000   Max.   :10.00000   Max.   :4.4100   Max.   :20.0000  
##     business          email             you             credit        
##  Min.   :0.0000   Min.   :0.0000   Min.   : 0.000   Min.   : 0.00000  
##  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.: 0.000   1st Qu.: 0.00000  
##  Median :0.0000   Median :0.0000   Median : 1.310   Median : 0.00000  
##  Mean   :0.1426   Mean   :0.1847   Mean   : 1.662   Mean   : 0.08558  
##  3rd Qu.:0.0000   3rd Qu.:0.0000   3rd Qu.: 2.640   3rd Qu.: 0.00000  
##  Max.   :7.1400   Max.   :9.0900   Max.   :18.750   Max.   :18.18000  
##       your              font             num000           money         
##  Min.   : 0.0000   Min.   : 0.0000   Min.   :0.0000   Min.   : 0.00000  
##  1st Qu.: 0.0000   1st Qu.: 0.0000   1st Qu.:0.0000   1st Qu.: 0.00000  
##  Median : 0.2200   Median : 0.0000   Median :0.0000   Median : 0.00000  
##  Mean   : 0.8098   Mean   : 0.1212   Mean   :0.1016   Mean   : 0.09427  
##  3rd Qu.: 1.2700   3rd Qu.: 0.0000   3rd Qu.:0.0000   3rd Qu.: 0.00000  
##  Max.   :11.1100   Max.   :17.1000   Max.   :5.4500   Max.   :12.50000  
##        hp               hpl              george            num650      
##  Min.   : 0.0000   Min.   : 0.0000   Min.   : 0.0000   Min.   :0.0000  
##  1st Qu.: 0.0000   1st Qu.: 0.0000   1st Qu.: 0.0000   1st Qu.:0.0000  
##  Median : 0.0000   Median : 0.0000   Median : 0.0000   Median :0.0000  
##  Mean   : 0.5495   Mean   : 0.2654   Mean   : 0.7673   Mean   :0.1248  
##  3rd Qu.: 0.0000   3rd Qu.: 0.0000   3rd Qu.: 0.0000   3rd Qu.:0.0000  
##  Max.   :20.8300   Max.   :16.6600   Max.   :33.3300   Max.   :9.0900  
##       lab                labs            telnet             num857       
##  Min.   : 0.00000   Min.   :0.0000   Min.   : 0.00000   Min.   :0.00000  
##  1st Qu.: 0.00000   1st Qu.:0.0000   1st Qu.: 0.00000   1st Qu.:0.00000  
##  Median : 0.00000   Median :0.0000   Median : 0.00000   Median :0.00000  
##  Mean   : 0.09892   Mean   :0.1029   Mean   : 0.06475   Mean   :0.04705  
##  3rd Qu.: 0.00000   3rd Qu.:0.0000   3rd Qu.: 0.00000   3rd Qu.:0.00000  
##  Max.   :14.28000   Max.   :5.8800   Max.   :12.50000   Max.   :4.76000  
##       data              num415            num85           technology     
##  Min.   : 0.00000   Min.   :0.00000   Min.   : 0.0000   Min.   :0.00000  
##  1st Qu.: 0.00000   1st Qu.:0.00000   1st Qu.: 0.0000   1st Qu.:0.00000  
##  Median : 0.00000   Median :0.00000   Median : 0.0000   Median :0.00000  
##  Mean   : 0.09723   Mean   :0.04784   Mean   : 0.1054   Mean   :0.09748  
##  3rd Qu.: 0.00000   3rd Qu.:0.00000   3rd Qu.: 0.0000   3rd Qu.:0.00000  
##  Max.   :18.18000   Max.   :4.76000   Max.   :20.0000   Max.   :7.69000  
##     num1999          parts              pm               direct       
##  Min.   :0.000   Min.   :0.0000   Min.   : 0.00000   Min.   :0.00000  
##  1st Qu.:0.000   1st Qu.:0.0000   1st Qu.: 0.00000   1st Qu.:0.00000  
##  Median :0.000   Median :0.0000   Median : 0.00000   Median :0.00000  
##  Mean   :0.137   Mean   :0.0132   Mean   : 0.07863   Mean   :0.06483  
##  3rd Qu.:0.000   3rd Qu.:0.0000   3rd Qu.: 0.00000   3rd Qu.:0.00000  
##  Max.   :6.890   Max.   :8.3300   Max.   :11.11000   Max.   :4.76000  
##        cs             meeting           original         project       
##  Min.   :0.00000   Min.   : 0.0000   Min.   :0.0000   Min.   : 0.0000  
##  1st Qu.:0.00000   1st Qu.: 0.0000   1st Qu.:0.0000   1st Qu.: 0.0000  
##  Median :0.00000   Median : 0.0000   Median :0.0000   Median : 0.0000  
##  Mean   :0.04367   Mean   : 0.1323   Mean   :0.0461   Mean   : 0.0792  
##  3rd Qu.:0.00000   3rd Qu.: 0.0000   3rd Qu.:0.0000   3rd Qu.: 0.0000  
##  Max.   :7.14000   Max.   :14.2800   Max.   :3.5700   Max.   :20.0000  
##        re               edu              table            conference      
##  Min.   : 0.0000   Min.   : 0.0000   Min.   :0.000000   Min.   : 0.00000  
##  1st Qu.: 0.0000   1st Qu.: 0.0000   1st Qu.:0.000000   1st Qu.: 0.00000  
##  Median : 0.0000   Median : 0.0000   Median :0.000000   Median : 0.00000  
##  Mean   : 0.3012   Mean   : 0.1798   Mean   :0.005444   Mean   : 0.03187  
##  3rd Qu.: 0.1100   3rd Qu.: 0.0000   3rd Qu.:0.000000   3rd Qu.: 0.00000  
##  Max.   :21.4200   Max.   :22.0500   Max.   :2.170000   Max.   :10.00000  
##  charSemicolon     charRoundbracket charSquarebracket charExclamation  
##  Min.   :0.00000   Min.   :0.000    Min.   :0.00000   Min.   : 0.0000  
##  1st Qu.:0.00000   1st Qu.:0.000    1st Qu.:0.00000   1st Qu.: 0.0000  
##  Median :0.00000   Median :0.065    Median :0.00000   Median : 0.0000  
##  Mean   :0.03857   Mean   :0.139    Mean   :0.01698   Mean   : 0.2691  
##  3rd Qu.:0.00000   3rd Qu.:0.188    3rd Qu.:0.00000   3rd Qu.: 0.3150  
##  Max.   :4.38500   Max.   :9.752    Max.   :4.08100   Max.   :32.4780  
##    charDollar         charHash          capitalAve        capitalLong     
##  Min.   :0.00000   Min.   : 0.00000   Min.   :   1.000   Min.   :   1.00  
##  1st Qu.:0.00000   1st Qu.: 0.00000   1st Qu.:   1.588   1st Qu.:   6.00  
##  Median :0.00000   Median : 0.00000   Median :   2.276   Median :  15.00  
##  Mean   :0.07581   Mean   : 0.04424   Mean   :   5.191   Mean   :  52.17  
##  3rd Qu.:0.05200   3rd Qu.: 0.00000   3rd Qu.:   3.706   3rd Qu.:  43.00  
##  Max.   :6.00300   Max.   :19.82900   Max.   :1102.500   Max.   :9989.00  
##   capitalTotal          type     
##  Min.   :    1.0   nonspam:2788  
##  1st Qu.:   35.0   spam   :1813  
##  Median :   95.0                 
##  Mean   :  283.3                 
##  3rd Qu.:  266.0                 
##  Max.   :15841.0
```

#Setting the seed 
Useful to seed the seed in order to be able to replicate the running experiments.

* Often useful to set an overall seed
* Possible to set a seed for each resample (for parallel fits)

Setting the seed   

```r
set.seed(123)
seeds <- vector(mode = "list", length = 2)
for(i in 1:2) seeds[[i]] <- sample.int(1000, 10)
seeds
## [[1]]
##  [1] 288 788 409 881 937  46 525 887 548 453
## 
## [[2]]
##  [1] 957 453 677 571 103 896 245  42 326 946

set.seed(123)
seeds <- vector(mode = "list", length = 2)
for(i in 1:2) seeds[[i]] <- sample.int(1000, 10)
seeds
## [[1]]
##  [1] 288 788 409 881 937  46 525 887 548 453
## 
## [[2]]
##  [1] 957 453 677 571 103 896 245  42 326 946
```

Not setting the seed   

```r
seeds <- vector(mode = "list", length = 2)
for(i in 1:2) seeds[[i]] <- sample.int(1000, 10)
seeds
## [[1]]
##  [1] 890 693 640 992 654 705 541 590 287 146
## 
## [[2]]
##  [1] 964 902 690 794  25 476 754 215 316 230

seeds <- vector(mode = "list", length = 2)
for(i in 1:2) seeds[[i]] <- sample.int(1000, 10)
seeds
## [[1]]
##  [1] 143 415 413 368 152 139 232 463 264 851
## 
## [[2]]
##  [1]  46 442 798 122 559 206 127 749 888 372
```


#The Caret Vocabulary & Process  
##Data Splitting
Techniques that can be used to create a **training** and **testing** dataset from the vailable data.  
###Simple Splitting Based On Outcome
Create a balanced split of the data based on the outcome, keeping the overall distribution of the data (if outcome is a classifier)....  


```r
prop.table(table(iris$Species))
## 
##     setosa versicolor  virginica 
##  0.3333333  0.3333333  0.3333333

#split 75%/25% - training/ test
inTraining <- createDataPartition(iris$Species, times = 1, p = 0.75, list = FALSE)
#If list = TRUE - a listy is returned

iris.train <- iris[inTraining,]
dim(iris.train)[1]/dim(iris)[1] * 100
## [1] 76
prop.table(table(iris.train$Species))
## 
##     setosa versicolor  virginica 
##  0.3333333  0.3333333  0.3333333

iris.test <- iris[-inTraining,]
dim(iris.test)[1]/dim(iris)[1] * 100
## [1] 24
prop.table(table(iris.test$Species))
## 
##     setosa versicolor  virginica 
##  0.3333333  0.3333333  0.3333333
```

###Splitting Based On Predictors
The data can be splitted on the basis of teh predictor values using the _maximum dissimilarity sampling_. Note!! Dissimilarity between two sample can be  measured in a number of ways. Simplest approach is to use the distance between predictor values - if the distance is small then the 2 values are in near proximity. Larger distances are indication for dissimilarities. See `caret::maxDissim` function.

###Cross-Validation and Resampling Techniques
Cross-Validation is a model validation technique for assessing how teh results of a statistical analysis will generalize to an independent dataset - using the same dataset e.g. **training** dataset to create different sets of test/training datasets (different cross-validation rounds).

####k-fold
Creating **training** folds...  

```r
set.seed(32323)
folds.training <- createFolds(y = iris$Species, k = 10, list = TRUE, returnTrain = TRUE)
#return a list objects, each list element contains info on the training dataset for each specific fold
sapply(folds.training, length)
```

```
## Fold01 Fold02 Fold03 Fold04 Fold05 Fold06 Fold07 Fold08 Fold09 Fold10 
##    135    135    135    135    135    135    135    135    135    135
```

Creating **testing** folds...  

```r
set.seed(32323)
folds.testing <- createFolds(y = iris$Species, k = 10, list = TRUE, returnTrain = FALSE)
#return a list objects, each list element contains info on the testing dataset for each specific fold
sapply(folds.testing, length)
```

```
## Fold01 Fold02 Fold03 Fold04 Fold05 Fold06 Fold07 Fold08 Fold09 Fold10 
##     15     15     15     15     15     15     15     15     15     15
```

If `list=FALSE` then `returnTrain` is not used - the **testing** dataset is returned (which fold each observation should be, based on teh k folder).


```r
set.seed(32323)
folds.testing <- createFolds(y = iris$Species, k = 5, list = FALSE)
head(folds.testing)
```

```
## [1] 4 3 4 5 1 5
```

```r
fold1.testing.idx <- which(folds.testing == 1)
fold1.testing <- iris[fold1.testing.idx,]
head(fold1.testing)
```

```
##    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 5           5.0         3.6          1.4         0.2  setosa
## 7           4.6         3.4          1.4         0.3  setosa
## 10          4.9         3.1          1.5         0.1  setosa
## 24          5.1         3.3          1.7         0.5  setosa
## 30          4.7         3.2          1.6         0.2  setosa
## 31          4.8         3.1          1.6         0.2  setosa
```

###Data Splitting Applied to Time Series: TimeSlices


```r
set.seed(32323)
tme_index <- 1:1000 # index for the time slice
time_folds <-  createTimeSlices(y = tme_index,initialWindow = 30, horizon = 10)
names(time_folds) #List of 2 elements train and test
## [1] "train" "test"

#Time Slice connected with the 1st fold 30 points for TRAINING/ 10 points for TESTING
time_folds$train$Training001
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
## [24] 24 25 26 27 28 29 30
time_folds$test$Testing001
##  [1] 31 32 33 34 35 36 37 38 39 40

#Time Slice connected with the 2nd fold 30 points for TRAINING/ 10 points for TESTING
time_folds$train$Training002
##  [1]  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
## [24] 25 26 27 28 29 30 31
time_folds$test$Testing002
##  [1] 32 33 34 35 36 37 38 39 40 41
```

####Playing with `fixedWindow`  

```r
createTimeSlices(y = 1:9, initialWindow = 5, horizon = 1, fixedWindow = FALSE)
## $train
## $train$Training1
## [1] 1 2 3 4 5
## 
## $train$Training2
## [1] 1 2 3 4 5 6
## 
## $train$Training3
## [1] 1 2 3 4 5 6 7
## 
## $train$Training4
## [1] 1 2 3 4 5 6 7 8
## 
## 
## $test
## $test$Testing1
## [1] 6
## 
## $test$Testing2
## [1] 7
## 
## $test$Testing3
## [1] 8
## 
## $test$Testing4
## [1] 9
createTimeSlices(y = 1:9, initialWindow = 5, horizon = 1, fixedWindow = TRUE)
## $train
## $train$Training1
## [1] 1 2 3 4 5
## 
## $train$Training2
## [1] 2 3 4 5 6
## 
## $train$Training3
## [1] 3 4 5 6 7
## 
## $train$Training4
## [1] 4 5 6 7 8
## 
## 
## $test
## $test$Testing1
## [1] 6
## 
## $test$Testing2
## [1] 7
## 
## $test$Testing3
## [1] 8
## 
## $test$Testing4
## [1] 9

createTimeSlices(y = 1:9, initialWindow = 5, horizon = 3, fixedWindow = TRUE)
## $train
## $train$Training1
## [1] 1 2 3 4 5
## 
## $train$Training2
## [1] 2 3 4 5 6
## 
## 
## $test
## $test$Testing1
## [1] 6 7 8
## 
## $test$Testing2
## [1] 7 8 9
createTimeSlices(y = 1:9, initialWindow = 5, horizon = 3, fixedWindow = FALSE)
## $train
## $train$Training1
## [1] 1 2 3 4 5
## 
## $train$Training2
## [1] 1 2 3 4 5 6
## 
## 
## $test
## $test$Testing1
## [1] 6 7 8
## 
## $test$Testing2
## [1] 7 8 9
```

####Playing with `skip`

```r
createTimeSlices(y = 1:15, initialWindow = 5, horizon = 3)
## $train
## $train$Training1
## [1] 1 2 3 4 5
## 
## $train$Training2
## [1] 2 3 4 5 6
## 
## $train$Training3
## [1] 3 4 5 6 7
## 
## $train$Training4
## [1] 4 5 6 7 8
## 
## $train$Training5
## [1] 5 6 7 8 9
## 
## $train$Training6
## [1]  6  7  8  9 10
## 
## $train$Training7
## [1]  7  8  9 10 11
## 
## $train$Training8
## [1]  8  9 10 11 12
## 
## 
## $test
## $test$Testing1
## [1] 6 7 8
## 
## $test$Testing2
## [1] 7 8 9
## 
## $test$Testing3
## [1]  8  9 10
## 
## $test$Testing4
## [1]  9 10 11
## 
## $test$Testing5
## [1] 10 11 12
## 
## $test$Testing6
## [1] 11 12 13
## 
## $test$Testing7
## [1] 12 13 14
## 
## $test$Testing8
## [1] 13 14 15
createTimeSlices(y = 1:15, initialWindow = 5, horizon = 3, skip = 2)
## $train
## $train$Training1
## [1] 1 2 3 4 5
## 
## $train$Training4
## [1] 4 5 6 7 8
## 
## $train$Training7
## [1]  7  8  9 10 11
## 
## 
## $test
## $test$Testing1
## [1] 6 7 8
## 
## $test$Testing4
## [1]  9 10 11
## 
## $test$Testing7
## [1] 12 13 14
createTimeSlices(y = 1:15, initialWindow = 5, horizon = 3, skip = 3)
## $train
## $train$Training1
## [1] 1 2 3 4 5
## 
## $train$Training5
## [1] 5 6 7 8 9
## 
## 
## $test
## $test$Testing1
## [1] 6 7 8
## 
## $test$Testing5
## [1] 10 11 12
```
##Visualizations
**Important!** When performing exploratory analysis on the available dataset is a **good practice** to **split the available data set in a training dataset and a testing dataset** and perform the relevant exploration/ visualization on the **training** dataset.

Visual inspection/ exploration is important for building up an "initial" understanding of the available predictors, "possible" patterns and relationships. E.g. looking for skewness, outliers, ...

Things to look for  

* Imbalance in outcomes/ predictors
* Outliers
* Group of points not explained by a predictor
* Skewed predictors

###Plots
####Histograms 
Using `graphics` ...  

```r
hist(Wage$wage)
```

![](R_caret_files/figure-html/unnamed-chunk-11-1.png) 

####Scatterplot Matrix (caret)
The `pairs` plot option is available for **regression** and **classification** problems.


```r
featurePlot(x=Wage[, c("age", "education", "jobclass")], y=Wage$wage, plot="pairs")
```

![](R_caret_files/figure-html/visualizationData1-1.png) 


```r
featurePlot(x=iris[, 1:4], y=iris$Species, plot="pairs", auto.key = list(colums= 3))
```

![](R_caret_files/figure-html/visualizationData2-1.png) 

####Scatterplot Matrix with Ellipses (caret)
The `ellipse` plot option is available for **classification** problems.


```r
featurePlot(x=iris[, 1:4], y=iris$Species, plot="ellipse", auto.key = list(colums= 3))
```

![](R_caret_files/figure-html/visualizationData2_1-1.png) 

####Scatterplot (ggplot2)
Simple Scatterplot:  

```r
qplot(x=age, y=wage, data=Wage)
```

![](R_caret_files/figure-html/unnamed-chunk-12-1.png) 

Adding the `jobclass` dimension:  

```r
qplot(x=age, y=wage, colour=jobclass, data=Wage)
```

![](R_caret_files/figure-html/unnamed-chunk-13-1.png) 

Using `education` dimension and adding regression smoothers:  

```r
qq <- qplot(x=age, y=wage, colour=education, data=Wage)
qq + geom_smooth(method="lm", formula = y~x)
```

![](R_caret_files/figure-html/unnamed-chunk-14-1.png) 

####Boxplot (Hmisc + ggplot2 + gridExtra)
A boxplot example using `qplot` ...  

```r
cutWage <- cut2(Wage$wage, g=3) #g: number of quantiles group
p1 <- qplot(x = cutWage, y = age , data=Wage, fill=cutWage, geom=c("boxplot"))
p1
```

![](R_caret_files/figure-html/unnamed-chunk-15-1.png) 

Adding the points overlayed...  

```r
p2 <- qplot(x = cutWage, y = age , data=Wage, fill=cutWage, geom=c("boxplot", "jitter"))
grid.arrange(p1, p2, ncol=2)
```

![](R_caret_files/figure-html/unnamed-chunk-16-1.png) 

####Boxplot (caret)
A boxplot example using `featurePlot` ...  

```r
featurePlot(x = iris[, 1:4],
            y = iris$Species,
            plot = "box",
            ##pass in options to bwplot
            scales = list(y = list(relation="free"), x = list(rot = 90)),
            layout= c(4,1), auto.key = list(columns = 2))
```

![](R_caret_files/figure-html/unnamed-chunk-17-1.png) 

####Density Plots  
Using `ggplot2` ...  

```r
qplot(x = wage, colour = education, data = Wage, geom = "density")
```

![](R_caret_files/figure-html/unnamed-chunk-18-1.png) 

Using `caret` ...  

```r
featurePlot(Wage$wage, y = Wage$education, plot = "density", scales = list(x = list(relation="free"), y = list(releation="free")), adjust = 1.5, pch = "|", auto.key = list(columns = 3))
```

```
## Warning in complete_names(y, y.scales): Invalid or ambiguous component
## names: releation
```

![](R_caret_files/figure-html/unnamed-chunk-19-1.png) 

####Tables

```r
t1 <- table(cut2(Wage$wage, g=3), Wage$jobclass)
##Show table content
t1
```

```
##                
##                 1. Industrial 2. Information
##   [ 20.1, 92.2)           629            371
##   [ 92.2,118.9)           533            507
##   [118.9,318.3]           382            578
```

```r
##Show Proportion by row
prop.table(t1, 1)
```

```
##                
##                 1. Industrial 2. Information
##   [ 20.1, 92.2)     0.6290000      0.3710000
##   [ 92.2,118.9)     0.5125000      0.4875000
##   [118.9,318.3]     0.3979167      0.6020833
```

```r
##Show Proportion by col
prop.table(t1, 2)
```

```
##                
##                 1. Industrial 2. Information
##   [ 20.1, 92.2)     0.4073834      0.2548077
##   [ 92.2,118.9)     0.3452073      0.3482143
##   [118.9,318.3]     0.2474093      0.3969780
```

##Pre-processing
__Remember!!__ When deciding the type fo pre-processing to apply to the data a good practice is to use only the __training__ dataset. __Do Not Use All of The Data Available - exlcude the testing/ validation dataset!!__

The addition, deletion or transformation of **training** dataset.

###Why pre-processing?
Sometimes it is needed to transform predictors to make them useful or valuable for the next steps.  Predictors can have different scales, outliers or predictors could be skewed...
 

```r
spam.inTrain <- createDataPartition(y = spam$type, p = 0.75, list = FALSE)
spam.training <- spam[spam.inTrain,]
spam.testing <- spam[-spam.inTrain,]
summary(spam.training$capitalAve)
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
##    1.000    1.583    2.276    4.992    3.702 1022.000

mean(spam.training$capitalAve)
## [1] 4.99219
sd(spam.training$capitalAve)
## [1] 29.3848
```

Distribution is right skewed..    

```r
hist(spam.training$capitalAve, xlab = "Average No Of Capital Letter")
```

![](R_caret_files/figure-html/unnamed-chunk-22-1.png) 

###Data Transformations For Individual Predictors

####Centering & Scaling  
Using the mean and standar deviation of a predictor to center & scale the standarized predictor. Note when standarizing we are losing interpreatbility of values.


```r
p_standarized.train <- spam.training$capitalAve
p_standarized.train <- (p_standarized.train - mean(p_standarized.train))/sd(p_standarized.train)
#Centering around the mean value - the mean of the standarized predictor is 0
p_standarized.train.mean <- mean(p_standarized.train)
p_standarized.train.mean
## [1] 9.445051e-18
#Scaling using the sd - the sd of the standarized predictor is 1
p_standarized.train.sd <- sd(p_standarized.train)
p_standarized.train.sd
## [1] 1
```

__When standarizing the predictor in the test set the same mean and standard deviation used to standarize the predictor in the training dataset must be used.__


```r
p_standarized.test <- spam.testing$capitalAve
p_standarized.test <- (p_standarized.test - mean(spam.training$capitalAve))/sd(spam.training$capitalAve)
#Centering around the mean value of training - the mean of the standarized predictor is not 0 (but should be close to)
mean(p_standarized.test)
## [1] 0.02713894
#Scaling using the sd of the training - the sd of the standarized predictor is not 1 (but should be close to)
sd(p_standarized.test)
## [1] 1.290229
```

#####Using `preProcess` function  
Working on `training` dataset...


```r
preProcessObj <- preProcess(spam.training[,-58], method = c("center", "scale"))
p_standarized.train.all <- predict(object = preProcessObj, spam.training[,-58]) #Center And Scale all
p_standarized.train.capitalAve <- p_standarized.train.all$capitalAve

mean(p_standarized.train.capitalAve)
## [1] 9.445051e-18

sd(p_standarized.train.capitalAve)
## [1] 1
```

Applying standarization on `testing` dataset...

```r
#Using the preProcessObj created using the 
p_standarized.test.all <- predict(object = preProcessObj, spam.testing[,-58]) #Center And Scale all
p_standarized.test.capitalAve <- p_standarized.test.all$capitalAve

mean(p_standarized.test.capitalAve)
## [1] 0.02713894

sd(p_standarized.test.capitalAve)
## [1] 1.290229
```

#####Using `preProcess` argument in the `train` function

```r
set.seed(32343)
modelFit <- train(type ~ ., data = spam.training, preProcess= c("center", "scale"), method="glm")
modelFit
```

```
## Generalized Linear Model 
## 
## 3451 samples
##   57 predictor
##    2 classes: 'nonspam', 'spam' 
## 
## Pre-processing: centered (57), scaled (57) 
## Resampling: Bootstrapped (25 reps) 
## Summary of sample sizes: 3451, 3451, 3451, 3451, 3451, 3451, ... 
## Resampling results
## 
##   Accuracy   Kappa      Accuracy SD  Kappa SD  
##   0.9061002  0.8022386  0.02894948   0.06081898
## 
## 
```

####Transformation To Resolve Skewness
The use of the Box & Cox family of transformations based on a specific parameter (calculated from the available values). The `"BoxCox"` will estimate a Box-Cox transformation on the predictors if the data are greater than zero).


```r
preProcessObj <- preProcess(spam.training[,-58], method = c("BoxCox"))
p_standarized.train.all <- predict(object = preProcessObj, spam.training[,-58]) #BoxCox all
p_standarized.train.capitalAve <- p_standarized.train.all$capitalAve

preProcessObj
## Created from 3451 samples and 3 variables
## 
## Pre-processing:
##   - Box-Cox transformation (3)
##   - ignored (0)
## 
## Lambda estimates for Box-Cox transformation:
## -0.6, 0, 0

preProcessObj$bc
## $capitalAve
## Box-Cox Transformation
## 
## 3451 data points used to estimate Lambda
## 
## Input data summary:
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
##    1.000    1.583    2.276    4.992    3.702 1022.000 
## 
## Largest/Smallest: 1020 
## Sample Skewness: 23.2 
## 
## Estimated Lambda: -0.6 
## 
## 
## $capitalLong
## Box-Cox Transformation
## 
## 3451 data points used to estimate Lambda
## 
## Input data summary:
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1.00    6.00   14.00   52.36   43.00 9989.00 
## 
## Largest/Smallest: 9990 
## Sample Skewness: 32.1 
## 
## Estimated Lambda: 0 
## With fudge factor, Lambda = 0 will be used for transformations
## 
## 
## $capitalTotal
## Box-Cox Transformation
## 
## 3451 data points used to estimate Lambda
## 
## Input data summary:
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##     1.0    35.0    97.0   290.1   272.0 15840.0 
## 
## Largest/Smallest: 15800 
## Sample Skewness: 9.12 
## 
## Estimated Lambda: 0 
## With fudge factor, Lambda = 0 will be used for transformations

par(mfrow=c(2,2));
hist(spam.training$capitalAve); qqnorm(spam.training$capitalAve)
hist(p_standarized.train.capitalAve); qqnorm(p_standarized.train.capitalAve)
```

![](R_caret_files/figure-html/unnamed-chunk-28-1.png) 

###Dealing with Missing Values
One popular techniuque for imputation of missing data is a K-nearest neighbor model where a missing sample is imputed by finding the samples in the training set closest to it and average the nearby points to fill in. Note the entire training set is required every time a missing value needs to be imputed.lllll

###Binning: making factors out of quantitative predictors (Hmisc)
An example on how to break a quantitative variables into different categories.


```r
cutWage <- cut2(Wage$wage, g=3) #g: number of quantiles group
table(cutWage)
```

```
## cutWage
## [ 20.1, 92.2) [ 92.2,118.9) [118.9,318.3] 
##          1000          1040           960
```

##Model Training & Parameter Tuning
The caret package has several functions that attempt to streamline the model building and evaluation process.

The `train` function can be used to

* evaluate, using resampling, the effect of model tuning parameters on performance
* choose the "optimal" model across these parameters
* estimate model performance from a training set

[Model List & Parameters](http://topepo.github.io/caret/modelList.html)


`train` arguments/ options

```r
args(train.default)
```

```
## function (x, y, method = "rf", preProcess = NULL, ..., weights = NULL, 
##     metric = ifelse(is.factor(y), "Accuracy", "RMSE"), maximize = ifelse(metric %in% 
##         c("RMSE", "logLoss"), FALSE, TRUE), trControl = trainControl(), 
##     tuneGrid = NULL, tuneLength = 3) 
## NULL
```

Using the train arguments is possible to perform some basic parameter tuning e.g.

`metric` option
* Continuous outcomes
    * RMSE Root Mean Squared Error
    * Rsquared
* Categorical outcomes
    * Accuracy
    * Kappa (a measure of concordance)


Basic parameter tuning can be done using the `trainControl` function. 

`fitControl` arguments/ options

```r
args(trainControl)
```

```
## function (method = "boot", number = ifelse(grepl("cv", method), 
##     10, 25), repeats = ifelse(grepl("cv", method), 1, number), 
##     p = 0.75, search = "grid", initialWindow = NULL, horizon = 1, 
##     fixedWindow = TRUE, verboseIter = FALSE, returnData = TRUE, 
##     returnResamp = "final", savePredictions = FALSE, classProbs = FALSE, 
##     summaryFunction = defaultSummary, selectionFunction = "best", 
##     preProcOptions = list(thresh = 0.95, ICAcomp = 3, k = 5), 
##     sampling = NULL, index = NULL, indexOut = NULL, timingSamps = 0, 
##     predictionBounds = rep(FALSE, 2), seeds = NA, adaptive = list(min = 5, 
##         alpha = 0.05, method = "gls", complete = TRUE), trim = FALSE, 
##     allowParallel = TRUE) 
## NULL
```

For example by default simple bootstrap resampling is used for `each resampling iteration`. `trainControl` can be used to specify the type of resampling. So if a repeated k-fold resampling is to be used instead 


```r
fitControl <- trainControl(## 10-fold CV
                           method = "repeatedcv",
                           number = 10,
                           ## repeated ten times
                           repeats = 10)
#This function will be used in the train function through the trControl argument
```

__`trainControl` resampling options__ (see documentation for more info)

* method
    * boot = bootstrapping
    * boot632 = bootstrapping with adjustment
    * cv = cross validation
    * repeatedcv = repeated cross validation
    * LOOCV = leave-one-out cross validation
* number
    * for boot/ cross validation
    * no of samples to take
* repeats
    * Number of times to repeat subsampling
    * If big - it can slow things down

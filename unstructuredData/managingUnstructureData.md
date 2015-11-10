# Managing Unstructured Data with the `tm` package
ppar  
10. nov. 2015  
Required packages

* `tm` package, used perform text mining operations on unstructured data
* `XML` package, used to perfom some web scraping
* `wordcloud` package, used for visualization purpose 



Text mining is the process of analysing natural language text.A __corpus__ is a collection of text document that we want to include in the analysis.

Available options in `tm` to import a corpus can be seen using `getSources()`

```r
getSources()
## [1] "DataframeSource" "DirSource"       "URISource"       "VectorSource"   
## [5] "XMLSource"       "ZipSource"
```

We can import text documents using a dataframe, a vector, a URI, a directory, etc. The `URISource` stands for a collection of hyperlinks or file paths, although this is somewhat easier to handle with `DirSource`, which imports all the textual documents found in the referenced directory on our hard drive.

Using `getReaders()` we can see teh supported text file formats

```r
getReaders()
##  [1] "readDOC"                 "readPDF"                
##  [3] "readPlain"               "readRCV1"               
##  [5] "readRCV1asPlain"         "readReut21578XML"       
##  [7] "readReut21578XMLasPlain" "readTabular"            
##  [9] "readTagged"              "readXML"
```

##Getting the data and creating the __corpus__
The data representing our __corpus__ is the list of R package names and short description available [here](http://cran.r-project.org/web/packages/available_packages_by_name.html). For dowloading the data we will use the `readHTMTable` function in the `XLM` package.


```r
dataUri <- "http://cran.r-project.org/web/packages/available_packages_by_name.html"
rawData <- XML::readHTMLTable(paste0(dataUri), stringsAsFactors = FALSE, which = 1)
```


```r
class(rawData)
## [1] "data.frame"

str(rawData)
## 'data.frame':	7492 obs. of  2 variables:
##  $ V1: chr  "A3" "abbyyR" "abc" "ABCanalysis" ...
##  $ V2: chr  "Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels" "Access to Abbyy Optical Character Recognition (OCR) API" "Tools for Approximate Bayesian Computation (ABC)" "Computed ABC Analysis" ...

tail(rawData, 3)
##          V1                                             V2
## 7490    ZRA      Dynamic Plots for Time Series Forecasting
## 7491 ztable Zebra-Striped Tables in LaTeX and HTML Formats
## 7492    zyp               Zhang + Yue-Pilon trends package
```

`rawData` is a dataframe of 7492 entries, where each entry includes the package name and a short description of the package.

The features/ columns do not have proper names (just the standard names assigned by R). Proper names are given to the columns - `packageName` and `description` respectively. 

```r
names(rawData)
## [1] "V1" "V2"

names(rawData) <- c("packageName", "description")
names(rawData)
## [1] "packageName" "description"

rawData$packageName[1:3]
## [1] "A3"     "abbyyR" "abc"
```

We have a dataframe containing all of the documents that should be part of our corpus. Let's build a corpus using the `vectorSource` and the package decsription.


```r
theCorpus <- Corpus(VectorSource(x = rawData$description))
print(theCorpus)
## <<VCorpus>>
## Metadata:  corpus specific: 0, document level (indexed): 0
## Content:  documents: 7492
#created a VCorpus (in-memory) object of 7492 documents - aka a description is a document
```
Here we can see the first 2 documents in the corpus (not very meaningful) and their contents. Note the corpus is a `list`. 


```r
inspect(head(theCorpus,2))
## <<VCorpus>>
## Metadata:  corpus specific: 0, document level (indexed): 0
## Content:  documents: 2
## 
## [[1]]
## <<PlainTextDocument>>
## Metadata:  7
## Content:  chars: 71
## 
## [[2]]
## <<PlainTextDocument>>
## Metadata:  7
## Content:  chars: 55
theCorpus[[1]]$content
## [1] "Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels"
theCorpus[[2]]$content
## [1] "Access to Abbyy Optical Character Recognition (OCR) API"
```

##Cleaning the __corpus__
The `tm` package offfers a variety of __predefined transformations__ that can be applied on __corpora__ (__corpuses__).


```r
getTransformations()
## [1] "removeNumbers"     "removePunctuation" "removeWords"      
## [4] "stemDocument"      "stripWhitespace"
```

Usually one of the first steps is to remove the most frequently used words from the  corpus, called __stopwords__.  __Stopwords__ are the most common, short function terms, whit no important meaning. The `tm` package already offers a list of such a word (predefined)


```r
stopwords()
##   [1] "i"          "me"         "my"         "myself"     "we"        
##   [6] "our"        "ours"       "ourselves"  "you"        "your"      
##  [11] "yours"      "yourself"   "yourselves" "he"         "him"       
##  [16] "his"        "himself"    "she"        "her"        "hers"      
##  [21] "herself"    "it"         "its"        "itself"     "they"      
##  [26] "them"       "their"      "theirs"     "themselves" "what"      
##  [31] "which"      "who"        "whom"       "this"       "that"      
##  [36] "these"      "those"      "am"         "is"         "are"       
##  [41] "was"        "were"       "be"         "been"       "being"     
##  [46] "have"       "has"        "had"        "having"     "do"        
##  [51] "does"       "did"        "doing"      "would"      "should"    
##  [56] "could"      "ought"      "i'm"        "you're"     "he's"      
##  [61] "she's"      "it's"       "we're"      "they're"    "i've"      
##  [66] "you've"     "we've"      "they've"    "i'd"        "you'd"     
##  [71] "he'd"       "she'd"      "we'd"       "they'd"     "i'll"      
##  [76] "you'll"     "he'll"      "she'll"     "we'll"      "they'll"   
##  [81] "isn't"      "aren't"     "wasn't"     "weren't"    "hasn't"    
##  [86] "haven't"    "hadn't"     "doesn't"    "don't"      "didn't"    
##  [91] "won't"      "wouldn't"   "shan't"     "shouldn't"  "can't"     
##  [96] "cannot"     "couldn't"   "mustn't"    "let's"      "that's"    
## [101] "who's"      "what's"     "here's"     "there's"    "when's"    
## [106] "where's"    "why's"      "how's"      "a"          "an"        
## [111] "the"        "and"        "but"        "if"         "or"        
## [116] "because"    "as"         "until"      "while"      "of"        
## [121] "at"         "by"         "for"        "with"       "about"     
## [126] "against"    "between"    "into"       "through"    "during"    
## [131] "before"     "after"      "above"      "below"      "to"        
## [136] "from"       "up"         "down"       "in"         "out"       
## [141] "on"         "off"        "over"       "under"      "again"     
## [146] "further"    "then"       "once"       "here"       "there"     
## [151] "when"       "where"      "why"        "how"        "all"       
## [156] "any"        "both"       "each"       "few"        "more"      
## [161] "most"       "other"      "some"       "such"       "no"        
## [166] "nor"        "not"        "only"       "own"        "same"      
## [171] "so"         "than"       "too"        "very"
```

As we can see stopwords are unimportant words that will not actually change the meaning of the documents (each package description). 

Example of a simple transformation on a document, we can see that the "and" word is replaced with an empty space. But "And" is not removed cause of the uppercase letter (case sensitive) and also "punctuation" symbol are not removed.


```r
removeWords("live long and prosper", stopwords())
## [1] "live long  prosper"

removeWords("live long And prosper.", stopwords())
## [1] "live long And prosper."
```

In order to remove the possible challenges connected with uppercases and punctuation symbols, common practices are to simply

* transform the uppercase to lowercase
* remove the stopwords
* remove punctuation symbols
* normalize the white spaces (a words removed is transofrmed into a white space) 

To iteratively apply transformations to the corpus we use the `tm_map` function. Lets apply the different transformations and see how the content of some documents have changed.

```r
theCorpus <- tm_map(theCorpus, content_transformer(tolower))
#we had to wrap the tolower function in the content_transformer function, so that
#our transformation really complies with the tm package's object structure. 
#This is usually required when using a transformation function outside of the 
#tm package.
theCorpus <- tm_map(theCorpus, removeWords, stopwords())
theCorpus <- tm_map(theCorpus, removePunctuation)
theCorpus <- tm_map(theCorpus, stripWhitespace)

##see the content fo 3 documents
theCorpus[[1]]$content
## [1] "accurate adaptable accessible error metrics predictive models"
theCorpus[[10]]$content
## [1] " analysis biological data"
theCorpus[[100]]$content
## [1] "estimation boxcox power transformation parameter"
```
##Visualizing most frequent words in the corpus
The `wordcloud` function in the `wordcloud` package can be used to generate useful wordclouds from the corpus. It is a valuable tool to visualize the some of teh information hidden in the corpus.


```r
wordcloud(theCorpus, random.order = FALSE)
```

![](managingUnstructureData_files/figure-html/generateWordcloud-1.png) 


















##Reference## 
* ["Mastering Data Analysis with R"](https://www.packtpub.com/big-data-and-business-intelligence/mastering-data-analysis-r), Gergely Daróczi

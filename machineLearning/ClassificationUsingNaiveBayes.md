# Probabilistic Learning - Naive Bayes
ppar  
05. nov. 2015  

#Classification Using Naive Bayes
The Naive Bayes algorith uses principles of probability fir classification. Naive Bayes uses data about prior events to estimate the probability of future events (e.g. using frequency of words in past junk emails to identify new junk emails).

##Naive Bayes Introduction
The technique descended from the work of the 18th century mathematician **Thomas Bayes**, who developed foundational mathematical principles (now known as **Bayesian methods**) for describing the probability of events, and how probabilities should be revised in light of additional information.

__Basic__: _the probability of a event is a number between 0 and 1 that captures the chances that the event will occur given the available evidence._

Classifiers based on Bayesian methods utilize __training data__ to calculate an observed probability of each "class/ label" based on feature values. When the classifier is used later on "real" data, it uses the observed probabilities to predict the most likely "class/label" for the new observations. 

Typically, __Bayesian classifiers__ are best applied to problems in which the information from numerous attributes/ features should be considered simultaneously in order to estimate the probability of an outcome. While many algorithms ignore features that have weak effects, Bayesian methods utilize all available evidence to subtly change the predictions. __If a large number of features have relatively minor effects, taken together their combined impact could be quite large.__

##Basic concepts of Bayesian methods
Some useful concepts

* __events__: all possible outcomes for an experiment
* __trial__: a single opportunity for teh event to occur

__P(A)__ (_probability of an event A_) can be estimated from observed data - specifically dividing the number of trials in which an event occured by the total number of trials.

The __total probability of all possible outcomes for a trial__ must always be __1__. So if a trial has only two possible outcomes that cannot occur simultaneously (e.g spam or ham), then knowing the probability of one of the outcomes reveals the probability of the other. The events are __mutaully exclusive__ and __exaustive__.

* __mutually exclusive__: the events cannot occur at the same time
* __exaustive__: the events (e.g. spam and ham) are the only possible events.

S = {all emails}  
A = {__spam__}  
B = {__ham__}  

$P(S) = 1$ -> $1 = P(A) + P(B)$ -> $P(A) = 1 - P(B)$

###Joint Probability
Given two events, __event__ A and __event B__, the the probability of both events happening at the same time $P(A \cup B)$ depends on the __joint probability__ of the two events, in other words how the probability of one event is related to the probability of the other.

If the 2 events are totally unrelated __independent events__ then $P(A \cup B) = P(A) * P(B)$. If the 2 events are related then ....

__Note!!__ Consideration and understanding need to be used to identify the nature of the relationship between the events. 

###Conditional probability with the Bayes' theorem
Given two events, __event__ A and __event B__, the probability of event A given that event B occured $P(A|B)$ (conditional porbability) is defined as

$P(A|B) = P(A \cap B)/ P(B) = (P(B|A) * P(A))/P(B)$

##The naive Bayes algorithm
The naive Bayes (NB) algorithm describes a simple application using Bayes' theorem for classification (e.g. assign an observation to a specific class for example SPAM or HAM). It is the most common, particularly for text classification where it has become the de facto standard. 

__Naive__:  the algorithm makes a couple of "naive" assumptions about the data. In particular, it assumes that all of the features in the dataset are equally important and independent. __Note!!__ These assumptions are rarely true in most of the real-world applications.

__Strengths__:

* Simple, fast, and very effective  
* Does well with noisy and missing data  
** Requires relatively few examples for training, but also works well with very large numbers of examples  
* Easy to obtain the estimated probability for a prediction  

__Weaknesses__:

* Relies on an often-faulty assumption of equally important and independent features  
* Not ideal for datasets with large numbers of numeric features  
* Estimated probabilities are less reliable than the predicted classes  


__Example__ (e.g. CLASS1 = SPAM and CLASS2 = HAM)

$P(CLASS1|B1 \cap B2 \cap B3 \cap B4) = (P(B1 \cap B2 \cap B3 \cap B4|CLASS1) * P(CLASS1))/ P(B1 \cap B2 \cap B3 \cap B4)$

... naive Bayes assumes class-conditional independence , events are independent so long as they are conditioned on the same class value so ...
 
$P(CLASS1|B1 \cap B2 \cap B3 \cap B4) = (P(B1|CLASS1) * P(B2|CLASS1) * P(B3|CLASS1) * P(B4|CLASS1) * P(CLASS1))/ (P(B1) * P(B2) * P(B3) * P(B4))$

$P(CLASS2|B1 \cap B2 \cap B3 \cap B4) = (P(B1|CLASS2) * P(B2|CLASS2) * P(B3|CLASS2) * P(B4|CLASS2) * P(CLASS2))/ (P(B1) * P(B2) * P(B3) * P(B4))$


###Generalized formula for the naive Bayes algorithm

CLASSi: level i for CLASS class
Fj: feature j evidence (j=1..n)

$P(CLASSi|F1,..,Fn) = (1/Z) p(CLASSi) \prod_{j=1}^{n} p(F_j|CLASSi)$

the probability of level i for class CLASS, given the evidence provided by features F 1 through F n, is equal to the product of the probabilities of each piece of evidence conditioned on the class level, the prior probability of the class level, and a scaling factor 1 / Z, which converts the result to a probability.

__Limitation!!__ Because probabilities in naive Bayes are multiplied, a 0 percent value in one of the p(Fj|CLASSi) gives the ability to effectively nullify and overrule all of the other evidence - this is problem. A solution to this problem is ti use the __Laplace estimator__ - it adds a small number to each of the counts in a frequency table, ensuring that each feature has not a zero probability of occuring with each class. Note typically the __laplace estimator__ is set to 1.

###Using numeric features with naive Bayes
Because naive Bayes uses frequency tables for learning the data, each feature must be categorical in order to create the combinations of class and feature values comprising the matrix. Since numeric features do not have categories of values, the preceding algorithm does not work directly with numeric data. There are, however, ways that this can be addressed.

One easy and effective solution is to __discretize numeric features__, which simply means that the numbers are put into categories known as bins. For this reason, discretization is also sometimes called binning. This method is ideal when there are large amounts of training data, a common condition when working with naive Bayes.

#Example
Filtering mobile phone spam with the __naive Bayes__ algorithm. 
##Problem
Advertisers utilize Short Message Service (SMS) text messages to target potential consumers with unwanted advertising known as SMS spam. This type of spam is particularly troublesome because, unlike email spam, many cellular phone users pay a fee per SMS received. Developing a classification algorithm that could filter SMS spam would provide a useful tool for cellular phone providers.

##Data Processing
###Loading the data and some essential changes
The data and relevant information can be found (here)[http://www.dt.fee.unicamp.br/~tiago/smsspamcollection/].

Load the raw data into R ...

```r
rawData <-  read.csv("./datasets/Chapter 04/sms_spam.csv", header = TRUE, stringsAsFactors = FALSE)
```


```r
#Show the structure of the raw dataset
str(rawData)
## 'data.frame':	5559 obs. of  2 variables:
##  $ type: chr  "ham" "ham" "ham" "spam" ...
##  $ text: chr  "Hope you are having a good week. Just checking in" "K..give back my thanks." "Am also doing in cbe only. But have to pay." "complimentary 4 STAR Ibiza Holiday or £10,000 cash needs your URGENT collection. 09066364349 NOW from Landline not to lose out!"| __truncated__ ...

#Summary of the raw dataset
summary(rawData)
##      type               text          
##  Length:5559        Length:5559       
##  Class :character   Class :character  
##  Mode  :character   Mode  :character

#Info about observations by type
table(rawData$type)
## 
##  ham spam 
## 4812  747
```

Transforming `type` feature from a `character` to a `factor` ...

```r
#Coverting the text to utf-8 format
rawData$text <- iconv(rawData$text, to = "utf-8")

#Type as factor
rawData$type <- factor(rawData$type)

#Show the structure of the raw dataset
str(rawData$type)
##  Factor w/ 2 levels "ham","spam": 1 1 1 2 2 1 1 1 2 1 ...

#Info about observations by type
table(rawData$type)
## 
##  ham spam 
## 4812  747
```
###Processing text data for analysis
SMS messages are strings of text composed of words, spaces, numbers, and punctuation. We needs to consider how to remove numbers, punctuation, handle uninteresting words such as and, but, and or, and how to break apart sentences into individual words.

__Note!__ `tm` package can be used for such purpose. For installing the package run `install.packages("tm")`.

__First step__ is creating the **corpus**, a collection of text documents. In this specific case a text document refers to a single SMS message.


```r
library(tm) #loading tm library for usage
## Loading required package: NLP
corpus <- Corpus(VectorSource(rawData$text))

#basic info about the corpus
print(corpus)
## <<VCorpus>>
## Metadata:  corpus specific: 0, document level (indexed): 0
## Content:  documents: 5559
```
Please note that the corpus contains 5559 text documents (aka sms text).


```r
#Inspect the first 4 documents
corpus[[1]]$content
## [1] "Hope you are having a good week. Just checking in"
corpus[[2]]$content
## [1] "K..give back my thanks."
corpus[[3]]$content
## [1] "Am also doing in cbe only. But have to pay."
corpus[[4]]$content
## [1] "complimentary 4 STAR Ibiza Holiday or £10,000 cash needs your URGENT collection. 09066364349 NOW from Landline not to lose out! Box434SK38WP150PPM18+"
```

Before splitting the text into words some cleaning steps need to be performed in order to remove punctuation and other characters that may create problems.

Standard `tm` transformations

```
## [1] "removeNumbers"     "removePunctuation" "removeWords"      
## [4] "stemDocument"      "stripWhitespace"
```


```r
#1. normalize to lowercase
corpus_clean <- tm_map(corpus, tolower)

#2. remove numbers
corpus_clean <- tm_map(corpus_clean, removeNumbers)

#3. remove stopwords e.g. to, and, but, or (using predefined set of word in tm package)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())

#4. remove punctuation
corpus_clean <- tm_map(corpus_clean, removePunctuation)

#5. normalize whitespaces
#Now that we have removed numbers, stop words, and punctuation, the text messages are left with #blank spaces where these characters used to be. The last step then is to remove additional #whitespace, leaving only a single space between words.
corpus_clean <- tm_map(corpus_clean, stripWhitespace)
```


```r
#Be sure to use the following script once you have completed preprocessing.
#This tells R to treat your preprocessed documents as text documents.
corpus_clean <- tm_map(corpus_clean, PlainTextDocument)

#Inspect the first 4 documents
corpus[[1]]$content
## [1] "Hope you are having a good week. Just checking in"
corpus_clean[[1]]$content
## [1] "hope good week just checking "

corpus[[2]]$content
## [1] "K..give back my thanks."
corpus_clean[[2]]$content
## [1] "kgive back thanks"

corpus[[3]]$content
## [1] "Am also doing in cbe only. But have to pay."
corpus_clean[[3]]$content
## [1] " also cbe pay"

corpus[[4]]$content
## [1] "complimentary 4 STAR Ibiza Holiday or £10,000 cash needs your URGENT collection. 09066364349 NOW from Landline not to lose out! Box434SK38WP150PPM18+"
corpus_clean[[4]]$content
## [1] "complimentary star ibiza holiday cash needs urgent collection now landline lose boxskwpppm"
```

###Tokenization
Now that the data are processed to our __liking__, the final step is to split the messages into individual elements through a process called __tokenization__. A __token__ is a single element of a text string; in this case, the tokens are words.

From the __corpus__ a data structured called __sparse matrix__ is created. In the __sparse matrix__, each row (observation) represents a document (SMS text message) and each column is a token/ word. The number in a cell represents the number of time the token (col) is present the document represented by that row.


```r
sms_dtm <- DocumentTermMatrix(corpus_clean)
```

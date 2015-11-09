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

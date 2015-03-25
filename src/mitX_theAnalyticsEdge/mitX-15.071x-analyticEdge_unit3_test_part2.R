# PREDICTING PAROLE VIOLATORS
# 
# In many criminal justice systems around the world, inmates deemed not to be a threat
# to society are released from prison under the parole system prior to completing 
# their sentence. They are still considered to be serving their sentence while on parole,
# and they can be returned to prison if they violate the terms of their parole.

# Parole boards are charged with identifying which inmates are good candidates for 
# release on parole. They seek to release inmates who will not commit additional crimes
# after release. In this problem, we will build and validate a model that predicts if an
# inmate will violate the terms of his or her parole. Such a model could be useful to a 
# parole board when deciding to approve or deny an application for parole.

# For this prediction task, we will use data from the United States 2004 National 
# Corrections Reporting Program, a nationwide census of parole releases that occurred 
# during 2004. We limited our focus to parolees who served no more than 6 months in 
# prison and whose maximum sentence for all charges did not exceed 18 months. 
# The dataset contains all such parolees who either successfully completed their term 
# of parole during 2004 or those who violated the terms of their parole during that year. 
# The dataset contains the following variables:
     
# male: 1 if the parolee is male, 0 if female
# race: 1 if the parolee is white, 2 otherwise
# age: the parolee's age (in years) when he or she was released from prison

# state: a code for the parolee's state. 2 is Kentucky, 3 is Louisiana, 4 is Virginia, 
# and 1 is any other state. The three states were selected due to having a high 
# representation in the dataset.

# time.served: the number of months the parolee served in prison (limited by the 
# inclusion criteria to not exceed 6 months).

# max.sentence: the maximum sentence length for all charges, in months (limited by 
# the inclusion criteria to not exceed 18 months).

# multiple.offenses: 1 if the parolee was incarcerated for multiple offenses, 0 otherwise.

# crime: a code for the parolee's main crime leading to incarceration. 2 is larceny, 3 is
# drug-related crime, 4 is driving-related crime, and 1 is any other crime.

# violator: 1 if the parolee violated the parole, and 0 if the parolee completed 
# the parole without violation.

# LOADING THE DATASET  
# Load the dataset parole.csv into a data frame called parole, and investigate it using 
# the str() and summary() functions.
# How many parolees are contained in the dataset?

Parole <- read.csv("parole.csv")
str(Parole)
summary(Parole)
nrow(Parole) #675 Parolees

# How many of the parolees in the dataset violated the terms of their parole?
table(Parole$violator)
#   0   1 
# 597  78 
#There are 78 observations with a viloation (1) of the parole

# You should be familiar with unordered factors (if not, review the Week 2 homework problem
# "Reading Test Scores"). Which variables in this dataset are unordered factors with 
# at least three levels? Select all that apply.
str(Parole)

# EXPLANATION
# While the variables male, race, state, crime, and violator are all unordered factors, 
# only state and crime have at least 3 levels in this dataset. (see below)

str(Parole$state)
unique(Parole$state) #Unordered factor, 4 levels

str(Parole$crime)
unique(Parole$crime) #Unordered factor, 4 levels

##FlashBack on Factors
# Factor variables are variables that take on a discrete set of values, like the 
# "Region" variable in the WHO dataset from the second lecture of Unit 1. 
# This is an unordered factor because there isn't any natural ordering between the levels.
# An ordered factor has a natural ordering between the levels (an example would be the 
# classifications "large," "medium," and "small").


# In the last subproblem, we identified variables that are unordered factors with at least
# 3 levels, so we need to convert them to factors for our prediction problem 
# (we introduced this idea in the "Reading Test Scores" problem last week). 
# Using the as.factor() function, convert these variables to factors. 
# Keep in mind that we are not changing the values, just the way R understands them 
# (the values are still numbers).

# How does the output of summary() change for a factor variable as compared to a numerical 
# variable?

Parole$state <- as.factor(Parole$state)
Parole$crime <- as.factor(Parole$crime)

summary(Parole)
#See output for crime for example...
summary(Parole$crime)

#   1   2   3   4 
# 315 106 153 101 

#The output becomes similar to that of the table() function applied to that variable
# The output of summary(parole$state) or summary(parole$crime) now shows a breakdown 
# of the number of parolees with each level of the factor, which is most similar to 
# the output of the table() function.

# SPLITTING INTO A TRAINING AND TESTING SET (1 point possible)
# To ensure consistent training/testing set splits, run the following 5 lines of code 
# (do not include the line numbers at the beginning):
    
# 1) set.seed(144)
# 2) library(caTools)
# 3) split = sample.split(parole$violator, SplitRatio = 0.7)
# 4) train = subset(parole, split == TRUE)
# 5) test = subset(parole, split == FALSE)
 
# Roughly what proportion of parolees have been allocated to the training and 
# testing sets?
set.seed(144)
library(caTools)
split <- sample.split(Parole$violator, SplitRatio = 0.7)
train <- subset(Parole, split == TRUE)
test <- subset(Parole, split == FALSE)

#if checking the content of the table split
table(split) # 70% TRUE

# FALSE  TRUE 
# 202   473 

# So 70% to the training set, 30% to the testing set
# EXPLANATION
# SplitRatio=0.7 causes split to take the value TRUE roughly 70% of the time, so train 
# should contain roughly 70% of the values in the dataset. You can verify this by running 
# nrow(train) and nrow(test).

# Now, suppose you re-ran lines [1]-[5] of Problem 3.1. What would you expect?
set.seed(144)
library(caTools)
split <- sample.split(Parole$violator, SplitRatio = 0.7)
train <- subset(Parole, split == TRUE)
test <- subset(Parole, split == FALSE)

#if checking the content of the table split
table(split) # 70% TRUE

# FALSE  TRUE 
# 202   473 

# As expected -> The exact same training/testing set split as the first execution of [1]-[5]
# because of the set.seed

# If you instead ONLY re-ran lines [3]-[5], what would you expect?
# As expected ->  A different training/testing set split from the first execution of [1]-[5]
# EXPLANATION
# If you set a random seed, split, set the seed again to the same value, and then split
# again, you will get the same split. However, if you set the seed and then split twice,
# you will get different splits. If you set the seed to different values, you will get
# different splits. You can also verify this by running the specified code in R. 
# If you have training sets train1 and train2, the function sum(train1 != train2) 
# will count the number of values in those two data frames that are different.


## BUILDING A LOGISTIC REGRESSION MODEL
# If you tested other training/testing set splits in the previous section, please 
# re-run the original 5 lines of code to obtain the original split.

# Using glm (and remembering the parameter family="binomial"), train a logistic regression
# model on the training set. Your dependent variable is "violator", and you should use 
# all of the other variables as independent variables.

# What variables are significant in this model? Significant variables should have a 
# least one star, or should have a probability less than 0.05 (the column Pr(>|z|) in 
# the summary output). Select all that apply.

ParoleLog1 <- glm(violator ~ . , data = train, family = binomial)
summary(ParoleLog1)

# -> race, state4 and multiple.offenses

# What can we say based on the coefficient of the multiple.offenses variable? 

# The following two properties might be useful to you when answering this question:
# 1) If we have a coefficient c for a variable, then that means the log odds (or Logit) 
# are increased by c for a unit increase in the variable.
# 2) If we have a coefficient c for a variable, then that means the odds are multiplied
# by e^c for a unit increase in the variable.

summary(ParoleLog1)

# EXPLANATION
# For parolees A and B who are identical other than A having committed multiple offenses, 
# the predicted log odds of A is 1.61 more than the predicted log odds of B. 
# Then we have:
#     
# ln(odds of A) = ln(odds of B) + 1.61
# exp(ln(odds of A)) = exp(ln(odds of B) + 1.61)
# exp(ln(odds of A)) = exp(ln(odds of B)) * exp(1.61)
# odds of A = exp(1.61) * odds of B
# odds of A= 5.01 * odds of B
# 
# In the second step we raised e to the power of both sides. In the third step we used 
# the exponentiation rule that e^(a+b) = e^a * e^b. In the fourth step we used the rule 
# that e^(ln(x)) = x.


# Consider a parolee who is male, of white race, aged 50 years at prison release, 
# from the state of Maryland, served 3 months, had a maximum sentence of 12 months, 
# did not commit multiple offenses, and committed a larceny. Answer the following 
# questions based on the model's predictions for this individual. 
# (HINT: You should use the coefficients of your model, the Logistic Response Function, 
# and the Odds equation to solve this problem.)
# According to the model, what are the odds this individual is a violator?

summary(ParoleLog1) #to get coefficient to build the relevant equations

# EXPLANATION
# From the logistic regression equation, we have 
# log(odds) = -4.2411574 + 0.3869904*male + 0.8867192*race - 0.0001756*age + 
# 0.4433007*state2 + 0.8349797*state3 - 3.3967878*state4 - 0.1238867*time.served + 
# 0.0802954*max.sentence + 1.6119919*multiple.offenses + 0.6837143*crime2 - 
# 0.2781054*crime3 - 0.0117627*crime4. 
# 
# This parolee has male=1, race=1, age=50, state2=0, state3=0, state4=0, time.served=3, 
# max.sentence=12, multiple.offenses=0, crime2=1, crime3=0, crime4=0. We conclude that 
# log(odds) = -1.700629.
# 
# Therefore, the odds ratio is exp(-1.700629) = 0.183, and the predicted probability of 
# violation is 1/(1+exp(1.700629)) = 0.154.


# EVALUATING THE MODEL ON THE TESTING SET
# Use the predict() function to obtain the model's predicted probabilities for parolees
# in the testing set, remembering to pass type="response".
# What is the maximum predicted probability of a violation?

TestPrediction <- predict(ParoleLog1, newdata=test, type="response")
max(TestPrediction) # -> 0.9072791

# In the following questions, evaluate the model's predictions on the test 
# set using a threshold of 0.5.

table(test$violator, TestPrediction >= 0.5)
#    FALSE TRUE
# 0   167   12
# 1    11   12

# What is the model's sensitivity?
#TP/ (TP + FN)
12/ (12 + 11) # -> 0.5217391

# What is the model's specificity?
#TN/ (TN+FP)
167 / (167 + 12) # -> 0.9329609

# What is the model's accuracy?
#(TN + TP) / N
(167 + 12) / nrow(test) # -> 0.8861386

# EXPLANATION
# To obtain the confusion matrix, use the following command:
# table(test$violator, as.numeric(predictions >= 0.5))
# There are 202 observations in the test set. The accuracy (percentage of values on
# the diagonal) is (167+12)/202 = 0.886. The sensitivity (proportion of the actual 
# violators we got correct) is 12/(11+12) = 0.522, and the specificity (proportion of the 
# actual non-violators we got correct) is 167/(167+12) = 0.933.

# What is the accuracy of a simple model that predicts that every parolee is a 
# non-violator?
#Base Model
table(test$violator)
#  0   1 
# 179  23 
179/ (179 + 23)
# EXPLANATION
# If you table the outcome variable using the following command:
#     table(test$violator)
# you can see that there are 179 negative examples, which are the ones that the baseline
# model would get correct. Thus the baseline model would have an accuracy of 
# 179/202 = 0.886.


# Consider a parole board using the model to predict whether parolees will be violators or 
# not. The job of a parole board is to make sure that a prisoner is ready to be released 
# into free society, and therefore parole boards tend to be particularily concerned with 
# releasing prisoners who will violate their parole. Which of the following most 
# likely describes their preferences and best course of action?

#Playing with different probabilities
table(test$violator, TestPrediction >= 0.3)
#    FALSE TRUE
# 0   160   19
# 1     9   14
table(test$violator, TestPrediction >= 0.2)
#    FALSE TRUE
# 0   154   25
# 1     6   17
table(test$violator, TestPrediction >= 0.1)
#    FALSE TRUE
# 0   130   49
# 1     3   20

# The board assigns more cost to a false negative than a false positive, 
# and should therefore use a logistic regression cutoff less than 0.5. 

# EXPLANATION
# If the board used the model for parole decisions, a negative prediction would lead to a 
# prisoner being granted parole, while a positive prediction would lead to a prisoner being
# denied parole. The parole board would experience more regret for releasing a prisoner 
# who then violates parole (a negative prediction that is actually positive, or false negative)
# than it would experience for denying parole to a prisoner who would not have violated parole 
# (a positive prediction that is actually negative, or false positive).
# 
# Decreasing the cutoff leads to more positive predictions, which increases false positives 
# and decreases false negatives. Meanwhile, increasing the cutoff leads to more negative 
# predictions, which increases false negatives and decreases false positives. The parole board
# assigns high cost to false negatives, and therefore should decrease the cutoff.


# Which of the following is the most accurate assessment of the value of the logistic 
# regression model with a cutoff 0.5 to a parole board, based on the model's accuracy as 
# compared to the simple baseline model?

table(test$violator, TestPrediction >= 0.5)
#   FALSE TRUE
# 0   167   12
# 1    11   12

#The model is likely of value to the board, and using a different logistic regression 
# cutoff is likely to improve the model's value. The model is likely of value to the board, 
# and using a different logistic regression cutoff is likely to improve the model's value. - 
# correct

# EXPLANATION
# The model at cutoff 0.5 has 12 false positives and 11 false negatives, while the baseline
# model has 0 false positives and 23 false negatives. Because a parole board is likely to 
# assign more cost to a false negative, the model at cutoff 0.5 is likely of value to the 
# board. From the previous question, the parole board would likely benefit from decreasing the 
# logistic regression cutoffs, which decreases the false negative rate while increasing the 
# false positive rate.

#Using the ROCR package, what is the AUC value for the model?
library(ROCR)
ROCRpred <- prediction(TestPrediction, test$violator)
ROCRperf <- performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize = TRUE)

as.numeric(performance(ROCRpred, "auc")@y.values) #auc

# EXPLANATION
# This can be obtained with the following code:
#     library(ROCR)
# pred = prediction(predictions, test$violator)
# as.numeric(performance(pred, "auc")@y.values)


# Describe the meaning of AUC in this context.
# The probability the model can correctly differentiate between a randomly selected parole 
# violator and a randomly selected parole non-violator.
# EXPLANATION
# The AUC deals with differentiating between a randomly selected positive and negative
# example. It is independent of the regression cutoff selected.


# IDENTIFYING BIAS IN OBSERVATIONAL DATA (1 point possible)
# Our goal has been to predict the outcome of a parole decision, and we used a publicly 
# available dataset of parole releases for predictions. In this final problem, we'll evaluate 
# a potential source of bias associated with our analysis. It is always important to evaluate 
# a dataset for possible sources of bias.

# The dataset contains all individuals released from parole in 2004, either due to completing 
# their parole term or violating the terms of their parole. However, it does not contain 
# parolees who neither violated their parole nor completed their term in 2004, causing
# non-violators to be underrepresented. This is called "selection bias" or "selecting on 
# the dependent variable," because only a subset of all relevant parolees were included 
# in our analysis, based on our dependent variable in this analysis (parole violation). 
# How could we improve our dataset to best address selection bias?
# We should use a dataset tracking a group of parolees from the start of their parole until 
# either they violated parole or they completed their term. 

# EXPLANATION
# While expanding the dataset to include the missing parolees and labeling each as 
# violator=0 would improve the representation of non-violators, it does not capture the true 
# outcome, since the parolee might become a violator after 2004. Though labeling these new 
# examples with violator=NA correctly identifies that we don't know their true outcome, we 
# cannot train or test a prediction model with a missing dependent variable.
# 
# As a result, a prospective dataset that tracks a cohort of parolees and observes the true 
# outcome of each is more desirable. Unfortunately, such datasets are often more challenging 
# to obtain (for instance, if a parolee had a 10-year term, it might require tracking that 
# individual for 10 years before building the model). Such a prospective analysis would not 
# be possible using the 2004 National Corrections Reporting Program dataset.

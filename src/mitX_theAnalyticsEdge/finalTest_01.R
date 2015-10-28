# Read in dataset
Airlines <- read.csv("AirlineDelay.csv")

# Randomly split data
set.seed(15071)
spl <- sample(nrow(Airlines), 0.7 * nrow(Airlines))
AirlinesTrain <- Airlines[spl,]
AirlinesTest <- Airlines[-spl,]

nrow(AirlinesTrain)
nrow(AirlinesTest)

# Regression model to predict wins
totalDelay_lm = lm(TotalDelay ~ ., data=AirlinesTrain)
summary(totalDelay_lm)

cor(AirlinesTrain$NumPrevFlights, AirlinesTrain$PrevFlightGap)
cor(AirlinesTrain$OriginAvgWind, AirlinesTrain$OriginWindGust)

predictions <- predict(totalDelay_lm, newdata = AirlinesTest)
SSE <- sum((predictions - AirlinesTest$TotalDelay)^2)
SST <- sum((mean(AirlinesTrain$TotalDelay) - AirlinesTest$TotalDelay)^2)
R2 <- 1 - SSE/SST


Airlines$DelayClass = factor(ifelse(Airlines$TotalDelay == 0, "No Delay", ifelse(Airlines$TotalDelay >= 30, "Major Delay", "Minor Delay")))
table(Airlines$DelayClass)
Airlines$TotalDelay = NULL

library(caTools)
set.seed(15071)
split = sample.split(Airlines$DelayClass, SplitRatio = 0.7)
split

# Create training and testing sets
dataTrain = subset(Airlines, split == TRUE)
dataTest = subset(Airlines, split == FALSE)

library(rpart)
library(rpart.plot)

# CART model
dataTree = rpart(DelayClass ~ ., method="class", data = dataTrain)
prp(dataTree)
# Make predictions
PredictCART = predict(dataTree, newdata = dataTest, type = "class")
table(dataTest$DelayClass, PredictCART)
(0+153+1301)/(0+153+1301+141+338+776+105)

table(dataTrain$DelayClass)
3282/nrow(dataTrain)


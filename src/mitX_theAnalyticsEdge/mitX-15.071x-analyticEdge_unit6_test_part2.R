# MARKET SEGMENTATION FOR AIRLINES
# 
# Market segmentation is a strategy that divides a broad target market of customers 
# into smaller, more similar groups, and then designs a marketing strategy 
# specifically for each group. Clustering is a common technique for market 
# segmentation since it automatically finds similar groups given a data set. 
# 
# In this problem, we'll see how clustering can be used to find similar groups of 
# customers who belong to an airline's frequent flyer program. The airline is trying 
# to learn more about its customers so that it can target different customer segments
# with different types of mileage offers. 
# 
# The file AirlinesCluster.csv contains information on 3,999 members of the frequent
# flyer program. This data comes from the textbook "Data Mining for Business
# Intelligence," by Galit Shmueli, Nitin R. Patel, and Peter C. Bruce. For more
# information, see the website for the book.
# 
# There are seven different variables in the dataset, described below:
#     
# Balance = number of miles eligible for award travel
# QualMiles = number of miles qualifying for TopFlight status
# BonusMiles = number of miles earned from non-flight bonus transactions in the past 12 months
# BonusTrans = number of non-flight bonus transactions in the past 12 months
# FlightMiles = number of flight miles in the past 12 months
# FlightTrans = number of flight transactions in the past 12 months
# DaysSinceEnroll = number of days since enrolled in the frequent flyer program

# PROBLEM 1.1 - NORMALIZING THE DATA  (2 points possible)
# Read the dataset AirlinesCluster.csv into R and call it "airlines".
# 
# Looking at the summary of airlines, which TWO variables have (on average) the 
# smallest values?
airlines <- read.csv("AirlinesCluster.csv", header = TRUE)
summary(airlines)
head(sort(colMeans(airlines)))

# FlightTrans      BonusTrans       QualMiles     FlightMiles 
# 1.373593       11.601900      144.114529      460.055764 
# DaysSinceEnroll      BonusMiles 
# 4118.559390    17144.846212 

#Min -> FlightTrans & BonusTrans
tail(sort(colMeans(airlines)))
#Max -> BonusMiles & Balance

# PROBLEM 1.2 - NORMALIZING THE DATA  (1 point possible)
# In this problem, we will normalize our data before we run the clustering 
# algorithms. Why is it important to normalize the data before clustering?

# If we don't normalize the data, the clustering will be dominated by the variables
# that are on a larger scale.

# EXPLANATION
# If we don't normalize the data, the variables that are on a larger scale will 
# contribute much more to the distance calculation, and thus will dominate the
# clustering.

# PROBLEM 1.3 - NORMALIZING THE DATA  (2 points possible)
# Let's go ahead and normalize our data. You can normalize the variables in a 
# data frame by using the preProcess function in the "caret" package. You should
# already have this package installed from Week 4, but if not, go ahead and install
# it with install.packages("caret"). Then load the package with library(caret).
# 
# Now, create a normalized data frame called "airlinesNorm" by running the 
# following commands:
# 
# preproc = preProcess(airlines)
# airlinesNorm = predict(preproc, airlines)
# 
# The first command pre-processes the data, and the second command performs the 
# normalization. If you look at the summary of airlinesNorm, you should see that
# all of the variables now have mean zero. You can also see that each of the 
# variables has standard deviation 1 by using the sd() function.
# 
# In the normalized data, which variable has the largest maximum value?
library(caret)
preproc <- preProcess(airlines)
airlinesNorm <- predict(preproc, airlines)
summary(airlinesNorm)
apply(airlinesNorm, 2, sd);sd(airlinesNorm$Balance)
apply(airlinesNorm, 2, max) # -> FlightMiles
apply(airlinesNorm, 2, min) # -> DaysSinceEnroll


# PROBLEM 2.1 - HIERARCHICAL CLUSTERING  (1 point possible)
# Compute the distances between data points (using euclidean distance) and then run 
# the Hierarchical clustering algorithm (using method="ward.D") on the normalized
# data. It may take a few minutes for the commands to finish since the dataset has
# a large number of observations for hierarchical clustering.
# 
# Then, plot the dendrogram of the hierarchical clustering process. Suppose the 
# airline is looking for somewhere between 2 and 10 clusters. According to the 
# dendrogram, which of the following is NOT a good choice for the number of clusters?

distance <- dist(airlinesNorm, method = "euclidean")
hclustAirlinesNorm <- hclust(distance, method = "ward.D")
plot(hclustAirlinesNorm)

# EXPLANATION
# You can plot the dendrogram with the command:
#     
#     plot(hierClust)
# 
# If you run a horizontal line down the dendrogram, you can see that there is a 
# long time that the line crosses 2 clusters, 3 clusters, or 7 clusters. However,
# it it hard to see the horizontal line cross 6 clusters. This means that 6 
# clusters is probably not a good choice.

# PROBLEM 2.2 - HIERARCHICAL CLUSTERING  (1 point possible)
# Suppose that after looking at the dendrogram and discussing with the marketing 
# department, the airline decides to proceed with 5 clusters. Divide the data 
# points into 5 clusters by using the cutree function. 
# How many data points are in Cluster 1?

clusterGroups <- cutree(hclustAirlinesNorm, k = 5)
table(clusterGroups) # 776

# PROBLEM 2.3 - HIERARCHICAL CLUSTERING  (2 points possible)
# Now, use tapply to compare the average values in each of the variables for the
# 5 clusters (the centroids of the clusters). You may want to compute the average
# values of the unnormalized data so that it is easier to interpret. You can do 
# this for the variable "Balance" with the following command:
#     
#     tapply(airlines$Balance, clusterGroups, mean)
# 
# Compared to the other clusters, Cluster 1 has the largest average values in 
# which variables (if any)? Select all that apply.

sort(tapply(airlines$Balance, clusterGroups, mean))
sort(tapply(airlines$QualMiles, clusterGroups, mean))
sort(tapply(airlines$BonusMiles, clusterGroups, mean))
sort(tapply(airlines$BonusTrans, clusterGroups, mean))
sort(tapply(airlines$FlightMiles, clusterGroups, mean))
sort(tapply(airlines$FlightTrans, clusterGroups, mean))
sort(tapply(airlines$DaysSinceEnroll, clusterGroups, mean))

# Advanced Explanation:
# Instead of using tapply, you could have alternatively used colMeans and 
# subset, as follows:
    
colMeans(subset(airlines, clusterGroups == 1))
colMeans(subset(airlines, clusterGroups == 2))
colMeans(subset(airlines, clusterGroups == 3))
colMeans(subset(airlines, clusterGroups == 4))
colMeans(subset(airlines, clusterGroups == 5))

# This only requires 5 lines of code instead of the 7 above. But an even more 
# compact way of finding the centroids would be to use the function "split" 
# to first split the data into clusters, and then to use the function "lapply" 
# to apply the function "colMeans" to each of the clusters:
    
lapply(split(airlines, clusterGroups), colMeans)

# In just one line, you get the same output as you do by running 7 lines like we 
# do above. To learn more about these functions, type ?split or ?lapply in your
# R console. Note that if you have a variable named split in your R session, you
# will need to remove it with rm(split) before you can use the split function.

# How would you describe the customers in Cluster 1?
# 
# EXPLANATION
# Cluster 1 mostly contains customers with few miles, but who have been with the
# airline the longest.

# PROBLEM 3.1 - K-MEANS CLUSTERING  (1 point possible)
# Now run the k-means clustering algorithm on the normalized data, again creating 5 clusters.
# Set the seed to 88 right before running the clustering algorithm, and set the 
# argument iter.max to 1000.
# 
# How many clusters have more than 1,000 observations?
set.seed(88)
KMC <- kmeans(airlinesNorm, centers = 5)
str(KMC)
table(KMC$cluster)

#  1    2    3    4    5 
# 408  141  993 1182 1275 

# PROBLEM 3.2 - K-MEANS CLUSTERING  (1 point possible)
# Now, compare the cluster centroids to each other either by dividing the data 
# points into groups and then using tapply, or by looking at the output of 
# kmeansClust$centers, where "kmeansClust" is the name of the output of the kmeans
# function. (Note that the output of kmeansClust$centers will be for the normalized data.
# If you want to look at the average values for the unnormalized data, you need 
# to use tapply like we did for hierarchical clustering.)
# 
# Do you expect Cluster 1 of the K-Means clustering output to necessarily be 
# similar to Cluster 1 of the Hierarchical clustering output?

colMeans(subset(airlines, clusterGroups == 1))
# Balance       QualMiles      BonusMiles      BonusTrans     FlightMiles     FlightTrans 
# 5.786690e+04    6.443299e-01    1.036012e+04    1.082345e+01    8.318428e+01    3.028351e-01 
# DaysSinceEnroll 
# 6.235365e+03 
KMC$centers
#        Balance   QualMiles BonusMiles BonusTrans FlightMiles FlightTrans DaysSinceEnroll
# 1  1.44439706  0.51115730  1.8769284  1.0331951   0.1169945   0.1444636       0.7198040
# 2  1.00054098  0.68382234  0.6144780  1.7214887   3.8559798   4.1196141       0.2742394
# 3 -0.05580605 -0.14104391  0.3041358  0.7108744  -0.1218278  -0.1287569      -0.3398209
# 4 -0.13331742 -0.11491607 -0.3492669 -0.3373455  -0.1833989  -0.1961819       0.9640923
# 5 -0.40579897 -0.02281076 -0.5816482 -0.7619054  -0.1989602  -0.2196582      -0.8897747

# EXPLANATION
# The clusters are not displayed in a meaningful order, so while there may be a cluster 
# produced by the k-means algorithm that is similar to Cluster 1 produced by the Hierarchical 
# method, it will not necessarily be shown first.




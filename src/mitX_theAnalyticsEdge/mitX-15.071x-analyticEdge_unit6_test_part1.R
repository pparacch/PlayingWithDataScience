# DOCUMENT CLUSTERING WITH DAILY KOS
# 
# Document clustering, or text clustering, is a very popular application of clustering algorithms. 
# A web search engine, like Google, often returns thousands of results for a simple query. For example, 
# if you type the search term "jaguar" into Google, around 200 million results are returned. This makes
# it very difficult to browse or find relevant information, especially if the search term has multiple 
# meanings. If we search for "jaguar", we might be looking for information about the animal, the car, or
# the Jacksonville Jaguars football team. 
# 
# Clustering methods can be used to automatically group search results into categories, making it easier
# to find relavent results. This method is used in the search engines PolyMeta and Helioid, as well as on
# FirstGov.gov, the official Web portal for the U.S. government. The two most common algorithms used for 
# document clustering are Hierarchical and k-means. 
# 
# In this problem, we'll be clustering articles published on Daily Kos, an American political blog that 
# publishes news and opinion articles written from a progressive point of view. Daily Kos was founded by 
# Markos Moulitsas in 2002, and as of September 2014, the site had an average weekday traffic of hundreds 
# of thousands of visits. 
# 
# The file dailykos.csv contains data on 3,430 news articles or blogs that have been posted on Daily Kos. 
# These articles were posted in 2004, leading up to the United States Presidential Election. The leading 
# candidates were incumbent President George W. Bush (republican) and John Kerry (democratic). Foreign 
# policy was a dominant topic of the election, specifically, the 2003 invasion of Iraq. 
# 
# Each of the variables in the dataset is a word that has appeared in at least 50 different articles 
# (1,545 words in total). The set of  words has been trimmed according to some of the techniques covered 
# in the previous week on text analytics (punctuation has been removed, and stop words have been removed). 
# For each document, the variable values are the number of times that word appeared in the document. 


# PROBLEM 1.1 - HIERARCHICAL CLUSTERING  (1 point possible)
# Let's start by building a hierarchical clustering model. First, read the data set into R. Then, compute the distances
# (using method="euclidean"), and use hclust to build the model (using method="ward.D"). You should cluster on all of 
# the variables.

# Running the dist function will probably take you a while. Why? Select all that apply.

dataRaw <- read.csv("dailykos.csv", header=TRUE) #3430 obs. and 1545 words
distance <- dist(dataRaw, method = "euclidean")

# EXPLANATION
# You can read in the data set, compute the distances, and build the hierarchical clustering model by using the following commands:
#   
#   dailykos = read.csv("dailykos.csv")
# 
# kosDist = dist(dailykos, method="euclidean")
# 
# kosHierClust = hclust(kosDist, method="ward.D")
# 
# The distance computation can take a long time if you have a lot of observations and/or if there are a lot of variables. As we saw in
# recitation, it might not even work if you have too many of either!

# PROBLEM 1.2 - HIERARCHICAL CLUSTERING  (1 point possible)
# Plot the dendrogram of your hierarchical clustering model. Just looking at the dendrogram, which of the following seem like good choices
# for the number of clusters? Select all that apply. -> 2 & 3

hierClust <- hclust(distance, method="ward.D")
plot(hierClust)

# EXPLANATION
# You can plot the dendrogram with the command:
#   
#   plot(kosHierClust)
# 
# where "kosHierClust" is the name of your clustering model.
# 
# The choices 2 and 3 are good cluster choices according to the dendrogram, because there is a lot of space between the horizontal lines 
# in the dendrogram in those cut off spots (draw a horizontal line across the dendrogram where it crosses 2 or 3 vertical lines). The choices
# of 5 and 6 do not seem good according to the dendrogram because there is very little space.

# PROBLEM 1.3 - HIERARCHICAL CLUSTERING  (1 point possible)
# In this problem, we are trying to cluster news articles or blog posts into groups. This can be used to show readers categories to choose 
# from when trying to decide what to read. Just thinking about this application, what are good choices for the number of clusters? Select 
# all that apply. -> 7 & 8

# EXPLANATION
# Thinking about the application, it is probably better to show the reader more categories than 2 or 3. These categories would probably be too
# broad to be useful. Seven or eight categories seems more reasonable.

# PROBLEM 1.4 - HIERARCHICAL CLUSTERING  (3 points possible)
# Let's pick 7 clusters. This number is reasonable according to the dendrogram, and also seems reasonable for the application. 
# Use the cutree function to split your data into 7 clusters.
# 
# Now, we don't really want to run tapply on every single variable when we have over 1,000 different variables. Let's instead use the subset 
# function to subset our data by cluster. Create 7 new datasets, each containing the observations from one of the clusters.
# 
# How many observations are in cluster 3?

clusterGroups <- cutree(hierClust, k = 7)
cluster1 <- subset(dataRaw, clusterGroups == 1)
cluster2 <- subset(dataRaw, clusterGroups == 2)
cluster3 <- subset(dataRaw, clusterGroups == 3)
cluster4 <- subset(dataRaw, clusterGroups == 4)
cluster5 <- subset(dataRaw, clusterGroups == 5)
cluster6 <- subset(dataRaw, clusterGroups == 6)
cluster7 <- subset(dataRaw, clusterGroups == 7)

dim(cluster1)
dim(cluster2)
dim(cluster3) #-> 374
dim(cluster4)
dim(cluster5)
dim(cluster6)
dim(cluster7)

#min -> 4. 139
#max -> 1. 1266

# More Advanced Approach:  
# There is a very useful function in R called the "split" function. Given a vector assigning groups like hierGroups, you could split 
# dailykos into the clusters by typing:
#   
#   HierCluster = split(dailykos, hierGroups)
# 
# Then cluster 1 can be accessed by typing HierCluster[[1]], cluster 2 can be accessed by typing HierCluster[[2]], etc. If you have a 
# variable in your current R session called "split", you will need to remove it with rm(split) before using the split function.

# PROBLEM 1.5 - HIERARCHICAL CLUSTERING  (1 point possible)
# Instead of looking at the average value in each variable individually, we'll just look at the top 6 words in each cluster. 
# To do this for cluster 1, type the following in your R console (where "HierCluster1" should be replaced with the name of your
# first cluster subset):

# tail(sort(colMeans(cluster1)))

# This computes the mean frequency values of each of the words in cluster 1, and then outputs the 6 words that occur the most frequently. 
# The colMeans function computes the column (word) means, the sort function orders the words in increasing order of the mean values, 
# and the tail function outputs the last 6 words listed, which are the ones with the largest column means.

# What is the most frequent word in this cluster, in terms of average value? 
# Enter the word exactly how you see it in the output: bush

tail(sort(colMeans(cluster1)))
tail(sort(colMeans(cluster2))) # -> november, poll, vote, challenge
tail(sort(colMeans(cluster3)))
tail(sort(colMeans(cluster4)))
tail(sort(colMeans(cluster5))) # iraq WAR
tail(sort(colMeans(cluster6)))
tail(sort(colMeans(cluster7))) # democratic nomination

# You can see that the words that best describe Cluster 2 are november, poll, vote, and challenge. The most common words in Cluster 5 
# are bush, iraq, war, and administration, so it is the cluster that can best be described as corresponding to the Iraq war. And the 
# most common words in Cluster 7 are dean, kerry, poll, and edward, so it looks like the democratic cluster.


# PROBLEM 2.1 - K-MEANS CLUSTERING  (3 points possible)
# Now, run k-means clustering, setting the seed to 1000 right before you run the kmeans function. Again, pick the number of clusters equal
# to 7. You don't need to add the iters.max argument.
# 
# Subset your data into the 7 clusters (7 new datasets) by using the "cluster" variable of your kmeans output.
# 
# How many observations are in Cluster 3?

set.seed(1000)
KMC <- kmeans(dataRaw, centers = 7)
str(KMC)
# Extract clusters
dataClusters <- KMC$cluster
table(dataClusters)
# dataClusters
# 1    2    3    4    5    6    7 
# 146  144  277 2063  163  329  308 

# EXPLANATION
# You can run k-means clustering by using the following commands:
#   set.seed(1000)
# KmeansCluster = kmeans(dailykos, centers=7)
# 
# Then, you can subset your data into the 7 clusters by using the following commands:
#   
# KmeansCluster1 = subset(dailykos, KmeansCluster$cluster == 1)
# KmeansCluster2 = subset(dailykos, KmeansCluster$cluster == 2)
# KmeansCluster3 = subset(dailykos, KmeansCluster$cluster == 3)
# KmeansCluster4 = subset(dailykos, KmeansCluster$cluster == 4)
# KmeansCluster5 = subset(dailykos, KmeansCluster$cluster == 5)
# KmeansCluster6 = subset(dailykos, KmeansCluster$cluster == 6)
# KmeansCluster7 = subset(dailykos, KmeansCluster$cluster == 7)
# 
# Alternatively, you could answer these questions by looking at the output of table(KmeansCluster$cluster).
# 
# More Advanced Approach:
# There is a very useful function in R called the "split" function. Given a vector assigning groups like KmeansCluster$cluster, 
# you could split dailykos into the clusters by typing:
#   
# KmeansCluster = split(dailykos, KmeansCluster$cluster)
# 
# Then cluster 1 can be accessed by typing KmeansCluster[[1]], cluster 2 can be accessed by typing KmeansCluster[[2]], etc. If you have
# a variable in your current R session called "split", you will need to remove it with rm(split) before using the split function.

# PROBLEM 2.2 - K-MEANS CLUSTERING  (2 points possible)
# Now, output the six most frequent words in each cluster, like we did in the previous problem, for each of the k-means clusters.
# 
# Which k-means cluster best corresponds to the Iraq War?

KmeansCluster1 = subset(dataRaw, KMC$cluster == 1)
KmeansCluster2 = subset(dataRaw, KMC$cluster == 2)
KmeansCluster3 = subset(dataRaw, KMC$cluster == 3)
KmeansCluster4 = subset(dataRaw, KMC$cluster == 4)
KmeansCluster5 = subset(dataRaw, KMC$cluster == 5)
KmeansCluster6 = subset(dataRaw, KMC$cluster == 6)
KmeansCluster7 = subset(dataRaw, KMC$cluster == 7)

tail(sort(colMeans(KmeansCluster1)))
tail(sort(colMeans(KmeansCluster2))) #dEMOCRATIC pARTY
tail(sort(colMeans(KmeansCluster3))) # Iraq War
tail(sort(colMeans(KmeansCluster4)))
tail(sort(colMeans(KmeansCluster5)))
tail(sort(colMeans(KmeansCluster6)))
tail(sort(colMeans(KmeansCluster7)))

# By looking at the output, you can see that the cluster best correponding to the Iraq War is cluster 3 
# (top words are iraq, war, and bush) and the cluster best corresponding to the democratic party is cluster 2 
# (top words dean, kerry, clark, and edward).

# PROBLEM 2.4 - K-MEANS CLUSTERING  (1/1 point)
# Which Hierarchical Cluster best corresponds to K-Means Cluster 3? -> cluster5 see below

tail(sort(colMeans(cluster5)))
#or
table(clusterGroups, KMC$cluster)

# clusterGroups / K-means   
#     1    2    3    4    5    6    7
# 1    3   11   64 1045   32    0  111
# 2    0    0    0    0    0  320    1
# 3   85   10   42   79  126    8   24
# 4   10    5    0    0    1    0  123
# 5   48    0  171  145    3    1   39
# 6    0    2    0  712    0    0    0
# 7    0  116    0   82    1    0   10

# EXPLANATION
# From "table(hierGroups, KmeansCluster$cluster)", we read that 171 (61.7%) of the observations in K-Means Cluster 3 also fall in 
# Hierarchical Cluster 5.

# PROBLEM 2.5 - K-MEANS CLUSTERING  (1 point possible)
# Which Hierarchical Cluster best corresponds to K-Means Cluster 7?

#see table above

tail(sort(colMeans(KmeansCluster7)))
tail(sort(colMeans(cluster4)))
# No Hierarchical Cluster contains at least half of the points in K-Means Cluster 7. 
# From "table(hierGroups, KmeansCluster$cluster)", we read that no more than 123 (39.9%) of the observations in K-Means Cluster 
# 7 fall in any hierarchical cluster.
 

# PROBLEM 2.6 - K-MEANS CLUSTERING  (1 point possible)
# Which Hierarchical Cluster best corresponds to K-Means Cluster 6?

#see table above # 2
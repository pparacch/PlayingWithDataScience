#Hierarchical clusring

set.seed(1234)
par(mar = c(4,4,4,4))

x <- rnorm(12, mean = rep(1:3, each = 4), sd= 0.2)
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)

plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

##calculate the distance between the different points
data <- data.frame(x = x, y = y)
data_dist <- dist(data)
#This function computes and returns the distance matrix computed
#by using the specified distance measure to compute the distances
#between the rows of a data matrix. By default "euclidean"
hClustering <- hclust(data_dist)
plot(hClustering)

#HeatMaps
#A heatmap is a literal way of visualizing a table of numbers,
#where you substitute the numbers with colored cells.
set.seed(145)
data_matrix <- as.matrix(data)[sample(1:12),]
heatmap(data_matrix)

data_matrix_2 <- as.matrix(data)
heatmap(data_matrix_2, Colv = NA, col = cm.colors(256))#No dendrogram, No reordering

#K-means Clustering
#Generate the data
set.seed(1234)
par(mar = c(4,4,4,4,))
x <- rnorm(12, mean = rep(1:3, each = 4), sd= 0.2)
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)

plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))


data_1 <- data.frame(x = x, y = y)
kmeansObj <- kmeans(data_1, centers = 3)
names(kmeansObj)

par(mar = rep(4, 4))
plot(x, y, col = kmeansObj$cluster, pch = 19, cex = 2)
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 2, lwd = 3)

#Using heatmaps
set.seed(1234)
data_1_matrix <- as.matrix(data_1)[sample(1:12),]
kmeansObj2 <- kmeans(data_1_matrix, centers = 3)

par(mfrow = c(1,2), mar = rep(4,4))
image(t(data_1_matrix)[, nrow(data_1_matrix):1], yaxt = "n")
image(t(data_1_matrix)[, order(kmeansObj2$cluster)], yaxt = "n")
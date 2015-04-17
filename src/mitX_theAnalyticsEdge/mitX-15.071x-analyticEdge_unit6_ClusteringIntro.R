# Unit 6 - Introduction to Clustering

# Video 6

# Now, to load our data, we'll be using a slightly different
# command this time.
# Our data is not a CSV file.
# It's a text file, where the entries
# are separated by a vertical bar.
# So we'll call our data set movies,
# and then we'll use the read.table function, where
# the first argument is the name of our data set in quotes.
# The second argument is header=FALSE.
# This is because our data doesn't have
# a header or a variable name row.
# And then the next argument is sep="|" ,
# which can be found above the Enter key on your keyboard.
# We need one more argument, which is quote="\"".
# 
# Close the parentheses, and hit Enter.
# That last argument just made sure that our text
# was read in properly.
# After following the steps in the video, load the data into R
movies = read.table("movieLens.txt", header=FALSE, sep="|",quote="\"")

# Let's take a look at the structure of our data
# using the str function.
str(movies)

# We have 1,682 observations of 24 different variables.
# Since our variables didn't have names, header equaled false,
# R just labeled them with V1, V2, V3, etc.
# But from the Movie Lens documentation,
# we know what these variables are.
# So we'll go ahead and add in the column names ourselves.
# To do this, start by typing colnames, for column names,
# and then in parentheses, the name of our data
# set, movies, and then equals, and we'll
# use the c function, where we're going
# to list all of the variable names,
# each of them in double quotes and separated by commas.
# So first, we have "ID", the ID of the movie, then "Title",
# "ReleaseDate", "VideoReleaseDate", "IMDB",
# "Unknown"-- this is the unknown genre--
#   and then our 18 other genres-- "Action", "Adventure",
# "Animation", "Childrens, "Comedy", "Crime",
# "Documentary", "Drama", "Fantasy", "FilmNoir",
# "Horror", "Musical", "Mystery", "Romance", "SciFi", "Thriller",
# "War", and "Western".
# 
# Go
# ahead and close the parentheses, and hit Enter.

# Add column names
colnames(movies) = c("ID", "Title", "ReleaseDate", "VideoReleaseDate", "IMDB", "Unknown", "Action", "Adventure", "Animation", "Childrens", "Comedy", "Crime", "Documentary", "Drama", "Fantasy", "FilmNoir", "Horror", "Musical", "Mystery", "Romance", "SciFi", "Thriller", "War", "Western")

# Let's see what our data looks like now
# using the str function again.
# We can see that we have the same number of observations
# and the same number of variables, but each of them
# now has the name that we just gave.
str(movies)

# We won't be using the ID, release date, video release
# date, or IMDB variables,
# so let's go ahead and remove them.
# To do this, we type the name of our data set-- movies$--
#   the name of the variable we want to remove,
# and then just say =NULL, in capital letters.
# This will just remove the variable from our data set.
# Let's repeat this with ReleaseDate, VideoReleaseDate,
# and IMDB.

# Remove unnecessary variables
movies$ID = NULL
movies$ReleaseDate = NULL
movies$VideoReleaseDate = NULL
movies$IMDB = NULL

str(movies)

# And there are a few duplicate entries in our data set,
# so we'll go ahead and remove them with the unique function.
# So just type the name of our data
# set, movies = unique(movies).

# Remove duplicates
movies = unique(movies)

# Take a look at our data again:
str(movies)

# Now, we have 1,664 observations, a few less than before,
# and 20 variables-- the title of the movie, the unknown genre
# label, and then the 18 other genre labels.
# In this video, we've seen one example
# of how to prepare data taken from the internet
# to work with it in R.
# In the next video, we'll use this data
# set to cluster our movies using hierarchical clustering.

# entries
sum(movies$Comedy) # -> 502
sum(movies$Western) # -> 27
sum(movies$Romance & movies$Drama) # -> 97

# Video 7
# In this video we'll use hierarchical clustering
# to cluster the movies in the Movie Lens data set by genre.
# After we make our clusters, we'll
# see how they can be used to make recommendations.
# There are two steps to hierarchical clustering.
# First we have to compute the distances between all data
# points,
# and then we need to cluster the points.
# To compute the distances we can use the dist function.
# We only want to cluster our movies on the genre variable,
# not on the title variable, so we'll cluster on columns two
# through 20.

# So let's call the output distances,
# and we'll use the dist function, where the first argument is
# movies[2:20], this is what we want to cluster on,
# and the second argument is method="euclidean",
# meaning that we want to use euclidean distance.

# Compute distances
distances = dist(movies[2:20], method = "euclidean")


# Now let's cluster our movies using the hclust function
# for hierarchical clustering.
# We'll call the output clusterMovies,
# and use hclust where the first argument is distances,
# the output of the dist function.
# And the second argument is method="ward.D".

# Hierarchical clustering
clusterMovies = hclust(distances, method = "ward.D") 

# The ward method cares about the distance between clusters using
# centroid distance, and also the variance in each
# of the clusters.
# Now let's plot the dendrogram of our clustering algorithm
# by typing plot, and then in parentheses clusterMovies.

# Plot the dendrogram
plot(clusterMovies)

# This dendrogram might look a little strange.
# We have all this black along the bottom.
# Remember that the dendrogram lists
# all of the data points along the bottom.
# But when there are over 1,000 data points
# it's impossible to read.
# We'll see later how to assign our clusters to groups so
# that we can analyze which data points are in which cluster.
# So looking at this dendrogram, how many clusters
# would you pick?
# It looks like maybe three or four clusters
# would be a good choice according to the dendrogram,
# but let's keep our application in mind, too.
# We probably want more than two, three, or even four clusters
# of movies to make recommendations to users.
# It looks like there's a nice spot
# down here where there's 10 clusters.
# This is probably better for our application.
# We could select even more clusters
# if we want to have very specific genre groups.
# If you want a lot of clusters it's
# hard to pick the right number from the dendrogram.
# You need to use your understanding of the problem
# to pick the number of clusters.
# Let's stick with 10 clusters for now,
# combining what we learned from the dendrogram
# with our understanding of the problem.
# Now back in our R console we can label each of the data points
# according to what cluster it belongs
# to using the cutree function.
# So let's type clusterGroups = cutree(clusterMovies,k=10)


# Assign points to clusters
clusterGroups = cutree(clusterMovies, k = 10)


# Now let's figure out what the clusters are like.
# We'll use the tapply function to compute
# the percentage of movies in each genre and cluster.
# So let's type tapply, and then give as the first argument,
# movies$Action-- we'll start with the action genre--
#   and then clusterGroups, and then mean.
# So what does this do?
# It divides our data points into the 10 clusters
# and then computes the average value
# of the action variable for each cluster.
# Remember that the action variable
# is a binary variable with value 0 or 1.
# So by computing the average of this variable
# we're computing the percentage of movies
# in that cluster that belong in that genre.
# So we can see here that in cluster 2, about 78%
# of the movies have the action genre
# label, whereas in cluster 4 none of the movies
# are labeled as action movies.
# Let's try this again, but this time
# let's look at the romance genre.

# Let's use the tapply function to compute the percentage of movies in each genre and cluster

tapply(movies$Action, clusterGroups, mean)
tapply(movies$Romance, clusterGroups, mean)

# We can repeat this for each genre. If you do, you get the results in ClusterMeans.ods

# Here we have in each column the cluster,
# and in each row the genre.
# I highlighted the cells that have
# a higher than average value.
# So we can see here in cluster 2, as we saw before,
# that cluster 2 has a high number of action movies.
# Cluster 1 has a little bit of everything, some animation,
# children's, fantasy, musicals, war and westerns.
# So I'm calling this the miscellaneous cluster.
# Cluster 2 has a lot of the action, adventure,
# and sci-fi movies.
# Cluster 3 has the crime, mystery, thriller movies.
# Cluster 4 exclusively has drama movies.
# Cluster 5, exclusively has comedies.
# Cluster 6 has a lot of the romance movies.
# Cluster 7 has movies that are comedies and romance movies,
# so I'm calling these the romantic comedies.
# Cluster 8 has the documentaries.
# Cluster 9 has the movies that are comedies and dramas,
# so the dramatic comedies.
# And cluster 10 has the horror flicks.
# Knowing common movie genres, these clusters
# seem to make a lot of sense.
# So now, back in our R console, let's see
# how these clusters could be used in a recommendation system.


# Remember that Amy liked the movie Men in Black.
# Let's figure out what cluster Men in Black is in.
# We'll use the subset function to take a subset of movies
# and only look at the movies where the Title="Men in Black
# (1997)".
# Close the quotes in the parentheses.
# I knew that this is the title of Men in Black
# because I looked it up in our data set.
# So it looks like Men in Black is the 257th row in our data.
# So which cluster did the 257th movie go into?
# We can figure this out by typing clusterGroups[257].

# Find which cluster Men in Black is in.
subset(movies, Title=="Men in Black (1997)")
clusterGroups[257]

# It looks like Men in Black went into cluster 2.
# That make sense since we just saw
# that cluster 2 is the action, adventure, sci-fi cluster.
# So let's create a new data set with just
# the movies from cluster two.
# We'll call it cluster2, and use the subset function
# to take a subset of movies only taking
# the observations for which clusterGroups is equal to 2.

# Create a new data set with just the movies from cluster 2
cluster2 = subset(movies, clusterGroups==2)

# Let's look at the first 10 titles in this cluster.
# We can do this by typing cluster2$Title[1:10].
# 
# So it looks like good movies to recommend to Amy,
# according to our clustering algorithm,
# would be movies like Apollo 13 and Jurassic Park.
# In this video we saw how clustering
# can be applied to create a movie recommendation system.
# In the next video, we'll conclude
# by learning who ended up winning the million dollar Netflix
# prize.

# Look at the first 10 titles in this cluster:
cluster2$Title[1:10]


# Run the cutree function again to create the cluster groups, but this time pick k = 2 clusters. 
# It turns out that the algorithm groups all of the movies that only belong to one specific genre 
# in one cluster (cluster 2), and puts all of the other movies in the other cluster (cluster 1). 
# What is the genre that all of the movies in cluster 2 belong to?
clusterGroups2 <- cutree(clusterMovies, k = 2)

tapply(movies$Unknown, clusterGroups2, mean)
tapply(movies$Action, clusterGroups2, mean)
tapply(movies$Adventure, clusterGroups2, mean)
tapply(movies$Animation, clusterGroups2, mean)
tapply(movies$Childrens, clusterGroups2, mean)
tapply(movies$Comedy, clusterGroups2, mean)
tapply(movies$Crime, clusterGroups2, mean)
tapply(movies$Documentary, clusterGroups2, mean)
tapply(movies$Drama, clusterGroups2, mean)
tapply(movies$Fantasy, clusterGroups2, mean)
tapply(movies$FilmNoir, clusterGroups2, mean)
tapply(movies$Horror, clusterGroups2, mean)
tapply(movies$Musical, clusterGroups2, mean)
tapply(movies$Mystery, clusterGroups2, mean)
tapply(movies$Romance, clusterGroups2, mean)
tapply(movies$SciFi, clusterGroups2, mean)
tapply(movies$Thriller, clusterGroups2, mean)
tapply(movies$War, clusterGroups2, mean)
tapply(movies$Western, clusterGroups2, mean)

#Alternatively, you can use colMeans or lapply as explained below Video 7.

# spl = split(movies[2:20], clusterGroups)
# 
# Then you can use spl to access the different clusters, because
# 
# spl[[1]]
# 
# is the same as
# 
# subset(movies[2:20], clusterGroups == 1)
# 
# so colMeans(spl[[1]]) will output the centroid of cluster 1. But an even easier approach uses the
# lapply function. The following command will output the cluster centroids for all clusters:
#   
#   lapply(spl, colMeans)
# 
# The lapply function runs the second argument (colMeans) on each element of the first argument 
# (each cluster subset in spl). So instead of using 19 tapply commands, or 10 colMeans commands, we can
# output our centroids with just two commands: one to define spl, and then the lapply command.
# 
# Note that if you have a variable called "split" in your current R session, you will need to remove it
# with rm(split) so that you can use the split function.
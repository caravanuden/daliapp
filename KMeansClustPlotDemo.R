#
# KMeansClustPlotDemo.R
# Demo of graphing kmeans clustering for iris dataset
# Used in OncoDataExplorer app at Celgene
#
# Created by Cara Van Uden, 07/15/16
# 

library(ggplot2)

# copy the iris data set to a separate data frame (iris is a demo dataset in R)
# unnecessary, but makes it easier for me to reflexively enter df whenever the data frame is in view
df = iris

# create a matrix object containing only the Petal Length and Width.
m = as.matrix(cbind(df$Petal.Length, df$Petal.Width),ncol = 2)

# doing the actual kmeans clustering
cl = (kmeans(m,3))


# a bit of data formatting and preparation for subsequent calls to graph the data

# add the cluster information back to our original data frame; requirement for working with ggplot2 which is designed to use data frames
df$cluster = factor(cl$cluster)
centers = as.data.frame(cl$centers)

# this graph color codes the points by cluster
# also add the centers and a semi transparent halo around the center to emphasize the place of the center and its role in classifying the observations into clusters
ggplot(data = df, aes(x = Petal.Length, y = Petal.Width, color = cluster )) + 
 geom_point() + 
 geom_point(data = centers, aes(x = V1,y = V2, color='Center')) +
 geom_point(data = centers, aes(x = V1,y = V2, color = 'Center'), size = 52, alpha = .3, legend = FALSE)

# there are misclassified observations - kmeans is pretty accurate, but not perfect

# this SQL statement highlights the misclassified observations
sqldf('select Species, cluster, count(*) from df group by Species, Cluster')

# pull the outliers into their own data frame
df2 = sqldf('select * from df where (Species || cluster) in 
             (select Species || cluster from df group by Species, Cluster having count(*) < 10)')

# enhance the previous graph by putting a diamond around misclassified points.
last_plot() +  geom_point(data = df2, aes(x = Petal_Length, y = etal_Width, shape = 5, alpha = .7, size = 4.5), legend = FALSE) 
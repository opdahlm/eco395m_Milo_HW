---
title: "Exercise 4"
author: "Milo Opdahl"
date: "April 18, 2019"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Clustering & PCA

```{r wine, include=FALSE}
library(ISLR)
library(tidyverse)
library(ggplot2)
library(psych)
library(xtable)

wine=read.csv("D:/School Stuff/Graduate School/DMDS/ECO395M/data/wine.csv")
summary(wine)
head(wine)

# Let's try PCA

z=wine[,c(1:9)]
z_std = scale(z, center=TRUE, scale=TRUE) # Standardized
plot(z_std)

x_wine = as.matrix(wine[,1:11])
y_wine_quality= wine[,12]
y_wine_color= wine[,13]

pc1 = prcomp(x_wine, scale=TRUE)
summary(pc1)
plot(pc1)

K = 3
scores = pc1$x[,1:K]
pcr1 = lm(y_wine_quality ~ scores)

```

# PCA
  
  To properly analyze the data in 'wine.csv', we will need to use a dimensionality-reduction technique.  First, let's try Principal Components Analysis.

```{r summary of pca, results = 'asis',echo=FALSE}
print(xtable(summary(pcr1)),comment=FALSE)

```

From the PCA regression, there are three PCA components that capture significant observations in the data.  Now let's make a matrix.
```{r matrix plot,echo=FALSE}
# fancy plot matrix
pairs.panels(z_std[,1:6], 
             method = "pearson", # correlation method
             hist.col = "#00AFBB",
             density = TRUE,  # show density plots
             ellipses = TRUE # show correlation ellipses
)
```

In the bi-variate scatter plots, we find a visual correlation between different variables. By utilizing PCA we can safely presume that linear combinations of similar variables would be a suitable approach in decomposing the data to a handful of variables.

While in the histograms on the diagonal, we see that once we normalize the underlying dataset, we would have a large concentration of values in the left hand side of the total range. Further supporting the notion that there is high correlation of similar wines.

Lastly, in the Pearson correlation, the rather low (relative to zero) values hints that there is little support for multicollinearity among the variables. Ultimately, PCA is one of two approaches we used to understand the data.

So how do each of the principle components match to one another?  The answer is the following:

```{r, echo=FALSE}
par(mfrow=c(2,2))
plot(fitted(pcr1), y_wine_quality, main="Wine Quality and PC 1", ylab = "Wine Quality",xlab = "Estimated Wine Quality from PCA")
plot(seq(1,11,by=1), pc1$rotation[,1], main="Coefficients of PC 1", ylab = "PC 1 Effects",xlab = "PC Input Variables")
plot(seq(1,11,by=1), pc1$rotation[,2], main="Coefficients of PC 2", ylab = "PC 2 Effects",xlab = "PC Input Variables")
plot(seq(1,11,by=1), pc1$rotation[,3], main="Coefficients of PC 3", ylab = "PC 3 Effects",xlab = "PC Input Variables")
```
From this, we can see that PCA is not the right dimensionality-reduction technique to use, since each principle component has betas that scatter their points and lose any clear interpretation of the 'wine.csv' data.

# Clustering

Now, let's try clustering.

```{r clustering, include=FALSE}
library(ggplot2)
library(LICORS)  # for kmeans++
library(foreach)
library(mosaic)
library(gridExtra)
library(grid)

# Center and scale
x= wine[,c(1:9)]
x=scale(x, center=TRUE, scale=TRUE)

mu = attr(x,"scaled:center")
sigma = attr(x,"scaled:scale")

clust1 = kmeans(x, 2, nstart=25)

clust2 = kmeanspp(x, k=2, nstart=25)
```



```{r, echo=FALSE}
print("Cluster 1")
clust2$center[1,]*sigma + mu
print("Cluster 2")
clust2$center[2,]*sigma + mu
```

```{r, echo=FALSE}
qplot(fixed.acidity, volatile.acidity, data=wine, color=factor(clust2$cluster),main = "Volatile and Fixed Acidity by Wine Type")+
  labs(colour = "Wine Type")
```

\pagebreak

## Market Segmentation

\pagebreak

## Association Rules for Grocery Purchases

```{r, include=FALSE}
library(tidyverse)
library(arules)
library(arulesViz)
library(knitr)

grocery_raw = read.csv("D:/School Stuff/Graduate School/DMDS/ECO395M/data/groceries.txt", header = FALSE)
# Trip ID
grocery_raw$ID = seq.int(nrow(grocery_raw))
# Stack columns
grocery <- cbind(grocery_raw[,5], stack(lapply(grocery_raw[,1:4], as.character)))[1:2]
# Rename columns
colnames(grocery) <- c("ID","items")
# Aggregate and order by Trip ID
grocery <- grocery[order(grocery$ID),]
# Remove blanks
grocery <- grocery[!(grocery$items==""),]
# Renumber the rows
row.names(grocery) <- 1:nrow(grocery)
# turn IDs to factors 
grocery$ID = factor(grocery$ID)

# Create list of baskets - vectors of items by consumer
# # apriori algorithm expects a list of baskets in a special format
# In this case, one "basket" of items per user
# First split data into a list of grocery items for each user
g = split(x=grocery$items, f=grocery$ID)
# Take out any duplicates
g=lapply(g, unique)
# Create a special variable for each transaction
gtrans=as(g, "transactions")
summary(gtrans)

# Now set up the apriori algorithm!
# Then inspect the rules.
groceryrules = apriori(gtrans, 
	parameter=list(support=.01, confidence=.1, maxlen=4))
inspect(groceryrules)
# Finding some interesting rules...
inspect(subset(groceryrules, lift < 1))
inspect(subset(groceryrules, confidence > 0.3))
```

```{r plotting,include=FALSE}
par(mfrow=c(3,1)) 
plot(groceryrules)
plot(groceryrules, measure = c("support", "lift"), shading = "confidence")
plot(groceryrules, method='two-key plot')
```

  By setting up an apriori algorithm for the 'grocery' dataset, I was able to find a couple of interesting rules.  

# Lifts

  First, I checked out any lifts that caught my attention. I decided to check for any substitute goods, that is any rule that have a lift < 1.  The following rules are what I found:

```{r, echo=FALSE, results='asis'}
inspect(subset(groceryrules, lift < 1))
kable(inspect(subset(groceryrules, lift < 1)))
```

  With a lift of 0.942117, it appears that "rolls/buns" and "whole milk" are substitute goods.  In truth, this does not make much sense to me since there is little reason these products would be substitutes in the real world.  One possible explanation would be from a food culture standpoint.  Personally, with parents from the Midwestern US, bread and milk together are commonplace in a typical meal.  So perhaps this data from 'grocery' comes from another region of the world where milk and bread are less common to partake together in an average meal.

# Confidence

  Next, I checked out any interesting confidence levels.  For this, I simply wanted to see the highest confidence levels of rules, to see which goods were more likely to be bought together. What I found was the following:
  
```{r, echo=FALSE}
inspect(subset(groceryrules, confidence > 0.3))
kable(inspect(subset(groceryrules, confidence > 0.3)))
```

  With the highest confidence level of 0.4036697, it appears that when consumers bought "butter" they also bought "whole milk" in the same transaction.  This would make sense, since many baking and cooking recipes call for these two ingredients.  The same can be said about the rule regarding "curd" and "whole milk."  Most of the other rules are in regard to vegetables being bought together with other vegetables, or vegetables being bought together with whole milk.





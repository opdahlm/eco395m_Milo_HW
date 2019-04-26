---
title: "Question 3"
author: "Milo Opdahl"
date: "April 26, 2019"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Association Rules for Grocery Purchases

```{r grocery, include=FALSE, echo=FALSE}
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

  By setting up an apriori algorithm for the 'grocery' dataset, I was able to find a couple of interesting rules.  

# Lifts

  First, I checked out any lifts that caught my attention. I decided to check for any substitute goods, that is any rule that have a lift < 1.  The following rules are what I found:

```{r groceryrules, echo=FALSE}
inspect(subset(groceryrules, lift < 1))
kable(inspect(subset(groceryrules, lift < 1)))
```

  With a lift of 0.942117, it appears that "rolls/buns" and "whole milk" are substitute goods.  In truth, this does not make much sense to me since there is little reason these products would be substitutes in the real world.  One possible explanation would be from a food culture standpoint.  Personally, with parents from the Midwestern US, bread and milk together are commonplace in a typical meal.  So perhaps this data from 'grocery' comes from another region of the world where milk and bread are less common to partake together in an average meal.

# Confidence

  Next, I checked out any interesting confidence levels.  For this, I simply wanted to see the highest confidence levels of rules, to see which goods were more likely to be bought together. What I found was the following:
  
```{r groceryrules2, echo=FALSE}
inspect(subset(groceryrules, confidence > 0.3))
kable(inspect(subset(groceryrules, confidence > 0.3)))
```

  With the highest confidence level of 0.4036697, it appears that when consumers bought "butter" they also bought "whole milk" in the same transaction.  This would make sense, since many baking and cooking recipes call for these two ingredients.  The same can be said about the rule regarding "curd" and "whole milk."  Most of the other rules are in regard to vegetables being bought together with other vegetables, or vegetables being bought together with whole milk.


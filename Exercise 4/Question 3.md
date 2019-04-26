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

```{r grocery, include=FALSE}
library(arules)
library(arulesViz)

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
# Adjust support in order to find more rules.
groceryrules2 = apriori(gtrans, 
	parameter=list(support=.05, confidence=.1, maxlen=4))
# Finding some interesting rules...
inspect(subset(groceryrules2, lift < 1))
inspect(subset(groceryrules2, confidence > 0.3))
```

  By setting up an apriori algorithm for the 'grocery' dataset, I was able to find a couple of interesting rules.  

# Lifts

  First, I checked out any lifts that caught my attention. I decided to check for any substitute goods, that is any rule that have a lift < 1.  The following rules are what I found:

```{r groceryrules2 lift, echo=TRUE}
inspect(subset(groceryrules2, lift < 1))
```

  The first rule of note is between "shopping bags" and "soda".  With a lift of 0.9020198, these two goods are considered substitutes.  While "shopping bags" and "soda" are certainly not substitutable with one another, this perhaps makes sense when thinking in another approach.  Customers who purchase shopping bags may not want to purchase anything that will be heavy enough to rip the bags; therefore, assuming soda is sold in high quantities i.e. more than a single liter bottle, customers may not want to purchase heavy soda products that could jeopardize the integrity of their shopping bags.  
  The other relationships in this subset are a little more odd.  With a lift of 0.942117, it appears that "rolls/buns" and "whole milk" are substitute goods.  In addition, with a lift of 0.9826570, "brown bread" and "whole milk" are just barely considered substitute goods.  In truth, this does not make much sense to me since there is little reason these products would be substitutes in the real world.  One possible explanation would be from a food culture standpoint.  Personally, with parents from the Midwestern US, bread and milk together are commonplace in a typical meal.  So perhaps this data from 'grocery' comes from another region of the world where milk and bread are less common to partake together in an average meal.

# Confidence

  Next, I checked out any interesting confidence levels.  For this, I simply wanted to see the highest confidence levels of rules, to see which goods were more likely to be bought together. What I found was the following:
  
```{r groceryrules2 confidence, echo=TRUE}
inspect(subset(groceryrules2, confidence > 0.3))
```

  With the highest confidence level of 0.4036697, it appears that when consumers bought "butter" they also bought "whole milk" in the same transaction.  This would make sense, since many baking and cooking recipes call for these two ingredients.  The same can be said about the rule regarding "curd" and "whole milk."  Most of the other rules are in regard to vegetables being bought together with other vegetables, which makes sense.  One other interestign rule is in row [9].  A 2-variable itemset, it reads that when "other vegetables" and "yogurt" are purchased together then "whole milk" will be purchased as well, with a confidence level of 0.3991770.
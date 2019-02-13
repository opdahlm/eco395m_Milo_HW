---
title: 'Data Mining and Statistical Learning: Exercise 1'
author: "Milo Opdahl"
date: "February 10, 2019"
output:
  word_document: default
  pdf_document: default
---



## Question 1



## "Data Guru" Analysis


![plot of chunk Guru_Analysis](figure/Guru_Analysis-1.png)

  The so-called "Data Guru" likely came to their conclusions similar to the chart above, utilizing certain methods such as a median rent measure of green vs non-green buildings and removing data on low-occupancy buildings under the theory that such information could "potentially distort the analysis."  From this we can see how they came to their conclusions on having a total payoff and breaking even on the investment after about 7.7 years, assuming 100% occupancy rate.  However, their approach has major faults, particularly in two matters.
  
* By removing data on low-occupancy buildings, we lose potentially important insight on market conditions for both green and non-green buildings, such as their rental values and knowing what type of buildings are more likely to have lower occupancy rates.

* Utilizing a median rent measure instead of a mean rental valuation of green vs non-green buildings may allow to control for robustness in outliers; however, controlling for robustness in outliers will skew the payoff data that is being gathered, specifically by overestimating the effect of green buildings.  


```
##                 Median     Mean
## Whole Dataset 25.29000 28.58585
## Green         27.60000 28.26678
## Non-Green     27.60000 28.26678
```

  The table above shows that there is a 2.6 difference using median-values, while there will only be a 1.7 difference in mean-values.  By using mean-values, the break-even point will be extended further than the "Data Guru" would anticipate.
  
## A New Analysis

  By using the full data and mean rent values, a new (and arguably better) understanding of the data can be found.
![plot of chunk New_Analysis](figure/New_Analysis-1.png)

  Here is a more accurate estimate of the payoff timetable for a green building using mean-values. For 100% occupancy, the payoff would take place within 11.43 years. In addition, at the building's estimated minimal lifecycle the payoff would take place given a 37% occupacy rate, with anything lower resulting in a loss.
  
\newpage

## Question 2


# American Airline Flights At ABIA

The following dot plot gives the speed of American Airline flights to and from ABIA per day of the week, in every month of 2008.  By getting to understand this graph, we can figure out what days have the fastest flight times or have the highest density of fast flights.

![plot of chunk plot_1](figure/plot_1-1.png)

\newpage
  
## Question 3



# S-Class 350

![plot of chunk plot 1](figure/plot 1-1.png)![plot of chunk plot 1](figure/plot 1-2.png)![plot of chunk plot 1](figure/plot 1-3.png)![plot of chunk plot 1](figure/plot 1-4.png)

\newpage

# S-Class 65 AMG

![plot of chunk plot 2](figure/plot 2-1.png)![plot of chunk plot 2](figure/plot 2-2.png)![plot of chunk plot 2](figure/plot 2-3.png)![plot of chunk plot 2](figure/plot 2-4.png)

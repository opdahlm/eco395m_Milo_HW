---
title: "Predicting Daily Volatility"
author:
- Hyunpyo Kim
- Milo Opdahl
- Charles Rudolph
date: "May 16, 2019"
output: pdf_document 
---
##Abstract

##Introduction
Many people get caught up in the impossible idea of conquering the stock market.  From the outside looking in, it appears to be a sure method of gaining a lot of money in a short amount of time.  In reality, the stock market is quite unpredictable in its movements.  A company’s stock may swing up or down in the blink of an eye,  making stock direction and price seem impossible to peg for the future.  However, what if we could predict the daily volatility of a company’s stock and use that to our advantage?  On a surface level, volatility may seem worthless: it only measures how much a stock could move in the future, without pinpointing the direction of the movement.  However, it is an important measurement in the option’s market, as traders analyze it in order to determine risk level in a particular transaction.  For example, high volatility allows for riskier trading opportunities, while low volatility leads to safer but less profitable trades.  Given this, we deem it necessary to be able to create a model that effectively measures volatility.  In particular, we will predict day-ahead volatility for individual stocks utilizing yesterday’s volatility for a variety of stocks, with stocks being drawn from the S&P 500.  Companies will be ranked by market cap.  From there, we will predict day-ahead volatility for the top five companies in this category (Apple, Microsoft, Amazon, Facebook, Google).  The remaining companies in the dataset will comprise of the rest of the top 50 companies by market cap.  Additionally, we will analyze which individual companies have the strongest effects on each of the top five companies’ daily volatility.  Daily volatility will be defined in a simplistic way: the difference in the log of closing price from day “t” to day “t-1”.  This is a well-established measurement often utilized by stock market experts.	

##Methods

##Results

```{r include=FALSE}
#libraries, load data, organize data, add volatility
library(quantmod)
library(gamlr)
library(tidyverse)
options(digits = 4)

startDate = as.Date("2015-12-31")
endDate = as.Date("2019-04-30") 

SP500C = read.csv("~/Downloads/SP500c.csv", head = TRUE)
#SP500_sym = as.vector(SP500C$Symbol)
SP500_sym = c("AAPL","MSFT", "AMZN", "FB", "JPM", "GOOG",
              "XOM", "V", "BAC", "PG", "DIS", "VZ", "CSCO", "CVX", "UNH",
              "PFE", "MA", "T", "HD", "INTC", "MRK", "CMCSA", "WFC", "BA",
              "KO", "PEP", "C", "NFLX", "MCD", "WMT", "ORCL", "ADBE", "ABT",
              "PM", "PYPL", "UNP", "HON", "IBM", "AVGO", "CRM", "MDT", "ABBV",
              "ACN", "UTX", "TMO", "AMGN", "TXN", "QCOM", "NVDA", "MMM") 

# loading all SP500 stock data, and combine
ST = getSymbols(SP500_sym[1], from = startDate, to = endDate, auto.assign = F)
colnames(ST) = c("open","high","low","close","volume","adjusted")
ST$Volatility = (diff(log(ST[,4]), lag = 1))
ST = ST[-1,]
sp500 = data.frame(date = index(ST), stock = SP500_sym[1], ST)
for (i in 2:length(SP500_sym)) {
  ST = getSymbols(SP500_sym[i], from = startDate, to = endDate, auto.assign = F)
  colnames(ST) = c("open","high","low","close","volume","adjusted")
  ST$Volatility = (diff(log(ST[,4]), lag = 1))
  ST = ST[-1,]
  ST = data.frame(date = index(ST), stock = SP500_sym[i], ST)
  sp500 = rbind(sp500, ST)
}
#plot any companys vol that you desire
#apple
ST = getSymbols(SP500_sym[1], from = startDate, to = endDate, auto.assign = F)
colnames(ST) = c("open","high","low","close","volume","adjusted")
ST$Volatility = (diff(log(ST[,4]), lag = 1))
ST = ST[-1,]
plot(ST$Volatility, main="Apple Daily Volatility")
#Microsoft
ST = getSymbols(SP500_sym[2], from = startDate, to = endDate, auto.assign = F)
colnames(ST) = c("open","high","low","close","volume","adjusted")
ST$Volatility = (diff(log(ST[,4]), lag = 1))
ST = ST[-1,]
plot(ST$Volatility, main= "Microsoft Daily Volatility")
#Amazon
ST = getSymbols(SP500_sym[3], from = startDate, to = endDate, auto.assign = F)
colnames(ST) = c("open","high","low","close","volume","adjusted")
ST$Volatility = (diff(log(ST[,4]), lag = 1))
ST = ST[-1,]
plot(ST$Volatility, main= "Amazon Daily Volatility")
#Facebook
ST = getSymbols(SP500_sym[4], from = startDate, to = endDate, auto.assign = F)
colnames(ST) = c("open","high","low","close","volume","adjusted")
ST$Volatility = (diff(log(ST[,4]), lag = 1))
ST = ST[-1,]
plot(ST$Volatility, main= "Facebook Daily Volatility")
#Google
ST = getSymbols(SP500_sym[6], from = startDate, to = endDate, auto.assign = F)
colnames(ST) = c("open","high","low","close","volume","adjusted")
ST$Volatility = (diff(log(ST[,4]), lag = 1))
ST = ST[-1,]
plot(ST$Volatility, main="Google Daily Volatility")
```

```{r echo=FALSE}
#Combine all the plots into one image space.
layout(matrix(c(1,1,2,3,4,5), 3, 2, byrow=TRUE))
plot(ST$Volatility, main="Apple Daily Volatility", yaxis.right=FALSE)
plot(ST$Volatility, main= "MSFT D.V.", yaxis.right=FALSE)
plot(ST$Volatility, main= "Amazon Daily Volatility", yaxis.right=FALSE, cex.main=.3)
plot(ST$Volatility, main= "Facebook Daily Volatility", yaxis.right=FALSE)
plot(ST$Volatility, main="Google Daily Volatility", yaxis.right=FALSE)
layout(matrix(c(1), 1, 1, byrow=TRUE))
```




##Conclusion
#==================================================================================================
# Ben Ewing - 3/15/2016
#
# This script is meant to demonstrate some of the capabilities of the Caret package, and the 
# random forests method
#
#==================================================================================================

#==================================================================================================
# Setup

# Clear Environments
rm(list=ls())

# Set Working Directory
setwd("C:/Users/bewing/Documents/GitHub/worldbank-rf")

# Import data
load("datasets/usaid_data.rdata")

# Libraries
# Plyr has a number of useful functions
library(plyr)
# Caret of course
library(caret)
# ggplot2 for plots, ggthemes for nice themes 
library(ggplot2)
library(ggthemes)
# randomForest for...random forests
library(randomForest)
#==================================================================================================

#==================================================================================================
# R Basics

# See the dimensions
# dim(eerf)
# 383 variables for 4332 observations

# see the first couple rows
# head(eerf)

# See variables and their types
# str(eerf, list.len = ncol(eerf))
# We have to specify how many vars to show using the list.len arg

# We can also get some basic stats, of course
# mean(eerf$hh_income)
# sd(eerf$hh_income)
# summary(eerf$hh_income)
#==================================================================================================

#==================================================================================================
# Set up testing data and training data
set.seed(3456)

trainIndex <- createDataPartition(y = eerf$parc_2cer, p = 0.8, list = F)
train_data <- eerf[trainIndex,]
test_data  <- eerf[-trainIndex,]
#==================================================================================================

#==================================================================================================
# for (i in 1:ncol(train_data)) {
#   print(names(train_data)[i])
#   if (class(train_data[, names(train_data)[i]])[1] == "factor")
#     contrasts(train_data[, names(train_data)[i]])
# }
#==================================================================================================

#==================================================================================================
# Training Model
# Basic - Use whichever variables you'd like to test here
mod_rf <- train(parc_2cer ~ state_id + hh_size + hh_num_male + hh_num_female +
                 hh_head_age + hh_avg_age + hh_ed_avg_yrs + inc_farm1 + inc_manual1 + 
                 inc_domstc1 + lofftrtime + redland, 
                data = train_data,
                trControl = trainControl(method="cv",number=5),
                metric = "Kappa",
                method = "rf")
#==================================================================================================

#==================================================================================================
# Evalutating the model on its own
# By just typing the model name, we can get some information
mod_rf
# Or to see some info about the final model, and particularly the confusion matrix
mod_rf$finalModel
#==================================================================================================

#==================================================================================================
# Evaluating our Model on Our Predictions
pred <- predict(mod_rf, test_data)

confusionMatrix(pred, test_data$parc_2cer)

test_data$predRight <- pred==test_data$parc_2cer
qplot(parc_2cer, fill=predRight, data=test_data, main="", 
      xlab = "Second Level Certification") + theme_fivethirtyeight()
#==================================================================================================

#==================================================================================================
# Variable Importance
varImp(mod_rf)

# and
ggplot(varImp(mod_rf)) + theme_fivethirtyeight()
# or
plot(varImp(mod_rf))
#==================================================================================================
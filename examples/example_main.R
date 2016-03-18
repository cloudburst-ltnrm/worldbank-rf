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

# Import data
load(url("https://github.com/cloudburst-ltnrm/worldbank-rf/raw/master/datasets/usaid_data.rdata"))

# Install Packages
install.packages(c("plyr", "caret", "randomForest", "ggplot2", "ggthemes"))

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
dim(data)

# see the first couple rows
head(data)

# See variables and their types
str(data, list.len = ncol(data))
# We have to specify how many vars to show using the list.len arg

# We can also get some basic stats, of course
mean(data$hh_income)
sd(data$hh_income)
summary(data$hh_income)
#==================================================================================================

#==================================================================================================
# Set up testing data and training data
set.seed(3456)

trainIndex <- createDataPartition(y = data$well_reg, p = 0.6, list = F)
train_data <- data[trainIndex,]
test_data  <- data[-trainIndex,]
#==================================================================================================

#==================================================================================================
# Training Model
# Basic - Use whichever variables you'd like to test here
mod_rf <- train(well_reg ~ ., 
                data = train_data,
                trControl = trainControl(method="cv",number=5),
                metric = "Kappa",
                method = "randomForest")
#==================================================================================================

#==================================================================================================
# Evalutating the model on its own
# By just typing the model name, we can get some information
mod_rf
# Or to see some info about the final model, and particularly the confusion matrix
mod_rf$finalModel

# Variable Importance
varImp(mod_rf)
# and
ggplot(varImp(mod_rf))# + theme_fivethirtyeight()
# or
# plot(varImp(mod_rf))
#==================================================================================================

#==================================================================================================
# Evaluating our Model on Our Test data
pred <- predict(mod_rf, test_data)

confusionMatrix(pred, test_data$well_reg)

test_data$predRight <- pred==test_data$well_reg
qplot(well_reg, fill=predRight, data=test_data, main="", 
      xlab = "Second Level Certification")# + theme_fivethirtyeight()
#==================================================================================================
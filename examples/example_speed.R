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
setwd("")

# Import data
load(url("https://github.com/cloudburst-ltnrm/worldbank-rf/raw/master/datasets/usaid_data.rdata"))

# Libraries
# Plyr has a number of useful functions
library(plyr)
# Caret of course
library(caret)
# ggplot2 for plots
library(ggplot2)
# randomForest for...random forests
library(randomForest)
#==================================================================================================

#==================================================================================================
# R Basics

# See the dimensions
dim(eerf)

# see the first couple rows
head(eerf)

# See variables and their types
str(eerf, list.len = ncol(eerf))
# We have to specify how many vars to show using the list.len arg

# We can also get some basic stats, of course
mean(eerf$hh_income)
sd(eerf$hh_income)
summary(eerf$hh_income)

qplot(eerf$region_id, eerf$hh_income, geom = "jitter")
#==================================================================================================

#==================================================================================================
# Set up testing data and training data
set.seed(3456)

trainIndex <- createDataPartition(y = eerf$parc_2cer, p = 0.8, list = F)
train_data <- eerf[trainIndex,]
test_data  <- eerf[-trainIndex,]
#==================================================================================================

#==================================================================================================
# Training Model
# Basic - Use whichever variables you'd like to test here
system.time(mod_rf1 <- train(parc_2cer ~ state_id + hh_size + hh_num_male + hh_num_female +
                              hh_head_age + hh_avg_age + hh_ed_avg_yrs + inc_farm1 + inc_manual1 + 
                              inc_domstc1 + lofftrtime + redland, 
                            data = train_data,
                            trControl = trainControl(method="repeatedcv",number=10, repeats = 10),
                            #prox = TRUE, 
                            metric = "Kappa",
                            method = "rf"))

system.time(mod_rf2 <- train(parc_2cer ~ state_id + hh_size + hh_num_male + hh_num_female +
                              hh_head_age + hh_avg_age + hh_ed_avg_yrs + inc_farm1 + inc_manual1 + 
                              inc_domstc1 + lofftrtime + redland, 
                            data = train_data,
                            #trControl=trainControl(method="cv",number=5),
                            #prox = TRUE, 
                            metric = "Kappa",
                            method = "rf"))

system.time(mod_rpart <- train(parc_2cer ~ state_id + hh_size + hh_num_male + hh_num_female +
                               hh_head_age + hh_avg_age + hh_ed_avg_yrs + inc_farm1 + inc_manual1 + 
                               inc_domstc1 + lofftrtime + redland, 
                             data = train_data,
                             #trControl=trainControl(method="cv",number=5),
                             #prox = TRUE, 
                             metric = "Kappa",
                             method = "rpart"))
# Long
# system.time(modelFitLong <- train(dispute ~ .,
#                       data = train_data, 
#                       method = "rf", 
#                       prox = TRUE))                    
#==================================================================================================

#==================================================================================================
# Testing Model on Our Predictions
pred1 <- predict(mod_rf1, test_data)
pred2 <- predict(mod_rf2, test_data)


test_data$predRight1 <- pred1==test_data$parc_2cer
test_data$predRight2 <- pred2==test_data$parc_2cer


table(test_data$predRight1)
prop.table(table(test_data$predRight1))

table(test_data$predRight2)
prop.table(table(test_data$predRight2))

pred1_plot <- qplot(parc_2cer, fill=predRight1, data=test_data,main="Simple Resample", 
                    xlab = "Second Level Certification")
pred2_plot <- qplot(parc_2cer, fill=predRight2, data=test_data,main="Not Simple Resample", 
                    xlab = "Second Level Certification")

library(gridExtra)
grid.arrange(pred1_plot, pred2_plot, ncol = 2)
#==================================================================================================
# Applications of Random Forests in Land Tenure Research

## Setup
### Software
* **[R Language](http://cran.cnr.berkeley.edu/)** (Required)
  * **Step 1:** Install the package for your operating system. This is all you need to get started in R.
* **[R Studio](https://www.rstudio.com/products/rstudio/download/)** (Optional, but recommended)
  * R Studio is an interface for R, which can make R programming much nicer.

### R Packages
A package in R typically consists of a group of functions, and the associated documentation, focused on accomplishing a specific task or goal. R comes with a base package, which includes all of R's core functionality.

Please install the following packages by pasting the install code in a R Console. Once installed, load the package by running `library(package_name)`. Note that a package must be loaded to access it's functionality every time a new instance of R is started.

* ggplot2 (Required)
  * The ggplot2 package can make creating nice looking graphics intuitive and easy. We'll use this package to create plots to analyze our     predictions and classification trees.
  * **Step 2:** Install the ggplot2 package by typing `install.packages("ggplot2")`in the R Console.
  * **Step 3:** Load the ggplot2 package by running `library(ggplot2)`.

* caret (Required)
  * The caret package provides an easy interface for building and testing many types of predictive models. Because it requires many R packages, it may take a couple minutes to install.
  * **Step 4:** Install the caret package by typing `install.packages("caret", dependencies = c("Depends", "Suggests"))`in the R Console.
  * **Step 5:** Load the caret package by running `library(caret)`.

* randomForests (Required)
  * The randomForests package is R's most used implementation of random forests. It can be slower than other implementations, but it is very widely supported and reliable.
  * **Step 6:** Install, as you may have guessed, with `install.packages("randomForest")`
  * **Step 7:** And load `library('randomForest')`

To access the documentation for any function in a package simply type `?function_name` in the console. If the exact function name is not known, you can search all available documentation by typing `??function_name`.

### Data
Now that we have R installed, and our packages loaded, we need some data. R can load data directly from the internet. Let's download a dataset in this repo. Please run the line below to download a dataset from an impact evaluation in Africa. This is a household level dataset containing a variety of land related indicators including land investment, conflict, governance, land registration, etc. The dataset also contains variables describing household size, income, migration, etc.

As discussed in the workshop presentation, multiple data processing steps were taken to prepare the data for analysis. This primarily involved plot and household-member level variables into household level variables. For example, rather than record for each field what crop is grown, a binary variable was created for each crop, indicating whether or not the household grows that crop. Other pre-processing included imputing missing data, generally by entering values randomized within one SD of the mean. Lastly, we made sure that all categorical variables are in R's [factor type](http://www.stat.berkeley.edu/~s133/factors.html).

* **Step 8:** Run the line below to download the dataset:
`load(url("https://github.com/cloudburst-ltnrm/worldbank-rf/raw/master/datasets/usaid_data.rdata"))`

The dataset will be stored in a data frame (this is one of the data structures in R) named `data`. A dataframe is basically a matrix, where columns represent variables, and rows are observations. To see the dimensions of this data type `dim(data)`. We can see the first couple rows of the `data` dataframe by typing `head(data)`. To get a more comprehensive view of the data structure, try `str(data)`. An individual variable can be accessed using the `$` operator, for example `data$hh_income`. With this we can get quickly get some basic statistics: `mean(data$hh_income)`, `sd(data$hh_income)`, or just `summary(data$hh_income)`. To get a basic plot from `ggplot2`, try `qplot(data$hh_id, data$hh_income, geom = "jitter")`. To read more about data exploration in R, see the resources section below.

## Random Forests in Practice

### Choosing The Outcome Variable
**Step 9.1:** We will go through the basic process of running random forests. Take a few minutes to browse the codebook [here](https://github.com/cloudburst-ltnrm/worldbank-rf/blob/master/datasets/codebook.md),  and choose an outcome variable that seems interesting. It can be continuous, or categorical. A couple suggestions are: Whether or not a respondent experienced a conflict in the past 2 years `dispute`, does the respondent think that land laws protect women `llawpw`, or whether or not someone in the household migrated permanently during the last 2 years `perm_migrat`. Alternatively, you can create your own variable of interest from the variables available. For example, using principal component analysis on the household assets variables.  

We will continue this example by trying to predict drinking well registration, `well_reg`.  

### Feature Building and Selection
In random forests and machine learning, predicting variables are often referred to as features. In a perfect world, we would train our model on all variables available. However, we only have limited time for this presentation, and these models can take quite a bit of time to train. **Step 9.2:** Take a couple minutes to browse the codebook [here](https://github.com/cloudburst-ltnrm/worldbank-rf/blob/master/datasets/codebook.md), and pick out 5 or so variables that you think might be could be good predictors of your chosen outcome variable.

### Testing - Setup
As mentioned in the presentation, we will need to create a testing set and a training set. `caret` has a function for this called [`createDataPartition`](http://www.inside-r.org/node/87010), which uses the outcome variable to split data. **Step 10:** The following commands will split your data into a training set (60%), and a test set (40%).  Note that the data will be split within levels of the `y` argument, to try and get an even distribution of all levels in the testing and training data.   
```
trainIndex <- createDataPartition(y = data$well_reg, p = 0.6, list = F)
train_data <- data[trainIndex,]
test_data  <- data[-trainIndex,]
```
Note, we are only using 60% of the data to train due to time constraints. The general recommendation is to use 60-80% for training, and the remainder for testing.
### Building a Model With `caret`
Once the dataset is split, building a model with random forests in R is a fairly straightforward process. A model can be built as follows. **Step 11:** Train a basic model using the variables you decided on previously.  
```
mod_rf <- train(well_reg ~ your_var_1 + your_var_2 + your_var_3 +
                your_var_4 + your_var_5,
                data = train_data,
                trControl = trainControl(method="cv",number=5),
                method = "rf")
```
Where the `trControl` argument specifies that we should use cross validation (cv) resampling. To read about available resampling methods, and other training/tuning parameters, [see here](http://topepo.github.io/caret/training.html#custom). We are using 5 fold cross validation here, as it is generally faster than the default method (boosting).
Note that if you'd like to use *all* variables in a dataframe, replace the list of variables with a period, e.g. `well_reg ~ .`, but be prepared to give up your laptop for a while.  Alternatively, you can try a faster implementation of random forests, see the resources section below.

### Taking a Look at the Results
**Step 12:** We can look at an overview of the training process by just typing `mod_rf`. In particular we can see the accuracy and [kappa](https://en.wikipedia.org/wiki/Cohen%27s_kappa) metrics for various `mtry` levels, where `mtry` is the number of predictors sampled at each split. There are also details about the number of samples and predictors, number of outcome variable classes, and resampling method used.  

**Step 13:** To see details more specific to the final model used, type `mod_rf$finalModel`. We can see many of the same details, as well as the number of trees (which is parameter we can set if desired), the estimated error rate, and a [confusion matrix](http://www.dataschool.io/simple-guide-to-confusion-matrix-terminology/).

### Making and Evaluating Predictions
**Step 14:** Now to put the `testing` dataset to use, enter `pred <- predict(mod_rf, testing)`, to make predictions on your dataset. **Step 15:** To generate a confusion matrix and evaluate the predictions, caret provides a great function: `confusionMatrix(pred, testing$well_reg)`. To plot a bar graph of your results, run the following:
```
testing$predRight <- pred == testing$well_reg
qplot(well_reg, fill=predRight, data=testingv,main="",
      xlab = "Well Registration")
```

### Variable Importance
The `caret` package also has a built in function for evaluating the importance of individual variables. **Step 16:** Run `varImp(mod_rf)`, to see the importance, and `ggplot(varImp(mod_rf))`, to plot it. If you'd like to read more about *how* variable is determined, the `caret` documentation is great, [see here](http://topepo.github.io/caret/varimp.html).

## Resources and Next Steps
There are many tuning parameters that can be specified with random forests, and there are several other implementations supported in R, and by `caret`. The resources below are meant to provide you with what you need to take your models to the next step, and gain a deeper understanding of random forests.  

### Resources for `caret`
* [`caret` Homepage](http://topepo.github.io/caret/index.html)
* [Model Training and Parameter Tuning](http://topepo.github.io/caret/training.html#custom)
* [Random Forests Models in `caret`](http://topepo.github.io/caret/Random_Forest.html)
* [Feature Selection]( http://machinelearningmastery.com/feature-selection-with-the-caret-r-package/)
* [Practical Machine Learning on Coursera](https://www.coursera.org/learn/practical-machine-learning)

### Machine Learning Resources
* [The Elements of Statistical Learning: Data Mining, Inference, and Prediction](http://statweb.stanford.edu/~tibs/ElemStatLearn/)
* [An Introduction to Statistical Learning](http://www-bcf.usc.edu/~gareth/ISL/)
* [Stanford Statistical Learning](https://lagunita.stanford.edu/courses/HumanitiesScience/StatLearning/Winter2014/about)

### Random Forests Resources
* [H2O](https://github.com/h2oai/h2o-3)
* [Yhat - Random Forests in Python](http://blog.yhat.com/posts/random-forests-in-python.html)
* [Yhat - Random Forest Regression and Classification in R and Python](http://blog.yhat.com/posts/comparing-random-forests-in-python-and-r.html)

## About
### Authors
* **Heather Huntington** - Impact Evaluation Specialist, Land Tenure and Natural Resources - The Cloudburst Group
* **Ben Ewing** - Research Analyst - The Cloudburst Group
* **Mercedes Stickler** - Sr. Land Tenure Specialist, USAID

### Affiliations
* **[USAID](https://www.usaid.gov/)**
* **[The Cloudburst Group](http://www.cloudburstgroup.com)**

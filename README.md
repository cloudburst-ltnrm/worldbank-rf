# Applications of Random Forests in Land Tenure Research
Descriptive paragraph.

## Setup
### Software
* **[R Language](http://cran.cnr.berkeley.edu/)** (Required)
  * **Step 1:** Install the package for your operating system. This is all you need to get started in R.
* **[R Studio](https://www.rstudio.com/products/rstudio/download/)** (Optional, but recommended)
  * R Studio is an interface for R, which can make R programming much nicer.

### R Packages
A package in R typically consists of a group of functions, and the associated documentation, focused on accomplishing a specific task or goal. R comes with a base package, which includes all of R's core functionality.

Please install the following packages by pasting the install code in a R Console. Once installed, load the package by running `library(package_name)`. Note that a package must be loaded to access it's functionality every time a new instance of R is started.
x1
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
Now that we have R installed, and our packages loaded, we need some data. R can load data directly from the internet. Let's download a dataset in this repo. Please run the line below to download a dataset from a land certification impact evaluation in Ethiopia. This is a household level dataset containing a variety of land related indicators including land investment, conflict, governance, land registration, etc. The dataset also contains variables describing household size, income, migration, etc.

As discussed in the workshop presentation, multiple data processing steps were taken to prepare the data for analysis. This primarily involved plot and household-member level variables into household level variables. For example, rather than record for each field what crop is grown, a binary variable was created for each crop, indicating whether or not the household grows that crop. Other pre-processing included imputing missing data, generally by entering values randomized within one SD of the mean. Lastly, we made sure that all categorical variables are in R's [factor type](http://www.stat.berkeley.edu/~s133/factors.html).

* **Step 8:** Run the line below to download the dataset:
`bb <-  read.csv("https://raw.githubusercontent.com/cloudburst-ltnrm/worldbank-rf/master/datasets/baseball_salaries.csv")`

The dataset will be stored in a data frame (this is one of the data structures in R) named `bb`. A dataframe is basically a matrix, where columns represent variables, and rows are observations. To see the dimensions of this data type `dim(bb)`. We can see the first couple rows of the `bb` dataframe by typing `head(bb)`. To get a more comprehensive view of the data structure, try `str(bb)`. An individual variable can be accessed using the `$` operator, for example `bb$salary`. With this we can get quickly get some basic statistics: `mean(bb$salary)`, `sd(bb$salary)`, or just `summary(bb$salary)`. To get a basic plot from `ggplot2`, try ` qplot(bb$yearID, bb$salary, geom = "jitter")`. To read more about data exploration in R, see the resources section below.


## Random Forests in Practice
We will go through the basic process of running random forests. In particular, we will be looking for good predictors of conflict. The variable `dispute` is binary for whether or not a respondent had a land related dispute, and `dispute_num` gives the total number of disputes for the respondent. Then the following variables count each kind of dispute for the respondent: `disp_boundary`, `disp_exchange`, `disp_roadacc`, `disp_wateracc`, `disp_rental`, `disp_divorce`, `disp_inhrt`, `disp_claim`, `disp_other`. For the sake of simplicity, we will focus on predicting `dispute`.

### Feature Building and Selection
In random forests and machine learning, predicting variables are often referred to as features. In a perfect world, we would train our model on all variables available. However, we only have limited time for this presentation, and these models can take quite a bit of time to train. **Step 9:** Take a couple minutes to browse the codebook [here](), and pick out 5 or so variables that you think might be could be good predictors of conflict.

### Testing - Setup
As mentioned in the presentation, we will need to create a testing set and a training set. `caret` has a function for this called [`createDataPartition`](http://www.inside-r.org/node/87010), which uses the outcome variable to split data. **Step 10:** The following commands will split your data into a training set (80%), and a test set (20%).  
```
trainIndex <- createDataPartition(y = eerf$dispute, p = 0.8, list = F)
train_data <- eerf[trainIndex,]
test_data  <- eerf[-trainIndex,]
```

### Building a Model With `caret`
Once the dataset is split, building a model with random forests in R is a fairly straightforward process. A model can be built as follows. **Step 11:** Train a basic model using the variables you decided on previously.
```
modelFit <- train(dispute ~ your_var_1 + your_var_2 + your_var_3 + your_var_4 + your_var_5, data = train_data, method = "rf")
```
Note that if you'd like to use *all* variables in a dataframe, replace the list of variables with a period, e.g. `dispute ~ .`  

### Testing - Evaluating a Model With `caret`
Testing the model on the test dataset. Discuss measures of accuracy. Graph stuff.

## Exploration
Set participants loose. If we want to give this structure, participants can try building a model based on data from one region, and test it on another region. Or we could allow participants to go crazy. Maybe give a task, and see who can get the best prediction.

## Resources
Whatever resources we would like to provide people,

## About
### Authors
* **Heather Huntington** - Impact Evaluation Specialist, Land Tenure and Natural Resources - The Cloudburst Group
* **Mercedes Stickler** - Sr. Land Tenure Specialist, E3/Land Office, USAID
* **Ben Ewing** - Research Analyst - The Cloudburst Group

### Affiliations
* **[USAID](https://www.usaid.gov/)**
* **[The Cloudburst Group](http://www.cloudburstgroup.com)**

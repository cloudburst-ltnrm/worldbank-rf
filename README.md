# Applications of Random Forests in Land Tenure Research
Descriptive paragraph.

## Setup
### Software
* **[R Language](http://cran.cnr.berkeley.edu/)** (Required)
  * **Step 1** Install the package for your operating system. This is all you need to get started in R.
* **[R Studio](https://www.rstudio.com/products/rstudio/download/)** (Optional, but recommended)
  * R Studio is an interface for R, which can make R programming much nicer.

### R Packages
A package in R typically consists of a group of functions, and the associated documentation, focused on accomplishing a specific task or goal. R comes with a base package, which includes all of R's core functionality.

Please install the following packages by pasting the install code in a R Console. Once installed, load the package by running `library(package_name)`. Note that a package must be loaded to access it's functionality every time a new instance of R is started.

* ggplot2 (Required)
  * The ggplot2 package can make creating nice looking graphics intuitive and easy. We'll use this package to create plots to analyze our     predictions and classification trees.
  * **Step 2** Install the ggplot2 package by typing `install.packages("ggplot2")`in the R Console. 
  * **Step 3** Load the ggplot2 package by running `library(ggplot2)`.

* caret (Required)
  * The caret package provides an easy interface for building and testing many types of predictive models. Because it requires many R packages, it may take a couple minutes to install. 
  * **Step 4** Install the caret package by typing `install.packages("caret", dependencies = c("Depends", "Suggests"))`in the R Console.
  * **Step 5** Load the caret package by running `library(caret)`.
  
To access the documentation for any function in a package simply type `?function_name` in the console. If the exact function name is not known, you can search all available documentation by typing `??function_name`.

### Data
Now that we have R installed, and our packages loaded, we need some data. R can load data directly from the internet. Let's download a dataset in this repo. Please run the line below to download a dataset from a land certification impact evaluation in Ethiopia. **BEN - CAN YOU ADD AND DOUBLE CHECK THIS INFO ABOUT THE DATASET. This is a field (or parcel) level dataset on a variety of land related indicators including land investment, conflit, governance, etc. 

As discussed in the workshop presentation, multiple data processing steps were taken to prepare the data for analysis. Some key steps included: BEN - maybe the top 3 things that you did. 

* **Step 6** Run the line below to download the dataset: 
`bb <-  read.csv("https://raw.githubusercontent.com/cloudburst-ltnrm/worldbank-rf/master/datasets/baseball_salaries.csv")`

The dataset will be stored in a data frame (this is one of the data structures in R) named `bb`. A dataframe is basically a matrix, where columns represent variables, and rows are observations. To see the dimensions of this data type `dim(bb)`. We can see the first couple rows of the `bb` dataframe by typing `head(bb)`. To get a more comprehensive view of the data structure, try `str(bb)`. An individual variable can be accessed using the `$` operator, for example `bb$salary`. With this we can get quickly get some basic statistics: `mean(bb$salary)`, `sd(bb$salary)`, or just `summary(bb$salary)`. To get a basic plot from `ggplot2`, try ` qplot(bb$yearID, bb$salary, geom = "jitter")`. To read more about data exploration in R, see the resources section below.


## Random Forests in Practice
Note that the `caret` package makes each of the following steps easy, but is not necessary, and may not always be ideal.

### Feature Building
A short paragraph about the level of the data, input variables, and outcome. Generally we want covariates to be at the same level as the outcome variable.

Also note that choosing features *after* initially running RF can bias predictions. Also, running RF with the *wrong* features can produce accurate but uninterpretable (or silly) results. This may be a good spot for a "bad" example.

### Testing 1: Setup
Discuss this before model building, so that we separate testing from training data. This is also a good spot to discuss assumptions, and sources of bias.

### Building a Model With `caret`
Use this section to introduce caret. Each of the parameters can be used as a learning moment (e.g. cross-validation).

We can also use this section to view decision trees.

### Testing 2: Evaluating a Model With `caret`
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





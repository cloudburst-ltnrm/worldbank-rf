# Applications of Random Forests in Land Tenure Research
Descriptive paragraph.

## Getting Started
### Setup
#### Software
* **[R Language](http://cran.cnr.berkeley.edu/)** (Required)
  * Install the package for your operating system. This is all you need to get started in R.
* **[R Studio](https://www.rstudio.com/products/rstudio/download/)** (Optional, but recommended)
  * R Studio is an interface for R which can make R programming much nicer.

#### R Packages
A package in R typically consists of a group of functions, and the associated documentation, focused on accomplishing a specific task or goal. R comes with the base package, which includes all of R's core functionality.

Please install the following packages by pasting the install code in a R Console. Once installed, load the package by running `library(package_name)`. Note that a package must be loaded to access it's functionality, every time a new instance of R is started.

* ggplot2 (Required)
  * `install.packages("ggplot2")`
  * The ggplot2 package can make creating nice looking graphics intuitive and easy. We'll use this package to create plots to analyze our predictions and classification trees.
* caret (Required)
  * `install.packages("caret", dependencies = c("Depends", "Suggests"))`
  * The caret package provides an easy interface for building and testing many types of predictive models. Because it requires many R packages, it may take a couple minutes to install.  

To access the documentation for any function in a package simply type `?function_name` in the console. If the exact function name is not known, you can search all available documentation by typing `??function_name`.

#### Data
Now that we have R installed, and our packages loaded, we need some data. R can load data directly from the internet. Let's download a dataset in this repo. Please run the line below to download a dataset containing baseball salaries. The dataset is stored in a data frame (this is one of the data structures in R) named `bb`.

`bb <- read.csv("https://raw.githubusercontent.com/cloudburst-ltnrm/worldbank-rf/master/datasets/baseball_salaries.csv")`

A dataframe is basically a matrix, where columns represent variables, and rows are observations. To see the dimensions of this data type `dim(bb)`. We can see the first couple rows of the `bb` dataframe by typing `head(bb)`. To get a more comprehensive view of the data structure, try `str(bb)`. An individual variable can be accessed using the `$` operator, for example `bb$salary`. With this we can get quickly get some basic statistics: `mean(bb$salary)`, `sd(bb$salary)`, or just `summary(bb$salary)`. To get a basic plot from ggplot2, try ` qplot(bb$yearID, bb$salary, geom = "jitter")`. To read more about data exploration in R, see the resources below.

## Random Forests
Basically the handout.

## Resources
Whatever resources we would like to provide people,

## About
### Authors
* **Mercedes Stickler** - Title and Position - Web Presence?
* **Heather Huntington** - Title and Position - Web Presence?
* **Ben Ewing** - Title and Position - Web Presence?

### Affiliations
* **[USAID](https://www.usaid.gov/)**
* **[The Cloudburst Group](http://www.cloudburstgroup.com)**

### Acknowledgments

## License
Do we want a license  on this content?

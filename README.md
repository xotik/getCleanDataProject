Get & Clean Data Course Project - Code Book
========================================================

Study Design
-------------------------------------------------
The data to serve as source for this project has been downloaded from the following URL: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

From the ZIP archive, the following files were used in this project:

* `activity_labels.txt`
* `test/subject_test.txt`
* `test/X_test.txt`
* `test/y_test.txt`
* `train/subject_train.txt`
* `train/X_train.txt`
* `train/y_train.txt`

Code Book
------------------------------------------------
Aside from `activity_labels.txt` (with two variables), each of the remaining files have only one variable per file; the files under `/test` and `/train` are equal in terms of variables and number of observations.

* `activity_labels.txt` - contains one numeric variable, that acts as the unique identifier for the string variable.
* `test/subject_test.txt` - contains one numeric variable, which represents the unique identifier of the study subjects.  
* `test/X_test.txt` - contains one numeric variable, which represents multiple observations generated by an accelerometer.
* `test/y_test.txt` - contains one numeric variable, which represents multiple observations of the numeric variable of `activity_labels.txt`.
* `train/subject_train.txt` - same as `test/subject_test.txt`
* `train/X_train.txt` - same as `test/X_test.txt`
* `train/y_train.txt` - same as `test/y_test.txt`


Instruction List
------------------------------------------------
Given the following project directives:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The approach was a little different, since the `test` and `train` datasets were handled separately and only merged at the very end, meaning that the directives #2 and #4 were done first, then #1 and finally #3 and #5. Here's the code used to handle each dataset and achieve directives #2 and #4:

```{r}
## Test Data
# Set path to files
maindir <- getwd()
path <- paste(maindir, "UCI_HAR_Dataset/test", sep="/")
# Read files
subjectTest <- read.table(file= paste(path,"subject_test.txt", sep="/"), header=FALSE)
xTest <- read.table(file= paste(path,"X_test.txt", sep="/"), header=FALSE)
yTest <- read.table(file= paste(path,"y_test.txt", sep="/"), header=FALSE)
# Extract the mean and standard deviation from xTest, and create new data frame
meanTest <- rowMeans(xTest, na.rm = TRUE)
stdTest <- apply(xTest,1,sd)
calcsTest <- data.frame(meanTest,stdTest)
# Concatenate the files
concatTest <- cbind(subjectTest,yTest,calcsTest)
# Rename columns to apply rbind() later and give descriptive names
colnames(concatTest) <- c("Subject", "Activity", "Mean","Std")
```
```{r}
## Train Data
# Set path to files
maindir <- getwd()
path <- paste(maindir, "UCI_HAR_Dataset/train", sep="/")
# Read files
subjectTrain <- read.table(file= paste(path,"subject_train.txt", sep="/"), header=FALSE)
xTrain <- read.table(file= paste(path,"X_train.txt", sep="/"), header=FALSE)
yTrain <- read.table(file= paste(path,"y_train.txt", sep="/"), header=FALSE)
# Extract the mean and standard deviation from xTest, and create new data frame
meanTrain <- rowMeans(xTrain, na.rm = TRUE)
stdTrain <- apply(xTrain,1,sd)
calcsTrain <- data.frame(meanTrain,stdTrain)
# Concatenate the files
concatTrain <- cbind(subjectTrain,yTrain,calcsTrain)
# Rename columns to apply rbind() later and give descriptive names
colnames(concatTrain) <- c("Subject", "Activity", "Mean","Std")
```

To achieve directive #1:

```{r}
## Concatenate train and test data into single dataset
data <- rbind(concatTest,concatTrain)
```

To achieve directive #3:

```{r}
## Replace activity code by its description from activity_labels.txt
maindir <- getwd()
path <- paste(maindir, "UCI_HAR_Dataset", sep="/")
# Read file
activityList <- read.table(file= paste(path,"activity_labels.txt", sep="/"), header=FALSE)
# Match activity id with description
data$Activity <- activityList$V2[match(data$Activity, activityList$V1)]
```

To achieve directive #5:

```{r}
## Generating the tidy dataset: group by Subject and Activity, outputing the average of Mean and Std
# Using package data.table
library(data.table)
dataDT <- data.table(data)
dataTidy <- dataDT[, list(Mean=mean(Mean), Std=mean(Std)), by=list(Subject, Activity)]
# write to file
write.table(x=dataTidy,file=paste(maindir, "tidyDataset.txt", sep="/"), sep= "\t", col.names= TRUE, quote=FALSE, row.names=FALSE)
```

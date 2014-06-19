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

## Concatenate train and test data into single dataset
data <- rbind(concatTest,concatTrain)

## Replace activity code by its description from activity_labels.txt
maindir <- getwd()
path <- paste(maindir, "UCI_HAR_Dataset", sep="/")
# Read file
activityList <- read.table(file= paste(path,"activity_labels.txt", sep="/"), header=FALSE)
# Match activity id with description
data$Activity <- activityList$V2[match(data$Activity, activityList$V1)]

## Generating the tidy dataset: group by Subject and Activity, outputing the average of Mean and Std
# Using package data.table
library(data.table)
dataDT <- data.table(data)
dataTidy <- dataDT[, list(Mean=mean(Mean), Std=mean(Std)), by=list(Subject, Activity)]
# write to file
write.table(x=dataTidy,file=paste(maindir, "tidyDataset.txt", sep="/"), sep= "\t", col.names= TRUE, quote=FALSE, row.names=FALSE)






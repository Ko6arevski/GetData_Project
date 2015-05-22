
Getting and Cleaning Data Course Project Code Book
==============

**This file describes the data, the variables, and any transformations or work that I have performed to clean up the data.**

#### The Data
The site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  
The data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#### The Variables
Information on collection of data and reporting the variables of he raw data is provided in the README.txt file contained in the archive (the link above) and information regarding the naming of these variables is given in the features_info.txt file in the same archive. Description of the methods used to assign names to variables and sorting them follows

#### Processing the data

The processing goals were laid down in the assignment as follows:  
  
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement.

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
 
I will describe the steps I have taken and indicate to which part of the prescribed goal it corresponds

1. Read the data

```r
feat<-read.table("./Raw_data/features.txt")
actLabels<-read.table("./Raw_data/activity_labels.txt")
subjectTrain<-read.table("./Raw_data/train/subject_train.txt")
xTrain<-read.table("./Raw_data/train/X_train.txt")
yTrain<-read.table("./Raw_data/train/y_train.txt")
subjectTest<-read.table("./Raw_data/test/subject_test.txt")
xTest<-read.table("./Raw_data/test/X_test.txt")
yTest<-read.table("./Raw_data/test/y_test.txt")
```

2. Bindinding the data (part 1)  
From the above mentioned documentation regarding the raw data, as well as from simply looking at the dimensions of the objects, it was obvious how to bind them. I decided to put the ubject number first and the activity second.

```r
testData<-cbind(cbind(subjectTest,yTest),xTest)
trainData<-cbind(cbind(subjectTrain,yTrain),xTrain)
fullData<-rbind(trainData,testData)
```

3.  Assigning variable names (part 4)  
I decided that it will be more conveniant if I was able to see and use variable names for further computations

```r
names(fullData)<-c("Subject", "Activity", as.character(feat$V2))
```

4. Giving the activity labels their names (part 3)  
Again for conveniance I assign the labels to the factor levels of the "Activity" variable.

```r
fullData$Activiy<-factor(fullData$Activity, labels=actLabels$V2)
```

5. Extracting mean and standard deviation measurements (part 2)  
Now when I have a complete data set I can extract more easily

```r
mean_sd_Data<- fullData[,grepl("mean|std|Subject|Activity", names(fullData))]
```

6. Creating tidy data set with the average of each variable for each activity and each subject. (part 5) (plyr package needed)

```r
library(plyr)
tidyData<-ddply(mean_sd_Data, c("Subject","Activity"), numcolwise(mean))
write.table(tidyData, file = "Tidy_data.txt")
```





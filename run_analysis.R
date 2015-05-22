# You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
#    measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.

# Reading the data

feat<-read.table("./Raw_data/features.txt")
actLabels<-read.table("./Raw_data/activity_labels.txt")
subjectTrain<-read.table("./Raw_data/train/subject_train.txt")
xTrain<-read.table("./Raw_data/train/X_train.txt")
yTrain<-read.table("./Raw_data/train/y_train.txt")
subjectTest<-read.table("./Raw_data/test/subject_test.txt")
xTest<-read.table("./Raw_data/test/X_test.txt")
yTest<-read.table("./Raw_data/test/y_test.txt")

# 1. Bindinding the data

testData<-cbind(cbind(subjectTest,yTest),xTest)
trainData<-cbind(cbind(subjectTrain,yTrain),xTrain)
fullData<-rbind(trainData,testData)
str(fullData)

# 4. Assigning variable names
names(fullData)<-c("Subject", "Activity", as.character(feat$V2))

# 3. Giving the activity labels their names

fullData$Activiy<-factor(fullData$Activity, labels=actLabels$V2)


# 2. Extracting mean and standard deviation

mean_sd_Data<- fullData[,grepl("mean|std|Subject|Activity", names(fullData))]

# 5. Producing tidy data set with the average of each variable for each 
#    activity and each subject.

library(plyr)

tidyData<-ddply(mean_sd_Data, c("Subject","Activity"), numcolwise(mean))


write.table(tidyData, file = "Tidy_data.txt")







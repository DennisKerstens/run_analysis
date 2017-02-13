#We are going to merge the training and the test set. We will create one new data set. 
#We will take the mean and stdev for each data point
#And we will create a new data set   

setwd("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment")
rm(list = ls())
library(dplyr) 

## read activity
activity_data <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/activity_labels.txt", 
                          col.names=c("activity","activityname"),stringsAsFactors=FALSE) 
## read features.txt 
feature <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/features.txt",stringsAsFactors=FALSE) 

## identify the columns for the mean and stdev 
MeanId <- feature[grepl("mean()",feature$V2) & !grepl("meanFreq()",feature$V2),1] 
StdId <- feature[grep("std()",feature$V2),1] 
meanColNames <- feature[c(MeanId,StdId),2] 

## read test and add the column names of tesData 
test_data <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/test/X_test.txt") 
test_labels <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/test/y_test.txt", 
                        col.names=c("activity")) 
Subject_Test <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/test/subject_test.txt",col.names=c("personId")) 
## column names are the feature names 
colnames(test_data) <- feature[,2] 
NewData <- test_data[,meanColNames] 
 
## cbind the data sets  
Test_data2 <- cbind(Subject_Test,test_labels,NewData) 
## read training data files 
Train_data <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/train/X_train.txt") 
Train_labels <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/train/y_train.txt", 
                        col.names=c("activity")) 
trainSubjects <- read.table("D:/My Data/PersonalFiles_for_Backup/Coursera/Course3_Week4/Assignment/train/subject_train.txt",col.names=c("personId")) 
 
## add column names for training 
colnames(Train_data) <- feature[,2] 
Train_dataSubset <- Train_data[,meanColNames] 
Train_data2 <- cbind(trainSubjects,Train_labels,Train_dataSubset) 

## rbind the two data sets train and test
Data_Train_Test <- rbind(Train_data2,Test_data2) 
 
## merge train_test with activity data 
Data_Train_Test <- merge(Data_Train_Test,activity_data,by.x="activity",by.y="activity") 
 
## with the command data.table you can sum columns by groups 
Data_table <- data.table(Data_Train_Test) 
NewDataSet <- Data_table[,lapply(.SD,mean),by="personId,activityname",.SDcols=3:68] 
 
## we now add "mean" to the variable names
NewColumns <- colnames(NewDataSet) 
NewColumns <- sapply(NewColumns, function(x) {paste("mean",x,sep="")}) 
setnames(NewDataSet,1:length(NewColumns),NewColumns) 
setnames(NewDataSet,1,"person_number") 
setnames(NewDataSet,2,"activity_name") 
 
write.table(NewDataSet,file="AssignmentCourse3_DennisKerstens.txt",row.names = FALSE) 

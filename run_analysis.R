library(plyr)
library(dplyr)

train <- read.table("UCI HAR Dataset/train/X_train.txt",header=FALSE)[,1:6]
train_labels <- read.table("UCI HAR Dataset/train/Y_train.txt",header=FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE)
test <- read.table("UCI HAR Dataset/test/X_test.txt",header=FALSE)[,1:6]
test_labels <- read.table("UCI HAR Dataset/test/Y_test.txt",header=FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE)

col_labels <- read.table("UCI HAR Dataset/features.txt")[1:6,2]
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE)


all_data <- rbind(train,test)
#colnames(all_data) <- col_labels #Commenting this out because Rstudio doesn't like recognizing the original column names
colnames(all_data) <- c("Xmean","Ymean","Zmean","Xstd","Ystd","Zstd")
all_labels <- rbind(train_labels,test_labels)
subject_labels <- rbind(subject_train,subject_test)[,1]
activity_labels <- mapvalues(all_labels[,1],from=activity_labels[,1],to=as.character(activity_labels[,2]))
all_data <- cbind(all_data,activity_labels,subject_labels)

mean_std_data <- merge(aggregate(Xmean~subject_labels+activity_labels,all_data,mean),aggregate(Ymean~subject_labels+activity_labels,all_data,mean))
mean_std_data <- merge(mean_std_data,aggregate(Zmean~subject_labels+activity_labels,all_data,mean))
mean_std_data <- merge(mean_std_data,aggregate(Xstd~subject_labels+activity_labels,all_data,mean))
mean_std_data <- merge(mean_std_data,aggregate(Ystd~subject_labels+activity_labels,all_data,mean))
mean_std_data <- merge(mean_std_data,aggregate(Zstd~subject_labels+activity_labels,all_data,mean))
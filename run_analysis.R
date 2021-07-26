# Downloading and unzipping data into the working directory
if(!file.exists("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data")){dir.create("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/Dataset.zip")
unzip(zipfile="C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/Dataset.zip",exdir="C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data")

#######1) Merges the training and the test sets to create one data set######
#a) Reading files
# Training tables
x_train <- read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/train/subject_train.txt")

# Testing tables
x_test <- read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/test/subject_test.txt")

# Feature vector
features <- read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/features.txt")

# Activity labels
activityLabels = read.table("C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/UCI HAR Dataset/activity_labels.txt")

#b) Column names
colnames(x_train) <- features[,2]
colnames(y_train) <-"activity_id"
colnames(subject_train) <- "subject_id"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_id"
colnames(subject_test) <- "subject_id"
colnames(activityLabels) <- c('activity_id','activityType')

#c) Merging data in one database
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
merged_database <- rbind(merge_train, merge_test)

#######2) Extracts only the measurements on the mean and standard deviation for each measurement#######
#a) Column names
colNames <- colnames(merged_database)

#b) vector of id, mean and standard deviation
id_mean_std <- (grepl("activity_id" , colNames) | 
                   grepl("subject_id" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#c) Subset
Mean_Std <- merged_database[ , id_mean_std == TRUE]

#######3) Uses descriptive activity names to name the activities in the data set#######
Activity_names <- merge(Mean_Std, activityLabels,
                              by='activity_id',
                              all.x=TRUE)

#######4) Appropriately labels the data set with descriptive variable names####### 
#Already done

#######5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject#######
#a) Second tidy data set
install.packages("dplyr") 
library(dplyr)
second_tidySet <- Activity_names %>% 
group_by(subject_id, activity_id) %>% 
summarise_each(funs(mean))

#b) Second tidy data set in txt file
write.table(second_tidySet, "C:/Users/Luis/Desktop/R/R course/Assignment_Cleaning and getting data/Data/Final_tidyset.txt", row.name=FALSE)





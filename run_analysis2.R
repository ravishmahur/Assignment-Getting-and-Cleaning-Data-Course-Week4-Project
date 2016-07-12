library(reshape2)
setwd("/home/coda/Documents/Data Science/3. Getting and Cleaning Data/Week 4/Assignments/UCI HAR Dataset")
activity_labels <- read.table("./activity_labels.txt", col.names = c("activity_id", "activity_name"))
features <- read.table("./features.txt")
features <- features[, 2]

test_X <- read.table("./test/X_test.txt")
test_Y <- read.table("./test/y_test.txt")
train_X <- read.table("./train/X_train.txt")
train_Y <- read.table("./train/y_train.txt")

subject_test <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")

colnames(test_X) <- features
colnames(train_X) <- features
colnames(test_Y) <- "activity_id"
colnames(train_Y) <- "activity_id"
colnames(subject_test) <- "subject_id"
colnames(subject_train) <- "subject_id"

testdata <- cbind(test_X, test_Y, subject_test)
traindata <- cbind(train_X, train_Y, subject_train)
data <- rbind(testdata, traindata)

mean_col_idx <- grep("mean", names(data), ignore.case=TRUE)
mean_col_names <- names(data)[mean_col_idx]
std_col_idx <- grep("std",names(data),ignore.case=TRUE)
std_col_names <- names(data)[std_col_idx]

mean_std_data <-data[, c("subject_id","activity_id",mean_col_names,std_col_names)]
descrnames <- merge(activity_labels, mean_std_data, by.x="activity_id", by.y="activity_id", all=TRUE)
data_melt <- melt(descrnames, id=c("activity_id","activity_name","subject_id"))
mean_data <- dcast(data_melt, activity_id + activity_name + subject_id ~ variable,mean)
write.table(mean_data,"./tidy_data.txt")


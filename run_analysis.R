setwd("C:/Users/vzt58p/Documents")

#Read files
activity<-read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features<-read.table("./UCI HAR Dataset/features.txt")[,2]
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Pulls the mean and standard deviation
pull_metric<-grepl("mean|std", features)

#Extracts the Test data
names(x_test) <- features
x_test <- x_test[,pull_metric]
y_test[,2] <- activity[y_test[,1]]
names(y_test) <- c("Activity_ID", "Activity_Label")
names(subject_test) <- "Subject"
test_data <- cbind(as.data.table(subject_test), y_test, x_test)

#Extracts the Train data
names(x_train) <- features
x_train <- x_train[,pull_metric]
y_train[,2] <- activity[y_train[,1]]
names(y_train) <-c("Activity_ID", "Activity_Label")
names(subject_train) <- "Subject"
train_data <- cbind(as.data.table(subject_train), y_train, x_train)

#Merges Test and Train data
data <- rbind(test_data, train_data)


ids <- c("Subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), ids)
melt_data <- melt(data, id = ids, measure.vars = data_labels)

tidy = dcast(melt_data, Subject + Activity_Label ~ variable, mean)
write.table(tidy, file = "./tidy.txt")
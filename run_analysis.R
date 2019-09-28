# Load the required library
library(dplyr)

# Load the data into R
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
feats <- read.table("./UCI HAR Dataset/features.txt")


# Label the data set with descriptive variable names
colnames(x_test) <- feats[,2]
colnames(x_train) <- feats[,2]

# Build a complete test data & train data
test_data <- cbind(subject_test, y_test, x_test)
train_data <- cbind(subject_train, y_train, x_train)

# Combine both test & train data
combined_data <- rbind(test_data, train_data)

# Extract only the measurements on mean and standard deviation
extracted_feats <- grep(".mean.|.std.", feats[,2])
temp_data <- combined_data[,c(1,2,extracted_feats+2)]

# Convert the subject and activity into factors
temp_data$activity <- factor(temp_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
temp_data$subject <- as.factor(temp_data$subject)

# Group the subject + activity and tabulate average of each variable
temp_data <- tbl_df(temp_data)
tidy_data <- group_by(temp_data, subject, activity, add = TRUE) %>%
                summarize_each(funs(mean))
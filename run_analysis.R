#   The following program collects data from the accelerometers of the Samsung Galaxy S smartphone
#   The purpose is to produce a clean (or tidy) data set, and output the result to a .txt file named "tidy.txt".

#load and attach dplyr package
library(dplyr)

# Get data
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

# Download (binary) file if it has not already been downloaded
if (!file.exists(zipFile)) {
  download.file(zipURL, zipFile, mode = "wb")
}

# If data directory doesn't already exist, unzip zip file with data
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}

# Read in TRAINING data
trainingSubjects <- read.table(file.path(dataPath, "train", "subject_train.txt"))
trainingValues <- read.table(file.path(dataPath, "train", "X_train.txt"))
trainingActivity <- read.table(file.path(dataPath, "train", "y_train.txt"))

# Read in TEST data
testSubjects <- read.table(file.path(dataPath, "test", "subject_test.txt"))
testValues <- read.table(file.path(dataPath, "test", "X_test.txt"))
testActivity <- read.table(file.path(dataPath, "test", "y_test.txt"))

# Read in FEATURES, and store in variable
features <- read.table(file.path(dataPath, "features.txt"), as.is = TRUE)

# Read in ACTIVITY LABELS
activities <- read.table(file.path(dataPath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")


# STEP 1 - Merge the training and the test sets to create one data set.

# Combine data tables to create a single data table
humanActivity <- rbind(cbind(trainingSubjects, trainingValues, trainingActivity), cbind(testSubjects, testValues, testActivity))

# Assign names to columns
colnames(humanActivity) <- c("subject", features[, 2], "activity")


# STEP 2 - Extract only the measurements on the mean and standard deviation for each measurement.

# Determine columns of dataset to keep
columnsToKeep <- grepl("subject|activity|mean|std", colnames(humanActivity))

# The columns to keep the data in.
humanActivity <- humanActivity[, columnsToKeep]


# STEP 3 - Uses descriptive activity names to name the activities in the data set.

# This is to replace the activity values with factor levels
humanActivity$activity <- factor(humanActivity$activity, levels = activities[, 1], labels = activities[, 2])


# STEP 4 - Appropriately label the data set with descriptive variable names

# Get column names, and store in a variable
humanActivityCols <- colnames(humanActivity)

# Declare variable that takes in column names, but removes special characters
humanActivityCols <- gsub("[\\(\\)-]", "", humanActivityCols)

# Substitute abbreviations and unsuitable names 
humanActivityCols <- gsub("Acc", "Accelerometer", humanActivityCols)
humanActivityCols <- gsub("^f", "FrequencyDomain", humanActivityCols)
humanActivityCols <- gsub("^t", "TimeDomain", humanActivityCols)
humanActivityCols <- gsub("std", "StandardDeviation", humanActivityCols)
humanActivityCols <- gsub("Gyro", "Gyroscope", humanActivityCols)
humanActivityCols <- gsub("Mag", "Magnitude", humanActivityCols)
humanActivityCols <- gsub("Freq", "Frequency", humanActivityCols)
humanActivityCols <- gsub("mean", "Mean", humanActivityCols)
humanActivityCols <- gsub("BodyBody", "Body", humanActivityCols)

# Use newly modified labels as the column names
colnames(humanActivity) <- humanActivityCols


# STEP 5 - From the data set in STEP 4, create a second, independent tidy data 
# set with the average of each variable for each activity and each subject

# Group by subject and activity
humanActivityMeans <- humanActivity %>% 
  group_by(subject, activity) %>%
  
  # Summarize using the mean
  summarise_each(funs(mean))

# Finally, output to .txt file "tidy.txt"
write.table(humanActivityMeans, "tidy.txt", row.names = FALSE, quote = FALSE)

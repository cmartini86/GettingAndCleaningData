# Variables

Each row contains 79 averaged signal measurements.

# Identifiers

- subject: subject identifier, integer, ranges from 1 to 30.

- `activity`
   Activity identifier, string with 6 possible values for each activity: 
   WALKING, WALKING_UPSTAIRS, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

# Transformations

The zip file containing the data is located at [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Below, are the transformations that were applied to the source data:

1. The TRAINING and TEST sets were merged to create one data set.
2. The measurements on the mean and standard deviation were extracted for each measurement, while discarding the others.
3. The activity identifiers were replaced with descriptive activity names.
4. The variable names were replaced with descriptive variable names.
5. From the data set in step 4, the final data set was created with the average of each variable for each activity and each subject.

Finally, the result is output to .txt file "tidy.txt"

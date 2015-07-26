## 1. Merges the training and the test sets to create one data set.
# Read the train dataset
trainX = read.table("./dataset/train/X_train.txt")
trainY = read.table("./dataset/train/y_train.txt")
trainSubj = read.table("./dataset/train/subject_train.txt")
# Read the test dataset
testX = read.table("./dataset/test/X_test.txt")
testY = read.table("./dataset/test/y_test.txt")
testSubj = read.table("./dataset/test/subject_test.txt")
# Combine both train and test dataset
combiX = rbind(trainX, testX)
combiY = rbind(trainY, testY)
combiSubj = rbind(trainSubj, testSubj)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features = read.table("./dataset/features.txt")
extractX = combiX[, grep("mean|std", features[,2])]

## 3. Uses descriptive activity names to name the activities in the data set
activityLabels = read.table("./dataset/activity_labels.txt")

# Replace numbers in combiY with labels
combiY[,1] = activityLabels[combiY[,1],2]

## 4. Appropriately labels the data set with descriptive variable names. 
names(extractX) = features[grep("mean|std", features[,2]),2]
names(combiY) = "activity"
names(combiSubj) = "subject"

# Merge the dataset
data1 = cbind(combiSubj, combiY, extractX)
names(data1) = gsub("-", "", names(data1))
names(data1) = gsub("mean", "Mean", names(data1))
names(data1) = gsub("std", "Std", names(data1))
names(data1) = gsub("\\(\\)", "", names(data1))

# Make tidy data
tidydata = aggregate(data1, by=list(activity = data1$activity, subject=data1$subject), mean)
tidydata[,4] = NULL
tidydata[,3] = NULL

# Write data to file
write.table(tidydata, "tidydata.txt", row.name=FALSE)


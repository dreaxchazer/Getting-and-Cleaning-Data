#1. Merges the training and the test sets to create one data set

activityLabels = read.table("./activity_labels.txt",header=FALSE)
colnames(activityLabels) = c("activityId","activity")
features = read.table("./features.txt",header=FALSE)

xTrain = read.table("./train/x_train.txt",header=FALSE)
yTrain = read.table("./train/y_train.txt",header=FALSE)
subjectTrain = read.table("./train/subject_train.txt",header=FALSE)
colnames(xTrain) = features[,2]
colnames(yTrain) = "activityId"
colnames(subjectTrain) = "subjectId"
trainSet = cbind(subjectTrain,yTrain,xTrain)

xTest = read.table("./test/x_test.txt",header=FALSE)
yTest = read.table("./test/y_test.txt",header=FALSE)
subjectTest = read.table("./test/subject_test.txt",header=FALSE)
colnames(xTest) = features[,2]
colnames(yTest) = "activityId"
colnames(subjectTest) = "subjectId"
testSet = cbind(subjectTest,yTest,xTest)

combineSet = rbind(trainSet,testSet)

#2. Extracts only the measurements on the mean and standard deviation for each measurement

trueFalse = (grepl("activityId",names(combineSet)) | grepl("subjectId",names(combineSet)) | (grepl("-mean",names(combineSet)) & !grepl("-mean\\()-",names(combineSet)) & !grepl("-meanF",names(combineSet))) | (grepl("-std",names(combineSet)) & !grepl("-std\\()-",names(combineSet))))
combineSet = combineSet[trueFalse==TRUE]

#3. Uses descriptive activity names to name the activities in the data set

combineSet = merge(combineSet,activityLabels,by="activityId",all.x=TRUE)

#4. Appropriately labels the data set with descriptive variable names

for (i in 1:length(names(combineSet)))
	{
		names(combineSet)[i] = gsub("-mean\\()","- Mean",names(combineSet)[i])
		names(combineSet)[i] = gsub("-std\\()","- SD",names(combineSet)[i])
		names(combineSet)[i] = gsub("^(t)","Time ",names(combineSet)[i])
		names(combineSet)[i] = gsub("^(f)","Frequency ",names(combineSet)[i])
		names(combineSet)[i] = gsub("Body","Body ",names(combineSet)[i])
		names(combineSet)[i] = gsub("Gravity","Gravity ",names(combineSet)[i])
		names(combineSet)[i] = gsub("Acc","Acceleration ",names(combineSet)[i])
		names(combineSet)[i] = gsub("Mag","Magnitude ",names(combineSet)[i])
		names(combineSet)[i] = gsub("Jerk","Jerk ",names(combineSet)[i])
		names(combineSet)[i] = gsub("Gyro","Gyro ",names(combineSet)[i])
	}

#5. Create a second, independent tidy data set with the average of each variable for each activity and each subject

tidyDataSet = aggregate(combineSet[3:20],by=list(activityId=combineSet[,1:20]$activityId,subjectId=combineSet[,1:20]$subjectId),mean)
tidyDataSet = merge(tidyDataSet,activityLabels,by="activityId",all.x=TRUE)

write.table(tidyDataSet,"./tidyDataSet.txt",row.names=FALSE,sep=";")
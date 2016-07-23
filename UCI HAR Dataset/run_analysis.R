
##Read Training Data Set - Leave Header to TRUE (Default)
trainingSetTrain<-read.csv("train/X_train.txt", sep = " ")


##Read Sample Data Set - Leave Header to TRUE (Default)
sampleSetTrain<-read.csv("test/X_test.txt", sep = " ")

#########################################################
##Other information required 
subjectsTrain<-read.csv("train/subject_train.txt", sep = " ")
subjectsSample<-read.csv("test/subject_test.txt", sep = " ")
activityLabels<-read.csv("activity_labels.txt", sep=" ", header = FALSE)
labelsSetTrain<-read.csv("train/y_train.txt", sep=" ")

##from sample
labelsSetSample<-read.csv("test/y_test.txt", sep=" ")
labelsSetSample$ActivityName <- activityLabels[labelsSetSample$X5,2]
labelsSetSample$Subject<-subjectsSample$X2

##Create LabelSet with correct activity names and subject association 
labelsSetTrain$ActivityName <- activityLabels[labelsSetTrain$X5,2]
labelsSetTrain$Subject<-subjectsTrain$X1

names(labelsSetTrain) <- c("ActivityID", "ActivityName", "Subject")
names(labelsSetSample) <- c("ActivityID", "ActivityName", "Subject")

labelsSetTrain<-rbind(labelsSetTrain, labelsSetSample)

#########################################################



##Read all variable names, set Header to FALSE (No header in file)
allVariables<-read.csv("features.txt", sep = " ", header = FALSE)

##Find all variables with representing the mean - look for mean in the name of variable
allMeans <- allVariables[grep("mean", allVariables$V2), ]

##The logic for standard deviation
allStds<-allVariables[grep("std", allVariables$V2), ]


##Create a vector with all variable id's by mearging all mean ids and all std ids
allMeanAndStds <- allMeans$V1
allMeanAndStds <- append(allMeanAndStds, allStds$V1)
allMeanAndStds <- sort(allMeanAndStds)
allSelectedVariables <- allVariables[allMeanAndStds, ]
 
##Reduce the two datasets to only the columns we are interested in
trainingSetTrain <- trainingSetTrain[ ,allSelectedVariables$V1]
sampleSetTrain <- sampleSetTrain[ ,allSelectedVariables$V1]

##Set the names to meaningfull variable names 
names(trainingSetTrain) <- allSelectedVariables$V2
names(sampleSetTrain) <- allSelectedVariables$V2

##order columns by name 
trainingSetTrain <- trainingSetTrain[, order(names(trainingSetTrain))]
sampleSetTrain <- sampleSetTrain[, order(names(sampleSetTrain))]

##Merge the training set with the sample set by appending each row from the sample at the end 
##      of the training set.
fullSet <- rbind(trainingSetTrain, sampleSetTrain)


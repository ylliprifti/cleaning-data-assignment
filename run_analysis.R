library(dplyr)
library(reshape2)


run_analysis <- function() {

##### READ RELEVANT INFORMATION FROM FILES ###

#Training DataSet
train           <-read.table("UCI HAR Dataset/train/X_train.txt")
#Sample DataSet
sample          <-read.table("UCI HAR Dataset/test/X_test.txt")

#Subjects, Labels and Variables for Test and Samples
subjectsTrain   <-read.table("UCI HAR Dataset/train/subject_train.txt")
subjectsSample  <-read.table("UCI HAR Dataset/test/subject_test.txt")
activityLabels  <-read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
labelsTrain     <-read.table("UCI HAR Dataset/train/y_train.txt")
labelsSample    <-read.table("UCI HAR Dataset/test/y_test.txt")

##All Variable Names, set Header to FALSE (No header in file)
allVariables    <-read.table("UCI HAR Dataset/features.txt", header = FALSE)


####  END READ INFORMATION                ###

###   CREATE CLEAN TABLE AUX INFO ###
###   I.E, ACTIVITYID, ACTIVITYNAME, SUBJECT

labelsSample$ActivityName   <- activityLabels[labelsSample$V1,2]
labelsSample$Subject        <- subjectsSample$V1

labelsTrain$ActivityName    <- activityLabels[labelsTrain$V1, 2]
labelsTrain$Subject         <- subjectsTrain$V1

names(labelsTrain)          <- c("ActivityID", "ActivityName", "Subject")
names(labelsSample)         <- c("ActivityID", "ActivityName", "Subject")

###   END CREATE CLEAN AUX INFO  ### 

##    CREATE TABLE WITH REQUIRED VARIABLED ##

allMeans <- allVariables[grep(".*mean*.", allVariables$V2), ]
allStds<-allVariables[grep(".*std*.", allVariables$V2), ]

allMeanAndStds <- allMeans$V1
allMeanAndStds <- append(allMeanAndStds, allStds$V1)
allMeanAndStds <- sort(allMeanAndStds)
allSelectedVariables <- allVariables[allMeanAndStds, ]
allSelectedVariables$V2 <- gsub("[()]", "", allSelectedVariables$V2, ignore.case = TRUE)
allSelectedVariables$V2 <- gsub("-mean", "Mean", allSelectedVariables$V2, ignore.case = TRUE)
allSelectedVariables$V2 <- gsub("-std", "Std", allSelectedVariables$V2, ignore.case = TRUE)

remove("allVariables", "allMeans", "allStds", "allMeanAndStds")

##    END REQUIRED VARIABLES               ##


######    CREATE CLEAN DATA               ####### 

train <- train[ ,allSelectedVariables$V1]
sample <- sample[ ,allSelectedVariables$V1]

##Set the names to meaningfull variable names 
names(train) <- allSelectedVariables$V2
names(sample) <- allSelectedVariables$V2

##Add Activity and Subject
train  <- cbind(labelsTrain, train)
sample <- cbind(labelsSample, sample)

fullSet <- rbind(train, sample)

remove("train", "sample")

#####  END CLEAN DATA              ######

#####  SUMMARIZE DATA AND CALCULATE MEAN #### 

fullSetMelted <- melt(fullSet, id.vars = c("ActivityID", "ActivityName", "Subject"))
fullSetMean   <- dcast(fullSetMelted, Subject + ActivityID + ActivityName ~ variable, mean)

write.table(fullSetMean, "tidy.txt", row.names = FALSE, quote = FALSE, col.names = FALSE)

print("Complete. File [tidy.txt] saved.")
fullSetMean
####  END OF FILE                        ####

}
  
## Run Function
fullSetMean<-run_analysis()
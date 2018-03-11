if(!file.exists("./data")){dir.create("./data")}
 fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 download.file(fileUrl,destfile = "./data/projectdata.zip",mode = 'wb')
 unzip(zipfile="./data/projectdata.zip",exdir = "./data")
#the directory to extract files to is created
 #Merge the data sets
 #Training Tables and Testing Tables
  xTraining<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
 yTraining<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
 subjectTraining<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
 xTesting<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
 yTesting<-read.table("./data/UCI HAR Dataset/test/y_test.txt") 
 subjectTesting<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
 #features and activity labels
  features<-read.table("./data/UCI HAR Dataset/features.txt")
 Labels<-read.table("./data/UCI HAR Dataset/activity_labels.txt")
 #Naming Coulmns
   colnames(xTraining)<-features[ ,2]
 colnames(xTesting)<-features[ ,2]
 colnames(yTraining)<-"Id_Activity"
 colnames(yTesting)<-"Id_Activity"
 colnames(subjectTraining)<-"Id_Subject"
 colnames(subjectTesting)<-"Id_Subject"
 colnames(Labels)<-c('Id_Activity','activitityType')
 #merge data
   Training<-cbind(yTraining,subjectTraining,xTraining)
 Testing<-cbind(yTesting,subjectTesting,xTesting)
 OneSet<-rbind(Training,Testing)
 #mean and standard deviation
   OneSetNames<-colnames(OneSet)
  Mean_SD<-(grepl("Id_Activity",OneSetNames)|grepl("Id_Subject",OneSetNames)|grepl("mean..",OneSetNames)|grepl("std..",OneSetNames))                   
 SetofMeanAndSd<-OneSet[ ,Mean_SD==TRUE]
  #final naming
    FinalNaming<-merge(SetofMeanAndSd,Labels,by='Id_Activity', all.x=TRUE)
  #second set
    secondSet<-aggregate(.~Id_Subject+Id_Activity,FinalNaming,mean)
 secondSet<-secondSet[order(secondSet$Id_Subject,secondSet$Id_Activity), ]
 write.table(secondSet,"secondSet.txt",row.names = FALSE)
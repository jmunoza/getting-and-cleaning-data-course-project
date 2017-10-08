

# Step 1: create a new folder called "Project" in de actual directory and donwload the file in it

ini_path <-"C:/Users/Jovo/Desktop/Curso Data Science/Curso 3 - Getting and Cleaning Data"

setwd(ini_path)

path <- getwd()
ruta <- paste0(path,"/Project")

if (!file.exists(ruta)) {
        dir.create(ruta)
}
setwd(ruta)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "Dataset.zip"
download.file(url, "project_file.zip")

# Step 2: unzip file


unzip(file.path(ruta,"project_file.zip"))

# update path with the extracted folder

ruta <- file.path(ruta,"UCI HAR Dataset")
setwd(ruta)
getwd()


# Step 3: create a variable for each dataset

## test data:
XTest<- read.table("UCI HAR Dataset/test/X_test.txt")
YTest<- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectTest <-read.table("UCI HAR Dataset/test/subject_test.txt")

## train data:
XTrain<- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain<- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")


## features and activity
features<-read.table("UCI HAR Dataset/features.txt")
activity<-read.table("UCI HAR Dataset/activity_labels.txt")

##Part1 - merges train and test data in one dataset (full dataset at the end)
X<-rbind(XTest, XTrain)
Y<-rbind(YTest, YTrain)
Subject<-rbind(SubjectTest, SubjectTrain)


dim(X)
dim(Y)
dim(Subject)

# Step 4:  Getting only rows with mean o std name

index<-grep("mean\\(\\)|std\\(\\)", features[,2]) 
X<-X[,index] ## gettin onli rows we want from X
 
# Step 5:  reeplacing numbers for descriptions in V1

Y[,1] <- merge(Y,activity)[,2]
table(Y[,1])



descr_names<-features[index,2]
length(descr_names)
names(X) <- descr_names
names(Subject)<-"SubjectID"
names(Y)<-"Activity"


# Step 6: export data

Final_data <- cbind(Subject,X,Y)
head(Final_data)
library(data.table)
Final_data<-data.table(Final_data)
TData <- Final_data[, lapply(.SD, mean), by = 'SubjectID,Activity'] 
TData
write.table(TData, file = "TData.txt", row.names = TRUE)


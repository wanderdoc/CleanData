getwd()



library(dplyr) # select, group_by, summarise_each.








# Load data (test dataset). This requires some time!
X_test<-read.table("./UCI HAR Dataset/test/X_test.txt" )
# Load activities (test dataset).
Y_test<-read.table("./UCI HAR Dataset/test/Y_test.txt" )
# Load subjects (test dataset).  
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt" )
# Combine test dataset.
test_all <- cbind(subject_test , Y_test , X_test)
# Clean up to save space.
rm(X_test, Y_test, subject_test)

# Load data (train dataset). This requires some more time!
X_train<-read.table("./UCI HAR Dataset/train/X_train.txt" )
# Load activities (train dataset).
Y_train<-read.table("./UCI HAR Dataset/train/Y_train.txt" )
# Load subjects (train dataset).
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt" )
# Combine train dataset.
train_all<-cbind(subject_train, Y_train, X_train)
# Clean up to save space.
rm(X_train, Y_train, subject_train)

# Combine complete dataset.
all<-rbind(test_all, train_all)
# Clean up.
rm(test_all, train_all)




# Load activity labels.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",
                              col.names=c("ID","activity"))

# Load field names.
features <- read.table("./UCI HAR Dataset/features.txt",
                       col.names=c("ID","FIELD"))
# Add names for subjects and activity.
# First convert loaded names to characters (they are factors).
data_names<-as.character(features$FIELD) 
two_cols<-c("subject", "activity")
data_names<-c(two_cols, data_names)

# Make syntactically valid names (option 'unique' is important). 
data_names <- make.names(data_names, unique=TRUE) 

# Apply these names.
colnames(all)<-data_names


# Select only columns we need into a smaller dataframe.
project <- select(all, subject, activity, contains(".mean."), contains(".std."))

# Clean up.
rm(all)
# Check the names.
names(project)

# Make descriptive names for activities.
al<-list()
al[activity_labels$ID]<-as.character(activity_labels$activity)
pa<-sapply(project$activity, function(x) al[[x]])
project$activity<-pa
rm(al, pa)

# Make descriptive field names.
# Well, one still need to look into codebook, 
# otherwise the names would be too long.
names(project)<- gsub("\\.+", "\\.", names(project))
names(project)<- gsub("\\.$", "", names(project))
names(project)<- gsub("BodyBody", "Body", names(project))

# Make the final dataset.
finaldata<-project  %>% group_by(subject, activity) %>%
  summarise_each(funs(mean))

# Write it down:
write.table(finaldata,"./tidy_dataset_final.txt", row.name=FALSE)

# Clean up:
rm(project, data_names, two_cols, features, activity_labels)

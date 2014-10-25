# Import data-------------------------------------------------------
setwd("C:/data/project"); getwd()

path_X_test <- "C:/data/project/test/X_test.txt"
path_y_test <- "C:/data/project/test/y_test.txt"
path_subject_test <- "C:/data/project/test/subject_test.txt"

path_X_train <- "C:/data/project/train/X_train.txt"
path_y_train <- "C:/data/project/train/y_train.txt"
path_subject_train <- "C:/data/project/train/subject_train.txt"

path_varname <- "C:/data/project/features.txt"
path_activity_label <- "C:/data/project/activity_labels.txt"

test_set <- read.table(path_X_test)
test_label <- read.table(path_y_test)
test_subject <- read.table(path_subject_test)
dim(test_set);dim(test_label);dim(test_subject)

train_set <- read.table(path_X_train)
train_label <- read.table(path_y_train)
train_subject <- read.table(path_subject_train)
dim(train_set);dim(train_label);dim(train_subject)

varname <- read.table(path_varname)
dim(varname)

activity_label <- read.table(path_activity_label, stringsAsFactors = FALSE)
str(activity_label)

# Generate test and train set with acitivity and subject(Step 4)--------------
names(test_set) <- varname$V2
names(test_label) <- c("activity")
names(test_subject) <- c("subject")
test <- cbind(test_set, test_label, test_subject)
dim(test)

names(train_set) <- varname$V2
names(train_label) <- c("activity")
names(train_subject) <- c("subject")
train <- cbind(train_set, train_label, train_subject)
dim(train)

# Step 1------------------------------------------------------------
dat <- rbind(test, train)
class(dat); dim(dat)
str(dat)

# Step 2------------------------------------------------------------
colIndex <- grepl("mean()", names(dat))|grepl("std()", names(dat))|grepl("activity", names(dat))|grepl("subject", names(dat))
dat2 <- dat[, colIndex]
dim(dat2);str(dat2)

# Step 3------------------------------------------------------------
act <- as.character(dat2$activity)
act <- sub("1", "WALKING", act)
act <- sub("2", "WALKING_UPSTAIRS", act)
act <- sub("3", "WALKING_DOWNSTAIRS", act)
act <- sub("4", "SITTING", act)
act <- sub("5", "STANDING", act)
act <- sub("6", "LAYING", act)
table(act)

dat2$activity <- act

# Step 4-------------------------------------------------------------
str(dat2)

# Step 5-------------------------------------------------------------
library(dplyr)
dat5 <- tbl_df(dat2)

dat6 <- dat5 %>%
	group_by(activity, subject) %>%
	summarise_each(funs(mean)) 
dim(dat6); str(dat6)
write.table(dat6, "tidy.txt", row.name = FALSE)	

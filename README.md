---
title: "Readme"
output: html_document
---

This assignment dealt with the data transformation. It uses the "Human Activity Recognition Using Smartphones Data Set" - see the full description [here.](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The citation of this data set: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013. 


The data transformation is performed by the run_analysis.R script. It assumes that the data directory "UCI HAR Dataset" is the subfolder of the working directory.


## The assignment tasks were as follows:
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Use descriptive activity names to name the activities in the data set.
- Appropriately label the data set with descriptive variable names.
- Create a second, independent tidy data set with the average of each variable for each activity and each subject.
- Submit the R script (`run_analysis.R`) as well as two markdown documents (`readme.md` - which is this document - and `codebook.md`).


## The original dataset included the following data files:
- 'features.txt': List of all measures in the original dataset.
- 'activity_labels.txt': List of the performed activities.
- 'train/X_train.txt': Training set of measures.
- 'train/y_train.txt': Activity labels in the training set (encoded).
- 'train/subject_train.txt': The ID's of volunteers in training set (encoded).
- 'test/X_test.txt': Test set of measures.
- 'test/y_test.txt': Activity labels in the test set (encoded).
- 'test/subject_test.txt': The ID's of volunteers in the test set (encoded).

## How the script works:

- Library dplyr is loaded for some manipulations on the dataframe (the functions `select`, `group_by`, `summarise_each` are required).
- The test set of measures is loaded and cbind'ed with the training list of activities and the ID's of subjects. The resulting dataframe is named `test_all`. After that the loaded raw data is removed to save memory.
- The same way the training data (values, activities, subject ID's) is loaded and cbinded to the `train_all` dataframe. The loaded raw data is removed as well to save memory.
- Next the two dataframes (`test_all` and `train_all`) ar rbind'ed to the `all` datasets. The parent dataframes are then removed.
- The descriptive names of activities are loaded (`activity_labels`).
- Next, the names of the measures are loaded (`features`) to become the column names. Since they are loaded as factors they are then converted to characters. The names for the first two columns (`subject` and `activity`) are added. Since the names of the measures are not in every cases valide `R` names they were made so with the function `make.names`. The option `unique` is important to prevent duplicates. The names are then applied as the column names of the `all` dataframe.
- Next only the variables which contain averages and standard deviations are left in the dataframe (command `select`) The columns with subjects and activity labels are included too.
- The encoded activity labels are mapped using `activity_labels` dataframe which is read into a dictionary-like list(`al`).
- The variable names are cleaned from dots and duplicate parts using regexes. The real descriptive names would be far to long to be practical. For the  description of the name constructions please see codebook.md. For the full description of the variables please see the original dataset documentation: `http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones`.
- Finally the tidy data set (`finaldata`)as required for the assignment is produced using `group_by` and `summarize_each` commands of dplyr.
- The data is written to disk using `write.table` command.

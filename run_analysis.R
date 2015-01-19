# Parts 1 and 2

# Function for reading subject_train, X_train, y_train from the folder 'train and labelling/extracting the data for mean and SD. 

r_Data = function (fname, folder) {
  
  path = file.path(folder, paste0("y_", fname, ".txt"))
  
  y_data = read.table(path, header=FALSE, col.names = c("ActiviytID"))
  
  path = file.path(folder, paste0("subject_", fname, ".txt"))
  
  subject_data = read.table(path, header=FALSE, col.names=c("SubjectID"))
  
  data_columns = read.table("features.txt", header=FALSE, as.is=TRUE, col.names=c("MeasureID", "MeasureName"))
  
  path = file.path(folder, paste0("X_", fname, ".txt"))
  
  dataset = read.table(path, header=FALSE, col.names=data_columns$MeasureName)
  
  subset_data_columns = grep(".*mean\\(\\)|.*std\\(\\)", data_columns$MeasureName)
  
  dataset = dataset[, subset_data_columns]
  
  dataset$ActivityID = y_data$ActivityID
  
  dataset$SubjectID = subject_data$SubjectID
    
  dataset
  
}

# read test dataset

read_test_data = function() {
  
  r_Data("test", "test")
  
}

# read train dataset

read_train_data = function () {
  
  r_Data("train", "train")
  
}

# merge datasets and apply proper names

mergeDataset = function () {
  
  dataset = rbind(read_test_data(), read_train_data())
  
  cnames = colnames(dataset)
  
  cnames = gsub("\\.+mean\\.+", cnames, replacement = "Mean")
  
  cnames = gsub("\\.+std\\.+", cnames, replacement = "Std")
  
  colnames(dataset) = cnames
  
  dataset
  
}

# Part 3 and 4

# Read activity labels 

activityLabels = function (dataset) {
  
  activity_labels = read.table("activity_labels.txt", header = FALSE, as.is=TRUE, col.names = c("ActivityID", "ActivityName"))
  
  activity_labels$ActivityName = as.factor(activity_labels$ActivityName)
  
  data_labels = merge(dataset, activity_labels)
  
  data_labels
  
}

# merge activity labels

merge_label_data = function () {
  
  activityLabels(mergeDataset())
  
}

# Part 5

# Creating a tidy data set with the average of each var for all activities and all subjects. 

tidyData = function(merge_label_data) {
  
  library(reshape2)
    
  vars = c("ActivityID", "ActivityName", "SubjectID")
  
  measure_vars = setdiff(colnames(merge_label_data), vars)
  
  melted_data <- melt(merge_label_data, id=vars, measure.vars=measure_vars)
  
  # recast data
  
  dcast(melted_data, ActivityName + SubjectID ~ variable, mean)
  
}

#write clean tidy dataset

tidy_datafile =function(fname){
  
  tidy_data = tidyData(merge_label_data())
  
  write.table(tidy_data, fname)
  
}

tidy_datafile("tidy.txt")
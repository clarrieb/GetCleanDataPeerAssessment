# GetCleanDataPeerAssessment


Functions used to read & parse the data

Function r_Data : reads the files from a folder and creates data.frame. Only those columns which has MeasureName for mean and standard deviation are used, via a grep statement.

Function read_test_data and read_train_data: reads the test/train  data respectively.

Function mergeDataset : merges datasets.

Function activityLabels: merges activity labels


Function tidyData: creates a tidy data set - average of all variables for all activities and all subjects.

Function tidy_datafile: writes the tidy.txt file
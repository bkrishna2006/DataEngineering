#```{r gettingData, echo=T}
setwd("D:/DataScienceCapstoneR/Scripts")

myScriptsDir <- "D:/DataScienceCapstoneR/Scripts"
myRawDataDir <- "D:/DataScienceCapstoneR/RawData"
myRefDataDir <- "D:/DataScienceCapstoneR/RefData"
mySampleDataDir <- "D:/DataScienceCapstoneR/SampleData"
myGenDataDir <- "D://DataScienceCapstoneR/GenData"

# Sample size for the timebeing is set to 10 %
sampleSize <- 0.1

setwd(myRawDataDir)

myNewDataFiles <- list.files(path = getwd(),pattern = "*.txt")

myNewDataset <- lapply(myNewDataFiles,function(x){
  return(list(fileName=x,fileContent=readLines(x,skipNul = T) ))
})
# Calculate the max length of the contents from each text file

myNewDataset.maxchar <- lapply(myNewDataset, function(x){
  return(max(nchar(x$fileContent)))
})
myNewDataset.maxchar <- as.data.frame.numeric(myNewDataset.maxchar)

# Calculate the max size of the contents from each text file

myNewDataset.maxlength <- lapply(myNewDataset, function(x){
  return(max(length(x$fileContent)))
})
myNewDataset.maxlength <- as.data.frame.numeric(myNewDataset.maxlength)
#```

# Calculate the size of the files

kb <- 1/1024  # bytes
mb <- kb/1024 # bytes
gb <- mb/1024 # bytes

fileSizeMB <- round((file.info(myNewDataFiles)$size * mb),1)

# Calculate the object size

myNewDataset.objSize <- lapply(myNewDataset, function(x){
  return(object.size(x$fileContent)) 
})

objectSizeMB <- round((as.numeric(myNewDataset.objSize) * mb),1)

# Build a table to compare the statistics of the text files

stat <- as.data.frame(matrix(nrow = length(myNewDataset), ncol = 5))
colnames(stat) <- c("file", "maxchar", "maxlines", "FileSize(MB)","ObjectSize(MB)")
stat[,1] <- myNewDataFiles
stat[,2] <- myNewDataset.maxchar
stat[,3] <- myNewDataset.maxlength
stat[,4] <- fileSizeMB
stat[,5] <- objectSizeMB

fileSizeTot <- sum(stat[,4])
objectSizeTot <- sum(stat[,5])

# From the file statistics table, it appears that a sampling based on file size shall be a good approach for getting a good mix from the 3 files. To restrict total file size to about 5 MB, only 1 % shall be considered for the samples.  So will extract 1 % of total lines from each file for further analysis.

stat[,6] <- round(stat[4]/sum(stat[,4]),2)  # to determine the proportion.
stat[,7] <- round(as.numeric(stat[,3]) * stat[,6] * sampleSize)  # 1 % of lines

colnames(stat) <- c("file", "maxchar", "maxlines", "FileSize(MB)","ObjSize(MB)", "DataRatio", "Lines4Smpl")
#```

# 3. Raw Data Statistics.. 
#========================================================
#  ```{R RawDataStatisticsOutput, echo=TRUE}
stat  # use this for first time run/knit
#stat[3:5,]    #shall use this for re-runs, when other .txts like badword.txt got created

#```

# Clearning the environment of objects not required anymore

rm(myNewDataset,myNewDataset.maxchar, myNewDataset.maxlength,
   kb,mb,gb,fileSizeMB,
   myNewDataset.objSize,objectSizeMB,
   fileSizeTot,objectSizeTot)
gc()
#4. Extracting the samples and exploring the contents
#========================================================

#  From file statistics, it appears that a sampling based on file size shall be a good approach for getting a good mix of data from the 3 files. To restrict total file size to about 5 MB, only 1 % data volume shall be considered for the samples.  
#So will extract 1 % of total lines from each file for further analysis.
#Based on the sampling logic, small samples of the 3 types of text data - (a) blogs (b)news and (c)twitter are created, with 3,237 lines from blogs, 270 lines from news and 6,844 lines from twitter respectively.

#```{r exploreSamples,echo=F}

blogsLinesSample <- round(stat[1,7])
newsLinesSample <- round(stat[2,7])
twitterLinesSample <- round(stat[3,7])

blogsSample <- as.data.frame(readLines(myNewDataFiles[1],n=blogsLinesSample,encoding = "Latin-1",skipNul = T),stringsAsFactors = F)
newsSample <- as.data.frame(readLines(myNewDataFiles[2],n=newsLinesSample,encoding = "Latin-1",skipNul = T),stringsAsFactors = F)
twitterSample <- as.data.frame(readLines(myNewDataFiles[3],n=twitterLinesSample,encoding = "Latin-1",skipNul = T),stringsAsFactors = F)


colnames(blogsSample) <- "blogsContents"
colnames(newsSample) <- "newsContents"
colnames(twitterSample) <- "twitterContents"

#allSample <- c(blogsSample,newsSample,twitterSample)

#colnames(allSample) <- "Contents"

setwd(mySampleDataDir)

write.table(blogsSample,file = "blogsSample.txt",col.names = F)
write.table(newsSample,file = "newsSample.txt",col.names = F)
write.table(twitterSample,file = "twitterSample.txt",col.names = F)
#write.table(allSample,file = "allSample.txt",col.names = F)

#```

# Clearning the environment of objects not required anymore
rm(blogsLinesSample, 
   newsLinesSample,
   twitterLinesSample,
   blogsSample,
   newsSample,
   twitterSample)
gc()

rm(list=ls(all.names = T))
gc()

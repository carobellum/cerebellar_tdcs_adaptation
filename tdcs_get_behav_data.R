# --------------------- File Description --------------------- 
#   FILES
#   All are stored in folder
#   ./data
# 
#   Files available:
#   wash_data.txt             contains Wash data
#   main_data.txt             contains Adapt data
#
#   main_subjectlist.txt     contains Adapt subject list
#   ............................................................
#   DATA
#   (text file ending in _data)
#   -> contains error data, information about experimental protocol
#   ............................................................
#   column 1    =     error
#   column 2    =     block number
#   column 3    =     trial number (within-block)
#   column 4    =     target
#   column 5    =     rotation                   
#   column 6    =     visual feedback ON yes or no           
#   column 7    =     Reaction Time
#   column 8    =     Movement Onset 
#   column 9    =     Movement Offset 
#   column 10   =     Timepoint of peak velocity (is the same as RT)
#   column 11   =     Peak Velocity                   
#   column 12   =     Artefactual trial yes or no
#   ............................................................
#   SUBJECT
#   (text file ending in _subjectlist)
#   -> contains subject name (is stored seperately from _data because matlab can't write out strings and numbers to the same text file)
#   ............................................................
#   ............................................................
#   ............................................................

library("bootnet")
# --------------------- Import Data --------------------- 
storepath="./data/"
adaptfile_stem="main"
adaptfile = paste(adaptfile_stem, "_data.txt", sep="")
badapt <- read.delim(paste(storepath,adaptfile,sep=""), header = FALSE, sep = "\t", dec = ".")
names(badapt)=c("error","block","trial",
                "target","rotation","feedback",
                "rt","mon","moff", 
                "pvtime","pv",     
                "artef")
badapt$target_n <- as.numeric(badapt$target)
badapt$target <- as.factor(badapt$target)
badapt$rotation_n <- as.numeric(badapt$rotation)
badapt$rotation_on <- binarize(badapt$rotation_n, split = 0.5)
badapt$rotation_on <- as.factor(badapt$rotation_on==0)

badapt$feedback <- as.factor(badapt$feedback)
badapt$block_n <- as.numeric(badapt$block)
badapt$block <- as.factor(badapt$block)
levels(badapt$feedback) <- c("FALSE","TRUE")
badapt$artef <- as.logical(badapt$artef)
# Convert movement onset, movement offset into ms
badapt$mon <- badapt$mon*1000/60
badapt$moff <- badapt$moff*1000/60
# Drop pvtime (is the same as rt)
badapt <- badapt[ , -which(names(badapt) %in% c("pvtime"))]
# Remove column that has only NaNs
badapt <- badapt[ , !colSums(is.na(badapt)) == dim(badapt)[1]]

# --------------------- Import Wash & Control Data --------------------- 

# source('/Users/CN//Documents/State_Space_Modelling/misc/WASH.R')


# --------------------- Get subject list --------------------- 
adaptfile_subj = paste(adaptfile_stem, "_subjectlist.txt", sep="")

badapt_subjlist <- read.delim(paste(storepath,adaptfile_subj,sep=""), header = FALSE, sep = "\t", dec = ".")
names(badapt_subjlist) <- "sub"
badapt_subjlist$sub <- as.factor(badapt_subjlist$sub)
# Make one dataframe
ba <- data.frame(badapt_subjlist,badapt)

# --------------------- Add Session Information (session number, stimulation condition) --------------------- 
ba$Subject <-  as.factor(substr(ba$sub, start=1, stop=3))
ba$Session <-  as.factor(substr(ba$sub, start=6, stop=6))
ba$Stimulation <-  as.factor(substr(ba$sub, start=8, stop=8))
ba$Stimulation <- relevel(ba$Stimulation, "S")
# # --------------------- Add epoch to dataset: --------------------- 
# set up cut-off values 
breaks <- c(1,9,17,25,33,40)
# specify interval/bin labels
tags <- c("1","2", "3", "4", "5")
# bucketing values into bins
ba$epoch <- cut(ba$trial, 
                breaks=breaks, 
                include.lowest=TRUE, 
                right=FALSE, 
                labels=tags)
# inspect bins
summary(ba$epoch)
ba$epoch_n <- as.numeric(ba$epoch)
ba$trial_f <- as.factor(ba$trial)

# --------------------- Calculate Adaptation Error, Adaptation Error (Stimulation Period Only) and Retention Error: --------------------- 
# Adaptation Error
trials <- ba$rotation>0 & ba$trial>9 
tdcs <- aggregate(ba[trials,]$error, list(ba[trials,]$sub), mean, na.rm=TRUE)
names(tdcs) <- c("Subject", "Error")

# Adaptation Error during online stimulation
trials <- ba$rotation>0 & ba$trial>9 & ba$rotation<50
tdcs$Error_StimON <- aggregate(ba[trials,]$error, list(ba[trials,]$sub), mean, na.rm=TRUE)$x

# Retention Error
trials <- ba$feedback=="TRUE"
tdcs$Retention <- aggregate(ba[trials,]$error, list(ba[trials,]$sub), mean, na.rm=TRUE)$x

# Retention Error during online stimulation
trials <- ba$feedback=="TRUE" & ba$block_n<9
tdcs$Retention_StimON <- aggregate(ba[trials,]$error, list(ba[trials,]$sub), mean, na.rm=TRUE)$x

# Baseline Error
trials <- ba$rotation==0 & ba$feedback=="TRUE"
tdcs$Baseline <- aggregate(ba[trials,]$error, list(ba[trials,]$sub), mean, na.rm=TRUE)$x

# Baseline Error before stimulation is turned on
trials <- ba$rotation==0 & ba$feedback=="TRUE" & ba$block_n==1
tdcs$BaselineStimOFF <- aggregate(ba[trials,]$error, list(ba[trials,]$sub), mean, na.rm=TRUE)$x

# Baseline Error after stimulation is turned on
trials <- ba$rotation==0 & ba$feedback=="TRUE" & ba$block_n==2
tdcs$BaselineStimON <- aggregate(ba[trials,]$error, list(ba[trials,]$sub), mean, na.rm=TRUE)$x

tdcs$Session <- as.factor(substr(tdcs$Subject, start=6, stop=6))
tdcs$Stimulation <- as.factor(substr(tdcs$Subject, start=8, stop=8))
tdcs$Stimulation <- relevel(tdcs$Stimulation, "S")
tdcs$Subject <-  as.factor(substr(tdcs$Subject, start=1, stop=3))




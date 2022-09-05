# Cerebellar tDCS and visuomotor adaptation
#### Code to analyse behavioural data of visuomotor adaptation task performed during anodal or sham cerebellar stimulation.
#### written by Caroline Nettekoven, University of Oxford, 2016 - 2022.
- Within-subject, sham-controlled anodal tDCS study.
- Real & sham stimulation condition.

## File Description
## FILES
All are stored in folder
./data

Files available:
main_data.txt             contains behavioural data
main_subjectlist.txt      contains subject list
____________________________________________________________________
DATA
(text file ending in _data)
-> contains error data, information about experimental protocol
____________________________________________________________________
column 1    =     error
column 2    =     block number
column 3    =     trial number (within-block)
column 4    =     target
column 5    =     rotation                   
column 6    =     visual feedback ON yes or no           
column 7    =     Reaction Time
column 8    =     Movement Onset 
column 9    =     Movement Offset 
column 10   =     Timepoint of peak velocity (is the same as RT)
column 11   =     Peak Velocity                   
column 12   =     Artefactual trial yes or no
____________________________________________________________________
SUBJECT
(text file ending in _subjectlist)
-> contains subject name (is stored seperately from _data because matlab can't write out strings and numbers to the same text file)
____________________________________________________________________
____________________________________________________________________

## Steps performed by analyse_tdcs.m script
1. Load datasets
     
2. Preprocessing:
   
- Reject faulty trials:
 - Print number of rejected trials
 - Reject outlier trials from each task block (identified by Grubbs test)
   
1. Calculate behavioural indices:
  - Adaptation
  - Retention

2. Export data as .txt file for further processing with R or Python

3. Plot data
  - Trial error in Real (red) & Sham (blue) condition in one plot
  - Epoch error in Real (red) & Sham (blue) condition in one plot


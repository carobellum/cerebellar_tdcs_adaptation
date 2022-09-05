# Cerebellar tDCS and visuomotor adaptation
#### Code to analyse behavioural data of visuomotor adaptation task performed during anodal or sham cerebellar stimulation.
#### written by Caroline Nettekoven, University of Oxford, 2016 - 2022.
- Within-subject, sham-controlled anodal tDCS study.
- Real stimulation parameters: 1.5 mA, 20 min

____________________________________________________________________

## Description
### FILES
All are stored in folder
./data

Files available:
main_data.txt             contains behavioural data
main_subjectlist.txt      contains subject list

### DATA
(text file ending in _data)
contains error data and information about experimental protocol

column 1    =     error \
column 2    =     block number \
column 3    =     trial number (within-block) \
column 4    =     target \
column 5    =     rotation \
column 6    =     visual feedback ON yes or no \        
column 7    =     Reaction Time \
column 8    =     Movement Onset \
column 9    =     Movement Offset \
column 10   =     Timepoint of peak velocity (is the same as RT) \
column 11   =     Peak Velocity \            
column 12   =     Artefactual trial yes or no \

SUBJECTS
(text file ending in _subjectlist)
contains subject name (is stored seperately from _data because matlab can't write out strings and numbers to the same text file)

____________________________________________________________________


## Steps to perform analysis.
1. Load datasets and calculate performance indices
   Run `tdcs_get_behav_data.R`
     
2. Calculate statistics:
   Run `tdcs_stats.R`


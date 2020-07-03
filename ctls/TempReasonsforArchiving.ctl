load data 
infile 'G:\SQL_Loader_Files\csv\TempReasonsforArchiving.csv' "str '\r\n'"
truncate
into table TEMP_REASONS_FOR_ARCHIVING
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( ReasonforArchivingID,
             ReasonforArchivingDescription CHAR(4000)
           )

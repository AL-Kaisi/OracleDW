load data 
infile 'G:\SQL_Loader_Files\csv\TempCurrent_Status.csv' "str '\r\n'"
truncate
into table TEMP_CURRENT_STATUS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( CurrentStatusID,
             CurrentStatusDescription CHAR(4000)
           )

load data 
infile 'G:\SQL_Loader_Files\csv\TempRequestStatus.csv' "str '\r\n'"
truncate
into table TEMP_REQUEST_STATUS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( RequestStatusID,
             RequestStatusDescription CHAR(4000)
           )

load data 
infile 'G:\SQL_Loader_Files\csv\TempStatus.csv' "str '\r\n'"
truncate
into table TEMP_STATUS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( TempStatusID,
             TempStatusDescription CHAR(4000)
           )

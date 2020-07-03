load data 
infile 'G:\SQL_Loader_Files\csv\TempPermanent_Job_Type.csv' "str '\r\n'"
truncate
into table TEMP_PERMANENT_JOB_TYPE
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( PermanentJobID,
             Type_of_Permanent_Job CHAR(4000)
           )

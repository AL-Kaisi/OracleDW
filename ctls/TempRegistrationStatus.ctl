load data 
infile 'G:\SQL_Loader_Files\csv\TempRegistrationStatus.csv' "str '\r\n'"
truncate
into table TEMP_REGISTRATION_STATUS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( LocumRegistrationStatusID,
             LocumRegistrationStatusDescription CHAR(4000)
           )

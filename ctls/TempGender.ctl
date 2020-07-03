load data 
infile 'G:\SQL_Loader_Files\csv\TempGender.csv' "str '\r\n'"
truncate
into table TEMP_GENDER
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( GenderID,
             GenderDescription CHAR(4000)
           )

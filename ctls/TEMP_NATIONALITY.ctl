load data 
infile 'G:\SQL_Loader_Files\csv\TEMP_NATIONALITY.csv' "str '\r\n'"
truncate
into table TEMP_NATIONALITY
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( NationalityID,
             NationalityDescription CHAR(4000)
           )

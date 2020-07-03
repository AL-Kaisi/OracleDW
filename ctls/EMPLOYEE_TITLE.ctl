load data 
infile 'G:\SQL_Loader_Files\csv\EMPLOYEE_TITLE.csv' "str '\r\n'"
truncate
into table EMPLOYEE_TITLE
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( TitleID,
             TitleDescription CHAR(4000)
           )

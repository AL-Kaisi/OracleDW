load data 
infile 'G:\SQL_Loader_Files\csv\TempReportDates.csv' "str '\r\n'"
truncate
into table TEMP_REPORT_DATES
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( First_date CHAR(4000),
             Last_date CHAR(4000)
           )

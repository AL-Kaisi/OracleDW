load data 
infile 'G:\SQL_Loader_Files\csv\TEMPMEETINGDATE.csv' "str '\r\n'"
truncate
into table TEMP_MEETING_DATE
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( Next_Locemdoc_meeting_date CHAR(4000)
           )

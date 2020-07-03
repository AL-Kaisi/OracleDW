load data 
infile 'G:\SQL_Loader_Files\csv\TEMP_REQUEST.csv' "str '\r\n'"
truncate
into table TEMP_REQUEST
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( TempRequestID,
             LocalCouncil_ID,
             Request_date  DATE "DD/MM/YYYY",
             Start_date CHAR(4000),
             End_date CHAR(4000),
             Monday_AM CHAR(4000),
             Monday_PM CHAR(4000),
             Tuesday_AM CHAR(4000),
             Tuesday_PM CHAR(4000),
             Wednesday_AM CHAR(4000),
             Wednesday_PM CHAR(4000),
             Thursday_AM CHAR(4000),
             Thursday_PM CHAR(4000),
             Friday_AM CHAR(4000),
             Friday_PM CHAR(4000),
             Saturday_AM CHAR(4000),
             Request_Status,
             Number_of_weeks,
             Comments CHAR(4000)
           )

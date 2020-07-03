load data 
infile 'G:\SQL_Loader_Files\csv\TYPE_OF_TEMP_COVER.csv' "str '\r\n'"
truncate
into table TYPE_OF_TEMP_COVER
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( TypeofCoverID,
             CoverDescription CHAR(4000)
           )

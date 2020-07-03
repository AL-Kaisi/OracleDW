load data 
infile 'G:\SQL_Loader_Files\csv\TempCompatibilityDetails.csv' "str '\r\n'"
truncate
into table TEMP_COMPATABILITY_DETAILS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( TempID,
             BranchID,
             Compatibility CHAR(4000)
           )

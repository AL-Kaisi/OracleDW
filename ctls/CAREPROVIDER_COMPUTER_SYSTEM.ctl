load data 
infile 'G:\SQL_Loader_Files\csv\CAREPROVIDER_COMPUTER_SYSTEM.csv' "str '\r\n'"
truncate
into table CAREPROVIDER_COMPUTER_SYSTEM
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( ComputerSystemID,
             ComputerSystemDescription CHAR(4000)
           )

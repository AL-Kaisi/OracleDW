load data 
infile 'G:\SQL_Loader_Files\csv\REFERENCES.csv' "str '\r\n'"
truncate
into table REFERENCES
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( ReferenceID,
             TempID,
             RefereeID,
             Date_Reference_Sent CHAR(4000),
             Date_Reference_Received CHAR(4000),
             Telephone_made CHAR(4000)
           )

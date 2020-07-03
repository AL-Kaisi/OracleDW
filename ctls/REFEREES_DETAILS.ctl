load data 
infile 'G:\SQL_Loader_Files\csv\REFEREES_DETAILS.csv' "str '\r\n'"
truncate
into table REFEREE_DETAILS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( RefereeID,
             First_Name CHAR(4000),
             Last_Name CHAR(4000),
             Address_Line_1 CHAR(4000),
             Adress_Line_2 CHAR(4000),
             Town CHAR(4000),
             County CHAR(4000),
             Postcode CHAR(4000),
             Tel CHAR(4000)
           )

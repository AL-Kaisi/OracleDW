load data 
infile 'G:\SQL_Loader_Files\csv\LOCAL_COUNCIL.csv' "str '\r\n'"
truncate
into table LOCAL_COUNCIL
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( LocalCouncil_ID,
             LocalCouncilName CHAR(4000),
             Address_Line_1 CHAR(4000),
             Address_Line_2 CHAR(4000),
             Town CHAR(4000),
             County CHAR(4000),
             Postcode CHAR(4000),
             Locality CHAR(4000),
             Telephone CHAR(4000),
             Fax CHAR(4000),
             Bypass CHAR(4000),
             Approximate_List_Size,
             Type_of_Computer_System,
             Computer_Used_in_Consultations CHAR(4000),
             Appointment_System,
             Leaflets CHAR(4000),
             Date_of_Last_Update CHAR(4000),
             TypeofLocalCouncil
           )

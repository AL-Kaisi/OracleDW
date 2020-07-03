load data 
infile 'G:\SQL_Loader_Files\csv\TEMP.csv' "str '\r\n'"
truncate
into table TEMP
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( TempID,
             Title,
             First_Name CHAR(4000),
             Last_Name CHAR(4000),
             Address_Line_4 CHAR(4000),
             Address_Line_2 CHAR(4000),
             Town CHAR(4000),
             County CHAR(4000),
             Postcode CHAR(4000),
             Tel_Home CHAR(4000),
             Fax_Home CHAR(4000),
             Tel_Work CHAR(4000),
             Fax_Work CHAR(4000),
             Mobile_Phone CHAR(4000),
             Date_application_was_sent  DATE "DD/MM/YYYY",
             Gender,
             Current_Status,
             Date_of_birth DATE "DD/MM/YYYY",
             Nationality,
             Use_of_a_car CHAR(4000),
             Qualification_Year CHAR(4000),
             Qualification_Place CHAR(4000),
             Type_of_Cover_Preferred,
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
             Temp_Registration_Status,
             Date_application_received  DATE "DD/MM/YYYY",
             TempStatus
           )

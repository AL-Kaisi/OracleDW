load data 
infile 'G:\SQL_Loader_Files\csv\EMPLOYEE_DETAILS.csv' "str '\r\n'"
truncate
into table EMPLOYEE_DETAILS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( Employee_ID CHAR(4000),
             LocalCouncil_ID,
             Title,
             First_Name,
             Last_Name CHAR(4000),
             Status CHAR(4000),
             YearQualified,
             Initials,
             show CHAR(4000),
             deleted CHAR(4000)
           )

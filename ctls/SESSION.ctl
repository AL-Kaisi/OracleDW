load data 
infile 'G:\SQL_Loader_Files\csv\SESSION.csv' "str '\r\n'"
truncate
into table SESSIONS
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( SessionID,
             RequestID,
             TempID,
             SessionDate DATE "DD/MM/YYYY",
             SessionStart timestamp "HH24:mi:ss",
             SessionEnd timestamp "HH24:mi:ss",
             Status CHAR(4000),
             Type,
             EmployeeCovered CHAR(4000),
             DoPrint CHAR(4000)
           )

load data 
infile 'G:\SQL_Loader_Files\csv\TempAgeBand.csv' "str '\r\n'"
truncate
into table TEMP_AGE_BAND
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( Age_band_name CHAR(4000),
             Age_band_low,
             Age_band_high
           )

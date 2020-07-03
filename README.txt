The folder "SQL_LOADER_FILES" needs to be in your G: drive.

Open the file "SOLUTION" in a text editor and use the 
replace all function to change te4695k/te4695k@obiwan to
yourusername/yourpassword@obiwan for each sqlldr command.

Navigate to the folder "sql" and open the SQL file
"FULL_SCHEMA" in Oracle SQL Developer and execute it.
(The tables have now been created but are empty)

Back out of "sql" and execute the batch file "SOLUTION".
(The tables have now been populated with the unclean data)

Navigate back into the folder "sql" and open the SQL file
"CLEANING_DATA" in Oracle SQL Developer and execute it.
(The package to clean the data has now been compiled)

In the "Connections" panel of SQL Developer, open the
"Packages" folder. Right-click on the package
"COMP1434_CLEANING" and select "Run...".
In the dialog box that just opened, in the "Target:" window,
select the procedure "RUN_ME_ONLY" and left-click OK at
the bottom of the dialog box.
(The data has been cleaned and imported into the DW tables)

In the folder "sql", open the SQL file "QUERIES" in
Oracle SQL Developer. The queries should be run individually.
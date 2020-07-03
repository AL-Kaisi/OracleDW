#Project Requirement

Detailed Specification
This is a group work. You must work in a group of two. Each group/team has a clear separation of
roles between members of the team.
Different roles will be required to perform different tasks. See section ‘Tasks allocations between
group members’ on page 5 for more details
You are required to design and build a data mart/data warehouse preferably using the Oracle
DBMS (Database Management System). If you prefer to use an alternative DBMS then this will be
acceptable as long as you can complete and demonstrate all of the requirements of this
coursework. If the DBMS of your choice is not available within the university, then you will be
required to demonstrate on using your own laptop.
Students are required to read through the following scenario and design and build a data warehouse
that can suitably reflect on the needs of the problem.
Description of the the Scenario
The government within the United Kingdom allocates funding each year for its local councils to
provide temporary staff cover(temps) for its care workers while they are on holiday, absent due to
illness, maternity or paternity leave amongst a number of other reasons. These care workers will
look after and care for members of the public who are elderly or infirm.
If one of the councils has a position needing urgently covered, it will contact the care provider called
“GreenHomeHelp” and request a care worker to cover the position for a given date and time called a
session. The care provider can check for the available care staff and try to arrange the necessary
cover within the timely period as requested by the council. The cover could be for a nurse or simple
home help. The summer can be a very busy time for the care provider and many care staff will take
annual leave during this time period. The type of cover can be viewed within the
‘TYPE_OF_CARE_COVER’ table.
The care provider will receive a payment for providing a temporary care worker for each day of cover.
The temp care worker will also receive a set amount (£8.00) for travel expenses and subsistence for
each day of work which will be paid initially by the care provider. The care provider must then claim
all costs back directly from the council at the end of each working month. Daily travel receipts need
to be submitted by the care provider to the council before reimbursement of travel and subsistence
is later approved. Many of these temporary care workers are students on vacation or retired
members of the public.
When a temporary care worker registers for the “GreenHomeHelp”, their references will be
thoroughly checked. The care provider must normally apply to the local council for its costs and
request details of time sessions covered by temporary care staff.

The government who is financially responsible for the local council care providers have now
requested that a data warehouse be built in order to collect data from individual councils and the
GreenHomeHelp care provider. The GreenHomeHelp care provider has agreed to provide access to
their data as they have had a long standing business relationship with councils providing thousands
of workers over the last 5 years. The data within your data warehouse will then be analysed by the
government office with the intention of providing more information regarding next year’s individual
council funding budget for temporary care providers.
Data from the GreenHomeHelp care provider and councils has been collected and added into one
Microsoft Access database called GreenCareProviderTemps. The GreenHomeHelp care provider has
some serious concerns about the quality of the data provided. GreenHomeHelp normally store
information about temporary nurses, simple home help and sessions covered etc. Details of clients
receiving home help will not be included for privacy reasons. The database model for the system is
displayed below. The GreenCareProviderTemps database (located in zip file) is available on the
student portal or from your course coordinator. 

You should design the Data Warehouse which will provide information to the government on the
following:
 The number of sessions filled by type of temp cover by month
 The number of temp care worker requests made by council for each week
 The number of temp care worker requests filled by county for each month
 The number temp care worker requests filled by council each week
 The number of temp care worker requests which were cancelled each month


Design Data Mart/Warehouse
You should produce a star schema for you data mart design.
#ETL
In the first instance you will need to export the data from a Microsoft Access database into Oracle.
You should then create a staging area in your own area. The data should be cleansed and any
necessary transformations carried out.

#Data Cleansing
You should plan your cleansing exercise by identifying the various types of error that you will search
for (e.g. missing primary keys, missing foreign keys, misspellings etc.) and describe the techniques
which you used to find errors and cleanse the data.
You should show how you have used SQL for both purposes.
#Building the Warehouse
You should create and populate the fact and dimension tables for your star schema.
The FACT table and the TIME table can be populated at the same time using a cursor.
Write SQL queries on the star schema to provide the required statistical information


#How to run the project 
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

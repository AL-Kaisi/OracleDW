CREATE TABLE TEMP_REQUEST ( TempRequestID int, LocalCouncil_ID int, Request_date date, Start_date varchar2(50), End_date varchar2(50), Monday_AM varchar2(50), Monday_PM varchar2(50), Tuesday_AM varchar2(50), Tuesday_PM varchar2(50), Wednesday_AM varchar2(50), Wednesday_PM varchar2(50), Thursday_AM varchar2(50), Thursday_PM varchar2(50), Friday_AM varchar2(50), Friday_PM varchar2(50), Saturday_AM varchar2(50), Request_Status int, Number_of_weeks int, Comments varchar2(100), PRIMARY KEY (TempRequestID ) );
CREATE INDEX "FK1" 
ON TEMP_REQUEST (LocalCouncil_ID);
CREATE TABLE REFERENCES ( ReferenceID int, TempID int, RefereeID int, Date_Reference_Sent varchar2(50), Date_Reference_Received varchar2(50), Telephone_made varchar2(50), PRIMARY KEY (ReferenceID) ); 
CREATE TABLE REFEREE_DETAILS ( RefereeID int, First_Name varchar2(50), Last_Name varchar2(50), Address_Line_1 varchar2(50), Adress_Line_2 varchar2(50), Town varchar2(50), County varchar2(50), Postcode varchar2(50), Tel varchar2(50), PRIMARY KEY (RefereeID) );
CREATE TABLE CAREPROVIDER_COMPUTER_SYSTEM ( ComputerSystemID int, ComputerSystemDescription varchar2(50), PRIMARY KEY (ComputerSystemID) );
CREATE TABLE EMPLOYEE_DETAILS ( Employee_ID int, LocalCouncil_ID int, Title varchar2(50), First_Name varchar2(50), Last_Name varchar2(50), Status varchar2(50), YearQualified varchar2(4), Initials varchar2(50), show varchar2(50), deleted varchar2(50), PRIMARY KEY (Employee_ID) );
CREATE INDEX "FK2" 
ON EMPLOYEE_DETAILS (LocalCouncil_ID);
CREATE TABLE TEMP ( TempID int, Title varchar2(50), First_Name varchar2(50), Last_Name varchar2(50), Address_Line_4 varchar2(50), Address_Line_2 varchar2(50), Town varchar2(50), County varchar2(50),
 Postcode varchar2(50), Tel_Home varchar2(50), Fax_Home varchar2(50), Tel_Work varchar2(50), Fax_Work varchar2(50), Mobile_Phone varchar2(50), Date_application_was_sent varchar2(50), Gender varchar2(50), 
Current_Status varchar2(50), Date_of_birth date, Nationality varchar2(50), Use_of_a_car varchar2(50), Qualification_Year varchar2(50), Qualification_Place varchar2(50), Type_of_Cover_Preferred varchar2(50),
 Monday_AM varchar2(50), Monday_PM varchar2(50), Tuesday_AM varchar2(50), Tuesday_PM varchar2(50), Wednesday_AM varchar2(50), Wednesday_PM varchar2(50), Thursday_AM varchar2(50), Thursday_PM varchar2(50), 
Friday_AM varchar2(50), Friday_PM varchar2(50), Saturday_AM varchar2(50),Temp_Registration_Status varchar2(50), Date_application_received varchar2(50), TempStatus varchar2(50), PRIMARY KEY(TempID) );
CREATE TABLE EMPLOYEE_TITLE ( TitleID int, TitleDescription varchar2(50), PRIMARY KEY (TitleID) );
CREATE TABLE SESSIONS ( SessionID int, RequestID int, TempID int, SessionDate date, SessionStart timestamp, 
SessionEnd timestamp, Status varchar2(50), Type varchar2(50), EmployeeCovered varchar2(50), DoPrint varchar2(50) ,Year int,Month int,Week int,Day int,SS_Hour int,SS_Minutes int,SE_Hour int,SE_Minutes int, PRIMARY KEY (SessionID) );
CREATE TABLE LOCAL_COUNCIL ( LocalCouncil_ID int, LocalCouncilName varchar2(50), Address_Line_1 varchar2(50), Address_Line_2 varchar2(50), Town varchar2(50), County varchar2(50), Postcode varchar2(50), Locality varchar2(50), Telephone varchar2(50), Fax varchar2(50), Bypass varchar2(50), Approximate_List_Size varchar2(50), Type_of_Computer_System varchar2(50), Computer_Used_in_Consultations varchar2(50), Appointment_System varchar2(50), Leaflets varchar2(50), Date_of_Last_Update varchar2(50), TypeofLocalCouncil varchar2(50), PRIMARY KEY (LocalCouncil_ID) );
CREATE TABLE TEMP_NATIONALITY ( NationalityID int, NationalityDescription varchar2(50), PRIMARY KEY (NationalityID) );
CREATE TABLE "TYPE_OF_TEMP_COVER" ( TypeofCoverID int, CoverDescription varchar2(50), PRIMARY KEY (TypeofCoverID ) );
 CREATE TABLE TEMP_AGE_BAND ( Age_band_name varchar2(50),Age_band_low varchar2(50), Age_band_high varchar2(50));
CREATE TABLE TEMP_COMPATABILITY_DETAILS( TempID int,BranchID int, Compatibility varchar2(50));
CREATE TABLE TEMP_CURRENT_STATUS ( CurrentStatusID int,CurrentStatusDescription varchar2(50));
CREATE TABLE TEMP_GENDER( GenderID int,GenderDescription varchar2(50));
CREATE TABLE TEMP_MEETING_DATE  ( Next_Locemdoc_meeting_date varchar2(50));
CREATE TABLE TEMP_PERMANENT_JOB_TYPE  ( PermanentJobID int,Type_of_Permanent_Job varchar2(50));
CREATE TABLE TEMP_REASONS_FOR_ARCHIVING  ( ReasonforArchivingID int, ReasonforArchivingDescription varchar(50));
CREATE TABLE TEMP_REGISTRATION_STATUS( LocumRegistrationStatusID int,LocumRegistrationStatusDescription varchar(50) );
CREATE TABLE TEMP_REPORT_DATES ( First_date varchar2(50),  Last_date varchar2(50));
CREATE TABLE TEMP_REQUEST_STATUS ( RequestStatusID int,RequestStatusDescription varchar2(50));
CREATE TABLE TEMP_STATUS  ( TempStatusID int, TempStatusDescription varchar2(50));

CREATE TABLE Dim_Temp ( TempID int, Title varchar2(15) NOT NULL, LastName varchar2(20) NOT NULL, County varchar2(30) NOT NULL, Postcode varchar2(10) NOT NULL, Gender varchar2(10)  NOT NULL, CurrentStatus varchar2(20) NOT NULL, DateOfBirth date , Nationality varchar2(50) NOT NULL, UseOfACar VARCHAR2(20) NOT NULL, QualificationYear varchar2(10) NOT NULL, QualificationPlace varchar2(25) NOT NULL, TypeOfCoverPreferred varchar2(30) NOT NULL, TempRegistrationStatus varchar2(30) NOT NULL, TempStatus varchar2(30) NOT NULL, PRIMARY KEY (TempID));

CREATE TABLE Dim_Local_Council ( LocalCouncilID int, CouncilName varchar2(50)  NOT NULL, Postcode varchar2(10) NOT NULL, County varchar2(25)  NOT NULL, ComputerSystemType varchar2(50) NOT NULL, PRIMARY KEY (LocalCouncilID));
	
CREATE TABLE Dim_Time ( TimeID int , SS_Minute int NOT NULL, SS_Hour int NOT NULL, SE_Minute int NOT NULL, SE_Hour int NOT NULL, Day int NOT NULL, Week int NOT NULL, Month int NOT NULL, Year int NOT NULL, PRIMARY KEY (TimeID));

CREATE TABLE Dim_Temp_Request ( TempRequestID int, LocalCouncilID int NOT NULL REFERENCES Dim_Local_Council(LocalCouncilID), RequestDate date, TempRequestStatus varchar2(50)  NOT NULL, PRIMARY KEY (TempRequestID));

CREATE TABLE Fact_Sessions ( SessionID int, TempRequestID int  NOT NULL REFERENCES Dim_Temp_Request(TempRequestID), TempID int  NOT NULL REFERENCES Dim_Temp(TempID), TimeID int  REFERENCES Dim_Time(TimeID), TypeOfCover varchar2(30) NOT NULL, Status varchar2(30) NOT NULL, PRIMARY KEY (SessionID));

CREATE SEQUENCE S_Time_PK
START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE OR REPLACE TRIGGER T_Time_PK
BEFORE INSERT
ON Dim_Time
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
  IF(:NEW.TimeID IS NULL) THEN
  SELECT S_Time_PK.NEXTVAL
  INTO :NEW.TimeID 
  FROM dual;
  END IF;
END;
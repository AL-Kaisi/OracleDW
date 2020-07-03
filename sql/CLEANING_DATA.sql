CREATE OR REPLACE PACKAGE COMP1434_CLEANING AS 
    PROCEDURE RUN_ME_ONLY;
    PROCEDURE prep_Sessions;
    PROCEDURE Cleaning_temp;
    PROCEDURE Delete_Update_Null;
    PROCEDURE clean_local_council;
    PROCEDURE clean_Temp_request;
    PROCEDURE Clean_Session;
    PROCEDURE validate_postcode_format;
    PROCEDURE TIME_DATE_EXTRACTION;
    PROCEDURE DW_Insert;
END COMP1434_CLEANING;
/

CREATE OR REPLACE PACKAGE BODY COMP1434_CLEANING IS

PROCEDURE RUN_ME_ONLY AS 

BEGIN 
    prep_Sessions();
    Cleaning_temp();
    Delete_Update_Null();
    clean_local_council();
    clean_Temp_request();
    Clean_Session();
    validate_postcode_format();
    TIME_DATE_EXTRACTION();
    DW_INSERT();
END RUN_ME_ONLY;

PROCEDURE prep_Sessions AS

BEGIN
    EXECUTE IMMEDIATE 'delete from sessions WHERE tempid = 0 OR tempid is null';
    EXECUTE IMMEDIATE 'alter TABLE sessions ADD FOREIGN KEY (tempid) REFERENCES temp(tempid) ON DELETE CASCADE';
END;

PROCEDURE Cleaning_temp AS 
      dr        employee_title.titledescription%TYPE; 
      mr        employee_title.titledescription%TYPE; 
      miss      employee_title.titledescription%TYPE; 
      ms        employee_title.titledescription%TYPE; 
      prof      employee_title.titledescription%TYPE; 
      mrs       employee_title.titledescription%TYPE; 
      nums      temp.title%TYPE; 
      tempidd   temp.tempid%TYPE; 
      tempiddd  temp.tempid%TYPE; 
      genders   temp.gender%TYPE; 
      addre     temp.address_line_2%TYPE; 
      tempidddd temp.tempid%TYPE; 
      cstatuss  temp.current_status%TYPE; 
      v_county  temp.county%TYPE ; 
      v_town    temp.town%TYPE; 
      v_type    temp.type_of_cover_preferred%TYPE; 
      v_rgs     temp.temp_registration_status%TYPE; 
      v_date    temp.date_of_birth%TYPE; 
      v_status  temp_status.tempstatusdescription%TYPE; 
      v_check   BOOLEAN; 
      v_count   NUMBER; 
      v_code    NUMBER; 
      v_error   VARCHAR(64); 
      v_postcode temp.postcode%TYPE;
      v_id       temp.tempid%TYPE;
      v_length  Number;
      v_check   BOOLEAN; 
      CURSOR temp_postcode IS 
        SELECT regexp_replace(postcode, '[[:space:]]*',''), length(regexp_replace(postcode, '[[:space:]]*','')),tempid from temp;
      CURSOR sess_requestid IS 
        SELECT title, tempid FROM temp; 
      CURSOR v_gender IS 
        SELECT gender, tempid FROM temp; 
      CURSOR v_tempst IS 
        SELECT current_status, tempid FROM temp; 
      CURSOR v_nation IS 
        SELECT nationality, tempid, address_line_2 FROM temp; 
      CURSOR v_countyid IS 
        SELECT tempid FROM temp WHERE county IS NULL; 
      CURSOR v_phonenum IS 
        SELECT tel_home, tempid FROM temp WHERE tel_home IS NULL;
      CURSOR v_cover IS 
        SELECT type_of_cover_preferred, tempid FROM temp; 
      CURSOR v_regid IS 
        SELECT temp_registration_status, tempid FROM temp; 
      CURSOR v_tempstatus IS 
        SELECT tempstatus, tempid FROM temp; 
BEGIN 
    OPEN sess_requestid;
    LOOP 
        FETCH sess_requestid INTO nums, tempidd;
        IF sess_requestid%FOUND THEN 
          IF nums IS NULL THEN 
            UPDATE temp SET title = 'N/A' WHERE tempid = tempidd; 
          ELSIF nums = '1' THEN 
            UPDATE temp SET title = 'DR' WHERE tempid = tempidd; 
          ELSIF nums = '2' THEN 
            UPDATE temp SET title = 'MR' WHERE tempid = tempidd; 
          ELSIF nums = '3' THEN 
            UPDATE temp SET title = 'Miss' WHERE tempid = tempidd; 
          ELSIF nums = '3' THEN 
            UPDATE temp SET title = 'Mrs' WHERE  tempid = tempidd; 
          ELSIF nums = '4' THEN 
            UPDATE temp SET title = 'MS' WHERE  tempid = tempidd; 
          ELSIF nums = '5' THEN 
            UPDATE temp SET title = 'Prof' WHERE  tempid = tempidd; 
          ELSIF nums = '6' THEN 
            UPDATE temp SET title = 'MRS' WHERE  tempid = tempidd; 
          END IF; 
        END IF;
        EXIT WHEN sess_requestid%NOTFOUND; 
    END LOOP;
    CLOSE sess_requestid; 

    OPEN v_gender;
    LOOP 
        FETCH v_gender INTO genders, tempiddd; 
        IF v_gender%FOUND THEN 
          IF genders = '1' THEN 
            UPDATE temp SET gender = 'FEMALE' WHERE  tempid = tempiddd; 
          ELSIF genders = '2' THEN 
            UPDATE temp SET gender = 'MALE' WHERE  tempid = tempiddd; 
          END IF; 
        END IF;
        EXIT WHEN v_gender%NOTFOUND; 
    END LOOP;
    CLOSE v_gender; 

    OPEN v_tempst;
    LOOP 
        FETCH v_tempst INTO cstatuss, tempidddd;
        IF v_tempst%FOUND THEN 
          IF cstatuss = '1' THEN 
            UPDATE temp SET current_status = 'Principal Full-Time' WHERE tempid = tempidddd; 
          ELSIF cstatuss = '2' THEN 
            UPDATE temp SET current_status = 'Principal Part-Time' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '3' THEN 
            UPDATE temp SET current_status = 'Assistant' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '4' THEN 
            UPDATE temp SET current_status = 'Temp' WHERE tempid = tempidddd; 
          ELSIF cstatuss = '5' THEN 
            UPDATE temp SET current_status = 'Retainer' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '6' THEN 
            UPDATE temp SET current_status = 'Retired' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '7' THEN 
            UPDATE temp SET current_status = 'Other' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '8' THEN 
            UPDATE temp SET current_status = 'Not Known' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '0' THEN 
            UPDATE temp SET current_status = 'Not Known' WHERE  tempid = tempidddd; 
          END IF; 
        END IF;
        EXIT WHEN v_tempst%NOTFOUND; 
    END LOOP;
    CLOSE v_tempst;

    OPEN v_nation;
    LOOP 
        FETCH v_nation INTO cstatuss, tempidddd, addre; 
        IF v_nation%FOUND THEN 
          IF cstatuss = '1' THEN 
            UPDATE temp SET nationality = 'British' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '2' THEN 
            UPDATE temp SET nationality = 'Irish' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '3' THEN 
            UPDATE temp SET nationality = 'Hindi' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '4' THEN 
            UPDATE temp SET nationality = 'Arabic' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '5' THEN 
            UPDATE temp SET    nationality = 'African' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '6' THEN 
            UPDATE temp SET nationality = 'Greek' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '7' THEN 
            UPDATE temp SET nationality = 'Not Known' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '8' THEN 
            UPDATE temp SET nationality = 'New Zealand' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '9' THEN 
            UPDATE temp SET nationality = 'South Africa' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '10' THEN 
            UPDATE temp SET nationality = 'European' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '11' THEN 
            UPDATE temp SET nationality = 'Chinese' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '12' THEN 
            UPDATE temp SET nationality = 'Australian' WHERE  tempid = tempidddd; 
          ELSIF cstatuss = '13' THEN 
            UPDATE temp SET nationality = 'Indian' WHERE  tempid = tempidddd; 
          ELSIF cstatuss IS NULL THEN 
            UPDATE temp SET nationality = 'Not Known' WHERE  tempid = tempidddd; 
          END IF; 
        END IF;
        EXIT WHEN v_nation%NOTFOUND; 
    END LOOP;
    CLOSE v_nation; 

    OPEN v_countyid;
    LOOP 
        FETCH v_countyid INTO tempidddd;
        IF v_countyid%FOUND THEN 
          SELECT town INTO v_county FROM temp WHERE  tempid = tempidddd; 
          UPDATE temp SET county = v_county WHERE  tempid = tempidddd; 
        END IF; 
        EXIT WHEN v_countyid%NOTFOUND; 
    END LOOP;
    CLOSE v_countyid;
    
    OPEN v_cover;
    LOOP 
        FETCH v_cover INTO v_type, tempidddd; 
        IF v_cover%FOUND THEN 
          IF v_type = '1' THEN 
            UPDATE temp SET type_of_cover_preferred = 'Shop Assistant' WHERE  tempid = tempidddd; 
          ELSIF v_type = '2' THEN 
            UPDATE temp SET    type_of_cover_preferred = 'Floor Manager' WHERE  tempid = tempidddd; 
          ELSIF v_type = '3' THEN 
            UPDATE temp SET type_of_cover_preferred = 'Window Dresser ' WHERE  tempid = tempidddd; 
          ELSIF v_type = '4' THEN 
            UPDATE temp SET type_of_cover_preferred = 'Stores Assistant' WHERE  tempid = tempidddd; 
          ELSIF v_type = '5' THEN 
            UPDATE temp SET type_of_cover_preferred = 'Cleaner' WHERE  tempid = tempidddd; 
          ELSIF v_type = '6' THEN 
            UPDATE temp SET type_of_cover_preferred = 'Cashier' WHERE  tempid = tempidddd; 
          ELSIF v_type = '0' THEN 
            UPDATE temp SET type_of_cover_preferred = 'N/A' WHERE  tempid = tempidddd; 
          END IF; 
        END IF;
        EXIT WHEN v_cover%NOTFOUND;
    END LOOP;
    CLOSE v_cover;

    OPEN v_regid;
    LOOP
        FETCH v_regid INTO v_rgs, tempidddd;
        IF v_regid%FOUND THEN
          IF v_rgs = '1' THEN
            UPDATE temp SET temp_registration_status = 'Waiting for Application Form' WHERE  tempid = tempidddd; 
          ELSIF v_rgs = '2' THEN 
            UPDATE temp SET temp_registration_status = 'None' WHERE  tempid = tempidddd; 
          ELSIF v_rgs = '3' THEN 
            UPDATE temp SET temp_registration_status = 'Waiting for Both References' WHERE  tempid = tempidddd; 
          ELSIF v_rgs = '4' THEN 
            UPDATE temp SET temp_registration_status = 'Waiting for 1 Reference' WHERE  tempid = tempidddd; 
          ELSIF v_rgs = '5' THEN 
            UPDATE temp SET temp_registration_status = 'Waiting for Both References' WHERE  tempid = tempidddd; 
              ELSIF v_rgs = '6' THEN 
            UPDATE temp SET temp_registration_status = 'Waiting for a decision' WHERE  tempid = tempidddd; 
            ELSIF v_rgs = '0'  THEN 
            UPDATE temp SET temp_registration_status = 'None' WHERE  tempid = tempidddd; 
             ELSIF v_rgs = '14'  THEN 
            UPDATE temp SET temp_registration_status = 'None' WHERE  tempid = tempidddd; 
          ELSIF v_rgs IS NULL THEN 
            UPDATE temp SET temp_registration_status = 'None' WHERE  tempid = tempidddd; 
          END IF; 
        END IF;
        EXIT WHEN v_regid%NOTFOUND;
    END LOOP;
    CLOSE v_regid;

    OPEN v_tempstatus;
    LOOP
        FETCH v_tempstatus INTO v_status, tempidddd;
        IF v_tempstatus%FOUND THEN 
          IF v_status = '1' THEN 
            UPDATE temp SET tempstatus = 'Live' WHERE  tempid = tempidddd; 
          ELSIF v_status = '2' THEN 
            UPDATE temp SET tempstatus = 'Archive' WHERE  tempid = tempidddd; 
          END IF; 
        END IF;
        EXIT WHEN v_tempstatus%NOTFOUND;
        END LOOP;
    CLOSE v_tempstatus;

    OPEN temp_postcode; 
    LOOP 
        FETCH temp_postcode INTO v_postcode,v_length,v_id ; 
        IF temp_postcode%FOUND THEN 
          IF v_length = 6 THEN 
            UPDATE temp SET  postcode = substr(v_postcode, 1, 3) || ' ' || substr(regexp_replace(v_postcode, '[[:space:]]*',''), 4) 
            WHERE tempid = v_id;
          ELSIF v_length = 7 THEN 
            UPDATE temp SET  postcode = substr(v_postcode, 1, 4) || ' ' || substr(regexp_replace(v_postcode, '[[:space:]]*',''), 5) 
            WHERE tempid = v_id;
          ELSE
            DELETE FROM temp WHERE tempid = v_id;
          END IF;
        END IF; 
        EXIT WHEN temp_postcode%NOTFOUND;
      END LOOP;
      CLOSE temp_postcode;

    EXCEPTION 
    WHEN OTHERS THEN 
             v_code := SQLCODE; 

             v_error := Substr(SQLERRM, 1, 64); 

             dbms_output.Put_line('ERROR CODE =' 
                                  || v_code 
                                  || ' : ' 
                                  ||v_error); 
END cleaning_temp; 

PROCEDURE Delete_Update_Null AS
BEGIN
    UPDATE temp SET title = 'NOT_KNOWN' WHERE title IS NULL;
    UPDATE temp SET gender = 'NOT_KNOWN' WHERE gender IS NULL OR gender = '0';
    UPDATE temp SET GENDER = 'NOT_KNOWN' WHERE  gender ='0' OR gender IS NUll;
    UPDATE temp SET qualification_place = 'NOT_KNOWN' WHERE qualification_place IS NUll;
    UPDATE temp SET qualification_year = 'NOT_KNOWN'  WHERE qualification_year IS NULL;
    UPDATE sessions SET status ='cancelled' WHERE status ='Unbooked' or status ='Temp Cancelled' or status = 'Branch Cancelled';
    UPDATE sessions SET status = 'booked' WHERE status ='Booked';
    DELETE FROM temp WHERE town IS NULL AND county IS NULL OR postcode IS NULL;
    UPDATE temp SET tel_home = 0 WHERE tel_home is null;
    COMMIT;
END Delete_Update_Null;

PROCEDURE clean_local_council
AS 
  v_county          local_council.county%TYPE; 
  v_localcouncil_id local_council.localcouncil_id%TYPE; 
  v_county          local_council.county%TYPE; 
  v_town            local_council.town%TYPE; 
  county_town       local_council.town%TYPE; 
  v_id              local_council.localcouncil_id%TYPE; 
  v_length          NUMBER; 
  v_postcode        local_council.postcode%TYPE; 
  v_cs              local_council.type_of_computer_system%TYPE; 
  v_councilname     local_council.address_line_2%TYPE;
  CURSOR v_countyid IS 
    SELECT localcouncil_id FROM local_council WHERE county IS NULL; 
  CURSOR local_postcode IS 
    SELECT Regexp_replace(postcode, '[[:space:]]*', ''), Length(Regexp_replace(postcode, '[[:space:]]*', '')), localcouncil_id 
    FROM   local_council; 
  CURSOR v_local IS 
    SELECT type_of_computer_system, localcouncil_id FROM local_council; 
  CURSOR c_councilname IS 
    SELECT  localcouncil_id,address_line_2 FROM local_council WHERE localcouncilname IS NULL; 
BEGIN 
    OPEN v_countyid;
    LOOP 
        FETCH v_countyid INTO v_localcouncil_id;
        IF v_countyid%FOUND THEN 
          SELECT town INTO county_town FROM local_council WHERE localcouncil_id = v_localcouncil_id AND county IS NULL;
          UPDATE local_council SET county = county_town WHERE localcouncil_id = v_localcouncil_id;
          DELETE FROM local_council WHERE town IS NULL AND county IS NULL OR postcode IS NULL;
          UPDATE local_council SET telephone = 0 WHERE telephone IS NULL; 
        END IF;
        EXIT WHEN v_countyid%NOTFOUND; 
    END LOOP;
    CLOSE v_countyid; 

    OPEN local_postcode;
    LOOP 
        FETCH local_postcode INTO v_postcode, v_length, v_id;
        IF local_postcode%FOUND THEN 
          IF v_length = 6 THEN
            UPDATE local_council SET postcode = Substr(v_postcode, 1, 3) || ' ' || Substr(Regexp_replace(v_postcode, 
                '[[:space:]]*', ''), 4) WHERE localcouncil_id = v_id; 
          ELSIF v_length = 7 THEN 
            UPDATE local_council SET  postcode = Substr(v_postcode, 1, 4) || ' ' || Substr(Regexp_replace(v_postcode, 
                '[[:space:]]*', ''), 5) WHERE  localcouncil_id = v_id; 
          ELSE 
            DELETE FROM local_council WHERE localcouncil_id = v_id; 
          END IF; 
        END IF;
        EXIT WHEN local_postcode%NOTFOUND;
    END LOOP;
    CLOSE local_postcode; 

    OPEN v_local;
    LOOP 
        FETCH v_local INTO v_cs, v_id;
        IF v_local%FOUND THEN 
          IF v_cs IS NULL THEN 
            UPDATE local_council SET type_of_computer_system = 'Not Known' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '0' THEN 
            UPDATE local_council SET  type_of_computer_system = 'Not Known' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '1' THEN 
            UPDATE local_council SET type_of_computer_system = 'Windows 95' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '2' THEN 
            UPDATE local_council SET type_of_computer_system = 'Windows 3.xx' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '3' THEN 
            UPDATE local_council SET type_of_computer_system = 'Dos' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '4' THEN 
            UPDATE local_council SET type_of_computer_system = 'Not Known' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '5' THEN 
            UPDATE local_council SET type_of_computer_system = 'VAMP' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '6' THEN 
            UPDATE local_council SET type_of_computer_system = 'Meditel' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '7' THEN 
            UPDATE local_council SET type_of_computer_system = 'Micro Solutions GP Plus' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '8' THEN 
            UPDATE local_council SET type_of_computer_system = 'HMC' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '9' THEN 
            UPDATE local_council SET type_of_computer_system = 'Emis' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '10' THEN 
            UPDATE local_council SET type_of_computer_system = 'MCS' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '11' THEN 
            UPDATE local_council SET type_of_computer_system = 'Genisyst' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '12' THEN 
            UPDATE local_council SET type_of_computer_system = 'Seetec' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '13' THEN 
            UPDATE local_council SET type_of_computer_system = 'Amsys' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '14' THEN 
            UPDATE local_council SET type_of_computer_system = 'GP Exeter' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '15' THEN 
            UPDATE local_council SET type_of_computer_system = 'Seven' WHERE  localcouncil_id = v_id; 
          ELSIF v_cs = '16' THEN 
            UPDATE local_council SET type_of_computer_system = 'Medusa' WHERE  localcouncil_id = v_id; 
          END IF; 
        END IF;
        EXIT WHEN v_local%NOTFOUND; 
    END LOOP; 
    CLOSE  v_local;
    
    OPEN c_councilname;
    LOOP 
        FETCH c_councilname INTO  v_id,v_councilname;
        IF c_councilname%FOUND THEN 
            UPDATE local_council SET localcouncilname = v_councilname WHERE  localcouncil_id = v_id; 
        END IF;
        EXIT WHEN c_councilname%NOTFOUND; 
    END LOOP;
    CLOSE c_councilname;  
END clean_local_council;

PROCEDURE clean_Temp_request AS 
  v_reg_num       temp_request.temprequestid%TYPE; 
  v_id            temp_request.temprequestid%TYPE; 
  v_requeststatus temp_request.request_status%TYPE; 
  CURSOR v_temprequest IS 
    SELECT Substr(temprequestid, -3), temprequestid FROM temp_request; 
BEGIN 
    OPEN v_temprequest;
    LOOP 
        FETCH v_temprequest INTO v_reg_num, v_id;
        IF v_temprequest%FOUND THEN 
          UPDATE temp_request SET temprequestid = v_reg_num WHERE  temprequestid = v_id; 
        END IF;
        EXIT WHEN v_temprequest%NOTFOUND; 
    END LOOP;
    CLOSE v_temprequest; 
END clean_Temp_request;

PROCEDURE Clean_Session AS 
    v_reg_num    sessions.requestid%TYPE; 
    ids          sessions.sessionid%TYPE; 
    idss          sessions.sessionid%TYPE;
    v_requestid   temp_request.temprequestid%TYPE; 
    ids_temprequestid         temp_request.temprequestid%TYPE; 
    v_type    temp.type_of_cover_preferred%TYPE;
    v_check   BOOLEAN; 
    v_count   NUMBER; 
    v_alter  varchar2(100);
    v_cursor INTEGER;
    v_code    NUMBER; 
    v_error   VARCHAR(64);
    CURSOR sess_requestid IS 
     SELECT SubSTR(requestid, -3),sessionid FROM sessions;
    CURSOR temp_requestid IS 
     SELECT SubSTR(temprequestid, -3),temprequestid FROM temp_Request;
    CURSOR v_cover IS 
     SELECT type, sessionid FROM sessions; 
  BEGIN  
    OPEN sess_requestid; 
    LOOP 
        FETCH sess_requestid INTO v_reg_num,ids; 
        IF sess_requestid%FOUND THEN 
           UPDATE sessions SET requestid = v_reg_num WHERE sessionid = ids;
        END IF; 
        EXIT WHEN sess_requestid%NOTFOUND;
      END LOOP;
      CLOSE sess_requestid; 
      
    OPEN temp_requestid; 
    LOOP 
        FETCH temp_requestid INTO  v_requestid, ids_temprequestid ; 
          IF temp_requestid%FOUND THEN 
            UPDATE temp_Request SET temprequestid = v_requestid WHERE temprequestid = ids_temprequestid;
            END IF; 
            EXIT WHEN temp_requestid%NOTFOUND;
    END LOOP;
    CLOSE temp_requestid;

    OPEN  v_cover;
    LOOP 
        FETCH  v_cover  INTO v_type, idss;
        IF  v_cover%FOUND THEN       
          IF   v_type = 1 THEN 
            UPDATE sessions SET   type = 'Shop Assistant' WHERE sessionid = idss; 
          ELSIF   v_type = 2 THEN 
            UPDATE sessions SET type = 'Floor Manager' WHERE sessionid = idss;  
          ELSIF   v_type = 3 THEN 
            UPDATE sessions SET type = 'Window Dresser' WHERE sessionid = idss; 
          ELSIF   v_type = 4 THEN 
            UPDATE sessions SET type = 'Stores Assistant' WHERE sessionid = idss; 
           ELSIF   v_type  = 0 THEN 
            UPDATE sessions SET type = 'N/A' WHERE sessionid = idss;
          END IF; 
        END IF;
        EXIT WHEN  v_cover%NOTFOUND; 
    END LOOP;
    CLOSE  v_cover; 

  EXCEPTION 
    WHEN OTHERS THEN 
               v_code := SQLCODE; 

               v_error := Substr(SQLERRM, 1, 64); 

               dbms_output.Put_line('ERROR CODE =' 
                                    || v_code 
                                    || ' : ' 
                                    ||v_error); 
  END Clean_Session;

PROCEDURE validate_postcode_format AS
    v_postCode temp.postcode%TYPE;
    v_tempid temp.tempid%TYPE;

    CURSOR v_pc IS 
        SELECT  postcode,tempid  FROM TEMP;
    BEGIN
    OPEN v_pc; 
    LOOP 
        FETCH  v_pc INTO v_postCode,v_tempid; 
        IF v_pc%FOUND THEN
            IF v_postCode = 'GIR 0AA' THEN
                DBMS_OUTPUT.PUT_LINE('');
            END IF;
            IF LENGTH( v_postCode ) > 8 THEN
                DBMS_OUTPUT.PUT_LINE(v_postCode || 'invalid PostCode ' || '2'||' '||'ID ='|| v_tempid);
            END IF;
            IF REGEXP_LIKE(v_postCode, '^[[:alpha:]]{1,2}[[:digit:]]{1,2}[[:alpha:]]{0,1}[[:space:]]{1}[[:digit:]]{1}[[:alpha:]]{2}')
            THEN
                DBMS_OUTPUT.PUT_LINE('');
            ELSE
                DBMS_OUTPUT.PUT_LINE('');
            END IF; 
        END IF;
        EXIT WHEN v_pc%NOTFOUND;
      END LOOP;
CLOSE v_pc; 

END;

PROCEDURE TIME_DATE_EXTRACTION AS 

    v_year      sessions.year%TYPE;
    v_month     sessions.month%TYPE;
    v_week      sessions.week%TYPE;
    v_day       sessions.day%TYPE;
    v_se_hour      sessions.se_hour%TYPE;
    v_se_minutes   sessions.se_minutes%TYPE;
    v_ss_hour      sessions.ss_hour%TYPE;
    v_ss_minutes   sessions.ss_minutes%TYPE;
    v_sessionID sessions.sessionid%TYPE;
    
    CURSOR c_sessionDate IS 
        SELECT EXTRACT(year FROM sessiondate),EXTRACT(month FROM sessiondate),EXTRACT(day FROM sessiondate),EXTRACT(HOUR FROM sessionstart),
        EXTRACT(minute FROM sessionstart),EXTRACT(HOUR FROM sessionend),EXTRACT(minute FROM sessionend), sessionid FROM sessions;
    CURSOR c_sessionWeek IS 
        SELECT to_number(to_char(to_date(sessiondate, 'DD/MM/YYYY'), 'WW')), sessionid FROM sessions;
BEGIN
OPEN c_sessionDate;
    LOOP 
        FETCH c_sessionDate INTO v_year,v_month,v_day,v_ss_hour,v_ss_minutes,v_se_hour,v_se_minutes,v_sessionID;
        IF c_sessionDate%FOUND THEN 
        UPDATE sessions SET year = v_year, month=v_month,day=v_day, ss_hour = v_ss_hour,ss_minutes = v_ss_minutes,
            se_hour = v_se_hour,se_minutes=v_se_minutes WHERE  sessionid = v_sessionID;        
        END IF;
        EXIT WHEN c_sessionDate%NOTFOUND; 
    END LOOP;
    CLOSE c_sessionDate; 

 OPEN c_sessionWeek;
    LOOP 
        FETCH c_sessionWeek INTO  v_week,v_sessionID; 
        IF c_sessionWeek%FOUND THEN 
            UPDATE sessions SET week = v_week WHERE  sessionid = v_sessionID;         
        END IF;
        EXIT WHEN c_sessionWeek%NOTFOUND; 
    END LOOP; 
    CLOSE c_sessionWeek;
END TIME_DATE_EXTRACTION;
  
PROCEDURE DW_Insert AS


v_tempid   temp.tempid%TYPE;
v_title    temp.title%TYPE;
v_ln       temp.last_name%TYPE;
v_county   temp.county%TYPE;
v_pc       temp.postcode%TYPE;
v_gender   temp.gender%TYPE;
v_cs       temp.current_status%TYPE;
v_dob      temp.date_of_birth%TYPE;
v_nationality   temp.nationality%TYPE;
v_car       temp.use_of_a_car%TYPE;
v_qy        temp.qualification_year%TYPE;
v_qp        temp.qualification_place%TYPE;
v_type      temp.type_of_cover_preferred%TYPE;
v_trs       temp.temp_registration_status%TYPE;
v_ts        temp.tempstatus%TYPE;

CURSOR C_DIM_TEMP IS
select tempid,title,last_name,county,postcode,gender,current_status,date_of_birth,nationality,use_of_a_car,qualification_year,
qualification_place,type_of_cover_preferred,temp_registration_status,tempstatus from temp;

v_councilid   local_council.localcouncil_id%TYPE;
v_councilname local_council.localcouncilname%TYPE;
v_local_pc          local_council.postcode%TYPE;
v_local_county      local_council.county%TYPE;
v_local_type         local_council.type_of_computer_system%TYPE;
CURSOR C_DIM_Local_Council IS
select localcouncil_id,localcouncilname,postcode,county,type_of_computer_system from local_council;

v_requestid temp_request.temprequestid%TYPE;
v_lcid      temp_request.localcouncil_id%TYPE;
v_requestdate temp_request.request_date%TYPE;
v_requeststatus temp_request.request_status%TYPE;

CURSOR C_DIM_TempRequest IS
select temprequestid,localcouncil_id,request_date,request_status from temp_request;

v_sessionid sessions.sessionid%TYPE;
v_session_requestid sessions.requestid%TYPE;
v_session_tempid   sessions.tempid%TYPE;
v_session_type    sessions.type%TYPE;
v_session_status   sessions.status%TYPE;


CURSOR c_Fact_Session IS
select sessionid,requestid,tempid,type,status  from sessions;

v_sID   sessions.sessionid%TYPE;
v_year  sessions.year%TYPE;
v_month sessions.month%TYPE;
v_week  sessions.week%TYPE;
v_day   sessions.day%TYPE;
v_ss_hour sessions.ss_hour%TYPE;
v_ss_minutes sessions.ss_minutes%TYPE;
v_se_hour   sessions.se_hour%TYPE;
v_se_minutes sessions.se_minutes%TYPE;
v_timeid    dim_time.timeid%TYPE;

CURSOR c_DIM_TIME IS
SELECT sessionid,year,month,week,day,ss_hour,ss_minutes,se_hour,se_minutes from  sessions;

cursor c_timeid is 
   select timeid  from dim_time;

BEGIN 




 OPEN C_DIM_TEMP; 

    LOOP 
        FETCH C_DIM_TEMP INTO v_tempid,v_title,v_ln,v_local_county,v_local_pc,v_gender,v_cs,v_dob,v_nationality,v_car,v_qy,v_qp,v_local_type,v_trs,v_ts; 

        IF C_DIM_TEMP%FOUND THEN 
        INSERT INTO dim_temp (tempid,title,lastname,county,postcode,gender,currentstatus,dateofbirth,nationality,useofacar,qualificationyear,
        qualificationplace,typeofcoverpreferred,TempRegistrationStatus,tempstatus)VALUES(v_tempid,v_title,v_ln,v_local_county,v_local_pc,v_gender,v_cs,v_dob,v_nationality,v_car,v_qy,v_qp,v_local_type,v_trs,v_ts);

       END IF; 
      

        EXIT WHEN C_DIM_TEMP%NOTFOUND; 
    END LOOP; 

    CLOSE C_DIM_TEMP; 

 OPEN C_DIM_Local_Council; 

    LOOP 
        FETCH C_DIM_Local_Council INTO  v_councilid,v_councilname,v_pc,v_county,v_type; 

        IF C_DIM_Local_Council%FOUND THEN 
        INSERT INTO dim_local_council (localcouncilid,councilname,postcode,county,computersystemtype)VALUES(v_councilid,v_councilname,v_pc,v_county,v_type);

        END IF; 

        EXIT WHEN C_DIM_Local_Council%NOTFOUND; 
    END LOOP; 

    CLOSE C_DIM_Local_Council; 

 OPEN C_DIM_TempRequest; 

    LOOP 
        FETCH C_DIM_TempRequest INTO  v_requestid,v_lcid ,v_requestdate,v_requeststatus; 

        IF C_DIM_TempRequest%FOUND THEN 
        INSERT INTO dim_temp_request (temprequestid,localcouncilid,requestdate,temprequeststatus)VALUES(v_requestid,v_lcid ,v_requestdate,v_requeststatus);

        END IF; 

        EXIT WHEN C_DIM_TempRequest%NOTFOUND; 
    END LOOP; 

    CLOSE C_DIM_TempRequest; 


 OPEN c_Fact_Session ; 

    LOOP 
        FETCH c_Fact_Session  INTO  v_sessionid,v_session_requestid,v_session_tempid,v_session_type,v_session_status; 

        IF c_Fact_Session %FOUND THEN 
        INSERT INTO fact_sessions (sessionid,temprequestid,tempid,typeofcover,status)VALUES(v_sessionid,v_session_requestid,v_session_tempid,v_session_type,v_session_status);

        END IF; 

        EXIT WHEN c_Fact_Session%NOTFOUND; 
    END LOOP; 

    CLOSE c_Fact_Session; 
 
 
 OPEN c_DIM_TIME; 

    LOOP 
        FETCH c_DIM_TIME  INTO v_sID,v_year,v_month,v_week,v_day,v_ss_hour,v_ss_minutes,v_se_hour,v_se_minutes; 

        IF c_DIM_TIME%FOUND THEN 
         
        INSERT INTO dim_time (year,month,week,day,ss_hour,ss_minute,se_hour,se_minute)VALUES(v_year,v_month,v_week,v_day,v_ss_hour,v_ss_minutes,v_se_hour,v_se_minutes);
     
        END IF; 
       open c_timeid;
       loop
       fetch c_timeid into v_timeid;
       IF C_timeid%FOUND THEN 
       
       UPDATE fact_sessions SET timeid =v_timeid where sessionid = v_sID;
       end IF;
          EXIT WHEN c_timeid%NOTFOUND; 
       end loop;
       close c_timeid;
        EXIT WHEN c_DIM_TIME%NOTFOUND; 
    END LOOP; 

    CLOSE c_DIM_TIME; 

 
 


End;
END COMP1434_CLEANING;
/

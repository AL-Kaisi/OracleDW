-- PostgreSQL CSV Loading Script
-- Uses COPY command to load data from CSV files

-- Function to load CSV files with error handling
CREATE OR REPLACE FUNCTION load_csv_file(
    table_name TEXT,
    file_path TEXT,
    delimiter TEXT DEFAULT ','
)
RETURNS VOID AS $$
DECLARE
    full_path TEXT;
    row_count INTEGER;
BEGIN
    -- Construct full file path
    full_path := '/data/csv/' || file_path;
    
    -- Execute COPY command
    EXECUTE format('COPY %I FROM %L WITH CSV HEADER DELIMITER %L', 
                   table_name, full_path, delimiter);
    
    -- Get row count
    EXECUTE format('SELECT COUNT(*) FROM %I', table_name) INTO row_count;
    
    RAISE NOTICE 'Loaded % rows into table %', row_count, table_name;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error loading % from %: %', table_name, file_path, SQLERRM;
        RAISE;
END;
$$ LANGUAGE plpgsql;

-- Procedure to load all CSV files
CREATE OR REPLACE PROCEDURE load_all_csv_files()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Load lookup tables first
    PERFORM load_csv_file('employee_title', 'EMPLOYEE_TITLE.csv');
    PERFORM load_csv_file('careprovider_computer_system', 'CAREPROVIDER_COMPUTER_SYSTEM.csv');
    PERFORM load_csv_file('temp_nationality', 'TEMP_NATIONALITY.csv');
    PERFORM load_csv_file('type_of_temp_cover', 'TYPE_OF_TEMP_COVER.csv');
    PERFORM load_csv_file('temp_age_band', 'TempAgeBand.csv');
    PERFORM load_csv_file('temp_current_status', 'TempCurrent_Status.csv');
    PERFORM load_csv_file('temp_gender', 'TempGender.csv');
    PERFORM load_csv_file('temp_permanent_job_type', 'TempPermanent_Job_Type.csv');
    PERFORM load_csv_file('temp_reasons_for_archiving', 'TempReasonsforArchiving.csv');
    PERFORM load_csv_file('temp_registration_status', 'TempRegistrationStatus.csv');
    PERFORM load_csv_file('temp_request_status', 'TempRequestStatus.csv');
    PERFORM load_csv_file('temp_status', 'TempStatus.csv');
    PERFORM load_csv_file('temp_meeting_date', 'TEMPMEETINGDATE.csv');
    PERFORM load_csv_file('temp_report_dates', 'TempReportDates.csv');
    
    -- Load main tables
    PERFORM load_csv_file('local_council', 'LOCAL_COUNCIL.csv');
    PERFORM load_csv_file('temp', 'TEMP.csv');
    PERFORM load_csv_file('employee_details', 'EMPLOYEE_DETAILS.csv');
    PERFORM load_csv_file('referee_details', 'REFEREES_DETAILS.csv');
    PERFORM load_csv_file('references', 'REFERENCES.csv');
    PERFORM load_csv_file('temp_request', 'TEMP_REQUEST.csv');
    PERFORM load_csv_file('sessions', 'SESSION.csv');
    PERFORM load_csv_file('temp_compatibility_details', 'TempCompatibilityDetails.csv');
    
    RAISE NOTICE 'All CSV files loaded successfully';
END;
$$;

-- Alternative loading method using file paths from application
CREATE OR REPLACE FUNCTION load_csv_with_path(
    table_name TEXT,
    full_file_path TEXT,
    delimiter TEXT DEFAULT ','
)
RETURNS VOID AS $$
BEGIN
    EXECUTE format('COPY %I FROM %L WITH CSV HEADER DELIMITER %L', 
                   table_name, full_file_path, delimiter);
    
    RAISE NOTICE 'Successfully loaded data into table %', table_name;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error loading % from %: %', table_name, full_file_path, SQLERRM;
        RAISE;
END;
$$ LANGUAGE plpgsql;
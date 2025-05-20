-- Data Cleaning and Transformation Functions for PostgreSQL
-- British English spellings used throughout

-- Function to standardise gender values
CREATE OR REPLACE FUNCTION standardise_gender(raw_gender TEXT)
RETURNS TEXT AS $$
BEGIN
    CASE UPPER(TRIM(raw_gender))
        WHEN 'M' THEN RETURN 'Male';
        WHEN 'MALE' THEN RETURN 'Male';
        WHEN 'F' THEN RETURN 'Female';
        WHEN 'FEMALE' THEN RETURN 'Female';
        ELSE RETURN 'Unknown';
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Function to standardise titles
CREATE OR REPLACE FUNCTION standardise_title(raw_title TEXT)
RETURNS TEXT AS $$
BEGIN
    CASE UPPER(TRIM(raw_title))
        WHEN 'MR' THEN RETURN 'Mr';
        WHEN 'MR.' THEN RETURN 'Mr';
        WHEN 'MRS' THEN RETURN 'Mrs';
        WHEN 'MRS.' THEN RETURN 'Mrs';
        WHEN 'MS' THEN RETURN 'Ms';
        WHEN 'MS.' THEN RETURN 'Ms';
        WHEN 'MISS' THEN RETURN 'Miss';
        WHEN 'DR' THEN RETURN 'Dr';
        WHEN 'DR.' THEN RETURN 'Dr';
        ELSE RETURN COALESCE(raw_title, 'Unknown');
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Function to format postcodes
CREATE OR REPLACE FUNCTION format_postcode(raw_postcode TEXT)
RETURNS TEXT AS $$
DECLARE
    clean_postcode TEXT;
BEGIN
    -- Remove all spaces and convert to uppercase
    clean_postcode := UPPER(REPLACE(raw_postcode, ' ', ''));
    
    -- Insert space before last 3 characters for UK postcode format
    IF LENGTH(clean_postcode) >= 5 THEN
        RETURN SUBSTR(clean_postcode, 1, LENGTH(clean_postcode) - 3) || ' ' || 
               SUBSTR(clean_postcode, LENGTH(clean_postcode) - 2);
    ELSE
        RETURN clean_postcode;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to standardise boolean values
CREATE OR REPLACE FUNCTION standardise_boolean(raw_value TEXT)
RETURNS TEXT AS $$
BEGIN
    CASE UPPER(TRIM(raw_value))
        WHEN 'YES' THEN RETURN 'Yes';
        WHEN 'Y' THEN RETURN 'Yes';
        WHEN 'TRUE' THEN RETURN 'Yes';
        WHEN '1' THEN RETURN 'Yes';
        WHEN 'NO' THEN RETURN 'No';
        WHEN 'N' THEN RETURN 'No';
        WHEN 'FALSE' THEN RETURN 'No';
        WHEN '0' THEN RETURN 'No';
        ELSE RETURN 'Unknown';
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Function to standardise status values
CREATE OR REPLACE FUNCTION standardise_status(raw_status TEXT)
RETURNS TEXT AS $$
BEGIN
    CASE UPPER(TRIM(raw_status))
        WHEN 'ACTIVE' THEN RETURN 'Active';
        WHEN 'INACTIVE' THEN RETURN 'Inactive';
        WHEN 'PENDING' THEN RETURN 'Pending';
        WHEN 'APPROVED' THEN RETURN 'Approved';
        WHEN 'REJECTED' THEN RETURN 'Rejected';
        WHEN 'SUSPENDED' THEN RETURN 'Suspended';
        WHEN 'ARCHIVED' THEN RETURN 'Archived';
        ELSE RETURN COALESCE(raw_status, 'Unknown');
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Procedure to clean temp data
CREATE OR REPLACE PROCEDURE clean_temp_data()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update gender values
    UPDATE temp 
    SET gender = standardise_gender(gender)
    WHERE gender IS NOT NULL;
    
    -- Update titles
    UPDATE temp 
    SET title = standardise_title(title)
    WHERE title IS NOT NULL;
    
    -- Update postcodes
    UPDATE temp 
    SET postcode = format_postcode(postcode)
    WHERE postcode IS NOT NULL;
    
    -- Update boolean fields
    UPDATE temp 
    SET use_of_a_car = standardise_boolean(use_of_a_car)
    WHERE use_of_a_car IS NOT NULL;
    
    UPDATE temp 
    SET monday_am = standardise_boolean(monday_am),
        monday_pm = standardise_boolean(monday_pm),
        tuesday_am = standardise_boolean(tuesday_am),
        tuesday_pm = standardise_boolean(tuesday_pm),
        wednesday_am = standardise_boolean(wednesday_am),
        wednesday_pm = standardise_boolean(wednesday_pm),
        thursday_am = standardise_boolean(thursday_am),
        thursday_pm = standardise_boolean(thursday_pm),
        friday_am = standardise_boolean(friday_am),
        friday_pm = standardise_boolean(friday_pm),
        saturday_am = standardise_boolean(saturday_am);
    
    -- Update status fields
    UPDATE temp 
    SET current_status = standardise_status(current_status)
    WHERE current_status IS NOT NULL;
END;
$$;

-- Procedure to clean local council data
CREATE OR REPLACE PROCEDURE clean_local_council_data()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update postcodes
    UPDATE local_council 
    SET postcode = format_postcode(postcode)
    WHERE postcode IS NOT NULL;
    
    -- Update boolean fields
    UPDATE local_council 
    SET computer_used_in_consultations = standardise_boolean(computer_used_in_consultations),
        appointment_system = standardise_boolean(appointment_system),
        leaflets = standardise_boolean(leaflets);
END;
$$;

-- Procedure to populate dimension tables
CREATE OR REPLACE PROCEDURE populate_dimensions()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Truncate dimension tables
    TRUNCATE TABLE fact_sessions CASCADE;
    TRUNCATE TABLE dim_temp_request CASCADE;
    TRUNCATE TABLE dim_time CASCADE;
    TRUNCATE TABLE dim_temp CASCADE;
    TRUNCATE TABLE dim_local_council CASCADE;
    
    -- Populate dim_local_council
    INSERT INTO dim_local_council (
        local_council_id,
        council_name,
        postcode,
        county,
        computer_system_type
    )
    SELECT 
        lc.local_council_id,
        lc.local_council_name,
        COALESCE(lc.postcode, 'Unknown'),
        COALESCE(lc.county, 'Unknown'),
        COALESCE(ccs.computer_system_description, 'Unknown')
    FROM local_council lc
    LEFT JOIN careprovider_computer_system ccs 
        ON lc.type_of_computer_system::INT = ccs.computer_system_id
    WHERE lc.local_council_id IS NOT NULL;
    
    -- Populate dim_temp
    INSERT INTO dim_temp (
        temp_id,
        title,
        last_name,
        county,
        postcode,
        gender,
        current_status,
        date_of_birth,
        nationality,
        use_of_a_car,
        qualification_year,
        qualification_place,
        type_of_cover_preferred,
        temp_registration_status,
        temp_status
    )
    SELECT 
        t.temp_id,
        COALESCE(t.title, 'Unknown'),
        COALESCE(t.last_name, 'Unknown'),
        COALESCE(t.county, 'Unknown'),
        COALESCE(t.postcode, 'Unknown'),
        COALESCE(t.gender, 'Unknown'),
        COALESCE(t.current_status, 'Unknown'),
        t.date_of_birth,
        COALESCE(tn.nationality_description, 'Unknown'),
        COALESCE(t.use_of_a_car, 'Unknown'),
        COALESCE(t.qualification_year, 'Unknown'),
        COALESCE(t.qualification_place, 'Unknown'),
        COALESCE(ttc.cover_description, 'Unknown'),
        COALESCE(trs.locum_registration_status_description, 'Unknown'),
        COALESCE(ts.temp_status_description, 'Unknown')
    FROM temp t
    LEFT JOIN temp_nationality tn 
        ON t.nationality::INT = tn.nationality_id
    LEFT JOIN type_of_temp_cover ttc 
        ON t.type_of_cover_preferred::INT = ttc.type_of_cover_id
    LEFT JOIN temp_registration_status trs 
        ON t.temp_registration_status::INT = trs.locum_registration_status_id
    LEFT JOIN temp_status ts 
        ON t.temp_status::INT = ts.temp_status_id
    WHERE t.temp_id IS NOT NULL;
    
    -- Populate dim_temp_request
    INSERT INTO dim_temp_request (
        temp_request_id,
        local_council_id,
        request_date,
        temp_request_status
    )
    SELECT 
        tr.temp_request_id,
        tr.local_council_id,
        tr.request_date,
        COALESCE(trs.request_status_description, 'Unknown')
    FROM temp_request tr
    LEFT JOIN temp_request_status trs 
        ON tr.request_status = trs.request_status_id
    WHERE tr.temp_request_id IS NOT NULL
        AND EXISTS (SELECT 1 FROM dim_local_council dlc WHERE dlc.local_council_id = tr.local_council_id);
    
    -- Populate dim_time (unique time combinations from sessions)
    INSERT INTO dim_time (
        ss_minute,
        ss_hour,
        se_minute,
        se_hour,
        day,
        week,
        month,
        year
    )
    SELECT DISTINCT
        COALESCE(ss_minutes, 0),
        COALESCE(ss_hour, 0),
        COALESCE(se_minutes, 0),
        COALESCE(se_hour, 0),
        COALESCE(day, 1),
        COALESCE(week, 1),
        COALESCE(month, 1),
        COALESCE(year, 2024)
    FROM sessions
    WHERE year IS NOT NULL;
    
    -- Populate fact_sessions
    INSERT INTO fact_sessions (
        session_id,
        temp_request_id,
        temp_id,
        time_id,
        type_of_cover,
        status
    )
    SELECT 
        s.session_id,
        s.request_id,
        s.temp_id,
        dt.time_id,
        COALESCE(s.type, 'Unknown'),
        COALESCE(s.status, 'Unknown')
    FROM sessions s
    INNER JOIN dim_temp_request dtr ON s.request_id = dtr.temp_request_id
    INNER JOIN dim_temp dtp ON s.temp_id = dtp.temp_id
    LEFT JOIN dim_time dt ON 
        dt.ss_minute = COALESCE(s.ss_minutes, 0) AND
        dt.ss_hour = COALESCE(s.ss_hour, 0) AND
        dt.se_minute = COALESCE(s.se_minutes, 0) AND
        dt.se_hour = COALESCE(s.se_hour, 0) AND
        dt.day = COALESCE(s.day, 1) AND
        dt.week = COALESCE(s.week, 1) AND
        dt.month = COALESCE(s.month, 1) AND
        dt.year = COALESCE(s.year, 2024)
    WHERE s.session_id IS NOT NULL;
END;
$$;

-- Master procedure to run all cleaning and transformation
CREATE OR REPLACE PROCEDURE run_etl_process()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Clean staging data
    CALL clean_temp_data();
    CALL clean_local_council_data();
    
    -- Populate dimensions and fact table
    CALL populate_dimensions();
    
    -- Log completion
    RAISE NOTICE 'ETL process completed successfully at %', NOW();
END;
$$;
-- Set date format to British format (DD/MM/YYYY)
SET datestyle TO 'DMY';

-- Create temporary table for TEMP data
CREATE TEMP TABLE temp_data_temp (LIKE temp);

-- Load data into temporary table
COPY temp_data_temp FROM '/data/csv/TEMP.csv' WITH CSV HEADER DELIMITER ',';

-- Insert data from temporary table to main table
INSERT INTO temp SELECT * FROM temp_data_temp;

-- Create temporary table for SESSION data
CREATE TEMP TABLE session_data_temp (LIKE sessions);

-- Load data into temporary table
COPY session_data_temp FROM '/data/csv/SESSION.csv' WITH CSV HEADER DELIMITER ',';

-- Insert data from temporary table to main table
INSERT INTO sessions SELECT * FROM session_data_temp;

-- Create temporary table for TEMP_REQUEST data if not already loaded
CREATE TEMP TABLE temp_request_data_temp (LIKE temp_request);

-- Load data into temporary table
COPY temp_request_data_temp FROM '/data/csv/TEMP_REQUEST.csv' WITH CSV HEADER DELIMITER ',';

-- Insert data from temporary table to main table
INSERT INTO temp_request SELECT * FROM temp_request_data_temp;

-- Run the ETL process
CALL run_etl_process();

-- Display row counts for verification
SELECT 'dim_temp' as table_name, COUNT(*) as row_count FROM dim_temp
UNION ALL
SELECT 'dim_local_council', COUNT(*) FROM dim_local_council
UNION ALL
SELECT 'dim_temp_request', COUNT(*) FROM dim_temp_request
UNION ALL
SELECT 'dim_time', COUNT(*) FROM dim_time
UNION ALL
SELECT 'fact_sessions', COUNT(*) FROM fact_sessions;
-- Oracle to PostgreSQL Migration Script
-- Green Care Provider Temps Data Warehouse

-- This script provides guidelines and SQL for migrating from Oracle to PostgreSQL

-- Key Differences and Conversions:

-- 1. Data Types
-- Oracle VARCHAR2 -> PostgreSQL VARCHAR
-- Oracle NUMBER -> PostgreSQL INT or NUMERIC
-- Oracle DATE -> PostgreSQL DATE or TIMESTAMP
-- Oracle CLOB -> PostgreSQL TEXT

-- 2. Sequences
-- Oracle: CREATE SEQUENCE seq_name START WITH 1
-- PostgreSQL: Use SERIAL or IDENTITY columns

-- 3. Functions and Procedures
-- Oracle: CREATE OR REPLACE PROCEDURE
-- PostgreSQL: CREATE OR REPLACE PROCEDURE (same syntax)

-- 4. String Concatenation
-- Oracle: || or CONCAT
-- PostgreSQL: || (same)

-- 5. Date Functions
-- Oracle: SYSDATE
-- PostgreSQL: CURRENT_DATE or NOW()

-- Example Migration Patterns:

-- Oracle table definition:
/*
CREATE TABLE TEMP_REQUEST (
    TempRequestID NUMBER PRIMARY KEY,
    LocalCouncil_ID NUMBER,
    Request_date DATE,
    Comments VARCHAR2(100)
);
*/

-- PostgreSQL equivalent:
CREATE TABLE temp_request (
    temp_request_id INT PRIMARY KEY,
    local_council_id INT,
    request_date DATE,
    comments VARCHAR(100)
);

-- Oracle sequence:
/*
CREATE SEQUENCE S_Time_PK
START WITH 1
INCREMENT BY 1
CACHE 10;
*/

-- PostgreSQL equivalent (using SERIAL):
-- Already handled in table definition with SERIAL type

-- Oracle trigger:
/*
CREATE OR REPLACE TRIGGER T_Time_PK
BEFORE INSERT ON Dim_Time
FOR EACH ROW
BEGIN
    SELECT S_Time_PK.NEXTVAL INTO :NEW.TimeID FROM DUAL;
END;
*/

-- PostgreSQL equivalent (automatic with SERIAL):
-- No trigger needed with SERIAL columns

-- Oracle PL/SQL Package:
/*
CREATE OR REPLACE PACKAGE COMP1434_CLEANING AS
    PROCEDURE P_CLEAN_DATA;
END COMP1434_CLEANING;
*/

-- PostgreSQL equivalent (separate functions):
CREATE OR REPLACE PROCEDURE clean_data()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Procedure body
END;
$$;

-- Common Function Conversions:

-- Oracle NVL -> PostgreSQL COALESCE
-- Oracle: NVL(column, 'default')
-- PostgreSQL: COALESCE(column, 'default')

-- Oracle DECODE -> PostgreSQL CASE
-- Oracle: DECODE(status, 1, 'Active', 2, 'Inactive', 'Unknown')
-- PostgreSQL: 
/*
CASE status
    WHEN 1 THEN 'Active'
    WHEN 2 THEN 'Inactive'
    ELSE 'Unknown'
END
*/

-- Oracle ROWNUM -> PostgreSQL LIMIT
-- Oracle: WHERE ROWNUM <= 10
-- PostgreSQL: LIMIT 10

-- String Functions:
-- Both use similar functions: UPPER(), LOWER(), TRIM(), SUBSTR()

-- Migration Steps:

-- 1. Export data from Oracle
-- Use Oracle Data Pump or CSV export

-- 2. Convert schema
-- Run the PostgreSQL schema creation scripts

-- 3. Load data
-- Use COPY command or CSV import

-- 4. Convert procedures and functions
-- Rewrite using PostgreSQL syntax

-- 5. Update application code
-- Change connection strings and any Oracle-specific code

-- Example Data Migration:

-- Export from Oracle:
/*
-- Create CSV files
SET COLSEP ','
SET PAGESIZE 0
SET TRIMSPOOL ON
SET HEADSEP OFF
SET LINESIZE 1000

SPOOL temp_data.csv
SELECT temp_id, first_name, last_name, ... FROM TEMP;
SPOOL OFF
*/

-- Import to PostgreSQL:
/*
COPY temp (temp_id, first_name, last_name, ...)
FROM '/path/to/temp_data.csv'
WITH (FORMAT CSV, HEADER true);
*/

-- Verification Queries:

-- Check row counts
SELECT 'temp' as table_name, COUNT(*) as row_count FROM temp
UNION ALL
SELECT 'local_council', COUNT(*) FROM local_council
UNION ALL
SELECT 'sessions', COUNT(*) FROM sessions;

-- Check data integrity
SELECT COUNT(*) as orphaned_sessions
FROM sessions s
LEFT JOIN temp t ON s.temp_id = t.temp_id
WHERE t.temp_id IS NULL;

-- Performance Tuning:

-- Update statistics
ANALYZE;

-- Create missing indexes
CREATE INDEX idx_sessions_date ON sessions(session_date);
CREATE INDEX idx_temp_status ON temp(current_status);

-- Monitor performance
SELECT query, calls, mean_exec_time, max_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
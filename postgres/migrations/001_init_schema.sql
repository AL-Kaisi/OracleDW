-- Initial PostgreSQL Data Warehouse Schema for Green Care Provider Temps
-- Uses English spelling throughout as per British English requirement

-- Create staging tables
CREATE TABLE IF NOT EXISTS temp_request (
    temp_request_id INT PRIMARY KEY,
    local_council_id INT,
    request_date DATE,
    start_date VARCHAR(50),
    end_date VARCHAR(50),
    monday_am VARCHAR(50),
    monday_pm VARCHAR(50),
    tuesday_am VARCHAR(50),
    tuesday_pm VARCHAR(50),
    wednesday_am VARCHAR(50),
    wednesday_pm VARCHAR(50),
    thursday_am VARCHAR(50),
    thursday_pm VARCHAR(50),
    friday_am VARCHAR(50),
    friday_pm VARCHAR(50),
    saturday_am VARCHAR(50),
    request_status INT,
    number_of_weeks INT,
    comments VARCHAR(100)
);

CREATE INDEX idx_temp_request_council ON temp_request(local_council_id);

CREATE TABLE IF NOT EXISTS references (
    reference_id INT PRIMARY KEY,
    temp_id INT,
    referee_id INT,
    date_reference_sent VARCHAR(50),
    date_reference_received VARCHAR(50),
    telephone_made VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS referee_details (
    referee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address_line_1 VARCHAR(50),
    address_line_2 VARCHAR(50),
    town VARCHAR(50),
    county VARCHAR(50),
    postcode VARCHAR(50),
    tel VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS careprovider_computer_system (
    computer_system_id INT PRIMARY KEY,
    computer_system_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS employee_details (
    employee_id INT PRIMARY KEY,
    local_council_id INT,
    title VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    status VARCHAR(50),
    year_qualified VARCHAR(4),
    initials VARCHAR(50),
    show VARCHAR(50),
    deleted VARCHAR(50)
);

CREATE INDEX idx_employee_council ON employee_details(local_council_id);

CREATE TABLE IF NOT EXISTS temp (
    temp_id INT PRIMARY KEY,
    title VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address_line_1 VARCHAR(50),
    address_line_2 VARCHAR(50),
    town VARCHAR(50),
    county VARCHAR(50),
    postcode VARCHAR(50),
    tel_home VARCHAR(50),
    fax_home VARCHAR(50),
    tel_work VARCHAR(50),
    fax_work VARCHAR(50),
    mobile_phone VARCHAR(50),
    date_application_was_sent VARCHAR(50),
    gender VARCHAR(50),
    current_status VARCHAR(50),
    date_of_birth DATE,
    nationality VARCHAR(50),
    use_of_a_car VARCHAR(50),
    qualification_year VARCHAR(50),
    qualification_place VARCHAR(50),
    type_of_cover_preferred VARCHAR(50),
    monday_am VARCHAR(50),
    monday_pm VARCHAR(50),
    tuesday_am VARCHAR(50),
    tuesday_pm VARCHAR(50),
    wednesday_am VARCHAR(50),
    wednesday_pm VARCHAR(50),
    thursday_am VARCHAR(50),
    thursday_pm VARCHAR(50),
    friday_am VARCHAR(50),
    friday_pm VARCHAR(50),
    saturday_am VARCHAR(50),
    temp_registration_status VARCHAR(50),
    date_application_received VARCHAR(50),
    temp_status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS employee_title (
    title_id INT PRIMARY KEY,
    title_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS sessions (
    session_id INT PRIMARY KEY,
    request_id INT,
    temp_id INT,
    session_date DATE,
    session_start TIMESTAMP,
    session_end TIMESTAMP,
    status VARCHAR(50),
    type VARCHAR(50),
    employee_covered VARCHAR(50),
    do_print VARCHAR(50),
    year INT,
    month INT,
    week INT,
    day INT,
    ss_hour INT,
    ss_minutes INT,
    se_hour INT,
    se_minutes INT
);

CREATE TABLE IF NOT EXISTS local_council (
    local_council_id INT PRIMARY KEY,
    local_council_name VARCHAR(50),
    address_line_1 VARCHAR(50),
    address_line_2 VARCHAR(50),
    town VARCHAR(50),
    county VARCHAR(50),
    postcode VARCHAR(50),
    locality VARCHAR(50),
    telephone VARCHAR(50),
    fax VARCHAR(50),
    bypass VARCHAR(50),
    approximate_list_size VARCHAR(50),
    type_of_computer_system VARCHAR(50),
    computer_used_in_consultations VARCHAR(50),
    appointment_system VARCHAR(50),
    leaflets VARCHAR(50),
    date_of_last_update VARCHAR(50),
    type_of_local_council VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_nationality (
    nationality_id INT PRIMARY KEY,
    nationality_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS type_of_temp_cover (
    type_of_cover_id INT PRIMARY KEY,
    cover_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_age_band (
    age_band_name VARCHAR(50),
    age_band_low VARCHAR(50),
    age_band_high VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_compatibility_details (
    temp_id INT,
    branch_id INT,
    compatibility VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_current_status (
    current_status_id INT,
    current_status_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_gender (
    gender_id INT,
    gender_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_meeting_date (
    next_locemdoc_meeting_date VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_permanent_job_type (
    permanent_job_id INT,
    type_of_permanent_job VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_reasons_for_archiving (
    reason_for_archiving_id INT,
    reason_for_archiving_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_registration_status (
    locum_registration_status_id INT,
    locum_registration_status_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_report_dates (
    first_date VARCHAR(50),
    last_date VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_request_status (
    request_status_id INT,
    request_status_description VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS temp_status (
    temp_status_id INT,
    temp_status_description VARCHAR(50)
);

-- Create dimension tables
CREATE TABLE IF NOT EXISTS dim_temp (
    temp_id INT PRIMARY KEY,
    title VARCHAR(15) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    county VARCHAR(30) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    current_status VARCHAR(20) NOT NULL,
    date_of_birth DATE,
    nationality VARCHAR(50) NOT NULL,
    use_of_a_car VARCHAR(20) NOT NULL,
    qualification_year VARCHAR(10) NOT NULL,
    qualification_place VARCHAR(25) NOT NULL,
    type_of_cover_preferred VARCHAR(30) NOT NULL,
    temp_registration_status VARCHAR(30) NOT NULL,
    temp_status VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_local_council (
    local_council_id INT PRIMARY KEY,
    council_name VARCHAR(50) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    county VARCHAR(25) NOT NULL,
    computer_system_type VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_time (
    time_id SERIAL PRIMARY KEY,
    ss_minute INT NOT NULL,
    ss_hour INT NOT NULL,
    se_minute INT NOT NULL,
    se_hour INT NOT NULL,
    day INT NOT NULL,
    week INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL
);

CREATE TABLE IF NOT EXISTS dim_temp_request (
    temp_request_id INT PRIMARY KEY,
    local_council_id INT NOT NULL REFERENCES dim_local_council(local_council_id),
    request_date DATE,
    temp_request_status VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS fact_sessions (
    session_id INT PRIMARY KEY,
    temp_request_id INT NOT NULL REFERENCES dim_temp_request(temp_request_id),
    temp_id INT NOT NULL REFERENCES dim_temp(temp_id),
    time_id INT REFERENCES dim_time(time_id),
    type_of_cover VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL
);

-- Create indexes for foreign keys
CREATE INDEX idx_dim_temp_request_council ON dim_temp_request(local_council_id);
CREATE INDEX idx_fact_sessions_request ON fact_sessions(temp_request_id);
CREATE INDEX idx_fact_sessions_temp ON fact_sessions(temp_id);
CREATE INDEX idx_fact_sessions_time ON fact_sessions(time_id);
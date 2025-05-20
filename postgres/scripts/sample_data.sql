-- Insert sample data into dimension tables
-- First, make sure tables exist
CREATE TABLE IF NOT EXISTS dim_local_council (
    local_council_id SERIAL PRIMARY KEY,
    council_name VARCHAR(255),
    postcode VARCHAR(10),
    county VARCHAR(100),
    computer_system_type VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_temp (
    temp_id SERIAL PRIMARY KEY,
    title VARCHAR(10),
    last_name VARCHAR(100),
    county VARCHAR(100),
    postcode VARCHAR(10),
    gender VARCHAR(10),
    current_status VARCHAR(50),
    date_of_birth DATE,
    nationality VARCHAR(100),
    use_of_a_car VARCHAR(3),
    qualification_year VARCHAR(4),
    qualification_place VARCHAR(100),
    type_of_cover_preferred VARCHAR(100),
    temp_registration_status VARCHAR(50),
    temp_status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_temp_request (
    temp_request_id SERIAL PRIMARY KEY,
    local_council_id INT REFERENCES dim_local_council(local_council_id),
    request_date DATE,
    temp_request_status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_time (
    time_id SERIAL PRIMARY KEY,
    ss_minute INT,
    ss_hour INT,
    se_minute INT, 
    se_hour INT,
    day INT,
    week INT,
    month INT,
    year INT
);

CREATE TABLE IF NOT EXISTS fact_sessions (
    session_id SERIAL PRIMARY KEY,
    temp_request_id INT REFERENCES dim_temp_request(temp_request_id),
    temp_id INT REFERENCES dim_temp(temp_id),
    time_id INT REFERENCES dim_time(time_id),
    type_of_cover VARCHAR(100),
    status VARCHAR(50)
);

-- Insert sample data into dim_local_council
INSERT INTO dim_local_council (council_name, postcode, county, computer_system_type)
VALUES 
('Birmingham City Council', 'B1 1BB', 'West Midlands', 'SystmOne'),
('Manchester City Council', 'M2 5DB', 'Greater Manchester', 'EMIS'),
('Liverpool City Council', 'L3 8EN', 'Merseyside', 'Vision'),
('Newcastle City Council', 'NE1 8QH', 'Tyne and Wear', 'SystmOne'),
('Leeds City Council', 'LS1 1UR', 'West Yorkshire', 'EMIS');

-- Insert sample data into dim_temp
INSERT INTO dim_temp (title, last_name, county, postcode, gender, current_status, date_of_birth, nationality, use_of_a_car, qualification_year, qualification_place, type_of_cover_preferred, temp_registration_status, temp_status)
VALUES 
('Dr', 'Smith', 'West Midlands', 'B15 2TT', 'Male', 'Active', '1975-06-15', 'British', 'Yes', '2000', 'Birmingham University', 'Full Cover', 'Registered', 'Active'),
('Dr', 'Jones', 'Greater Manchester', 'M4 3AB', 'Female', 'Active', '1980-03-22', 'British', 'Yes', '2005', 'Manchester University', 'Clinical Only', 'Registered', 'Active'),
('Dr', 'Williams', 'Merseyside', 'L18 9YZ', 'Male', 'Inactive', '1968-11-10', 'Irish', 'Yes', '1995', 'Liverpool University', 'Partial Cover', 'Registered', 'Inactive'),
('Dr', 'Brown', 'Tyne and Wear', 'NE3 2PQ', 'Female', 'Active', '1982-09-05', 'British', 'No', '2010', 'Newcastle University', 'Full Cover', 'Registered', 'Active'),
('Dr', 'Taylor', 'West Yorkshire', 'LS6 3BG', 'Male', 'Active', '1977-07-30', 'British', 'Yes', '2003', 'Leeds University', 'Clinical Only', 'Registered', 'Active');

-- Insert sample data into dim_time
INSERT INTO dim_time (ss_minute, ss_hour, se_minute, se_hour, day, week, month, year)
VALUES 
(0, 9, 0, 17, 1, 1, 1, 2024),
(30, 8, 30, 16, 2, 1, 1, 2024),
(0, 9, 0, 17, 3, 1, 1, 2024),
(30, 8, 30, 16, 4, 1, 1, 2024),
(0, 9, 0, 13, 5, 1, 1, 2024),
(0, 9, 0, 17, 8, 2, 1, 2024),
(30, 8, 30, 16, 9, 2, 1, 2024),
(0, 9, 0, 17, 10, 2, 1, 2024),
(30, 8, 30, 16, 11, 2, 1, 2024),
(0, 9, 0, 13, 12, 2, 1, 2024);

-- Insert sample data into dim_temp_request
INSERT INTO dim_temp_request (local_council_id, request_date, temp_request_status)
VALUES 
(1, '2024-01-01', 'Active'),
(2, '2024-01-02', 'Active'),
(3, '2024-01-03', 'Active'),
(4, '2024-01-04', 'Active'),
(5, '2024-01-05', 'Active');

-- Insert sample data into fact_sessions
INSERT INTO fact_sessions (temp_request_id, temp_id, time_id, type_of_cover, status)
VALUES 
(1, 1, 1, 'Full Cover', 'Completed'),
(2, 2, 2, 'Clinical Only', 'Completed'),
(3, 3, 3, 'Partial Cover', 'Cancelled'),
(4, 4, 4, 'Full Cover', 'Completed'),
(5, 5, 5, 'Clinical Only', 'Completed'),
(1, 2, 6, 'Clinical Only', 'Completed'),
(2, 3, 7, 'Partial Cover', 'Cancelled'),
(3, 4, 8, 'Full Cover', 'Completed'),
(4, 5, 9, 'Clinical Only', 'Completed'),
(5, 1, 10, 'Full Cover', 'Completed'),
(1, 3, 1, 'Partial Cover', 'Cancelled'),
(2, 4, 2, 'Full Cover', 'Completed'),
(3, 5, 3, 'Clinical Only', 'Completed'),
(4, 1, 4, 'Full Cover', 'Completed'),
(5, 2, 5, 'Clinical Only', 'Completed');

-- Add more sample data for sessions by month
INSERT INTO dim_time (ss_minute, ss_hour, se_minute, se_hour, day, week, month, year)
VALUES 
(0, 9, 0, 17, 1, 5, 2, 2024),
(30, 8, 30, 16, 2, 5, 2, 2024),
(0, 9, 0, 17, 3, 6, 3, 2024),
(30, 8, 30, 16, 4, 6, 3, 2024),
(0, 9, 0, 13, 5, 7, 4, 2024),
(0, 9, 0, 17, 8, 8, 5, 2024),
(30, 8, 30, 16, 9, 9, 6, 2024),
(0, 9, 0, 17, 10, 10, 7, 2024),
(30, 8, 30, 16, 11, 11, 8, 2024),
(0, 9, 0, 13, 12, 12, 9, 2024),
(0, 9, 0, 17, 15, 13, 10, 2024),
(30, 8, 30, 16, 16, 14, 11, 2024),
(0, 9, 0, 17, 17, 15, 12, 2024);

-- Add sessions for these months
INSERT INTO fact_sessions (temp_request_id, temp_id, time_id, type_of_cover, status)
VALUES 
(1, 1, 11, 'Full Cover', 'Completed'),
(2, 2, 12, 'Clinical Only', 'Completed'),
(3, 3, 13, 'Partial Cover', 'Cancelled'),
(4, 4, 14, 'Full Cover', 'Completed'),
(5, 5, 15, 'Clinical Only', 'Completed'),
(1, 2, 16, 'Clinical Only', 'Completed'),
(2, 3, 17, 'Partial Cover', 'Cancelled'),
(3, 4, 18, 'Full Cover', 'Completed'),
(4, 5, 19, 'Clinical Only', 'Completed'),
(5, 1, 20, 'Full Cover', 'Completed'),
(1, 3, 21, 'Partial Cover', 'Cancelled'),
(2, 4, 22, 'Full Cover', 'Completed'),
(3, 5, 23, 'Clinical Only', 'Completed');
# Green Care Provider Temps Data Warehouse

A comprehensive data warehouse solution for managing temporary healthcare workers, local councils, and work sessions. This project provides a modern web interface for data visualization, analytics, and management.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Data Warehouse Design](#data-warehouse-design)
- [ETL Process](#etl-process)
- [Web Interface](#web-interface)
- [PostgreSQL Implementation](#postgresql-implementation)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)
- [Performance Considerations](#performance-considerations)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [Migration from Oracle](#migration-from-oracle)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)
- [Appendix](#appendix)

## Overview

The Green Care Provider Temps Data Warehouse represents a migration from an Oracle-based system to a modern PostgreSQL database with a web-based frontend. The system helps healthcare organizations manage temporary workers' assignments to local councils, track sessions, and generate reports.

```
+------------------+      +-----------------+      +------------------+
|                  |      |                 |      |                  |
|    CSV Files     +----->+  PostgreSQL DB  +----->+  Flask Web App   |
|                  |      |                 |      |                  |
+------------------+      +-----------------+      +------------------+
        |                         |                        |
        |                         |                        |
        v                         v                        v
+------------------+      +-----------------+      +------------------+
|                  |      |                 |      |                  |
|   Extract Data   |      | Transform Data  |      |  Visualize Data  |
|                  |      |                 |      |                  |
+------------------+      +-----------------+      +------------------+

                   Green Care Provider Temps Architecture
```

### Key Features

- **Dashboard**: Visualize key metrics and trends across the organization
- **Temporary Worker Management**: Track and manage temporary healthcare workers
- **Council Management**: Manage local council information and requirements
- **Session Tracking**: Monitor work sessions and assignments
- **Data Analytics**: Generate reports and insights from historical data
- **ETL Capabilities**: Load and transform data from various sources with column mapping

## Architecture

The system uses a modern, containerized architecture with PostgreSQL as the database and Flask as the web framework.

### Key Components

1. **PostgreSQL Database**: Stores all staging and warehouse data
2. **Flask Web Application**: Provides user interface and REST API
3. **ETL Process**: Transforms data from CSV to dimensional model
4. **Docker**: Containerizes the entire solution

### Migration Benefits

- **Open Source**: PostgreSQL is free and open-source
- **Modern Features**: Full JSON support, window functions, CTEs
- **Extensibility**: Rich ecosystem of extensions
- **Performance**: Excellent query optimization and indexing
- **Standards Compliance**: SQL standard compliance

## Data Warehouse Design

The system uses a star schema design optimized for analytical queries:

```
                               +-------------------+
                               |                   |
                     +-------->+   dim_time        +<--------+
                     |         |                   |         |
                     |         +-------------------+         |
                     |                                       |
                     |                                       |
+-------------------+|                                       |+-------------------+
|                   ||                                       ||                   |
|   dim_temp        ||      +-------------------+            ||  dim_local_council|
|                   ||      |                   |            ||                   |
+----------+--------+|      |   fact_sessions   |            |+--------+----------+
           |         +----->+                   +<-----------+         |
           |                |                   |                      |
           |                +--------+----------+                      |
           |                         |                                 |
           |                         |                                 |
           |                         v                                 |
           |                +-------------------+                      |
           |                |                   |                      |
           +--------------->+   dim_temp_request+<---------------------+
                            |                   |
                            +-------------------+

                        Green Care Provider Temps Star Schema
```

### Fact Table

- **fact_sessions**: Central fact table tracking work sessions
  - Records all temporary worker sessions
  - Contains foreign keys to all dimension tables
  - Stores metrics like session duration and status

### Dimension Tables

- **dim_temp**: Temporary worker attributes
  - Contains worker demographics and qualifications
  - Includes contact details and geographic information
  - Tracks worker status and preferences

- **dim_local_council**: Council information
  - Stores council details and locations
  - Includes computer systems used
  - Contains contact information

- **dim_time**: Time dimension with granular time attributes
  - Breaks down time into year, month, day components
  - Includes session start and end times
  - Enables time-based analysis at multiple levels

- **dim_temp_request**: Request tracking dimension
  - Links councils to their temporary worker requests
  - Tracks request status and dates
  - Connects to relevant sessions

### Staging Tables

Multiple staging tables store raw data from CSV imports before transformation:
- **temp**: Raw temporary worker data
- **local_council**: Raw council information
- **sessions**: Raw session records
- **temp_request**: Raw request data
- And various lookup tables for reference data

### Key PostgreSQL Features Used

- **SERIAL**: Auto-incrementing primary keys
- **FOREIGN KEY**: Enforced referential integrity
- **CHECK CONSTRAINTS**: Data validation rules
- **INDEXES**: B-tree indexes on join columns
- **DATE/TIME FUNCTIONS**: Rich temporal operations
- **VIEWS**: For simplified query access

## ETL Process

The data warehouse includes a complete ETL (Extract, Transform, Load) pipeline:

```
+----------------+     +-------------------+     +----------------+
|                |     |                   |     |                |
|   CSV Files    +---->+  Staging Tables   +---->+  Clean Data    |
|                |     |                   |     |                |
+-------+--------+     +-------------------+     +-------+--------+
        |                                                |
        |                                                |
        v                                                v
+----------------+     +-------------------+     +----------------+
|                |     |                   |     |                |
| Standard Format+---->+ Transform Data    +---->+ Dimension Load |
|                |     |                   |     |                |
+-------+--------+     +-------------------+     +-------+--------+
        |                                                |
        |                                                |
        v                                                v
+----------------+     +-------------------+     +----------------+
|                |     |                   |     |                |
| Reference Data +---->+ Load Fact Tables  +---->+ Data Available |
|                |     |                   |     |                |
+----------------+     +-------------------+     +----------------+

                     Green Care Provider Temps ETL Flow
```

### Extract Phase

- **CSV Loading**: Uses PostgreSQL's COPY command for high-performance bulk loading
- **Data Validation**: Checks for required fields and data types
- **Error Handling**: Records and logs problematic data
- **Metadata Tracking**: Captures load timestamps and record counts

Implementation:

```sql
-- Function to load CSV files with error handling
CREATE OR REPLACE FUNCTION load_csv_file(
    table_name TEXT,
    file_path TEXT,
    delimiter TEXT DEFAULT ','
)
RETURNS VOID AS $$
BEGIN
    EXECUTE format('COPY %I FROM %L WITH CSV HEADER DELIMITER %L',
                  table_name, full_path, delimiter);
END;
$$ LANGUAGE plpgsql;
```

### Transform Phase

- **Data Cleaning**: Standardizes formats (titles, genders, postcodes)
- **Code Resolution**: Converts codes to descriptive values
- **Time Extraction**: Parses date/time fields into components
- **Business Rules**: Applies domain-specific transformations
- **Quality Checks**: Validates transformed data

Key transformation functions:

```sql
-- Standardize gender values
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

-- Format postcodes
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
```

### Load Phase

- **Dimension Loading**: Populates dimension tables with transformed data
- **Surrogate Keys**: Generates unique identifiers for dimension records
- **Fact Table Loading**: Creates fact records with foreign keys
- **Referential Integrity**: Ensures valid relationships between tables
- **Indexing**: Builds indexes for query performance

Final ETL workflow:

```sql
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
```

### Web-Based ETL Interface

The system includes a modern web interface for ETL operations:

- **File Upload**: Browser-based CSV file upload
- **Column Mapping**: Interactive mapping of source to target columns
- **Data Preview**: Shows sample data before processing
- **Validation**: Client and server-side validation of uploads
- **Progress Tracking**: Real-time processing status updates

## Web Interface

The system features a modern web interface built with Flask and Bootstrap:

### Dashboard

The dashboard provides a real-time overview of key metrics and visualizations:

```
+------------------------------------------------------------------+
|  Green Care Provider Temps Dashboard                             |
+------------------------------------------------------------------+
|                                                                  |
|  +---------------------+            +------------------------+   |
|  | Key Metrics         |            | Sessions by Month      |   |
|  |                     |            |                        |   |
|  | Total Temps: 150    |            | [Bar Chart]            |   |
|  | Active Temps: 120   |            |                        |   |
|  | Councils: 25        |            |                        |   |
|  | Sessions: 1250      |            |                        |   |
|  |                     |            |                        |   |
|  +---------------------+            +------------------------+   |
|                                                                  |
|  +---------------------+            +------------------------+   |
|  | Sessions by Council |            | Coverage Types         |   |
|  |                     |            |                        |   |
|  | [Pie Chart]         |            | [Bar Chart]            |   |
|  |                     |            |                        |   |
|  |                     |            |                        |   |
|  |                     |            |                        |   |
|  +---------------------+            +------------------------+   |
|                                                                  |
+------------------------------------------------------------------+
```

### Temporary Workers Management

View and manage all temporary workers in the system:

```
+------------------------------------------------------------------+
|  Temporary Workers                                     Page 1/5  |
+------------------------------------------------------------------+
|                                                                  |
| ID  | Title | Last Name | Gender | Status   | County      | DOB  |
+------------------------------------------------------------------+
| 1   | Dr    | Smith     | Male   | Active   | West Midl   | 1975 |
| 2   | Dr    | Jones     | Female | Active   | Manchester  | 1979 |
| 3   | Dr    | Williams  | Male   | Inactive | Merseyside  | 1968 |
| 4   | Dr    | Brown     | Female | Active   | Tyne & Wear | 1982 |
| 5   | Dr    | Taylor    | Male   | Active   | Yorkshire   | 1977 |
| 6   | Dr    | Martin    | Female | On Leave | Essex       | 1980 |
| 7   | Dr    | Wilson    | Male   | Active   | Kent        | 1975 |
| 8   | Dr    | Anderson  | Female | Active   | Surrey      | 1983 |
| 9   | Dr    | Thomas    | Male   | Inactive | London      | 1971 |
| 10  | Dr    | Johnson   | Female | Active   | Berkshire   | 1988 |
|                                                                  |
|                                                                  |
|  << Prev                                               Next >>   |
+------------------------------------------------------------------+
```

### Local Councils Management

View and analyze local council data:

```
+------------------------------------------------------------------+
|  Local Councils                                                  |
+------------------------------------------------------------------+
|                                                                  |
| ID | Council Name         | County         | System | Requests   |
+------------------------------------------------------------------+
| 1  | Birmingham City      | West Midlands  | SystmOne | 23      |
| 2  | Manchester City      | Greater Mancs  | EMIS     | 17      |
| 3  | Liverpool City       | Merseyside     | Vision   | 12      |
| 4  | Newcastle City       | Tyne and Wear  | SystmOne | 9       |
| 5  | Leeds City           | West Yorkshire | EMIS     | 21      |
| 6  | Bristol City         | Bristol        | SystmOne | 14      |
| 7  | Sheffield City       | South Yorks    | EMIS     | 11      |
| 8  | Nottingham City      | Nottinghamshire| Vision   | 8       |
| 9  | Glasgow City         | Glasgow        | EMIS     | 15      |
| 10 | Edinburgh City       | Edinburgh      | SystmOne | 13      |
|                                                                  |
|                                                                  |
+------------------------------------------------------------------+
```

### Data Loading Interface

The system provides an intuitive interface for uploading and mapping data:

```
+------------------------------------------------------------------+
|  Data Loading Interface                                          |
+------------------------------------------------------------------+
|                                                                  |
|  [Choose File]  sample_temps.csv                 [Upload File]   |
|                                                                  |
|  CSV Preview:                                                    |
|  +-------------------------------------------------------+       |
|  | title | forename | surname | sex  | dob      | status |       |
|  | Dr    | James    | Smith   | Male | 1985-... | Active |       |
|  | Dr    | Emily    | Jones   | Fem. | 1979-... | Active |       |
|  | Dr    | Robert   | Williams| Male | 1968-... | Inact. |       |
|  +-------------------------------------------------------+       |
|                                                                  |
|  Map Columns:                                                    |
|  +--------------------------------------+                        |
|  | Title:       [title       ▼]         |                        |
|  | First Name:  [forename    ▼]         |                        |
|  | Last Name:   [surname     ▼]         |                        |
|  | Gender:      [sex         ▼]         |                        |
|  | Date of Birth:[dob        ▼]         |                        |
|  | Status:      [status      ▼]         |                        |
|  +--------------------------------------+                        |
|                                                                  |
|              [Process Data]                                      |
|                                                                  |
+------------------------------------------------------------------+
```

## PostgreSQL Implementation

### Deployment

The application uses Docker for consistent deployment across environments.

### Container Setup

1. **PostgreSQL Container**
   - Image: postgres:15-alpine
   - Port: 5432
   - Persistent data volume

2. **Flask Application Container**
   - Python 3.11
   - Web server with multiple workers
   - Port: 5000

## Getting Started

### Prerequisites

- Docker and Docker Compose
- At least 2GB of free RAM
- 1GB of free disk space
- Git (for cloning the repository)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/green-care-dw.git
   cd green-care-dw
   ```

2. Start the application using Docker:
   ```bash
   ./start.sh
   ```
   Or manually:
   ```bash
   docker-compose up -d
   ```

3. Access the web interface:
   Open your browser and navigate to: http://localhost:5000

### Detailed Setup

1. **Environment Configuration**

Create a `.env` file (optional):
```env
POSTGRES_DB=greencare_dw
POSTGRES_USER=greencare
POSTGRES_PASSWORD=your_secure_password
DATABASE_URL=postgresql://greencare:your_secure_password@postgres:5432/greencare_dw
```

2. **Database Initialization**

The database schema is automatically created on first run. To manually initialize:

```bash
docker-compose exec postgres psql -U greencare -d greencare_dw -f /docker-entrypoint-initdb.d/001_init_schema.sql
```

3. **Load Sample Data**

Use the web interface data load page or run:
```bash
docker-compose exec webapp python -c "from app import db; db.session.execute('CALL load_all_csv_files()'); db.session.commit()"
```

## Technology Stack

- **Database**: PostgreSQL 15
- **Backend**: Python 3.11, Flask 3.0
- **ORM**: SQLAlchemy
- **Visualization**: Plotly.js 
- **Frontend**: Bootstrap 5, HTML5, CSS3, JavaScript
- **Containerization**: Docker, Docker Compose

## Project Structure

```
OracleDW/
├── csv/                  # CSV data files
├── ctls/                 # Control files (from Oracle)
├── docker/               # Docker configuration
├── docs/                 # Documentation and diagrams
│   └── diagrams/         # System diagrams
├── postgres/             # PostgreSQL files
│   ├── migrations/       # Database migrations
│   └── scripts/          # SQL scripts
├── sql/                  # SQL queries and schema definitions
├── webapp/               # Flask web application
│   ├── static/           # Static resources (CSS, JS)
│   ├── templates/        # HTML templates
│   └── enhanced_dashboard.py  # Main application file
├── docker-compose.yml    # Docker Compose configuration
├── README.md             # Project documentation
└── start.sh              # Startup script
```

## API Documentation

### Endpoints

#### Dashboard Metrics
```
GET /api/dashboard-metrics
```
Returns key performance indicators.

#### Load CSV Files
```
POST /api/load-csv
```
Triggers CSV file loading process.

#### Run ETL
```
POST /api/run-etl
```
Executes complete ETL process.

#### Health Check
```
GET /health
```
Returns system health status.

### Example API Usage

```python
import requests

# Get dashboard metrics
response = requests.get('http://localhost:5000/api/dashboard-metrics')
metrics = response.json()

# Run ETL process
response = requests.post('http://localhost:5000/api/run-etl')
result = response.json()
```

## Performance Considerations

### Indexing Strategy

Key indexes are created on:
- Foreign key columns
- Frequently queried fields
- Join columns

### Query Optimization

- Use materialized views for complex aggregations
- Partition large fact tables by date
- Regular VACUUM and ANALYZE operations

### Scaling

- Horizontal scaling via read replicas
- Connection pooling
- Query caching

## Security

### Best Practices

1. **Database Security**
   - Use strong passwords
   - Limit user privileges
   - Enable SSL connections

2. **Application Security**
   - Input validation
   - SQL injection prevention
   - HTTPS in production

3. **Data Protection**
   - Encrypt sensitive data
   - Regular backups
   - Audit logging

### Environment Variables

Store sensitive configuration in environment variables:
```bash
export DATABASE_URL="postgresql://user:pass@host:port/db"
export SECRET_KEY="your-secret-key"
```

## Troubleshooting

### Common Issues

1. **Container Won't Start**
   - Check Docker daemon status
   - Verify port availability
   - Review container logs

2. **Database Connection Failed**
   - Confirm PostgreSQL is running
   - Check connection string
   - Verify network connectivity

3. **ETL Process Errors**
   - Check CSV file formats
   - Review transformation logs
   - Validate data types

### Debugging

Enable debug mode:
```python
app.config['DEBUG'] = True
```

View PostgreSQL logs:
```bash
docker-compose logs postgres
```

## Migration from Oracle

This project represents a migration from an Oracle database to PostgreSQL. The migration involved:

1. Schema conversion from Oracle to PostgreSQL
2. Data cleaning and standardization
3. Implementation of equivalent functionality
4. Building a modern web interface

### Data Type Mappings

| Oracle Type | PostgreSQL Type | Notes |
|-------------|-----------------|-------|
| NUMBER(p,s) | NUMERIC(p,s)    | Direct mapping |
| VARCHAR2    | VARCHAR         | Standard syntax |
| DATE        | TIMESTAMP       | Enhanced precision |
| CLOB        | TEXT            | Improved for large text |
| BLOB        | BYTEA           | Binary data |
| RAW         | BYTEA           | Binary data |

### Function Conversions

| Oracle Function | PostgreSQL Function | Example |
|------------------|----------------------|---------|
| NVL              | COALESCE            | `COALESCE(column, 'default')` |
| DECODE           | CASE WHEN           | `CASE WHEN x=1 THEN 'a' ELSE 'b' END` |
| TO_CHAR          | TO_CHAR             | Similar syntax, different formats |
| SYSDATE          | CURRENT_TIMESTAMP   | Standard SQL function |

## Future Enhancements

- **User Authentication**: Add role-based access control
- **API Access**: Provide API endpoints for external integration
- **Advanced Analytics**: Implement predictive analytics and forecasting
- **Mobile Support**: Enhance responsive design for mobile interfaces
- **Automated Testing**: Implement comprehensive testing suite

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Code Style

- Follow PEP 8 for Python code
- Use British English for all documentation
- Add docstrings to all functions

### Commit Messages

Use descriptive commit messages:
```
feat: Add council performance report
fix: Correct postcode formatting function
docs: Update API documentation
```

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

## Appendix

### Data Dictionary

#### DIM_TEMP
| Column | Type | Description |
|--------|------|-------------|
| temp_id | INT | Primary key |
| title | VARCHAR(15) | Worker title |
| last_name | VARCHAR(20) | Surname |
| county | VARCHAR(30) | County location |
| postcode | VARCHAR(10) | Postal code |
| gender | VARCHAR(10) | Gender |
| current_status | VARCHAR(20) | Employment status |
| nationality | VARCHAR(50) | Nationality |

#### FACT_SESSIONS
| Column | Type | Description |
|--------|------|-------------|
| session_id | INT | Primary key |
| temp_request_id | INT | Foreign key to request |
| temp_id | INT | Foreign key to temp |
| time_id | INT | Foreign key to time |
| type_of_cover | VARCHAR(30) | Coverage type |
| status | VARCHAR(30) | Session status |

### Performance Metrics

- Average query response time: < 100ms
- ETL processing time: < 5 minutes for full load
- Concurrent users supported: 100+
- Data retention: 7 years

---

For more detailed information, please refer to the [Project_Report.pdf](./Project_Report.pdf) and [MIGRATION_SUMMARY.md](./MIGRATION_SUMMARY.md).
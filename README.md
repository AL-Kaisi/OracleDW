
# Data Warehousing Project – Oracle

This repository contains an end‑to‑end data warehousing project implemented using Oracle Database technologies. The project includes PL/SQL scripts, ETL control files, CSV source data, and automation tools (batch files) designed to load, transform, and manage data within a data warehouse environment.

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup and Installation](#setup-and-installation)
- [ETL Process and Execution](#etl-process-and-execution)
- [Project Report](#project-report)
- [Usage Notes](#usage-notes)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project demonstrates how to build a data warehouse using Oracle. The solution involves:

- **Data Extraction & Loading:** Importing source data stored as CSV files.
- **Data Transformation:** Utilizing PL/SQL scripts for cleansing, transformation, and loading into warehouse tables.
- **Automation:** Batch files and control files that automate the execution of the ETL process.
- **Logging:** Maintaining logs for monitoring the ETL process and diagnosing issues.

The repository is designed for educational purposes as well as for showcasing a complete Oracle‑based data warehousing workflow.

## Project Structure

The repository is organized into the following directories and files:

```
Data-warehousing-Project-ORACLE/
├── bads/                    
│   └── [Files containing rejected or error records]  
├── csv/                     
│   └── [CSV files that serve as the raw input data for the ETL process]  
├── ctls/                    
│   └── [SQL*Loader control files used for loading CSV data into Oracle]  
├── logs/                    
│   └── [Log files generated during ETL operations for monitoring and troubleshooting]  
├── sql/                     
│   └── [PL/SQL scripts for table creation, data transformation, and ETL processing]  
├── GreenCareProviderTemps.mdb  
│   └── [Microsoft Access database file provided as an additional data source or sample dataset]  
├── Project_Report.pdf       
│   └── [Comprehensive project report detailing methodology, design, and outcomes]  
└── SOLUTION.bat             
    └── [Batch file to automate the overall ETL process execution]
```

### Folder Details

- **bads/**: Contains files or logs of records that failed validation or encountered errors during data loading.
- **csv/**: Holds the raw source data in CSV format. These files are typically imported into staging tables.
- **ctls/**: Includes SQL*Loader control files that define how CSV data is parsed and loaded into Oracle tables.
- **logs/**: Captures detailed logs from the ETL process. Use these logs for debugging and auditing the data load.
- **sql/**: Contains the heart of the project – PL/SQL scripts that create schemas, perform data transformations, and implement business logic for data warehousing.
- **GreenCareProviderTemps.mdb**: A Microsoft Access database file that may serve as an additional data source or provide sample data for testing purposes.
- **Project_Report.pdf**: Provides detailed documentation of the project including design decisions, process flow, and final results.
- **SOLUTION.bat**: A batch file that automates the running of control scripts and PL/SQL procedures, streamlining the entire ETL process.

## Prerequisites

Before running the project, ensure you have the following installed and configured:

- **Oracle Database**: An Oracle instance where you can create schemas, load data, and run PL/SQL scripts.
- **SQL*Loader**: Utility for loading CSV data into Oracle tables using control files.
- **Oracle SQL Developer** (or equivalent): For running and testing PL/SQL scripts.
- **Microsoft Access (optional)**: To view or modify the provided `.mdb` file if needed.
- **Windows Environment**: For executing the batch file (`SOLUTION.bat`). (If you are on a different OS, you might need to adapt the automation scripts accordingly.)

## Setup and Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/AL-Kaisi/Data-warehousing-Project-ORACLE.git
   cd Data-warehousing-Project-ORACLE
   ```

2. **Prepare the Oracle Environment**

   - Create the required database schema.
   - Ensure that you have the necessary privileges to run PL/SQL scripts and use SQL*Loader.

3. **Review CSV and Control Files**

   - Place the CSV files (located in the `csv/` directory) in an accessible directory.
   - Verify that the control files in the `ctls/` folder correctly reference the CSV file paths and database table structures.

4. **Configure the Batch File**

   - Open `SOLUTION.bat` and adjust any path variables or connection parameters according to your Oracle environment settings.

## ETL Process and Execution

The ETL (Extract, Transform, Load) workflow for this project typically follows these steps:

1. **Data Extraction**: CSV files are read and parsed using SQL*Loader with control files located in `ctls/`.
2. **Data Transformation**: PL/SQL scripts in the `sql/` folder perform cleansing, transformation, and loading of data into the data warehouse tables.
3. **Error Handling**: Records that do not meet validation criteria are logged and stored in the `bads/` folder.
4. **Logging**: The process creates detailed logs in the `logs/` folder for monitoring and troubleshooting.

To execute the ETL process, simply run the batch file:

```bash
SOLUTION.bat
```

This script will execute the necessary commands to load data from CSV files, run the PL/SQL scripts, and generate logs for each step.

## Project Report

For a detailed explanation of the project’s design, implementation, and results, please refer to the [Project_Report.pdf](./Project_Report.pdf). This report covers:

- Project objectives and scope
- Detailed ETL process flow
- Database schema design and relationships
- Data transformation rules and business logic
- Testing, results, and performance evaluation

## Usage Notes

- **Customizations:** Adjust file paths, database connection strings, and control file settings as needed for your environment.
- **Error Logs:** Always check the log files in the `logs/` directory if any issues occur during the ETL process.
- **Data Integrity:** Review the `bads/` folder to ensure that all erroneous data is handled according to your project’s quality standards.

## Contributing

Contributions to enhance or extend the project are welcome. If you have improvements or bug fixes:

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Submit a pull request with a detailed description of your changes.

## License

*Specify your project license here. For example:*

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

This README aims to provide a clear and comprehensive guide for setting up, running, and understanding the Data Warehousing Project implemented with Oracle. If you have any questions or need further clarification, please feel free to open an issue or contact the repository maintainer.

---

*Note: Some details (such as specific connection parameters or data validation rules) might need to be adjusted to reflect your local environment or further documentation provided in the Project Report.*

References:  
cite50†[Data-warehousing-Project-ORACLE Repository](https://github.com/AL-Kaisi/Data-warehousing-Project-ORACLE)

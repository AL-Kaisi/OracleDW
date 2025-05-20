from flask import Flask, render_template_string

app = Flask(__name__)

# Simple HTML template
HOME_TEMPLATE = '''
<!DOCTYPE html>
<html lang="en-GB">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Green Care Provider Temps</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
        }
        .section {
            margin: 20px 0;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        .card {
            background-color: white;
            padding: 15px;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        .card h3 {
            color: #495057;
            margin-top: 0;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 10px;
        }
        .button:hover {
            background-color: #0056b3;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
        }
        .alert-info {
            color: #0c5460;
            background-color: #d1ecf1;
            border-color: #bee5eb;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Green Care Provider Temps Data Warehouse</h1>
        
        <div class="alert alert-info">
            Welcome to the Green Care data warehouse system. This application has been converted from Oracle to PostgreSQL.
        </div>
        
        <div class="section">
            <h2>System Overview</h2>
            <p>This data warehouse consolidates information about temporary care workers, local councils, and work sessions. It provides comprehensive tracking and analytics for temporary worker placements.</p>
        </div>
        
        <div class="grid">
            <div class="card">
                <h3>Dashboard</h3>
                <p>View key metrics and visualisations of the data warehouse.</p>
                <a href="#" class="button">View Dashboard</a>
            </div>
            
            <div class="card">
                <h3>Manage Temps</h3>
                <p>Browse and manage temporary workers in the system.</p>
                <a href="#" class="button">Manage Temps</a>
            </div>
            
            <div class="card">
                <h3>Local Councils</h3>
                <p>View and manage local council information.</p>
                <a href="#" class="button">View Councils</a>
            </div>
            
            <div class="card">
                <h3>Sessions</h3>
                <p>Track and manage work sessions.</p>
                <a href="#" class="button">View Sessions</a>
            </div>
            
            <div class="card">
                <h3>Reports</h3>
                <p>Generate reports and analytics.</p>
                <a href="#" class="button">View Reports</a>
            </div>
            
            <div class="card">
                <h3>Data Management</h3>
                <p>Load data and run ETL processes.</p>
                <a href="#" class="button">Manage Data</a>
            </div>
        </div>
        
        <div class="section">
            <h2>Features</h2>
            <ul>
                <li>Comprehensive tracking of temporary worker placements</li>
                <li>Council request management and fulfilment tracking</li>
                <li>Performance analytics and reporting</li>
                <li>ETL processes for data integration</li>
                <li>Dimensional modelling for efficient analysis</li>
                <li>PostgreSQL database backend (migrated from Oracle)</li>
                <li>Modern web interface using Flask</li>
            </ul>
        </div>
        
        <div class="section">
            <h2>Technical Information</h2>
            <p><strong>Database:</strong> PostgreSQL (converted from Oracle)</p>
            <p><strong>Web Framework:</strong> Flask</p>
            <p><strong>Architecture:</strong> Star schema data warehouse</p>
            <p><strong>Deployment:</strong> Docker containers</p>
        </div>
    </div>
</body>
</html>
'''

@app.route('/')
def index():
    return render_template_string(HOME_TEMPLATE)

if __name__ == '__main__':
    print("Starting Green Care Provider Temps Demo...")
    print("Access the application at: http://localhost:5000")
    app.run(debug=True, host='0.0.0.0', port=5000)
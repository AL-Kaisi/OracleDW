from flask import Flask, jsonify
import json

app = Flask(__name__)

@app.route('/')
def index():
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>Green Care Provider Temps</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; }
            .container { max-width: 800px; margin: 0 auto; }
            h1 { color: #2c3e50; }
            .status { 
                background-color: #d4edda; 
                border: 1px solid #c3e6cb; 
                padding: 15px; 
                border-radius: 4px;
                color: #155724;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Green Care Provider Temps Data Warehouse</h1>
            <div class="status">
                <p><strong>Application Status:</strong> Running</p>
                <p><strong>Database:</strong> PostgreSQL (Port 5433)</p>
                <p><strong>Environment:</strong> Development</p>
            </div>
            <h2>Available Endpoints</h2>
            <ul>
                <li><a href="/api/status">/api/status</a> - Check system status</li>
                <li><a href="/api/metrics">/api/metrics</a> - View sample metrics</li>
            </ul>
        </div>
    </body>
    </html>
    '''

@app.route('/api/status')
def status():
    return jsonify({
        'status': 'healthy',
        'database': 'postgresql',
        'version': '1.0.0'
    })

@app.route('/api/metrics')
def metrics():
    return jsonify({
        'total_temps': 150,
        'total_councils': 25,
        'total_sessions': 1250,
        'active_requests': 12
    })

if __name__ == '__main__':
    print("Starting Green Care Provider Temps Application...")
    print("Access at: http://localhost:5001")
    app.run(port=5001, debug=False)
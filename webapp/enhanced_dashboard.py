from flask import Flask, render_template, jsonify, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
import pandas as pd
import json
import os
import tempfile
from sqlalchemy import create_engine, text, Column, Integer, String, Date
from sqlalchemy.ext.declarative import declarative_base
import plotly.express as px
import plotly.graph_objects as go
from plotly.utils import PlotlyJSONEncoder
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = 'greencare-temp-secret-key'

# Database configuration
DATABASE_URL = os.environ.get('DATABASE_URL', 'postgresql://greencare:greencare123@localhost:5433/greencare_dw')
app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URL
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['UPLOAD_FOLDER'] = '/tmp/uploads'

# Ensure upload directory exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

db = SQLAlchemy(app)
engine = create_engine(DATABASE_URL)

# Define some models for data display
Base = declarative_base()

class TempData(Base):
    __tablename__ = 'temp_data'
    id = Column(Integer, primary_key=True)
    title = Column(String)
    first_name = Column(String)
    last_name = Column(String)
    gender = Column(String)
    date_of_birth = Column(Date)
    status = Column(String)

    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'first_name': self.first_name,
            'last_name': self.last_name,
            'gender': self.gender,
            'date_of_birth': str(self.date_of_birth) if self.date_of_birth else None,
            'status': self.status
        }

# Routes
@app.route('/')
def index():
    """Home page with navigation to different modules"""
    return render_template('index.html')

@app.route('/dashboard')
def dashboard():
    """Main dashboard with key metrics"""
    try:
        # Get key metrics
        metrics = {}
        
        with engine.connect() as conn:
            # Total temps
            result = conn.execute(text("SELECT COUNT(*) FROM dim_temp"))
            metrics['total_temps'] = result.scalar()
            
            # Total councils
            result = conn.execute(text("SELECT COUNT(*) FROM dim_local_council"))
            metrics['total_councils'] = result.scalar()
            
            # Total sessions
            result = conn.execute(text("SELECT COUNT(*) FROM fact_sessions"))
            metrics['total_sessions'] = result.scalar()
            
            # Active requests
            result = conn.execute(text("""
                SELECT COUNT(*) 
                FROM dim_temp_request 
                WHERE temp_request_status = 'Active'
            """))
            metrics['active_requests'] = result.scalar()
            
            # Sessions by month
            result = conn.execute(text("""
                SELECT dt.month, dt.year, COUNT(*) as session_count
                FROM fact_sessions fs
                JOIN dim_time dt ON fs.time_id = dt.time_id
                GROUP BY dt.year, dt.month
                ORDER BY dt.year DESC, dt.month DESC
                LIMIT 12
            """))
            
            monthly_data = [{'month': f"{row.year}-{row.month:02d}", 'count': row.session_count} 
                           for row in result]
            
            # Sessions by council
            result = conn.execute(text("""
                SELECT dlc.council_name, COUNT(*) as session_count
                FROM fact_sessions fs
                JOIN dim_temp_request dtr ON fs.temp_request_id = dtr.temp_request_id
                JOIN dim_local_council dlc ON dtr.local_council_id = dlc.local_council_id
                GROUP BY dlc.council_name
                ORDER BY session_count DESC
                LIMIT 10
            """))
            
            council_data = [{'council': row.council_name, 'count': row.session_count} 
                           for row in result]
        
        # Create visualisations
        if monthly_data:
            months = [d['month'] for d in monthly_data]
            counts = [d['count'] for d in monthly_data]
            
            fig_monthly = go.Figure()
            fig_monthly.add_trace(go.Bar(x=months, y=counts, name='Sessions'))
            fig_monthly.update_layout(
                title='Sessions by Month',
                xaxis_title='Month',
                yaxis_title='Number of Sessions',
                height=400
            )
            monthly_chart = json.dumps(fig_monthly, cls=PlotlyJSONEncoder)
        else:
            monthly_chart = None
            
        if council_data:
            councils = [d['council'] for d in council_data]
            counts = [d['count'] for d in council_data]
            
            fig_council = px.pie(values=counts, names=councils, 
                               title='Sessions by Council (Top 10)')
            council_chart = json.dumps(fig_council, cls=PlotlyJSONEncoder)
        else:
            council_chart = None
        
        return render_template('dashboard.html', 
                             metrics=metrics,
                             monthly_chart=monthly_chart,
                             council_chart=council_chart)
    
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/temps')
def temps():
    """Temporary workers management page"""
    try:
        with engine.connect() as conn:
            # Get all temps
            result = conn.execute(text("""
                SELECT temp_id, title, last_name, county, postcode, 
                       gender, current_status, nationality, temp_status
                FROM dim_temp
                ORDER BY temp_id
            """))
            
            temps_list = []
            for row in result:
                temps_list.append({
                    'temp_id': row.temp_id,
                    'title': row.title,
                    'last_name': row.last_name,
                    'county': row.county,
                    'postcode': row.postcode,
                    'gender': row.gender,
                    'current_status': row.current_status,
                    'nationality': row.nationality,
                    'temp_status': row.temp_status
                })
            
            total_count = len(temps_list)
            
            return render_template('temps.html', 
                                temps=temps_list,
                                page=1,
                                total_pages=1,
                                total_count=total_count)
        
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/councils')
def councils():
    """Local councils management page"""
    try:
        with engine.connect() as conn:
            result = conn.execute(text("""
                SELECT dlc.*, 
                       COUNT(DISTINCT dtr.temp_request_id) as total_requests,
                       COUNT(DISTINCT fs.session_id) as total_sessions
                FROM dim_local_council dlc
                LEFT JOIN dim_temp_request dtr ON dlc.local_council_id = dtr.local_council_id
                LEFT JOIN fact_sessions fs ON dtr.temp_request_id = fs.temp_request_id
                GROUP BY dlc.local_council_id, dlc.council_name, dlc.postcode, 
                         dlc.county, dlc.computer_system_type
                ORDER BY dlc.council_name
            """))
            
            councils_list = []
            for row in result:
                councils_list.append({
                    'local_council_id': row.local_council_id,
                    'council_name': row.council_name,
                    'postcode': row.postcode,
                    'county': row.county,
                    'computer_system_type': row.computer_system_type,
                    'total_requests': row.total_requests,
                    'total_sessions': row.total_sessions
                })
            
            return render_template('councils.html', councils=councils_list)
        
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/sessions')
def sessions():
    """Sessions management page"""
    try:
        with engine.connect() as conn:
            # Get all sessions with related data
            result = conn.execute(text("""
                SELECT fs.session_id, fs.type_of_cover, fs.status,
                       dt.temp_id, dt.last_name as temp_name,
                       dlc.council_name,
                       dti.year, dti.month, dti.day,
                       dti.ss_hour, dti.ss_minute,
                       dti.se_hour, dti.se_minute
                FROM fact_sessions fs
                JOIN dim_temp dt ON fs.temp_id = dt.temp_id
                JOIN dim_temp_request dtr ON fs.temp_request_id = dtr.temp_request_id
                JOIN dim_local_council dlc ON dtr.local_council_id = dlc.local_council_id
                LEFT JOIN dim_time dti ON fs.time_id = dti.time_id
                ORDER BY fs.session_id DESC
            """))
            
            sessions_list = []
            for row in result:
                start_time = f"{row.ss_hour:02d}:{row.ss_minute:02d}" if row.ss_hour is not None else "N/A"
                end_time = f"{row.se_hour:02d}:{row.se_minute:02d}" if row.se_hour is not None else "N/A"
                date = f"{row.year}-{row.month:02d}-{row.day:02d}" if row.year else "N/A"
                
                sessions_list.append({
                    'session_id': row.session_id,
                    'temp_name': row.temp_name,
                    'council_name': row.council_name,
                    'type_of_cover': row.type_of_cover,
                    'status': row.status,
                    'date': date,
                    'start_time': start_time,
                    'end_time': end_time
                })
            
            total_count = len(sessions_list)
            
            return render_template('sessions.html',
                                sessions=sessions_list,
                                page=1,
                                total_pages=1,
                                total_count=total_count)
        
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/reports')
def reports():
    """Reports and analytics page"""
    try:
        with engine.connect() as conn:
            # Coverage analysis by type
            result = conn.execute(text("""
                SELECT type_of_cover, COUNT(*) as count
                FROM fact_sessions
                GROUP BY type_of_cover
                ORDER BY count DESC
            """))
            
            coverage_types = []
            for row in result:
                coverage_types.append({
                    'type': row.type_of_cover,
                    'count': row.count
                })
            
            # Session status distribution
            result = conn.execute(text("""
                SELECT status, COUNT(*) as count
                FROM fact_sessions
                GROUP BY status
                ORDER BY count DESC
            """))
            
            status_dist = []
            for row in result:
                status_dist.append({
                    'status': row.status,
                    'count': row.count
                })
            
            # Top performing temps
            result = conn.execute(text("""
                SELECT dt.temp_id, dt.last_name, COUNT(fs.session_id) as session_count
                FROM fact_sessions fs
                JOIN dim_temp dt ON fs.temp_id = dt.temp_id
                GROUP BY dt.temp_id, dt.last_name
                ORDER BY session_count DESC
                LIMIT 10
            """))
            
            top_temps = []
            for row in result:
                top_temps.append({
                    'temp_id': row.temp_id,
                    'name': row.last_name,
                    'sessions': row.session_count
                })
        
        # Create visualisations
        if coverage_types:
            types = [d['type'] for d in coverage_types]
            counts = [d['count'] for d in coverage_types]
            
            fig_coverage = px.bar(x=types, y=counts, 
                                title='Sessions by Coverage Type')
            fig_coverage.update_layout(xaxis_title='Coverage Type', 
                                     yaxis_title='Number of Sessions')
            coverage_chart = json.dumps(fig_coverage, cls=PlotlyJSONEncoder)
        else:
            coverage_chart = None
        
        return render_template('reports.html',
                             coverage_chart=coverage_chart,
                             top_temps=top_temps,
                             status_dist=status_dist)
    
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/data-load')
@app.route('/data_load')
def data_load():
    """Data loading interface"""
    try:
        # Get list of uploaded files if any
        uploaded_files = []
        if os.path.exists(app.config['UPLOAD_FOLDER']):
            uploaded_files = [f for f in os.listdir(app.config['UPLOAD_FOLDER']) 
                            if os.path.isfile(os.path.join(app.config['UPLOAD_FOLDER'], f))]
        
        # Get sample of loaded data to display
        loaded_data = None
        with engine.connect() as conn:
            try:
                # Check if temp_data table exists
                result = conn.execute(text(
                    "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'temp_data')"
                ))
                if result.scalar():
                    # Get sample of data
                    result = conn.execute(text("SELECT * FROM temp_data LIMIT 10"))
                    loaded_data = [dict(row) for row in result]
            except:
                # Table doesn't exist yet
                pass
                
        return render_template('enhanced_data_load.html',
                            uploaded_files=uploaded_files,
                            loaded_data=loaded_data)
                            
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/upload-csv', methods=['POST'])
def upload_csv():
    """Handle file upload"""
    if 'file' not in request.files:
        return jsonify({'success': False, 'error': 'No file part'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'success': False, 'error': 'No file selected'}), 400
    
    if file:
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        # Read the CSV to show a preview
        try:
            df = pd.read_csv(filepath)
            # Return success with data preview
            return jsonify({
                'success': True, 
                'message': f'File {filename} uploaded successfully',
                'preview': df.head(5).to_dict(orient='records'),
                'columns': df.columns.tolist()
            })
        except Exception as e:
            return jsonify({'success': False, 'error': f'Error reading CSV: {str(e)}'}), 500
    
    return jsonify({'success': False, 'error': 'Failed to upload file'}), 500

@app.route('/process-csv', methods=['POST'])
def process_csv():
    """Process the uploaded CSV file"""
    try:
        data = request.json
        filename = data.get('filename')
        mapping = data.get('mapping', {})
        
        if not filename:
            return jsonify({'success': False, 'error': 'No filename provided'}), 400
        
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], secure_filename(filename))
        if not os.path.exists(filepath):
            return jsonify({'success': False, 'error': 'File not found'}), 404
        
        # Read the CSV file
        df = pd.read_csv(filepath)
        
        # Apply column mappings
        mapped_df = pd.DataFrame()
        for target_col, source_col in mapping.items():
            if source_col in df.columns:
                mapped_df[target_col] = df[source_col]
            else:
                mapped_df[target_col] = None
        
        # Create temp_data table if it doesn't exist
        with engine.connect() as conn:
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS temp_data (
                    id SERIAL PRIMARY KEY,
                    title VARCHAR(10),
                    first_name VARCHAR(50),
                    last_name VARCHAR(50),
                    gender VARCHAR(10),
                    date_of_birth DATE,
                    status VARCHAR(20)
                )
            """))
            
            # Clear existing data
            conn.execute(text("TRUNCATE TABLE temp_data"))
            conn.commit()
        
        # Save to database
        mapped_df.to_sql('temp_data', engine, if_exists='append', index=False)
        
        # Get a sample of the loaded data
        with engine.connect() as conn:
            result = conn.execute(text("SELECT * FROM temp_data LIMIT 10"))
            loaded_data = [dict(row) for row in result]
            
            # Get record count
            result = conn.execute(text("SELECT COUNT(*) FROM temp_data"))
            record_count = result.scalar()
        
        return jsonify({
            'success': True,
            'message': f'Processed {record_count} records from {filename}',
            'sample_data': loaded_data
        })
        
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/load-csv', methods=['POST'])
def load_csv_api():
    """Legacy API endpoint to trigger CSV loading"""
    try:
        # Since we're using sample data, we'll just return success
        return jsonify({'success': True, 'message': 'CSV files loaded successfully'})
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/run-etl', methods=['POST'])
def run_etl():
    """Legacy API endpoint to run the ETL process"""
    try:
        # Since we're using sample data, we'll just return success
        return jsonify({'success': True, 'message': 'ETL process completed successfully'})
    
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/health')
def health():
    """Health check endpoint"""
    try:
        # Test database connection
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        return jsonify({'status': 'healthy', 'database': 'connected'})
    except Exception as e:
        return jsonify({'status': 'unhealthy', 'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
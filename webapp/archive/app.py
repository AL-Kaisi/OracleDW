from flask import Flask, render_template, jsonify, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import pandas as pd
import json
import os
from datetime import datetime
from sqlalchemy import text
import plotly.express as px
import plotly.graph_objects as go
from plotly.utils import PlotlyJSONEncoder

app = Flask(__name__)
CORS(app)

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'postgresql://greencare:greencare123@localhost:5433/greencare_dw')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

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
        
        # Total temps
        result = db.session.execute(text("SELECT COUNT(*) FROM dim_temp"))
        metrics['total_temps'] = result.scalar()
        
        # Total councils
        result = db.session.execute(text("SELECT COUNT(*) FROM dim_local_council"))
        metrics['total_councils'] = result.scalar()
        
        # Total sessions
        result = db.session.execute(text("SELECT COUNT(*) FROM fact_sessions"))
        metrics['total_sessions'] = result.scalar()
        
        # Active requests
        result = db.session.execute(text("""
            SELECT COUNT(*) 
            FROM dim_temp_request 
            WHERE temp_request_status = 'Active'
        """))
        metrics['active_requests'] = result.scalar()
        
        # Sessions by month
        result = db.session.execute(text("""
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
        result = db.session.execute(text("""
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
        # Get temps with pagination
        page = request.args.get('page', 1, type=int)
        per_page = 20
        offset = (page - 1) * per_page
        
        # Get total count
        result = db.session.execute(text("SELECT COUNT(*) FROM dim_temp"))
        total_count = result.scalar()
        
        # Get paginated data
        result = db.session.execute(text(f"""
            SELECT temp_id, title, last_name, county, postcode, 
                   gender, current_status, nationality, temp_status
            FROM dim_temp
            ORDER BY temp_id
            LIMIT {per_page} OFFSET {offset}
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
        
        total_pages = (total_count + per_page - 1) // per_page
        
        return render_template('temps.html', 
                             temps=temps_list,
                             page=page,
                             total_pages=total_pages,
                             total_count=total_count)
    
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/councils')
def councils():
    """Local councils management page"""
    try:
        result = db.session.execute(text("""
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
        page = request.args.get('page', 1, type=int)
        per_page = 20
        offset = (page - 1) * per_page
        
        # Get total count
        result = db.session.execute(text("SELECT COUNT(*) FROM fact_sessions"))
        total_count = result.scalar()
        
        # Get paginated sessions with related data
        result = db.session.execute(text(f"""
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
            LIMIT {per_page} OFFSET {offset}
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
        
        total_pages = (total_count + per_page - 1) // per_page
        
        return render_template('sessions.html',
                             sessions=sessions_list,
                             page=page,
                             total_pages=total_pages,
                             total_count=total_count)
    
    except Exception as e:
        return f"Error: {str(e)}", 500

@app.route('/reports')
def reports():
    """Reports and analytics page"""
    try:
        # Generate various reports
        reports_data = {}
        
        # Coverage analysis by type
        result = db.session.execute(text("""
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
        result = db.session.execute(text("""
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
        result = db.session.execute(text("""
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
def data_load():
    """Data loading interface"""
    return render_template('data_load.html')

@app.route('/api/load-csv', methods=['POST'])
def load_csv():
    """API endpoint to trigger CSV loading"""
    try:
        # Execute the CSV loading procedure
        db.session.execute(text("CALL load_all_csv_files()"))
        db.session.commit()
        
        return jsonify({'success': True, 'message': 'CSV files loaded successfully'})
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/run-etl', methods=['POST'])
def run_etl():
    """API endpoint to run the complete ETL process"""
    try:
        # Execute the ETL process
        db.session.execute(text("CALL run_etl_process()"))
        db.session.commit()
        
        return jsonify({'success': True, 'message': 'ETL process completed successfully'})
    
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/dashboard-metrics')
def api_dashboard_metrics():
    """API endpoint for dashboard metrics"""
    try:
        metrics = {}
        
        # Get all key metrics
        queries = {
            'total_temps': "SELECT COUNT(*) FROM dim_temp",
            'total_councils': "SELECT COUNT(*) FROM dim_local_council",
            'total_sessions': "SELECT COUNT(*) FROM fact_sessions",
            'active_requests': """
                SELECT COUNT(*) 
                FROM dim_temp_request 
                WHERE temp_request_status = 'Active'
            """,
            'total_requests': "SELECT COUNT(*) FROM dim_temp_request"
        }
        
        for key, query in queries.items():
            result = db.session.execute(text(query))
            metrics[key] = result.scalar()
        
        return jsonify(metrics)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health():
    """Health check endpoint"""
    try:
        # Test database connection
        db.session.execute(text("SELECT 1"))
        return jsonify({'status': 'healthy', 'database': 'connected'})
    except Exception as e:
        return jsonify({'status': 'unhealthy', 'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
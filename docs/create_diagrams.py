import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import Rectangle, FancyBboxPatch

# Set style
plt.style.use('default')

def create_architecture_diagram():
    """Create system architecture diagram"""
    fig, ax = plt.subplots(1, 1, figsize=(12, 8))
    ax.set_xlim(0, 10)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    # Title
    ax.text(5, 7.5, 'Green Care Provider Temps - System Architecture', 
            fontsize=20, fontweight='bold', ha='center')
    
    # CSV Files
    csv_box = FancyBboxPatch((0.5, 5.5), 2, 1.5, 
                            boxstyle="round,pad=0.1", 
                            facecolor='lightblue', edgecolor='black')
    ax.add_patch(csv_box)
    ax.text(1.5, 6.25, 'CSV Files\n(Source Data)', ha='center', va='center', fontweight='bold')
    
    # PostgreSQL Database
    db_box = FancyBboxPatch((4, 5.5), 2, 1.5,
                           boxstyle="round,pad=0.1",
                           facecolor='lightgreen', edgecolor='black')
    ax.add_patch(db_box)
    ax.text(5, 6.25, 'PostgreSQL\nDatabase', ha='center', va='center', fontweight='bold')
    
    # Web Application
    web_box = FancyBboxPatch((7.5, 5.5), 2, 1.5,
                            boxstyle="round,pad=0.1",
                            facecolor='lightyellow', edgecolor='black')
    ax.add_patch(web_box)
    ax.text(8.5, 6.25, 'Flask Web\nApplication', ha='center', va='center', fontweight='bold')
    
    # ETL Process
    etl_box = FancyBboxPatch((3.5, 3.5), 3, 1,
                            boxstyle="round,pad=0.1",
                            facecolor='lightcoral', edgecolor='black')
    ax.add_patch(etl_box)
    ax.text(5, 4, 'ETL Process\n(Extract, Transform, Load)', ha='center', va='center', fontweight='bold')
    
    # Data Warehouse
    dw_box = FancyBboxPatch((3.5, 1.5), 3, 1,
                           boxstyle="round,pad=0.1",
                           facecolor='lavender', edgecolor='black')
    ax.add_patch(dw_box)
    ax.text(5, 2, 'Data Warehouse\n(Star Schema)', ha='center', va='center', fontweight='bold')
    
    # Arrows
    ax.arrow(2.5, 6.25, 1.2, 0, head_width=0.1, head_length=0.1, fc='black', ec='black')
    ax.arrow(6, 6.25, 1.2, 0, head_width=0.1, head_length=0.1, fc='black', ec='black')
    ax.arrow(5, 5.5, 0, -0.8, head_width=0.1, head_length=0.1, fc='black', ec='black')
    ax.arrow(5, 3.5, 0, -0.8, head_width=0.1, head_length=0.1, fc='black', ec='black')
    ax.arrow(5, 2.5, 0, 0.8, head_width=0.1, head_length=0.1, fc='blue', ec='blue')
    ax.arrow(6.5, 2, 2, 3.3, head_width=0.1, head_length=0.1, fc='blue', ec='blue')
    
    # Labels
    ax.text(3.2, 6.4, 'Load', ha='center', fontsize=10)
    ax.text(6.7, 6.4, 'API', ha='center', fontsize=10)
    ax.text(5.2, 4.8, 'Transform', ha='center', fontsize=10, rotation=90)
    ax.text(5.2, 2.9, 'Load', ha='center', fontsize=10, rotation=90)
    ax.text(4.8, 3.0, 'Query', ha='center', fontsize=10, rotation=90, color='blue')
    ax.text(7.5, 3.5, 'Analytics', ha='center', fontsize=10, rotation=45, color='blue')
    
    plt.tight_layout()
    plt.savefig('diagrams/architecture_diagram.png', dpi=300, bbox_inches='tight')
    plt.close()

def create_star_schema_diagram():
    """Create star schema diagram"""
    fig, ax = plt.subplots(1, 1, figsize=(14, 10))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Title
    ax.text(7, 9.5, 'Green Care Provider Temps - Star Schema', 
            fontsize=22, fontweight='bold', ha='center')
    
    # Fact table (center)
    fact_box = FancyBboxPatch((5.5, 4), 3, 2,
                             boxstyle="round,pad=0.1",
                             facecolor='gold', edgecolor='black', linewidth=2)
    ax.add_patch(fact_box)
    ax.text(7, 5.5, 'FACT_SESSIONS', ha='center', va='center', fontweight='bold', fontsize=14)
    ax.text(7, 5, 'session_id (PK)\ntemp_request_id (FK)\ntemp_id (FK)\ntime_id (FK)\ntype_of_cover\nstatus', 
            ha='center', va='center', fontsize=10)
    
    # Dimension tables
    dimensions = [
        {'name': 'DIM_TEMP', 'x': 2, 'y': 7, 
         'fields': 'temp_id (PK)\ntitle\nlast_name\ncounty\npostcode\ngender\ncurrent_status\nnationality'},
        {'name': 'DIM_LOCAL_COUNCIL', 'x': 11, 'y': 7,
         'fields': 'local_council_id (PK)\ncouncil_name\npostcode\ncounty\ncomputer_system_type'},
        {'name': 'DIM_TIME', 'x': 2, 'y': 1,
         'fields': 'time_id (PK)\nss_minute\nss_hour\nse_minute\nse_hour\nday\nweek\nmonth\nyear'},
        {'name': 'DIM_TEMP_REQUEST', 'x': 11, 'y': 1,
         'fields': 'temp_request_id (PK)\nlocal_council_id (FK)\nrequest_date\ntemp_request_status'}
    ]
    
    for dim in dimensions:
        dim_box = FancyBboxPatch((dim['x']-1.5, dim['y']-1), 3, 2,
                                boxstyle="round,pad=0.1",
                                facecolor='lightblue', edgecolor='black')
        ax.add_patch(dim_box)
        ax.text(dim['x'], dim['y']+0.5, dim['name'], ha='center', va='center', 
                fontweight='bold', fontsize=12)
        ax.text(dim['x'], dim['y']-0.2, dim['fields'], ha='center', va='center', 
                fontsize=9)
    
    # Draw relationships
    # DIM_TEMP to FACT
    ax.plot([3.5, 5.5], [7, 5.5], 'k-', linewidth=2)
    ax.plot([5.5, 5.3, 5.3], [5.5, 5.7, 5.3], 'k-', linewidth=2)
    
    # DIM_LOCAL_COUNCIL to FACT
    ax.plot([9.5, 8.5], [7, 5.5], 'k-', linewidth=2)
    ax.plot([8.5, 8.7, 8.3], [5.5, 5.7, 5.3], 'k-', linewidth=2)
    
    # DIM_TIME to FACT
    ax.plot([3.5, 5.5], [2, 4.5], 'k-', linewidth=2)
    ax.plot([5.5, 5.3, 5.3], [4.5, 4.7, 4.3], 'k-', linewidth=2)
    
    # DIM_TEMP_REQUEST to FACT
    ax.plot([9.5, 8.5], [2, 4.5], 'k-', linewidth=2)
    ax.plot([8.5, 8.7, 8.3], [4.5, 4.7, 4.3], 'k-', linewidth=2)
    
    # Add legend
    legend_elements = [
        mpatches.Patch(color='gold', label='Fact Table'),
        mpatches.Patch(color='lightblue', label='Dimension Tables')
    ]
    ax.legend(handles=legend_elements, loc='upper right')
    
    plt.tight_layout()
    plt.savefig('diagrams/star_schema_diagram.png', dpi=300, bbox_inches='tight')
    plt.close()

def create_etl_flow_diagram():
    """Create ETL flow diagram"""
    fig, ax = plt.subplots(1, 1, figsize=(14, 10))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Title
    ax.text(7, 9.5, 'ETL Process Flow', fontsize=22, fontweight='bold', ha='center')
    
    # Extract phase
    extract_title = FancyBboxPatch((0.5, 7.5), 4, 0.8,
                                  boxstyle="round,pad=0.1",
                                  facecolor='lightyellow', edgecolor='black')
    ax.add_patch(extract_title)
    ax.text(2.5, 7.9, 'EXTRACT', ha='center', va='center', fontweight='bold', fontsize=14)
    
    csv_sources = ['TEMP.csv', 'LOCAL_COUNCIL.csv', 'SESSIONS.csv', 'Other CSV files...']
    for i, csv in enumerate(csv_sources):
        csv_box = Rectangle((0.5, 6.5-i*0.7), 4, 0.6, facecolor='lightblue', edgecolor='black')
        ax.add_patch(csv_box)
        ax.text(2.5, 6.8-i*0.7, csv, ha='center', va='center')
    
    # Transform phase
    transform_title = FancyBboxPatch((5.5, 7.5), 3, 0.8,
                                    boxstyle="round,pad=0.1",
                                    facecolor='lightgreen', edgecolor='black')
    ax.add_patch(transform_title)
    ax.text(7, 7.9, 'TRANSFORM', ha='center', va='center', fontweight='bold', fontsize=14)
    
    transforms = [
        'Standardise Gender Values',
        'Format Postcodes',
        'Clean Titles',
        'Convert Status Codes',
        'Handle NULL Values',
        'Date/Time Extraction'
    ]
    
    for i, transform in enumerate(transforms):
        t_box = Rectangle((5.5, 6.5-i*0.7), 3, 0.6, facecolor='lightcoral', edgecolor='black')
        ax.add_patch(t_box)
        ax.text(7, 6.8-i*0.7, transform, ha='center', va='center', fontsize=10)
    
    # Load phase
    load_title = FancyBboxPatch((9.5, 7.5), 4, 0.8,
                               boxstyle="round,pad=0.1",
                               facecolor='lavender', edgecolor='black')
    ax.add_patch(load_title)
    ax.text(11.5, 7.9, 'LOAD', ha='center', va='center', fontweight='bold', fontsize=14)
    
    tables = ['DIM_TEMP', 'DIM_LOCAL_COUNCIL', 'DIM_TIME', 'DIM_TEMP_REQUEST', 'FACT_SESSIONS']
    for i, table in enumerate(tables):
        table_box = Rectangle((9.5, 6.5-i*0.7), 4, 0.6, facecolor='lightgray', edgecolor='black')
        ax.add_patch(table_box)
        ax.text(11.5, 6.8-i*0.7, table, ha='center', va='center', fontweight='bold')
    
    # Arrows
    ax.arrow(4.5, 5.5, 0.8, 0, head_width=0.1, head_length=0.1, fc='black', ec='black')
    ax.arrow(8.5, 5.5, 0.8, 0, head_width=0.1, head_length=0.1, fc='black', ec='black')
    
    # Process steps
    ax.text(7, 1.5, 'PostgreSQL Functions:\n• standardise_gender()\n• format_postcode()\n• standardise_title()\n• standardise_boolean()\n• standardise_status()', 
            ha='center', va='center', bbox=dict(boxstyle="round,pad=0.5", facecolor='white', edgecolor='gray'))
    
    plt.tight_layout()
    plt.savefig('diagrams/etl_flow_diagram.png', dpi=300, bbox_inches='tight')
    plt.close()

def create_deployment_diagram():
    """Create deployment diagram"""
    fig, ax = plt.subplots(1, 1, figsize=(12, 8))
    ax.set_xlim(0, 12)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    # Title
    ax.text(6, 7.5, 'Deployment Architecture', fontsize=20, fontweight='bold', ha='center')
    
    # Docker Container 1 - PostgreSQL
    pg_container = FancyBboxPatch((1, 4), 4, 2.5,
                                 boxstyle="round,pad=0.1",
                                 facecolor='lightblue', edgecolor='navy', linewidth=2)
    ax.add_patch(pg_container)
    ax.text(3, 6, 'PostgreSQL Container', ha='center', va='center', fontweight='bold', fontsize=12)
    ax.text(3, 5.5, 'postgres:15-alpine', ha='center', va='center', fontsize=10)
    ax.text(3, 5, 'Port: 5432\nVolumes:\n- ./postgres/migrations\n- ./postgres/scripts\n- ./csv', 
            ha='center', va='center', fontsize=9)
    
    # Docker Container 2 - Web App
    web_container = FancyBboxPatch((7, 4), 4, 2.5,
                                  boxstyle="round,pad=0.1",
                                  facecolor='lightgreen', edgecolor='darkgreen', linewidth=2)
    ax.add_patch(web_container)
    ax.text(9, 6, 'Flask Application', ha='center', va='center', fontweight='bold', fontsize=12)
    ax.text(9, 5.5, 'Python 3.11', ha='center', va='center', fontsize=10)
    ax.text(9, 5, 'Port: 5000\nGunicorn\n4 Workers', ha='center', va='center', fontsize=9)
    
    # Docker Network
    network_box = FancyBboxPatch((1, 2.5), 10, 0.8,
                                boxstyle="round,pad=0.1",
                                facecolor='lightyellow', edgecolor='orange')
    ax.add_patch(network_box)
    ax.text(6, 2.9, 'Docker Network', ha='center', va='center', fontweight='bold')
    
    # Host System
    host_box = FancyBboxPatch((0.5, 0.5), 11, 6.5,
                             boxstyle="round,pad=0.1",
                             facecolor='none', edgecolor='black', linestyle='--')
    ax.add_patch(host_box)
    ax.text(6, 0.8, 'Host System', ha='center', va='center', fontweight='bold')
    
    # Connection arrows
    ax.plot([5, 7], [5.25, 5.25], 'k-', linewidth=2)
    ax.text(6, 5.4, 'DB Connection', ha='center', fontsize=9)
    
    # External access
    ax.arrow(6, 7.5, 0, -1, head_width=0.1, head_length=0.1, fc='red', ec='red')
    ax.text(6.2, 7, 'HTTP', ha='left', fontsize=9, color='red')
    
    plt.tight_layout()
    plt.savefig('diagrams/deployment_diagram.png', dpi=300, bbox_inches='tight')
    plt.close()

if __name__ == "__main__":
    import os
    os.makedirs('diagrams', exist_ok=True)
    
    print("Creating diagrams...")
    create_architecture_diagram()
    print("Architecture diagram created")
    
    create_star_schema_diagram()
    print("Star schema diagram created")
    
    create_etl_flow_diagram()
    print("ETL flow diagram created")
    
    create_deployment_diagram()
    print("Deployment diagram created")
    
    print("All diagrams created successfully!")
#!/bin/bash

# Green Care Provider Temps - Startup Script

echo "Starting Green Care Provider Temps Data Warehouse..."
echo "=============================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed."
    exit 1
fi

# Create necessary directories
echo "Creating directories..."
mkdir -p postgres/migrations postgres/scripts webapp/static webapp/templates csv logs docs/diagrams

# Start containers
echo "Starting containers..."
docker-compose up -d

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
sleep 5

# Check if containers are running
if docker-compose ps | grep -q "Up"; then
    echo "=============================================="
    echo "Application started successfully!"
    echo "Access the web interface at: http://localhost:5000"
    echo "PostgreSQL is available at: localhost:5432"
    echo ""
    echo "To view logs: docker-compose logs -f"
    echo "To stop: docker-compose down"
    echo "=============================================="
else
    echo "Error: Failed to start containers"
    docker-compose logs
    exit 1
fi
from waitress import serve
from simple_app import app

if __name__ == '__main__':
    print("Starting waitress server on port 8080...")
    print("Access at: http://127.0.0.1:8080")
    serve(app, host='127.0.0.1', port=8080)
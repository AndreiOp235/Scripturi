from flask import Flask, send_from_directory, abort
import os
import socket

# Configuration
DIRECTORY = r"F:\Pirate Bucket"  # Replace with your directory
PORT = 8000  # Port to run the HTTP server on

app = Flask(__name__)

def get_ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip

@app.route('/')
def list_files():
    try:
        files = os.listdir(DIRECTORY)
        file_links = [f'<li><a href="/files/{file}">{file}</a></li>' for file in files]
        return f'<ul>{"".join(file_links)}</ul>'
    except FileNotFoundError:
        abort(404, "Directory not found")

@app.route('/files/<path:filename>')
def serve_file(filename):
    try:
        return send_from_directory(DIRECTORY, filename)
    except FileNotFoundError:
        abort(404, "File not found")

if __name__ == "__main__":
    ip = get_ip_address()
    print(f"Serving files from {DIRECTORY} on port {PORT}")
    print(f"Access the files at http://{ip}:{PORT}")
    app.run(host='0.0.0.0', port=PORT)

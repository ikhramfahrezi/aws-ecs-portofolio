from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_cloud():
    return "Halo! Aplikasi ini berjalan di dalam Docker Container dan akan di-deploy ke AWS ECS."

if __name__ == '__main__':
    # Jangan gunakan app.run() untuk production, kita akan pakai Gunicorn di Dockerfile
    app.run(host='0.0.0.0', port=5000)
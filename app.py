from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, This service is deploy using GitHub Actions on Cloud Run_v1!"

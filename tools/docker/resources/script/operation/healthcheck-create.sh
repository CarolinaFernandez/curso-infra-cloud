#!/bin/bash

# Note: partly based on https://howchoo.com/devops/how-to-add-a-health-check-to-your-docker-container

# Create Flask entry point with REST
cat <<EOF>main.py
from flask import Flask
import uuid
app = Flask(__name__)

@app.route("/token")
def fetch_token():
    return str(uuid.uuid4())

if __name__ == "__main__":
    app.run(host="0.0.0.0")
EOF

# Create Dockerfile to run a Flask (Python specific app) inside
cat <<EOF>Dockerfile.flask
FROM python:3.8.9-alpine3.13

RUN apk add curl
RUN pip install Flask==1.1.2

COPY main.py /opt
WORKDIR /opt

HEALTHCHECK CMD curl --fail http://localhost:5000/token || exit 1

CMD ["python", "main.py"]
EOF

docker build -f Dockerfile.flask -t flask-app .
docker run -d --name flask-app -p 5000:5000 flask-app

sleep .7

# Check for status after 30 seconds
docker inspect --format='{{json .State.Health}}' flask-app

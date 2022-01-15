#!/usr/bin/env bash

# Retrieve the image
docker pull nginx:stable

# Run it as an instance, exposing the port outside the Docker node
docker run --name nginx_local -p 8080:80 -d nginx

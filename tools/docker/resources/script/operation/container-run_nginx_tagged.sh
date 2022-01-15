#!/usr/bin/env bash

# Instantiate the previously created image
docker run --name nginx_local -p 8080:80 -d nginx:local

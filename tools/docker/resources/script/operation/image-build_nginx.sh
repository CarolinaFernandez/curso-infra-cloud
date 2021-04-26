#!/bin/bash

# Create entry page for the image
cat <<EOF>>nginx_index.html
<html><body>Prueba NGINX dentro del curso</body></html>
EOF

# Define the Dockerfile, instructing how to create the image
cat <<EOF>>Dockerfile.nginx
FROM nginx:stable
ADD nginx_index.html /usr/share/nginx/html/index.html
EOF

# Create the image
docker build -f ./Dockerfile.nginx -t nginx:local .

rm -f Dockerfile.nginx
rm -f nginx_index.html

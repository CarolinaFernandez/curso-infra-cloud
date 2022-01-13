#!/bin/bash

##
# Run the Portainer instance over Docker
#

# Create a dedicated volume
docker volume create portainer_data

# Run the instance
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

echo "Dashboard located at http://192.178.33.113:9000"

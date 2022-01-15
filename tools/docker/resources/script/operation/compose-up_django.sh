#!/usr/bin/env bash

# Taken from https://docs.docker.com/compose/django/

USER=$(whoami)

mkdir django_compose
cd django_compose

cat <<EOF>>Dockerfile
FROM python:3
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
EOF

cat <<EOF>>requirements.txt
Django>=3.0,<4.0
psycopg2-binary>=2.8
EOF


cat <<EOF>>docker-compose.yml
version: "3.9"

services:
  db:
    image: postgres
    volumes:
      - ./data/db:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8010
    volumes:
      - .:/code
    ports:
      - "8010:8010"
    depends_on:
      - db
EOF

# Create Django project
sudo docker-compose run web django-admin startproject composeexample .

# Allow current user and the DB to access the files
sudo chown ${USER}:${USER} . -R
sudo chmod 777 . -R
#sudo chmod g+s composeexample

# Invalidate auto-generated values
sed -i 's/\DATABASES =/DATABASES_OLD =/g' composeexample/settings.py
sudo chmod 777 composeexample/settings.py
sed -i 's/\ALLOWED_HOSTS =/ALLOWED_HOSTS_OLD =/g' composeexample/settings.py
sudo chmod 777 composeexample/settings.py

# Insert valid values
cat <<EOF>>composeexample/settings.py
# New values to allow the test to proceed
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',
        'USER': 'postgres',
        'PASSWORD': 'postgres',
        'HOST': 'db',
        'PORT': 5432,
    }
}

ALLOWED_HOSTS = ["*"]
EOF
sudo chmod 777 composeexample/settings.py

docker-compose up -d

cd ..

# Apply migrations from DB first
docker exec -t django_compose_web_1 python manage.py migrate

echo "Generate a Django superuser (define at least username and password)"

# Create superuser (user's input required)
docker exec -it django_compose_web_1 python manage.py createsuperuser

echo "Open http://192.178.33.113:8010/admin in a browser and access with the given credentials"

#!/bin/bash

# Taken from https://github.com/docker/awesome-compose/tree/master/elasticsearch-logstash-kibana

current=$PWD

mkdir elk_compose
cd elk_compose

wget https://raw.githubusercontent.com/docker/awesome-compose/master/elasticsearch-logstash-kibana/docker-compose.yml -O docker-compose.yml

docker-compose -f docker-compose.yml up -d --build --force-recreate

cd ..

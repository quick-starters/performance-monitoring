#!/bin/sh

# Stop & Remove all running containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker volume rm $(docker volume ls -q)

# Build demo-apps
cd demo-app
#./gradlew clean bootBuildImage

# Docker compose up
cd ..
docker compose \
  -f demo-app/docker/docker-compose.yml \
  -f prometheus-grafana/docker-compose.yml --project-directory ./prometheus-grafana \
  up -d
#  -f ngrinder/docker-compose.yml \

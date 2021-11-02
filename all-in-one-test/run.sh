#!/bin/sh

# Stop & Remove all running containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Build demo-apps
cd demo-app
#./gradlew clean bootBuildImage

# Docker compose up
cd ..
docker compose -f ngrinder/docker-compose.yml -f demo-app/docker/docker-compose.yml up -d

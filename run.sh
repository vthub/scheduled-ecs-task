#!/bin/sh

docker build -t scheduled-ecs-task .
docker run scheduled-ecs-task

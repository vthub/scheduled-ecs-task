#!/bin/bash

export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/scheduled-ecs-credentials"
REPO="$(cat repo)"

eval "$(aws ecr get-login --no-include-email --region us-west-2)"
docker build -t scheduled-ecs .
docker tag scheduled-ecs:latest "$REPO:latest"
docker push "$REPO:latest"

export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/scheduled-ecs-credentials"

LOGIN=$(aws ecr get-login --no-include-email --region us-west-2)
eval "$LOGIN"
docker build -t scheduled-ecs .
docker tag scheduled-ecs:latest 073540669542.dkr.ecr.us-west-2.amazonaws.com/scheduled-ecs:latest
docker push 073540669542.dkr.ecr.us-west-2.amazonaws.com/scheduled-ecs:latest

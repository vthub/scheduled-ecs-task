# Running ECS task on a schedule

## File description

* `infrastructure/ecs.tf` - ECS cluster and task configuration
* `infrastrcuture/ecr.tf` - image repository configuration 

## Shortcuts and scripts

1. Run docker locally:
    ```shell script
    $ ./run.sh
    ```
   
2. Publish docker to your ECR repository: 
   ```shell script
   $ echo "YOUR_ECR_REPOSITORY_URI" > repo
   $ ./push.sh
   ```
   
3. Apply terraform changes to your environment:
    ```shell script
    $ cd infrastructure/
    $ terraform apply   
    ```
  
## AWS Access Configuration

For terraform and docker push scripts to find your AWS configuration, place the configuration in the `~/.aws/scheduled-ecs-credentials` file:

```
[default]
aws_access_key_id=YOUR_ACCESS_KEY
aws_secret_access_key=YOUR_SECRET_ACCESS_KEY
region=us-west-2
```

resource "aws_ecs_cluster" "cluster" {
  name = "${local.service_name}-cluster"
}

resource "aws_cloudwatch_log_group" "task_log_group" {
  retention_in_days = 1
  name_prefix       = "${local.service_name}-"
}

data "template_file" "definition" {
  template = file("${path.module}/task-def/def.json")
  vars = {
    region          = var.region
    log_group       = aws_cloudwatch_log_group.task_log_group.name
    image_tag       = data.aws_ecr_repository.ecr_repository.repository_url
    definition_name = local.service_name
  }
}

resource "aws_ecs_task_definition" "definition" {
  family                   = local.service_name
  container_definitions    = data.template_file.definition.rendered
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.service_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
}

resource "aws_ecs_service" "service" {
  name                               = "${local.service_name}-service"
  task_definition                    = aws_ecs_task_definition.definition.arn
  cluster                            = aws_ecs_cluster.cluster.id
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 0
  launch_type                        = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnet_ids.subnets.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
  }
}


resource "aws_security_group" "ecs" {
  vpc_id = aws_default_vpc.default.id
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }
}

resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = "${local.service_name}-event-rule"
  schedule_expression = "rate(5 minutes)" // https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions
  is_enabled          = false             // Change to true to enable scheduling
}

resource "aws_cloudwatch_event_target" "scheduled_task" {
  target_id = "${local.service_name}-target"
  rule      = aws_cloudwatch_event_rule.scheduled_task.name
  arn       = aws_ecs_cluster.cluster.arn
  role_arn  = aws_iam_role.scheduled_task_cloudwatch.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = data.aws_subnet_ids.subnets.ids
      assign_public_ip = true
      security_groups  = [aws_security_group.ecs.id]
    }
  }
}

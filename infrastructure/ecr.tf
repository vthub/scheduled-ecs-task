data "aws_ecr_repository" "ecr_repository" {
  name = local.service_name
}

data "aws_ecr_image" "ecr_image" {
  repository_name = data.aws_ecr_repository.ecr_repository.name
  image_tag       = "latest"
}

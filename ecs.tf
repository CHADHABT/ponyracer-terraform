/* Cluster definition */
resource "aws_ecs_cluster" "ECS_CLUSTER" {
  name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}_CLUSTER"
}

/* ECS service definition */
resource "aws_ecs_service" "ECS_SERVICE" {
  name                               = "${var.NAME_PREFIX}_${var.ENV_PREFIX}_SERVICE"
  cluster                            = aws_ecs_cluster.ECS_CLUSTER.id
  task_definition                    = aws_ecs_task_definition.ECS_TASK_DEFINITION.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = var.MINIMUM_HEALTHY_PERCENT
  iam_role                           = var.ECS_SERVICE_ROLE

  load_balancer {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP1.arn
    container_name   = "ponyracer"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_alb_target_group.ALB_TARGET_GROUP1"]
}

resource "aws_ecs_task_definition" "ECS_TASK_DEFINITION" {
  family                = "${var.NAME_PREFIX}_${var.ENV_PREFIX}_TASKDEF"
  container_definitions = data.template_file.TEMPLATE.rendered
  execution_role_arn    = var.TASK_EXECUTION_ROLE_ARN

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_ecs_task_definition.ECS_TASK_DEFINITION"]
}

data "template_file" "TEMPLATE" {
  template = file("task-definitions/ecs_task.tpl")

  vars = {
  webapp_docker_image = "${var.WEBAPP_DOCKER_IMAGE_NAME}:${var.WEBAPP_DOCKER_IMAGE_TAG}" }

}

# CodeDeploy application
resource "aws_codedeploy_app" "APPLICATION" {
  compute_platform = "ECS"
  name             = "${var.APP_NAME}"
}

# Blue Green Deployments with ECS
resource "aws_codedeploy_deployment_group" "DEPLOY_GROUP" {
  app_name               = "${aws_codedeploy_app.APPLICATION.name}"
  deployment_group_name  = "${var.APP_NAME}-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = "${var.CODE_DEPLOY_ROLE_ARN}"

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
	  termination_wait_time_in_minutes = 5
    }
  }

  ecs_service {
    cluster_name = "${var.ECS_CLUSTER_NAME}"
    service_name = "${var.ECS_SERVICE_NAME}"
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${var.ALB_LISTENER_ARN}"]
      }

      target_group {
        name = "${var.ALB_TARGET_GROUP_BLUE_NAME}"
      }

      target_group {
        name = "${var.ALB_TARGET_GROUP_GREEN_NAME}"
      }
    }
  }
}
resource "aws_launch_configuration" "LAUNCH_CONFIGURATION" {
  instance_type               = var.INSTANCE_TYPE
  image_id                    = lookup(var.ECS_IMAGE_ID, var.AWS_REGION)
  iam_instance_profile        = var.ECS_INSTANCE_PROFILE
  user_data                   = data.template_file.AUTOSCALING_USER_DATA.rendered
  security_groups             = ["${var.SG_INSTANCES_ID}"]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "AUTOSCALING_GROUP" {
  name                      = "${var.NAME_PREFIX}_${var.ENV_PREFIX}_ASG"
  max_size                  = var.MAX_INSTANCE_SIZE
  min_size                  = var.MIN_INSTANCE_SIZE
  desired_capacity          = var.DESIRED_CAPACITY
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.LAUNCH_CONFIGURATION.name
  vpc_zone_identifier       = var.SUBNET_IDS

  tag {
    key                 = "Name"
    value               = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "AUTOSCALING_USER_DATA" {
  template = file("user_data.tpl")
  vars = {
    ecs_cluster = "${aws_ecs_cluster.ECS_CLUSTER.name}"
  }
}

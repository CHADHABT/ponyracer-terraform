resource "aws_alb" "ALB" {
  name            = "${var.ALB_PREFIX}-${var.ENV_PREFIX}-ALB"
  subnets         = var.SUBNET_IDS
  security_groups = ["${var.SG_ALB_ID}"]
  idle_timeout    = 400
  # if the inactivity of the session between the client and server surpass 400 s the session is no longer maintained.

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
  }
}

# For blue/green deployment we create 2 target groups
resource "aws_alb_target_group" "ALB_TARGET_GROUP1" {
  name     = "${var.ALB_PREFIX}-${var.ENV_PREFIX}-TG1"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  deregistration_delay = 300

  health_check {
    interval            = "30"
    path                = "/"
    port                = "80"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    timeout             = "5"
    protocol            = "HTTP"
  }

  tags = {
    Name = "BLUE-TG"
  }

  depends_on = ["aws_alb.ALB"]
}

resource "aws_alb_target_group" "ALB_TARGET_GROUP2" {
  name     = "${var.ALB_PREFIX}-${var.ENV_PREFIX}-TG2"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  deregistration_delay = 300

  health_check {
    interval            = "30"
    path                = "/"
    port                = "80"
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    timeout             = "5"
    protocol            = "HTTP"
  }

  tags = {
    Name = "GREEN-TG"
  }

  depends_on = ["aws_alb.ALB"]
}

resource "aws_alb_listener" "ALB_LISTENER" {
  load_balancer_arn = aws_alb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP1.id
    type             = "forward"
  }

  depends_on = ["aws_alb.ALB"]
}

resource "aws_alb_listener_rule" "ALB_LISTENER_RULE" {
  depends_on   = ["aws_alb_target_group.ALB_TARGET_GROUP1"]
  listener_arn = aws_alb_listener.ALB_LISTENER.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ALB_TARGET_GROUP1.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

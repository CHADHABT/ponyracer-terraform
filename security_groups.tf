resource "aws_security_group" "SG_ECS_SERVICE" {
  name        	= "${var.NAME_PREFIX}_${var.ENV_PREFIX}_ECS"
  vpc_id 		= "${aws_vpc.VPC.id}"
  description 	= "Security group for ECS service"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
  }
}

/**
  * We will utilize ALB and allow web access only from ALB
  */
resource "aws_security_group" "SG_ALB" {
    name 			= "${var.NAME_PREFIX}_${var.ENV_PREFIX}_ALB"
    vpc_id 			= "${aws_vpc.VPC.id}"
    description 	= "Security group for ALBs"

    ingress {
        from_port 	= 80
        to_port 	= 80
        protocol 	= "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port 	= 0
        to_port 	= 0
        protocol 	= "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    }
}

/**
  * Security group for each instances
  */
resource "aws_security_group" "SG_INSTANCES" {
    name 			= "${var.NAME_PREFIX}_${var.ENV_PREFIX}_INST"
    vpc_id 			= "${aws_vpc.VPC.id}"
    description 	= "Security group for instances"

    tags = {
        Name = "${var.NAME_PREFIX}_${var.ENV_PREFIX}"
    }
}

/* Allow all outgoing connections */
resource "aws_security_group_rule" "ALLOW_ALL_EGRESS" {
    type 			= "egress"
    from_port 		= 0
    to_port 		= 0
    protocol 		= "-1"
    cidr_blocks 	= ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.SG_INSTANCES.id}"
}

/* Allow incoming requests from ELB and peers only */
resource "aws_security_group_rule" "ALLOW_ALL_FROM_ALBS" {
    type 			= "ingress"
    from_port 		= 0
    to_port 		= 0
    protocol 		= "-1"

    security_group_id = "${aws_security_group.SG_INSTANCES.id}"
    source_security_group_id = "${aws_security_group.SG_ALB.id}"
}

resource "aws_security_group_rule" "ALLOW_ALL_FROM_PEERS" {
    type 			= "ingress"
    from_port 		= 0
    to_port 		= 0
    protocol 		= "-1"

    security_group_id = "${aws_security_group.SG_INSTANCES.id}"
    source_security_group_id = "${aws_security_group.SG_INSTANCES.id}"
}
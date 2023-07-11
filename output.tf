####### -------------------- IAM variables ----------------------- #######

/* Instance profile which will be used in the ASG launch configuration */
output "ECS_INSTANCE_PROFILE" {
  value = aws_iam_instance_profile.ECS_INSTANCE_PROFILE.name
}

/* IAM Role for ECS services */
output "ECS_SERVICE_ROLE" {
  value = aws_iam_role.ECS_SERVICE_ROLE.name
}

/* IAM Role for Task definition */
output "TASK_EXECUTION_ROLE" {
  value = aws_iam_role.ECS_TASK_ROLE.name
}


####### --------------------SG variables ----------------------- #######

/* Security group */
output "SG_ECS_SERVICE_ID" {
  value = aws_security_group.SG_ECS_SERVICE.id
}


output "SG_INSTANCES_ID" {
  value = aws_security_group.SG_INSTANCES.id
}

output "VPC_ID" {
  value = aws_vpc.VPC.id
}

/* Subnet IDs */
output "SUBNET_IDS" {
  value = join(",", aws_subnet.PUBLIC_SUBNET.*.id)
}


####### -------------------- variables ----------------------- #######


output "REPOSITORY_URL" {
  description = "The URL of the repository."
  value       = aws_ecr_repository.ECR_REPOSITORY.repository_url
}


/**
  * DNS name from ALB
  * In production, you can add this DNS Name to Route 53 (your domain)
  */
output "ALB_DNS_NAME" {
  value = aws_alb.ALB.dns_name
}

/**
  * The ALB listner ARN
  */
output "ALB_LISTENER_ARN" {
  value = aws_alb_listener.ALB_LISTENER.arn
}

####### -------------------- IAM variables ----------------------- #######


########################### AWS credentials ###############################
variable "AWS_ACCESS_KEY_ID" {
	description = "AWS access key"
}

variable "AWS_SECRET_ACCESS_KEY" {
	description = "AWS secret access key"
}

variable "AWS_REGION" {
	description = "AWS region"
}


########################### AWS managed policies ###############################

variable "TASK_POLICY_ARN" {
    default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    description = "Provides access to other AWS service resources that are required to run Amazon ECS tasks."
}

variable "CODE_DEPLOY_ECS_ARN" {
    default = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
    description = "Provides CodeDeploy service wide access to perform an ECS blue/green deployment."
}


####### ---------------------- SG variables -------------------------- #######

########################### VPC CONFIGURATION ###############################
variable "VPC_CIDR" {
	default = "192.168.0.0/16"
}

variable "PUBLIC_SUBNET_CIDRS" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  default = ["192.168.1.0/24", "192.168.2.0/24"]
  type    = list(string)
}

variable "SUBNET_AZS" {
    default = ["a", "b"]
	type    = list(string)
}

########################### QUOTIDIENNE PREFIX ###############################
variable "NAME_PREFIX" {
    description = "Project prefix."
}

variable "ENV_PREFIX" {
    description = "Environment prefix."
}

####### ------------------------ ECR variables ----------------------- #######

########################### REPOSITORY NAME ###############################
variable "REPOSITORY_NAME" {
    default = "ponyracer"
    description = "The ECR repository"
}



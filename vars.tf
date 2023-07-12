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
  default     = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  description = "Provides access to other AWS service resources that are required to run Amazon ECS tasks."
}

variable "CODE_DEPLOY_ECS_ARN" {
  default     = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  description = "Provides CodeDeploy service wide access to perform an ECS blue/green deployment."
}


####### ---------------------- SG variables -------------------------- #######

########################### VPC CONFIGURATION ###############################
variable "VPC_CIDR" {
  default = "192.168.0.0/16"
}

variable "PUBLIC_SUBNET_CIDRS" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
  type        = list(string)
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


########################### REPOSITORY NAME ###############################
variable "REPOSITORY_NAME" {
  default     = "ponyracer"
  description = "The ECR repository"
}

########################### ALB Variables ###############################

variable "ALB_PREFIX" {
  default     = "Ponyracer"
  description = "Project prefix."
}
########################### Autoscaling Config ##############################
variable "MAX_INSTANCE_SIZE" {
  description = "Maximum number of instances in the cluster"
}

variable "MIN_INSTANCE_SIZE" {
  description = "Minimum number of instances in the cluster"
}

variable "DESIRED_CAPACITY" {
  description = "Desired number of instances in the cluster"
}

variable "MINIMUM_HEALTHY_PERCENT" {
  description = "Desired percentage of healthy instance"
}

variable "INSTANCE_TYPE" {
  description = "Type of the instance"
}

########################### Docker Image Config ##############################
/* ECS optimized AMIs per region */
variable "ECS_IMAGE_ID" {
  # ami-2017.09.i with ECS Agent 1.17.1-1 and Docker 17.09.1-ce
  default = {
    eu-west-1 = "ami-023f1074e24ccf964"
  }
}

variable "WEBAPP_DOCKER_IMAGE_NAME" {
  default     = "170012228819.dkr.ecr.eu-west-1.amazonaws.com/ponyracer"
  description = "Docker image from ECR"
}

variable "WEBAPP_DOCKER_IMAGE_TAG" {
  default     = "version1"
  description = "Docker image version to pull (from tag)"
}

/* Consume common outputs */
variable "SG_ECS_SERVICE_ID" {}
variable "SG_ALB_ID" {}
variable "SG_INSTANCES_ID" {}
variable "VPC_ID" {}
variable "SUBNET_IDS" {
  type = list(string)
}

/* Consume static outputs */
variable "ECS_INSTANCE_PROFILE" {}
variable "ECS_SERVICE_ROLE" {}
variable "TASK_EXECUTION_ROLE_ARN" {}



##############################################################################

############################## IAM ROLE ##################################
variable "CODE_DEPLOY_ROLE_ARN" {
    description = "Role to perform an ECS blue/green deployment"
}

########################### Cluster informations ##############################
variable "ECS_CLUSTER_NAME" {
	description 	= "Cluster name"
}

variable "ECS_SERVICE_NAME" {
	description 	= "Service name"
}

########################### Load balancer ##############################
variable "ALB_LISTENER_ARN" {
	description 	= "Load balancer ARN"
}

variable "ALB_TARGET_GROUP_BLUE_NAME" {
	description 	= "Target group 1 name."
}

variable "ALB_TARGET_GROUP_GREEN_NAME" {
  description 	    = "Target group 2 name."
}
##########################################################################

variable "APP_NAME" {
	default = "ponyracer"
}

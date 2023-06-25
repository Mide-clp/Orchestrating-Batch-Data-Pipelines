variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Default AWS region"
}


######################## ECR ################################################ 

variable "ecr_repository_name" {
  type        = string
  default     = "batch-data-repo"
  description = "Name to give the ecr container"
}

variable "ecr_scan_on_push" {
  type        = bool
  description = "whether images are scanned after being pushed to the repository"
  default     = true

}

variable "tags" {
  type = object({
    terraform = string
    purpose = string
  })
  default = {
    "terraform": "true", 
    "purpose": "ecs-batch-job",
  }
}

######################## s3 ################################################ 

variable "bucket_name" {
  type        = string
  default     = "mide-ecs-batch-job"
  description = "Name to give the bucket"
}

######################## iam roles ################################################ 

variable "ecs_role_name" {
  type        = string
  default     = "BatchEcsRole"
  description = "role name for ecs"
}

variable "cloudwatch_role_name" {
  type        = string
  default     = "BatchCloudWatchRole"
  description = "role name for cloudwatch"
}


######################## VPC ################################################ 

variable "subnet_count" {
  type        = number
  default     = 3
  description = "Number of subnet needed"
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "cidr block for the subnet"
}

variable "subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "list of cidr blocks to be used by subnet"
}

variable "subnet_availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "list of availability zones to be used by subnet"
}

variable "sg_name" {
  type         = string
  default      = ""
  description  = "name of the security group"
}

######################## ECS ################################################ 

variable "cluster_name" {
  type        = string
  default     = "batch-job"
  description = "ECS cluster name"
}

variable "task_definition_name" {
  type        = string
  default     = "batch-gharchive-task"
  description = "ECS task definition name"
}

variable "ecs_service_name" {
  type        = string
  default     = "batch-gharchive"
  description = "ECS service name"
}

######################## CloudWatch ################################################ 

variable "cloudwatch_log_group_name" {
  type        = string
  default     = "batch-gharchive"
  description = "CloudWatch log group name"
} 

variable "clouwatch_event_name" {
  type        = string
  default     = "batch-gharchive-event"
  description = "Eventbridge name"
}
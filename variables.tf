variable "beanstalk_env_name" {
  type = string
  description = "Name of the beanstalk environment. Also used for the instance profile and the security group."
}

variable "beanstalk_app_name" {
  type = string
  description = "Name of the beanstalk application to which the new environment will be attached."
}

variable "tier" {
  type = string
  description = "WebServer or Worker"
  validation {
    condition = var.tier == "WebServer" || var.tier == "Worker"
    error_message = "Tier must be WebServer or Worker"
  }
}

variable "description" {
  type = string
  description = "A description for the beanstalk environment"
}


variable "vpc_id" {
  type = string
  description = "Id of the VPC."
}

variable "production" {
  type = bool
  default = false
}

variable "ha" {
  type = bool
  default = false
}

variable "beanstalk_settings" {
  type = list(object({
    namespace: string,
    name: string,
    value: string,
  }))
}

variable "beanstalk_env_vars" {
  type = list(object({
    name: string,
    value: string,
  }))
  default = []
}

variable "solution_stack_name" {
  type = string
  description = "See https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html#concepts.platforms.list or run `aws elasticbeanstalk list-available-solution-stacks`"
}


variable "instance_type" {
  type = string
  description = "An AWS instance type to use for the environment. Defaults to t4g.small for production environments and t4g.micro for non-production environments"
  default = null
}

variable "profile_permissions_boundary_arn" {
  type = string
  default = null
  description = "The ARN of AWS IAM Policy used as permissions boundary for the beanstalk instances profile."
}

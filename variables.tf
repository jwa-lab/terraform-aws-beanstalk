variable "env_name" {
  type = string
  description = "Name of the environment. Used for the Beanstalk environment name and CNAME prefix, the IAM instance profile, the S3 logs bucket, the security groups"
}

variable "app_name" {
  type = string
  description = "Name of the beanstalk application to which the new environment will be attached."
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

variable "alb_logs" {
  type = bool
  default = false
  description = "Enable the ALB Logs in S3, stored in a dedicated bucket"
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
}

variable "domain" {
  type = object({
    main = string
    sub = string
  })
}

variable "certificate_additional_domains" {
  type = list(object({
    main = string
    sub = string
  }))
  default = []
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

variable "health_check_path" {
  type = string
  default = "/health-check"
  description = "The path to the health check endpoint used by the load balancer."
}

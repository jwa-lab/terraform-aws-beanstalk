variable "app_name" {
  type = string
  description = "Name of the beanstalk application to which the new environment will be attached."
}

variable "env_name" {
  type = string
}

variable "vpc_id" {
  type = string
  description = "Id of the VPC."
}

variable "elb_subnets_ids" {
  type = list(string)
  description = "Public vpc subnets for the load balancer"
}

variable "app_subnets_ids" {
  type = list(string)
  description = "Private vpc subnets for the beanstalk instances"
}

variable "production" {
  type = bool
  default = false
}

variable "ha" {
  type = bool
  default = false
}

variable "beanstalk_env_vars" {
  type = list(object({
    name: string,
    value: string,
  }))
}

variable "solution_stack_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "sub_domain" {
  type = string
}

variable "instance_type" {
  type = string
  description = "An AWS instance type to use for the environment. Defaults to t4g.small for production environments and t4g.micro for non-production environments"
  default = null
}

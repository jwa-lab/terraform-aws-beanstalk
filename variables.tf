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

variable "aws_bucket_id" {
  type = string
  description = "Name of the S3 Bucket where AWS artifacts (mainly logs) can be written"
}

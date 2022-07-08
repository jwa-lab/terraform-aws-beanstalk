locals {
  app_name = var.app_name
  env_name = var.env_name

  vpc_id = var.vpc_id
  elb_subnets_ids = var.elb_subnets_ids
  app_subnets_ids = var.app_subnets_ids

  solution_stack_name = var.solution_stack_name
  instance_type = var.instance_type

  ha = var.ha
  production = var.production

  domain_name = var.domain_name
  sub_domain = var.sub_domain

  beanstalk_env_vars = var.beanstalk_env_vars
}

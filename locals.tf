locals {
  elb_subnets_ids = data.aws_subnets.public.ids
  app_subnets_ids = data.aws_subnets.private_apps.ids
}

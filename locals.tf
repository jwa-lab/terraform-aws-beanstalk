locals {
  account_id = data.aws_caller_identity.current.account_id
  region = data.aws_region.current.name

  elb_subnets_ids = data.aws_subnets.public.ids
  app_subnets_ids = data.aws_subnets.private_apps.ids
}

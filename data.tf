data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    visibility = "public"
  }
}

data "aws_subnets" "private_apps" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    visibility = "private"
    target = "apps"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

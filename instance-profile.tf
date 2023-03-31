module "instance_profile" {
  source  = "jwa-lab/instance-profile/aws"
  version = "0.0.3"

  name = var.beanstalk_env_name

  policies_arn = [
    var.tier == "WebServer" ? "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier" : "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  permissions_boundary_policy_arn = var.profile_permissions_boundary_arn
}

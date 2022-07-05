resource "aws_elastic_beanstalk_environment" "beanstalk_env" {
  name = local.env_name
  application = local.app_name
  cname_prefix = local.env_name
  description = "${local.env_name} environment for ${local.app_name}"
  tier = "WebServer"
  solution_stack_name = local.solution_stack_name

  dynamic "setting" {
    for_each = local.beanstalk_settings

    content {
      namespace = setting.value["namespace"]
      name = setting.value["name"]
      value = setting.value["value"]
      resource = ""
    }
  }

  dynamic "setting" {
    for_each = local.beanstalk_env_vars

    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name = setting.value["name"]
      value = setting.value["value"]
      resource = ""
    }
  }
}

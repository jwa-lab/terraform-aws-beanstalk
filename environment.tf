resource "aws_elastic_beanstalk_environment" "beanstalk_env" {
  name = var.env_name
  application = var.app_name
  cname_prefix = var.env_name
  description = "${var.env_name} environment for ${var.app_name}"
  tier = "WebServer"
  solution_stack_name = var.solution_stack_name

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
    for_each = var.beanstalk_env_vars

    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name = setting.value["name"]
      value = setting.value["value"]
      resource = ""
    }
  }
}

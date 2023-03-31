resource "aws_elastic_beanstalk_environment" "beanstalk_env" {
  name = var.beanstalk_env_name
  application = var.beanstalk_app_name

  tier = var.tier
  solution_stack_name = var.solution_stack_name
  cname_prefix = var.tier == "WebServer" ? var.beanstalk_env_name : null

  description = var.description

  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any ${length(local.elb_subnets_ids)}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = module.instance_profile.instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "MonitoringInterval"
    value = var.production ? "1 minute" : "5 minute"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = aws_security_group.instances_security_group.id
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "BreachDuration"
    value = var.production ? 2 : 5
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "EvaluationPeriods"
    value = var.production ? 2 : 5
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "LowerBreachScaleIncrement"
    value = "-1"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "LowerThreshold"
    value = 20
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "MeasureName"
    value = "CPUUtilization"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Period"
    value = 1
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Statistic"
    value = "Average"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "Unit"
    value = "Percent"
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "UpperBreachScaleIncrement"
    value = 2
  }

  setting {
    namespace = "aws:autoscaling:trigger"
    name = "UpperThreshold"
    value = 70
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "RollingUpdateEnabled"
    value = var.production
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "Timeout"
    value = "PT5M"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = join(",", sort(local.app_subnets_ids))
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = join(",", sort(local.elb_subnets_ids))
  }

  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = false
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name = "DeleteOnTerminate"
    value = var.production ? false: true
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name = "RetentionInDays"
    value = var.production ? 7 : 1
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name = "StreamLogs"
    value = true
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "BatchSize"
    value = var.ha ? 50 : 100
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "BatchSizeType"
    value = "Percentage"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "DeploymentPolicy"
    value = var.ha ? "Rolling" : "AllAtOnce"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "Timeout"
    value = 300
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "IgnoreHealthCheck"
    value = var.production ? false : true
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
  }

  dynamic "setting" {
    for_each = var.beanstalk_settings

    content {
      namespace = setting.value["namespace"]
      name = setting.value["name"]
      value = setting.value["value"]
    }
  }

  dynamic "setting" {
    for_each = var.beanstalk_env_vars

    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name = setting.value["name"]
      value = setting.value["value"]
    }
  }
}

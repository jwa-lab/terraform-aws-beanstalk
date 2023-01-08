locals {
  beanstalk_settings = [
    {
      namespace = "aws:autoscaling:asg"
      name = "Availability Zones"
      value = "Any ${length(local.elb_subnets_ids)}"
    },
    {
      namespace = "aws:autoscaling:asg"
      name = "MaxSize"
      value = var.production ? 20 : 2
    },
    {
      namespace = "aws:autoscaling:asg"
      name = "MinSize"
      value = var.ha ? 2 : 1
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "IamInstanceProfile"
      value = aws_iam_instance_profile.beanstalk_instances_profile.name
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "MonitoringInterval"
      value = var.production ? "1 minute" : "5 minute"
    },
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name = "SecurityGroups"
      value = aws_security_group.beanstalk_instances_security_group.id
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "BreachDuration"
      value = var.production ? 2 : 5
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "EvaluationPeriods"
      value = var.production ? 2 : 5
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "LowerBreachScaleIncrement"
      value = "-1"
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "LowerThreshold"
      value = 20
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "MeasureName"
      value = "CPUUtilization"
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "Period"
      value = 1
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "Statistic"
      value = "Average"
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "Unit"
      value = "Percent"
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "UpperBreachScaleIncrement"
      value = 2
    },
    {
      namespace = "aws:autoscaling:trigger"
      name = "UpperThreshold"
      value = 70
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name = "RollingUpdateEnabled"
      value = var.production
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name = "RollingUpdateType"
      value = "Health"
    },
    {
      namespace = "aws:autoscaling:updatepolicy:rollingupdate"
      name = "Timeout"
      value = "PT5M"
    },
    {
      namespace = "aws:ec2:instances"
      name = "InstanceTypes"
      value = var.instance_type != null ? var.instance_type : (var.production ? "t4g.small" : "t4g.micro")
    },
    {
      namespace = "aws:ec2:vpc"
      name = "VPCId"
      value = var.vpc_id
    },
    {
      namespace = "aws:ec2:vpc"
      name = "Subnets"
      value = join(",", sort(local.app_subnets_ids))
    },
    {
      namespace = "aws:ec2:vpc"
      name = "ELBSubnets"
      value = join(",", sort(local.elb_subnets_ids))
    },
    {
      namespace = "aws:ec2:vpc"
      name = "AssociatePublicIpAddress"
      value = false
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      name = "DeleteOnTerminate"
      value = var.production ? false: true
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      name = "RetentionInDays"
      value = var.production ? 7 : 1
    },
    {
      namespace = "aws:elasticbeanstalk:cloudwatch:logs"
      name = "StreamLogs"
      value = true
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name = "BatchSize"
      value = var.ha ? 50 : 100
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name = "BatchSizeType"
      value = "Percentage"
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name = "DeploymentPolicy"
      value = var.ha ? "Rolling" : "AllAtOnce"
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name = "Timeout"
      value = 300
    },
    {
      namespace = "aws:elasticbeanstalk:command"
      name = "IgnoreHealthCheck"
      value = var.production ? false : true
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name = "EnvironmentType"
      value = "LoadBalanced"
    },
    {
      namespace = "aws:elasticbeanstalk:environment"
      name = "LoadBalancerType"
      value = "application"
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "DeregistrationDelay"
      value = 10
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "HealthCheckInterval"
      value = 30
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "HealthCheckPath"
      value = "/health-check"
    },
    {
      namespace = "aws:elasticbeanstalk:environment:process:default"
      name = "HealthCheckTimeout"
      value = 2
    },
    {
      namespace = "aws:elasticbeanstalk:healthreporting:system"
      name = "SystemType"
      value = "enhanced"
    },
    {
      namespace = "aws:elbv2:listener:443"
      name = "Protocol"
      value = "HTTPS"
    },
    {
      namespace = "aws:elbv2:listener:443"
      name = "SSLCertificateArns"
      value = aws_acm_certificate.certificate.arn
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "AccessLogsS3Bucket"
      value = aws_s3_bucket.aws_logs_bucket.id
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "AccessLogsS3Enabled"
      value = true
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "IdleTimeout"
      value = 10
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "ManagedSecurityGroup"
      value = aws_security_group.load_balancer_security_group.id
    },
    {
      namespace = "aws:elbv2:loadbalancer"
      name = "SecurityGroups"
      value = aws_security_group.load_balancer_security_group.id
    },
  ]
}

resource "aws_iam_role" "beanstalk_instances_role" {
  name = terraform.workspace
  description = "Role for ${terraform.workspace} instances"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "beanstalk_instances_profile" {
  name = "${terraform.workspace}-instance-profile"
  role = aws_iam_role.beanstalk_instances_role.name
}

data "aws_iam_policy" "beanstalk_default_policy" {
  name = "AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "beanstalk_default_policy_attachment" {
  policy_arn = data.aws_iam_policy.beanstalk_default_policy.arn
  role = aws_iam_role.beanstalk_instances_role.name
}

data "aws_iam_policy" "beanstalk_health_policy" {
  name = "AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "beanstalk_health_policy_attachment" {
  policy_arn = data.aws_iam_policy.beanstalk_health_policy.arn
  role = aws_iam_role.beanstalk_instances_role.name
}

data "aws_iam_policy" "ssm_managed_instance_core" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_policy_attachment" {
  policy_arn = data.aws_iam_policy.ssm_managed_instance_core.arn
  role = aws_iam_role.beanstalk_instances_role.name
}

data "aws_iam_policy" "ecr_ro_policy" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ecr_ro_attachment" {
  policy_arn = data.aws_iam_policy.ecr_ro_policy.arn
  role = aws_iam_role.beanstalk_instances_role.name
}

resource "aws_iam_role_policy" "platform_api_cloudwatch_logs_policy" {
  name = "CloudWatchLogsStreaming"
  role = aws_iam_role.beanstalk_instances_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["logs:CreateLogGroup"]
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:log-group:/aws/elasticbeanstalk*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "platform_api_secrets_manager_policy" {
  name = "PlatformApiSecretsManagerPolicy"
  role   = aws_iam_role.beanstalk_instances_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["secretsmanager:GetSecretValue"]
        Effect = "Allow"
        Resource = [
          "arn:aws:secretsmanager:eu-central-1:188232076030:secret:*",
        ]
      }
    ]
  })
}

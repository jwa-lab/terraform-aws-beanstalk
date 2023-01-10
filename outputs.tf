output "beanstalk_env_cname" {
  value = aws_elastic_beanstalk_environment.beanstalk_env.cname
}

output "instances_security_group_id" {
  value = aws_security_group.beanstalk_instances_security_group.id
}

output "instance_role_id" {
  value = aws_iam_role.beanstalk_instances_role.id
}

output "load_balancer_arn" {
  value = aws_elastic_beanstalk_environment.beanstalk_env.load_balancers[0]
}

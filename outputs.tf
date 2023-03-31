#output "beanstalk_env_cname" {
#  value = aws_elastic_beanstalk_environment.beanstalk_env.cname
#}
#
output "instances_security_group_id" {
  value = aws_security_group.instances_security_group.id
}

output "instance_role" {
  value = module.instance_profile.instance_role
}

#output "load_balancer_arn" {
#  value = aws_elastic_beanstalk_environment.beanstalk_env.load_balancers[0]
#}

output "beanstalk_env" {
  value = aws_elastic_beanstalk_environment.beanstalk_env
}

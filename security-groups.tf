########################################################################################################################
#### BEANSTALK INSTANCES
########################################################################################################################

resource "aws_security_group" "instances_security_group" {
  name = "${var.beanstalk_env_name}-beanstalk-instances"
  description = "${var.beanstalk_env_name} ec2 beanstalk instances security group"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.beanstalk_env_name}-beanstalk-instances"
  }
}

resource "aws_security_group_rule" "allow_all_outbound_traffic_from_beanstalk_instances" {
  description = "Allow all outbound traffic from ${var.beanstalk_env_name} beanstalk instances"
  protocol = "-1"
  type = "egress"
  security_group_id = aws_security_group.instances_security_group.id
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  from_port = 0
}

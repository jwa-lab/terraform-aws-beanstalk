########################################################################################################################
#### LOAD BALANCER
########################################################################################################################
resource "aws_security_group" "load_balancer_security_group" {
  name = "${terraform.workspace}-load-balancer"
  description = "${terraform.workspace} load balancer security group"
  vpc_id = local.vpc_id

  tags = {
    Name = "${terraform.workspace}-load-balancer"
  }
}

resource "aws_security_group_rule" "allow_http_traffic_to_lb" {
  description = "Allow HTTP inbound traffic to ${terraform.workspace} load balancer on port 80"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.load_balancer_security_group.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_traffic_to_lb" {
  description = "Allow HTTPS inbound traffic to ${terraform.workspace} load balancer on port 443"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "TCP"
  security_group_id = aws_security_group.load_balancer_security_group.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound_traffic_from_lb" {
  description = "Allow outbound traffic from ${terraform.workspace} load balancer on port 80"
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.load_balancer_security_group.id
  source_security_group_id = aws_security_group.instances_security_group.id
}

########################################################################################################################
#### BEANSTALK INSTANCES
########################################################################################################################

# TODO: rename to beanstalk_instances_security_group
resource "aws_security_group" "instances_security_group" {
  name = "${terraform.workspace}-beanstalk-instances"
  description = "${terraform.workspace} ec2 beanstalk instances security group"
  vpc_id = local.vpc_id

  tags = {
    Name = "${terraform.workspace}-beanstalk-instances"
  }
}

resource "aws_security_group_rule" "allow_traffic_from_lb_to_beanstalk_instances" {
  description = "Allow inbound traffic to ${terraform.workspace} beanstalk instances on port 80"
  from_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.instances_security_group.id
  to_port = 80
  source_security_group_id = aws_security_group.load_balancer_security_group.id
  type = "ingress"
}

# TODO: rename to allow_all_outbound_traffic_from_beanstalk_instances
resource "aws_security_group_rule" "allow_outbound_traffic_from_beanstalk_instances" {
  description = "Allow all outbound traffic from ${terraform.workspace} beanstalk instances"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.instances_security_group.id
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

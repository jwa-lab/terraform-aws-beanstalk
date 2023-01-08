########################################################################################################################
#### LOAD BALANCER
########################################################################################################################
resource "aws_security_group" "load_balancer_security_group" {
  name = "${var.env_name}-load-balancer"
  description = "${var.env_name} load balancer security group"
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_name}-load-balancer"
  }
}

resource "aws_security_group_rule" "allow_http_traffic_to_lb" {
  description = "Allow HTTP inbound traffic to ${var.env_name} load balancer on port 80"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.load_balancer_security_group.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_https_traffic_to_lb" {
  description = "Allow HTTPS inbound traffic to ${var.env_name} load balancer on port 443"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "TCP"
  security_group_id = aws_security_group.load_balancer_security_group.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound_traffic_from_lb" {
  description = "Allow outbound traffic from ${var.env_name} load balancer on port 80"
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "TCP"
  security_group_id = aws_security_group.load_balancer_security_group.id
  source_security_group_id = aws_security_group.beanstalk_instances_security_group.id
}

########################################################################################################################
#### BEANSTALK INSTANCES
########################################################################################################################

resource "aws_security_group" "beanstalk_instances_security_group" {
  name = "${var.env_name}-beanstalk-instances"
  description = "${var.env_name} ec2 beanstalk instances security group"
  vpc_id = var.vpc_id

  tags = {
    Name = "${terraform.workspace}-beanstalk-instances"
  }
}

resource "aws_security_group_rule" "allow_traffic_from_lb_to_beanstalk_instances" {
  description = "Allow inbound traffic to ${var.env_name} beanstalk instances on port 80 from the load balancer"
  protocol = "TCP"
  type = "ingress"
  security_group_id = aws_security_group.beanstalk_instances_security_group.id
  to_port = 80
  source_security_group_id = aws_security_group.load_balancer_security_group.id
  from_port = 80
}

resource "aws_security_group_rule" "allow_all_outbound_traffic_from_beanstalk_instances" {
  description = "Allow all outbound traffic from ${var.env_name} beanstalk instances"
  protocol = "-1"
  type = "egress"
  security_group_id = aws_security_group.beanstalk_instances_security_group.id
  to_port = 0
  cidr_blocks = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  from_port = 0
}

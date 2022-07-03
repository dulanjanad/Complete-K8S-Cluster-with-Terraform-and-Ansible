resource "aws_security_group" "allow_traffice" {
  name        = "${var.vpc_name}-SG"
  description = "Security Group for ${var.vpc_name}"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["${var.current_public_ip}"]
    }
  }

  ingress {
    description = "security group itself will be added as a source to this ingress rule"
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name"        = "${var.vpc_name}-SG"
    "Environment" = "Dev"
  }
}
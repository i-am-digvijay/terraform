resource "aws_security_group" "myweb" {
  name        = "${var.environment}-myweb-sg"
  description = "Security group for web tier in ${var.environment}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.environment}-myweb-sg"
  }
}

# HTTP access
resource "aws_security_group_rule" "http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.myweb.id
}

# SSH access (restricted by environment)
resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_cidr]
  security_group_id = aws_security_group.myweb.id
  description       = "SSH access for ${var.environment}"
}

# Outbound access (allow all)
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.myweb.id
  description       = "Allow all outbound traffic"
}







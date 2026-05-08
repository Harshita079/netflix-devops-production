# main.tf

resource "aws_security_group" "main" {
  name        = "${var.project_name}-sg"
  description = "Production Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH Access"

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Access"

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins Access"

    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}
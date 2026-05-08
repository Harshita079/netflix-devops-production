# main.tf

resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name

  subnet_id                   = var.subnet_id

  vpc_security_group_ids      = [var.security_group_id]

  associate_public_ip_address = true

  user_data                   = var.user_data

  tags = {
    Name = "${var.project_name}-${var.instance_name}"
  }
}

resource "aws_eip" "main" {
  instance = aws_instance.main.id

  tags = {
    Name = "${var.project_name}-${var.instance_name}-eip"
  }
}
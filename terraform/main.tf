data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    #values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "consul1" {
  ami = data.aws_ami.latest-ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.consul.name]

  lifecycle {
    ignore_changes = [user_data, ami]
  }

  tags = {
    Name = "consul1"
  }

  user_data = templatefile("userdata.tpl", {
    hostname = var.hostname
  })
}

resource "aws_instance" "consul2" {
  ami = data.aws_ami.latest-ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.consul.name]

  lifecycle {
    ignore_changes = [user_data, ami]
  }

  tags = {
    Name = "consul2"
  }

  user_data = templatefile("userdata.tpl", {
    hostname = var.hostname
  })
}

resource "aws_instance" "consul3" {
  ami = data.aws_ami.latest-ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  security_groups = [aws_security_group.consul.name]

  lifecycle {
    ignore_changes = [user_data, ami]
  }

  tags = {
    Name = "consul3"
  }

  user_data = templatefile("userdata.tpl", {
    hostname = var.hostname
  })
}

resource "aws_security_group" "consul" {
  name        = var.hostname
  description = "Allow consul inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.166.0.0/16"]
  }

  ingress {
    description = "consul"
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["73.166.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "consul"
  }
}

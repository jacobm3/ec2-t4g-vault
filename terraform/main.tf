data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    #values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
    #values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "vault" {
  ami = data.aws_ami.latest-ubuntu.id

  # t4g.nano: 2vpu, 512MB ram, ebs = $0.0042/hr = $0.10/day = $3/month

  # t3a.large; 2 vcpu, 8GB ram, ebs = $1.80/day
  # m5d.large; 2 vcpu, 8GB ram, nvme = $2.70/day
  # m5d.xlarge; 4 vcpu, 16GB ram, nvme = $5.42/day
  # m6a.large; 2 vcpu, 8GB ram, ebs = $2.07/day
  # c6a.xlarge: 4 vcpu, 8GB ram, ebs = $3.67/day

  instance_type = "t4g.nano"
  key_name      = var.key_name

  security_groups = [aws_security_group.vault.name]

  lifecycle {
    ignore_changes = [user_data, ami]
  }

  tags = {
    Name = var.hostname
  }

  user_data = templatefile("userdata.tpl", {
    hostname = var.hostname
  })

}

resource "aws_security_group" "vault" {
  name        = "vault.t4g"
  description = "Allow vault inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["73.166.0.0/16"]
  }

  ingress {
    description = "vault"
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
    Name = "vault"
  }
}

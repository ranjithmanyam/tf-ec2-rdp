provider "aws" {
  region = "ap-south-1"
}

variable "ingress_cidr_block" {
  description = "Your IP"
  type = list(string)
}

variable "instance_password" {
  description = "Password for the instance"
  default     = "default-password"
  sensitive = true
}

variable "ubuntu_version" {
  default = "22.04"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-${var.ubuntu_version}-amd64-*"]
  }

  filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "ssh_key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security Group for RDP and SSH
resource "aws_security_group" "gui_sg" {
  name        = "gui-instance-sg"
  description = "Allow RDP and SSH"

  ingress {
    description = "Allow RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_block
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.ssh_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.gui_sg.id]

  user_data = templatefile("user-data.sh", { instance_password = var.instance_password })
  tags = {
    Name = "ubuntu"
  }
}

output "public_ip" {
  value = aws_instance.ubuntu.public_ip
}

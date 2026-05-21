terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server1" {
  ami               = "ami-0e12ffc2dd465f6e4"
  availability_zone = "ap-south-1a"
  instance_type     = "t3.micro"
}

resource "aws_eip" "staticip" {
  instance = aws_instance.server1.id

 provisioner "local-exec" {
    command = <<EOT
      sudo ssh-keygen -R ${self.public_ip}
      sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${self.public_ip}, playbook.yaml -u ec2-user --private-key /home/ec2-user/docker.pem
    EOT
  }
}

output "aws_eip" {
    value = aws_instance.server1.public_ip
}

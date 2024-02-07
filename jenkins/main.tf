provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_jenkins_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jenkins-*"]
  }

  filter {
    name   = "tag:Name"
    values = ["Jenkins - *"]
  }

  owners = ["self"] 
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
    Name = "Jenkins"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami             = data.aws_ami.latest_jenkins_ami.id
  instance_type   = "t2.small"
  security_groups = [aws_security_group.jenkins_sg.name]

  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "This is the end, beautifull friend the end."
  #             EOF

  tags = {
    Name = "JenkinsInstance"
  }
}

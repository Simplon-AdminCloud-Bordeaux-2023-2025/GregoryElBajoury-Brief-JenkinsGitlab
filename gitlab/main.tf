provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest_gitlab_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["gitlab-*"]
  }

  filter {
    name   = "tag:Name"
    values = ["Gitlab - *"]
  }

  owners = ["self"] 
}

resource "aws_security_group" "gitlab_sg" {
  name        = "gitlab-sg"
  description = "Security group for GitLab server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8181
    to_port     = 8181
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
    Name = "Gitlab"
  }
}

resource "aws_instance" "gitlab_instance" {
  ami             = data.aws_ami.latest_gitlab_ami.id
  instance_type   = "t2.xlarge"
  security_groups = [aws_security_group.gitlab_sg.name]

  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "This is the end, beautifull friend the end."
  #             EOF

  tags = {
    Name = "GitlabInstance"
  }
}

#           _____                    _____                   _______                  _______               _____          
#          /\    \                  /\    \                 /::\    \                /::\    \             /\    \         
#         /::\    \                /::\    \               /::::\    \              /::::\    \           /::\    \        
#        /::::\    \              /::::\    \             /::::::\    \            /::::::\    \          \:::\    \       
#       /::::::\    \            /::::::\    \           /::::::::\    \          /::::::::\    \          \:::\    \      
#      /:::/\:::\    \          /:::/\:::\    \         /:::/~~\:::\    \        /:::/~~\:::\    \          \:::\    \     
#     /:::/  \:::\    \        /:::/__\:::\    \       /:::/    \:::\    \      /:::/    \:::\    \          \:::\    \    
#    /:::/    \:::\    \      /::::\   \:::\    \     /:::/    / \:::\    \    /:::/    / \:::\    \         /::::\    \   
#   /:::/    / \:::\    \    /::::::\   \:::\    \   /:::/____/   \:::\____\  /:::/____/   \:::\____\       /::::::\    \  
#  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\____\ |:::|    |     |:::|    ||:::|    |     |:::|    |     /:::/\:::\    \ 
# /:::/____/  ___\:::|    |/:::/  \:::\   \:::|    ||:::|____|     |:::|    ||:::|____|     |:::|    |    /:::/  \:::\____\
# \:::\    \ /\  /:::|____|\::/   |::::\  /:::|____| \:::\    \   /:::/    /  \:::\    \   /:::/    /    /:::/    \::/    /
#  \:::\    /::\ \::/    /  \/____|:::::\/:::/    /   \:::\    \ /:::/    /    \:::\    \ /:::/    /    /:::/    / \/____/ 
#   \:::\   \:::\ \/____/         |:::::::::/    /     \:::\    /:::/    /      \:::\    /:::/    /    /:::/    /          
#    \:::\   \:::\____\           |::|\::::/    /       \:::\__/:::/    /        \:::\__/:::/    /    /:::/    /           
#     \:::\  /:::/    /           |::| \::/____/         \::::::::/    /          \::::::::/    /     \::/    /            
#      \:::\/:::/    /            |::|  ~|                \::::::/    /            \::::::/    /       \/____/             
#       \::::::/    /             |::|   |                 \::::/    /              \::::/    /                            
#        \::::/    /              \::|   |                  \::/____/                \::/____/                             
#         \::/____/                \:|___|                   ~~                       ~~                                   
#  
#
#
# Le 07 février 2024 - 
/*
Ce script Terraform permet de créer une instance EC2 pour GitLab dans AWS. Il commence par spécifier le fournisseur AWS et la région,
puis récupère l'AMI la plus récente pour GitLab à partir de vos propres images. 
Ensuite, il définit un groupe de sécurité avec des règles d'entrée pour le trafic SSH, HTTP, HTTPS et 8181, ainsi qu'une règle de sortie autorisant tout le trafic.
Enfin, il crée une instance EC2 en utilisant l'AMI récupérée et associe le groupe de sécurité à cette instance.
*/

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
  #             echo "Je s'appelle GrOoT"
  #             EOF

  tags = {
    Name = "GitlabInstance"
  }
}

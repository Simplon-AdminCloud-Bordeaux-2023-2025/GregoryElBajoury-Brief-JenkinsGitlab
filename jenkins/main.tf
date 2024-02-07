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
# Le 05 février 2024 

# Ce script Terraform permet de créer une instance EC2 pour Jenkins dans AWS. Il commence par spécifier le fournisseur AWS et la région,
# puis récupère l'AMI la plus récente pour Jenkins à partir de vos propres images. 
# Ensuite, il définit un groupe de sécurité avec des règles d'entrée pour le trafic SSH et HTTP, ainsi qu'une règle de sortie autorisant tout le trafic.
# Enfin, il crée une instance EC2 en utilisant l'AMI récupérée et associe le groupe de sécurité à cette instance.

# Définition du fournisseur AWS et spécification de la région
provider "aws" {
  region = "us-east-1"
}

# Récupération de l'AMI la plus récente pour Jenkins
data "aws_ami" "latest_jenkins_ami" {
  most_recent = true

# Filtres pour rechercher l'AMI Jenkins
  filter {
    name   = "name"
    values = ["jenkins-*"]
  }

  filter {
    name   = "tag:Name"
    values = ["Jenkins - *"]
  }

# Propriétaire de l'AMI (auto)
  owners = ["self"] 
}

# Définition du groupe de sécurité pour Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"

# Règles d'entrée pour le trafic SSH et HTTP
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

# Règle de sortie autorisant tout le trafic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Tags pour le groupe de sécurité
  tags = {
    Name = "Jenkins"
  }
}

# Définition de l'instance EC2 pour Jenkins
resource "aws_instance" "jenkins_instance" {
  ami             = data.aws_ami.latest_jenkins_ami.id
  instance_type   = "t2.small"
  security_groups = [aws_security_group.jenkins_sg.name]

  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "This is the end, beautifull friend the end."
  #             EOF

# Tags pour l'instance EC2
  tags = {
    Name = "JenkinsInstance"
  }
}

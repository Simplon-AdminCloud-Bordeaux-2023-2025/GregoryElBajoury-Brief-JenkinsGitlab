#!/bin/bash

# Mise à jour des paquets
sudo apt-get update -y

# Installation des dépendances
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Téléchargement du package GitLab
curl -LO https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh

# Exécution du script d'installation de GitLab
sudo bash script.deb.sh

# Installation de GitLab Community Edition
sudo apt-get install -y gitlab-ce

# Démarrage des services GitLab
sudo gitlab-ctl reconfigure


#!/bin/bash

# Mise à jour des paquets disponibles pour l'installation
sudo apt-get update -y

# Installation de Java Development Kit (JDK) version 17
sudo apt-get install openjdk-17-jdk -y

# Téléchargement et ajout de la clé GPG du dépôt Jenkins au trousseau de clés du système
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Ajout du dépôt Jenkins dans la liste des sources de paquets du système
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Mise à jour de la liste des paquets disponibles après l'ajout du dépôt Jenkins
sudo apt-get update -y

# Installation du paquet Jenkins
sudo apt-get install jenkins -y

# Activation du service Jenkins pour qu'il démarre automatiquement au démarrage du système
sudo systemctl enable jenkins

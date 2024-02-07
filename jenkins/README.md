# Déploiement Jenkins avec Terraform et Packer

### Ce dépôt contient les fichiers nécessaires pour déployer Jenkins sur AWS en utilisant Terraform pour la gestion de l'infrastructure et Packer pour la création de l'image AMI.

## Prérequis

### Assurez-vous d'avoir les éléments suivants avant de commencer :

- Compte AWS avec les clés d'accès nécessaires
- Terraform installé localement
- Packer installé localement

## Configuration

### Clonez ce dépôt sur votre machine locale :

```
git clone https://github.com/Simplon-AdminCloud-Bordeaux-2023-2025/GregoryElBajoury-Brief-JenkinsGitlab.git
```
### Assurez-vous d'avoir les variables d'environnement AWS_ACCESS_KEY_ID et AWS_SECRET_ACCESS_KEY configurées avec les clés d'accès appropriées.

### Modifiez le fichier vars.json avec vos informations d'identification AWS :

```
{
    "aws_access_key": "VOTRE_AWS_ACCESS_KEY",
    "aws_secret_key": "VOTRE_AWS_SECRET_KEY",
    "ssh_username": "ubuntu"
}
```

## Déploiement de l'infrastructure

### Utilisez Packer pour créer l'image AMI Jenkins en exécutant la commande suivante :

`packer build -var-file=vars.json jenkins.json
`

### Utilisez Terraform pour déployer l'instance Jenkins en exécutant les commandes suivantes :

```
cd main
terraform init
terraform apply
```
### Suivez les invites pour confirmer le déploiement.

## Accès à Jenkins

### fois le déploiement terminé, vous pouvez accéder à Jenkins via le navigateur en utilisant l'adresse IP publique de l'instance EC2 déployée et son port Jenkins (8080).

```
xxx.xxx.xxx.xxx:8080
```

## Maintenance et Gestion

### Assurez-vous de maintenir vos clés d'accès AWS en sécurité et de ne pas les divulguer publiquement.

### Surveillez l'état de votre infrastructure et des services déployés pour détecter les problèmes éventuels.





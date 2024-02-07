# Déploiement Jenkins avec Terraform et Packer

### Ce dépôt contient les fichiers nécessaires pour déployer Jenkins sur AWS en utilisant Terraform pour la gestion de l'infrastructure et Packer pour la création de l'image AMI.

## Prérequis

### Assurez-vous d'avoir les éléments suivants avant de commencer :

- Compte AWS avec les clés d'accès nécessaires (AWS Access Key et AWS Secret Key)
- Terraform installé localement
- Packer installé localement

### Fonction des Fichiers
  
- <a href="vars.json" target="_blank">vars.json</a>
 : Ce fichier contient les variables d'environnement nécessaires pour l'authentification AWS. Il est utilisé par Packer lors de la création de l'image AMI Jenkins.

- <a href="jenkins.json" target="_blank">jenkins.json</a> : Ce fichier est utilisé par Packer pour créer l'image AMI Jenkins sur AWS. Il définit les variables telles que la région, le type d'instance, et les scripts de provisionnement à exécuter.

- <a href="script.sh" target="_blank">script.sh</a> : Ce script Shell est utilisé par Packer pour provisionner l'image AMI Jenkins. Il met à jour le système, installe Java, télécharge la clé de signature de Jenkins et ajoute le référentiel Jenkins avant d'installer Jenkins et d'activer le service.

- <a href="main.tf" target="_blank">main.tf</a> : Ce fichier est utilisé par Terraform pour déployer l'infrastructure AWS nécessaire pour l'instance Jenkins. Il crée un groupe de sécurité avec les règles d'accès appropriées et déploie l'instance EC2 Jenkins en utilisant l'AMI créée par Packer.

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

### Une fois le déploiement terminé, vous pouvez accéder à Jenkins via le navigateur en utilisant l'adresse IP publique de l'instance EC2 déployée et son port Jenkins (8080).

```
xxx.xxx.xxx.xxx:8080
```

## Maintenance et Gestion

### Assurez-vous de maintenir vos clés d'accès AWS en sécurité et de ne pas les divulguer publiquement.

### Surveillez l'état de votre infrastructure et des services déployés pour détecter les problèmes éventuels.





# Déploiement de Jenkins avec Terraform et Packer sur AWS (EN EDITION)

### Ce dépôt contient les fichiers nécessaires pour déployer Gitlab sur AWS en utilisant Terraform pour la gestion de l'infrastructure et Packer pour la création de l'image AMI.

## Prérequis ⚠️

### Assurez-vous d'avoir les éléments suivants avant de commencer :

- Compte AWS avec les clés d'accès nécessaires (AWS Access Key et AWS Secret Key)
- Terraform installé localement
- Packer installé localement

### Fonction des Fichiers
  
- <a href="vars.json" target="_blank">vars.json</a>
 : Ce fichier contient les variables d'environnement nécessaires pour l'authentification AWS. Il est utilisé par Packer lors de la création de l'image AMI Gitlab. C'est içi que vous assignez votre access key et votre secret key.

- <a href="gitlab.json" target="_blank">gitlab.json</a> : Ce fichier est utilisé par Packer pour créer l'image AMI Gitlab sur AWS. Il définit les variables telles que la région, le type d'instance, et les scripts de provisionnement à exécuter.

- <a href="script.sh" target="_blank">script.sh</a> : Ce script Shell est utilisé par Packer pour provisionner l'image AMI Gitlab. Il commence par mettre à jour les paquets système, installe les dépendances nécessaires comme curl et openssh-server, télécharge le script d'installation de GitLab depuis le référentiel GitLab, puis exécute ce script pour configurer les référentiels requis. Ensuite, il installe GitLab Community Edition via apt-get et démarre les services GitLab en utilisant la commande gitlab-ctl reconfigure pour appliquer les configurations.

- <a href="main.tf" target="_blank">main.tf</a> : Ce fichier est utilisé par Terraform pour déployer l'infrastructure AWS nécessaire pour l'instance Gitlab. Il crée un groupe de sécurité avec les règles d'accès appropriées et déploie l'instance EC2 Gitlab en utilisant l'AMI créée par Packer.

## Configuration 👷‍♀️

### Clonez ce dépôt sur votre machine locale :

```
git clone https://github.com/Simplon-AdminCloud-Bordeaux-2023-2025/GregoryElBajoury-Brief-JenkinsGitlab.git
```
### Choix 1 - Utiliser les variables d'environnement AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY configurées avec les clés d'accès appropriées. 

### Pour exporter vos clés dans des variables d'environnement :

### Ouvrir un terminal puis entrez ces commandes l'une après l'autre:

`export AWS_ACCESS_KEY=votreCleDaccesAWS`

`export AWS_SECRET_KEY=votreCleSecreteAWS`

`export AWS_SSH_USERNAME=votreUsernameSSH`


### Faire un echo de vos variables d'environnement afin de vérifier que tout est en règle :

`echo $AWS_ACCESS_KEY`

En retour vous devriez recevoir la valeur définie auparavant, à savoir votreCleDaccesAWS. Répetez le processus pour les deux autres variables d'environnement restantes.

### Choix 2 - Ne pas utiliser de variables d'environnement

### Modifiez le fichier <a href="vars.json" target="_blank">vars.json</a> avec vos informations d'identification AWS :

```
{
    "aws_access_key": "VOTRE_AWS_ACCESS_KEY",
    "aws_secret_key": "VOTRE_AWS_SECRET_KEY",
    "ssh_username": "ubuntu"
}
```

## Déploiement de l'infrastructure

### dans votre IDE, vous rendre dans le répertoire `gitlab` du repo. Utilisez Packer pour créer l'image AMI Jenkins en exécutant la commande suivante :

`packer build -var-file=vars.json jenkins.json
`

### Utilisez Terraform pour déployer l'instance Gitlab en exécutant les commandes suivantes, l'une après l'autre :

`terraform init`

`terraform plan`

`terraform apply`
### Suivez les invites pour confirmer le déploiement.

## Accès à Gitlab

### Une fois le déploiement terminé, vous pouvez accéder à Jenkins via le navigateur en utilisant l'adresse IP publique de l'instance EC2 déployée et son port Gitlab (8080).

Pour trouver l'adresse IP de la machine fraîchement créée :

- Rendez-vous sur le portail AWS, identifiez vous puis accedez à la liste de vos instances ;
- Identifiez la machine puis récupérez son ip publique ;
- Entrez l'ip publique dans la barre de recherche de votre navigateur, puis ajoutez-y :8080

```
xxx.xxx.xxx.xxx:8080
```

Vous Arriverez sur une page vous indiquant la marche à suivre pour récupérer le mot de passe nécessaire pour accéder à Jenkins.
Il s'agit ni plus ni moins que d'accéder au chemin `/var/lib/jenkins/secrets/initialAdminPaswword`.
Pour ce faire rendez-vous, depuis un terminal de la vm créée, dans le dossier `/var/lib/jenkins/secrets/` puis affichez le fichier `initialAdminPaswword` avec la commande suivante :

```
cd /var/lib/jenkins/secrets/ && cat initialAdminPaswword
```

Copiez le contenu de ce fichier et collez le dans la fenêtre Jenkins de tout à l'heure.

## Félicitations vous avez réussi à déployer Jenkins avec Packer et Terraform 🎆

## Maintenance et Gestion

### Assurez-vous de maintenir vos clés d'accès AWS en sécurité et de ne pas les divulguer publiquement.

### Surveillez l'état de votre infrastructure et des services déployés pour détecter les problèmes éventuels.

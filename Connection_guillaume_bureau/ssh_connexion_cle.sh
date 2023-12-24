#!/bin/bash

# Nom du script : ssh_connexion_clé.sh
# Adresse IP de l'ordinateur distant
adresse_ip="10.117.53.101"

# Nom d'utilisateur sur l'ordinateur distant
utilisateur="guillaume"

# Chemin vers la clé privée SSH sur l'ordinateur local
chemin_cle_privee="/Users/themezeguillaume/.ssh/id_rsa.pub"

# Vérifier si la clé privée existe
if [ ! -f "$chemin_cle_privee" ]; then
    echo "La clé privée SSH ($chemin_cle_privee) n'existe pas. Veuillez suivre ces étapes pour configurer l'authentification SSH par clé :"
    echo
    echo "1. Générez une paire de clés SSH (clé privée et clé publique) sur l'ordinateur local en utilisant la commande suivante :"
    echo "   ssh-keygen -t rsa -b 4096"
    echo
    echo "2. Copiez la clé publique sur l'ordinateur distant en utilisant la commande suivante (remplacez 'utilisateur' par le nom d'utilisateur sur l'ordinateur distant et 'adresse_ip' par son adresse IP) :"
    echo "   ssh-copy-id utilisateur@adresse_ip"
    echo
    echo "3. Une fois la clé publique copiée, vous pourrez vous connecter à l'ordinateur distant sans saisir de mot de passe en utilisant la clé privée :"
    echo "   ssh utilisateur@adresse_ip"
    echo
    echo "L'utilisation de clés SSH est plus sécurisée que de stocker des mots de passe dans des scripts et simplifie également la connexion à l'ordinateur distant. Assurez-vous de sécuriser votre clé privée, car elle est utilisée pour authentifier votre accès à l'ordinateur distant."
    exit 1
fi

# Connexion SSH en utilisant la clé privée
echo "Tentative de connexion SSH à $adresse_ip en tant qu'utilisateur $utilisateur en utilisant la clé SSH..."
ssh -i "$chemin_cle_privee" "$utilisateur@$adresse_ip"

# Vérifier le code de sortie de la connexion SSH
if [ $? -eq 0 ]; then
    echo "Connexion SSH réussie à $adresse_ip avec la clé SSH."
else
    echo "Échec de la connexion SSH à $adresse_ip avec la clé SSH."
fi

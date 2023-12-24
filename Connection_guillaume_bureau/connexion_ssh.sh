#!/bin/bash

# Nom du script : connexion_ssh.sh

# Adresse IP de l'ordinateur distant
adresse_ip="10.117.53.101"

#"192.168.1.100"

# Nom d'utilisateur sur l'ordinateur distant
utilisateur="guillaume"

# Chemin vers la clé privée SSH sur l'ordinateur local
chemin_cle_privee="/Users/themezeguillaume/.ssh/id_rsa"

# Vérifier si la clé privée existe
if [ ! -f "$chemin_cle_privee" ]; then
    echo "La clé privée SSH ($chemin_cle_privee) n'existe pas. Vérification de sshpass..."
    
    # Vérifier si sshpass est installé
    if command -v sshpass &> /dev/null; then
        echo "sshpass est installé. Tentative de connexion SSH avec mot de passe..."
        sshpass -p "atomsheep" ssh "$utilisateur@$adresse_ip"
        #ssh "$utilisateur@$adresse_ip"
        
        # Vérifier le code de sortie de la connexion SSH
        if [ $? -eq 0 ]; then
            echo "Connexion SSH réussie à $adresse_ip avec mot de passe."
        else
            echo "Échec de la connexion SSH à $adresse_ip avec mot de passe."
        fi
    else
        echo "sshpass n'est pas installé et la clé privée SSH n'existe pas. Veuillez générer une clé SSH ou installer sshpass."
        exit 1
    fi
else
    # Connexion SSH en utilisant la clé privée
    echo "Tentative de connexion SSH à $adresse_ip en tant qu'utilisateur $utilisateur en utilisant la clé SSH..."
    ssh -i "$chemin_cle_privee" "$utilisateur@$adresse_ip"
    
    # Vérifier le code de sortie de la connexion SSH
    if [ $? -eq 0 ]; then
        echo "Connexion SSH réussie à $adresse_ip avec la clé SSH."
    else
        echo "Échec de la connexion SSH à $adresse_ip avec la clé SSH."
    fi
fi

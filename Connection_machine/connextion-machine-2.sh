#!/bin/bash

# Fonction pour installer sshpass sur Linux (utilisant apt-get)
install_sshpass_linux() {
    sudo apt-get update
    sudo apt-get install -y sshpass
}

# Fonction pour installer sshpass sur macOS (utilisant Homebrew)
install_sshpass_mac() {
    if ! command -v brew &>/dev/null; then
        echo "Homebrew n'est pas installé. Installation de Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
}

# Déterminer le système d'exploitation
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Système Linux détecté. Installation de sshpass..."
    install_sshpass_linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Système macOS détecté. Installation de sshpass..."
    install_sshpass_mac
else
    echo "Système d'exploitation non pris en charge."
fi

chmod +x sshpass_instal.sh
./sshpass_instal.sh

# Fonction pour afficher le contenu de Léa ou Guillaume
afficher_contenu() {
    local chemin_repertoire
    if [ "$1" == "L" ]; then
        chemin_repertoire="/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea"
    elif [ "$1" == "G" ]; then
        chemin_repertoire="/mnt/data/DonneesEquipePuce/analysedata/analysdata/analyses_jupyter/analyses_Guillaume"
    else
        echo "Choix invalide. Vous devez entrer 'L' pour Léa ou 'G' pour Guillaume."
        exit 1
    fi

    echo "Chemin du répertoire : $chemin_repertoire"
    # Affiche le contenu du répertoire
    #sshpass -p "$password" ssh equipepuce@10.117.51.227 "ls -l $chemin_repertoire"
    ssh equipepuce@10.117.51.227
    "cd $chemin_repertoire"
}

# Mot de passe SSH
password="isabellenoeud9L"

# Adresse IP ou nom d'hôte de la machine distante
adresse_distante="10.117.48.25"

# Nom d'utilisateur sur la machine distante
utilisateur_distante="isabellebouchoule"

# Fonction pour copier un dossier depuis equipepuce@10.117.51.227
copier_dossier() {
    local chemin_source="$1"
    local chemin_destination="$2"
    
    echo "Copie du dossier en cours..."
    scp -r equipepuce@10.117.51.227:"$chemin_source" "$chemin_destination"
    echo "Dossier copié avec succès."
}



echo "Voulez-vous vous connecter à l'ordinateur equipepuce (C) ou copier un dossier (D) ?"
read choix

if [ "$choix" == "C" ]; then
    # Demander à l'utilisateur s'il veut afficher le contenu de Léa ou Guillaume
    echo "Voulez-vous afficher le contenu de Léa (L) ou Guillaume (G) ?"
    read contenu_choice
    afficher_contenu "$contenu_choice"
    
    # Connexion SSH à $utilisateur_distante @ $adresse_distante
    echo "Connexion à $utilisateur_distante @ $adresse_distante"
    sshpass -p "$password" $utilisateur_distante @ $adresse_distante "cd $chemin_repertoire; exec \$SHELL -l"
    
elif [ "$choix" == "D" ]; then
    # Demander à l'utilisateur s'il veut afficher le contenu de Léa ou Guillaume
    echo "Voulez-vous afficher le contenu de Léa (L) ou Guillaume (G) ?"
    read contenu_choice
    afficher_contenu "$contenu_choice"

    echo "Combien de dossiers souhaitez-vous copier ?"
    read nombre_dossiers

    for ((i = 1; i <= nombre_dossiers; i++)); do
        echo "Dossier $i :"
        echo "Quel est le chemin du dossier sur equipepuce@10.117.51.227 que vous souhaitez copier ?"
        echo "Chemin : $chemin_repertoire"
        read chemin_source
        echo "Où voulez-vous stocker les fichiers/copiés localement ?"
        echo "Bureau : /Users/themezeguillaume/Desktop/"
        read chemin_destination
        copier_dossier "$chemin_source" "$chemin_destination"
    done
else
    echo "Choix invalide. Veuillez entrer 'C' pour vous connecter ou 'D' pour copier un dossier."
fi

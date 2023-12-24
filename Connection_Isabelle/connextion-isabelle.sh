# Afficher un message de connexion
#echo 'Connexion à equipepuce@10.117.51.227'

# Afficher le mot de passe (à des fins d'identification, bien que cela ne soit pas recommandé dans un script)
#echo 'Mot de passe : PuceRubidium87'

# Établir une connexion SSH avec le serveur distant (10.117.51.227) en utilisant le nom d'utilisateur equipepuce
#ssh equipepuce@10.117.51.227
#cd ../../mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume

# Lancer une copie sécurisée (SCP) pour copier des fichiers et répertoires du serveur distant vers le dossier local.
# "-r" indique la copie récursive (pour les répertoires).
#equipepuce@10.117.51.227:/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume
# est le chemin sur le serveur distant que vous souhaitez copier.
# /Users/themezeguillaume/Desktop/Etude2023/PHD/
# est le dossier local où les fichiers/copiés seront stockés.
#scp -r equipepuce@10.117.51.227:/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume/ /Users/themezeguillaume/Desktop/Etude2023/PHD/

#!/bin/bash

echo "Voulez-vous vous connecter à l'ordinateur equipepuce (C) ou copier un dossier (D) ?"
read choix

if [ "$choix" == "C" ]; then
    # Connexion SSH à equipepuce@10.117.51.227
    echo "Connexion à equipepuce@10.117.51.227"
    echo 'Mot de passe : PuceRubidium87'
    ssh equipepuce@10.117.51.227
    cd ../../mnt/data/DonneesEquipePuce/analysedata/analysdata/analyses_jupyter/analyses_Guillaume
elif [ "$choix" == "D" ]; then
    # Liste des fichiers dans le répertoire distant
    echo "Liste des fichiers dans le répertoire distant :"
    echo 'Mot de passe : PuceRubidium87'
    ssh equipepuce@10.117.51.227 "ls -l /mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume"
    
    # Copier un dossier depuis equipepuce@10.117.51.227
    echo "Copie sécurisée (SCP) depuis equipepuce@10.117.51.227 vers le dossier local."
    echo "Quel est le chemin du dossier sur equipepuce@10.117.51.227 que vous souhaitez copier ?"
    echo "Chemin :/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume"
    read chemin_source
    echo "Où voulez-vous stocker les fichiers/copiés localement ?"
    echo "Bureau : /Users/themezeguillaume/Desktop/"
    read chemin_destination
    echo 'Mot de passe : PuceRubidium87'

    scp -r equipepuce@10.117.51.227:"$chemin_source" "$chemin_destination"
else
    echo "Choix invalide. Veuillez entrer 'C' pour vous connecter ou 'D' pour copier un dossier."
fi

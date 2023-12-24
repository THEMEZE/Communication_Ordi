#!/bin/bash

sudo apt-get update
sudo apt-get install -y sshpass

# Mot de passe SSH
#password="PuceRubidium87"

# Chemins sources
chemins_source=(
    "/home/guillaume/Documents/"
   "/media/OA-Data/LogCicero/C/Users/Puce/Desktop/"
)

# Adresse IP ou nom d'hôte de la machine distante
adresse_distante="10.117.51.101"

# Nom d'utilisateur sur la machine distante
utilisateur_distante="guillaume"

chemin_destination="/Users/themezeguillaume/Desktop/Etude2023/PHD/Etudes/Ordi_Programmation/"

# Boucle pour copier les dossiers
if [ -n "$password" ]; then
    for chemin_source in "${chemins_source[@]}"; do
        echo "Copie de $chemin_source vers $chemin_destination"
        sshpass -p "$password" scp -r "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        echo "Dossier copié avec succès."
    done
else
    for chemin_source in "${chemins_source[@]}"; do
        echo "Copie de $chemin_source vers $chemin_destination"
        echo "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        scp -r "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        echo "Dossier copié avec succès."
    done
fi

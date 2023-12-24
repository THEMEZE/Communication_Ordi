#!/bin/bash

sudo apt-get update
sudo apt-get install -y sshpass

# Mot de passe SSH (si nécessaire)
#password="PuceRubidium87"

# Chemins sources locaux
chemins_source=(
    "/Users/themezeguillaume/Desktop/Documents_Clef/Traveaux/PHD/Etudes/Ordi_Programmation"
)

# Adresse IP ou nom d'hôte de la machine distante
adresse_distante="10.117.51.227"

# Nom d'utilisateur sur la machine distante
utilisateur_distante="equipepuce"

# Chemin de destination sur la machine distante
chemin_destination="/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume/"

echo "Copie des fichiers vers $adresse_distante:$chemin_destination"

# Utilisation de scp pour copier les fichiers vers la machine distante
if [ -n "$password" ]; then
    for chemin_source in "${chemins_source[@]}"; do
        echo "Copie de $chemin_source vers $adresse_distante:$chemin_destination"
        sshpass -p "$password" scp -r "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        echo "Fichier copié avec succès."
    done
else
    for chemin_source in "${chemins_source[@]}"; do
        echo "Copie de $chemin_source vers $adresse_distante:$chemin_destination"
        echo "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        scp -r "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        echo "Fichier copié avec succès."
    done
fi

echo "Tous les fichiers ont été copiés avec succès."

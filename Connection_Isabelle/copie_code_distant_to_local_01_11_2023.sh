#!/bin/bash

#sudo apt-get update
#sudo apt-get install -y sshpass

brew update
#brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb

# Installer sshpass s'il n'est pas déjà installé
if ! command -v sshpass &> /dev/null
then
    echo "sshpass n'est pas installé. Installation en cours..."
    brew install http://git.io/sshpass.rb
fi


# Mot de passe SSH
password="PuceRubidium87"

# Chemins sources
chemins_source=(
   "/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume"
   "/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea"
   "/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyse_DR_2022/parameters.py"
   "/mnt/data/DonneesEquipePuce/analysedata/2023-10-04/scan059"
   "/media/pucemanip/manip/data/2023-10-04/scan059"
)

# Chemins de destination correspondants
chemins_destination=(
   "/Users/themezeguillaume/Documents/Ordi_Isa/"
   "/Users/themezeguillaume/Documents/Ordi_Isa/"
   "/Users/themezeguillaume/Documents/Ordi_Isa/Donnees/"
   "/Users/themezeguillaume/Documents/Ordi_Isa/Donnees/mnt/"
   "/Users/themezeguillaume/Documents/Ordi_Isa/Donnees/media/"
)

# Liste des dossiers à exclure pour chaque chemin source
dossiers_a_exclure=(
   "Figures-Resultat"
   ""
   ""
   ""
   ""
)

# Adresse IP ou nom d'hôte de la machine distante
adresse_distante="10.117.51.227"

# Nom d'utilisateur sur la machine distante
utilisateur_distante="equipepuce"

if [ -n "$password" ]; then
    for i in "${!chemins_source[@]}"; do
        chemin_source="${chemins_source[$i]}"
        chemin_destination="${chemins_destination[$i]}"
        
        # Récupérer la liste des dossiers à exclure pour ce chemin source
        dossiers_exclure=("${dossiers_a_exclure[$i]}")
        
        exclude_args=()
        for dossier in "${dossiers_exclure[@]}"; do
            exclude_args+=("--exclude=$dossier")
        done

        echo "Copie de $chemin_source vers $chemin_destination (en excluant ${dossiers_exclure[@]})"
        sshpass -p "$password" rsync -av "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        echo "Dossier copié avec succès."
    done
else
    for i in "${!chemins_source[@]}"; do
        chemin_source="${chemins_source[$i]}"
        chemin_destination="${chemins_destination[$i]}"
        
        # Récupérer la liste des dossiers à exclure pour ce chemin source
        dossiers_exclure=("${dossiers_a_exclure[$i]}")
        
        exclude_args=()
        for dossier in "${dossiers_exclure[@]}"; do
            exclude_args+=("--exclude=$dossier")
        done

        echo "Copie de $chemin_source vers $chemin_destination (en excluant ${dossiers_exclure[@]})"
        rsync -av "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        echo "Dossier copié avec succès."
    done
fi

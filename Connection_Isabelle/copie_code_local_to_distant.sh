#!/bin/bash

#sudo apt-get update
#sudo apt-get install -y sshpass

brew update

brew install rsync

#brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb

#brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb

# Installer sshpass s'il n'est pas déjà installé
if ! command -v sshpass &> /dev/null
then
    echo "sshpass n'est pas installé. Installation en cours..."
    brew install http://git.io/sshpass.rb
fi

# Mot de passe SSH
password="PuceRubidium87"

# Chemins sources (maintenant, ils correspondent aux fichiers sur l'ordinateur distant)
chemins_source=(
   "/Users/themezeguillaume/Documents/Ordi_Isa/analyses_Guillaume/Traitement_Franges"
)

# Chemins de destination correspondants (maintenant, ils correspondent aux emplacements locaux)
chemins_destination=(
   "/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume/"
)

# Liste des dossiers à exclure pour chaque chemin source
dossiers_a_exclure=(
   "Figures-Resultat"
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

        echo "Copie des modifications de $chemin_source vers $chemin_destination (en excluant ${dossiers_exclure[@]})"
        sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
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

        echo "Copie des modifications de $chemin_source vers $chemin_destination (en excluant ${dossiers_exclure[@]})"
        rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        echo "Dossier copié avec succès."
    done
fi

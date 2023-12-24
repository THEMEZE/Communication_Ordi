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
password="isabellenoeud9L"

# Chemins sources
chemins_source=(
    "/home/isabellebouchoule/Puce/analysedata/analyses_jupyter/analyses_Guillaume"
    "/home/isabellebouchoule/Puce/analysedata/analyses_jupyter/analyses_Lea"
)

# Chemins de destination correspondants
chemins_destination=(
    "/Users/themezeguillaume/Documents/Ordi_Isa"
    "/Users/themezeguillaume/Documents/Ordi_Isa"
)

# Liste des dossiers à exclure pour chaque chemin source
dossiers_a_exclure=(
    ""
    ""
)

# Adresse IP ou nom d'hôte de la machine distante
adresse_distante="10.117.48.25"

# Nom d'utilisateur sur la machine distante
utilisateur_distante="isabellebouchoule"

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
        sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
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
        rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        echo "Dossier copié avec succès."
    done
fi

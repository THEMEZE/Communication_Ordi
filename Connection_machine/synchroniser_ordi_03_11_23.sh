#!/bin/bash


# Liste de répertoires et dossiers à exclure
Liste_repertoires=(
    "utilisateurs A B C"
    "adresses_ip IP_A 192.168.0.24 IP_C"
    "mot_de_passe_ssh password_A password_B password_C"
    "repertoire1 rep_A1 rep_B1 rep_C1 Exc_11 Exc_12"
    "repertoire2 rep_A2 rep_B2 rep_C2 Exc_21 Exc_22"
    "repertoire3 rep_A3 rep_B3 rep_C3 Exc_31 Exc_32 Exc_33"
)

# a revoir
for ((k = 0; k < 0; k++)); do
    IFS=' ' read -ra elements <<< "${Liste_repertoires[$k]}"
    nom_variable="${elements[0]}"
    valeurs=("${elements[@]:1}")  # Supprime le premier élément

    # Utiliser un tableau pour stocker les valeurs avec des indices
    declare -a "${nom_variable}=(${valeurs[@]})"
    
    # Afficher tous les éléments
    for element in "${!nom_variable}"; do
        echo "Élément : $element"
    done
    
    # Afficher la longueur de la liste d'éléments
    echo "Longueur : ${#valeurs[@]}"
done

IFS=' ' read -ra elements <<< "${Liste_repertoires[0]:1}"
utilisateurs=("${elements[@]:1}")
IFS=' ' read -ra elements <<< "${Liste_repertoires[1]:1}"
adresses_ip=("${elements[@]:1}")
IFS=' ' read -ra elements <<< "${Liste_repertoires[2]:1}"
mot_de_passe_ssh=("${elements[@]:1}")
# Accéder aux valeurs d'une variable spécifique (par exemple, mot_de_passe_ssh)

for element in "${utilisateurs[@]}"; do
    echo "Élément : $element"
done

for element in "${adresses_ip[@]}"; do
    echo "Élément : $element"
done

for element in "${mot_de_passe_ssh[@]}"; do
    echo "Élément : $element"
done

# Paramètres généraux
nb_ordi=${#adresses_ip[@]}

# Vérifier que les longueurs des tableaux sont égales
if [ ${#adresses_ip[@]} -eq ${#utilisateurs[@]} ] && [ ${#utilisateurs[@]} -eq ${#mot_de_passe_ssh[@]} ]; then
    echo "Les longueurs des tableaux sont égales."
else
    echo "Les longueurs des tableaux ne sont pas égales."
fi


# Installer sshpass s'il n'est pas déjà installé
if ! command -v sshpass &> /dev/null
then
    echo "sshpass n'est pas installé. Installation en cours..."
    brew install http://git.io/sshpass.rb
fi

# Fonction pour copier depuis une machine locale  vers une machine distante
function expoter_locale_to_distant() {
    local utilisateur_distante="$1"
    local adresse_distante="$2"
    local chemin_source="$3"
    local chemin_destination="$4"
    local password="$5"
    local dossiers_a_exclure=("${@:6}")

    exclude_args=()
    for dossier in "${dossiers_a_exclure[@]}"; do
        exclude_args+=("--exclude=$dossier")
    done

    echo "Copie des modifications de $chemin_source vers $chemin_destination de l'adresse $adresse_distante (en excluant ${dossiers_a_exclure[@]})"
    
    # Définir une deuxième condition (par exemple, la longueur du mot de passe doit être supérieure à 5)
    length_condition=$((${#password} > 5))
    
    # Vérifier si la variable password n'est pas égale à "vide" et que la longueur est supérieure à 5
    if [ -n "$password"  ] && [ "$password" != "vide" ] && [ "$length_condition" -eq 1 ]; then
        sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        echo "Dossier copié avec succès."
    
    echo "Système d'exploitation : $(uname -s)"
    # Utilisation de rsync pour Linux/macOS
    elif [ "$(uname -s)" == "Linux" ] || [ "$(uname -s)" == "Darwin" ]; then
        #rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        echo "Dossier copié avec succès."
        
    # Utilisation de Robocopy pour Windows
    elif [ "$(uname -s)" == "CYGWIN"* ] || [ "$(uname -s)" == "MINGW"* ]; then
        robocopy "$chemin_source" "\\$adresse_distante\$utilisateur_distante\$chemin_destination" /MIR
        echo "Dossier copié avec succès."
        
    else
        echo "Système d'exploitation non pris en charge."
        exit 1
    fi
    
    
}


# Fonction pour copier depuis une machine distante vers une machine locale
function importer_distant_to_local() {
    local utilisateur_distante="$1"
    local adresse_distante="$2"
    local chemin_source="$3"
    local chemin_destination="$4"
    local password="$5"
    local dossiers_a_exclure=("${@:6}")

    exclude_args=()
    for dossier in "${dossiers_a_exclure[@]}"; do
        exclude_args+=("--exclude=$dossier")
    done

    echo "Copie des modifications de $chemin_source depuis $adresse_distante vers $chemin_destination (en excluant ${dossiers_a_exclure[@]})"
    
    # Récupérer la liste des dossiers à exclure pour ce chemin source
    dossiers_exclure=("${dossiers_a_exclure[$i]}")
    exclude_args=()
    for dossier in "${dossiers_exclure[@]}"; do
        exclude_args+=("--exclude=$dossier")
    done
    
    echo "Copie des modifications de $chemin_source vers $chemin_destination (en excluant ${dossiers_exclure[@]})"
    
    # Définir une deuxième condition (par exemple, la longueur du mot de passe doit être supérieure à 5)
    length_condition=$((${#password} > 5))
    
    # Vérifier si la variable password n'est pas égale à "vide" et que la longueur est supérieure à 5
    if [ -n "$password"  ] && [ "$password" != "vide" ] && [ "$length_condition" -eq 1 ]; then
        sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_destination" "$chemin_source"
        echo "Dossier copié avec succès."
    
    echo "Système d'exploitation : $(uname -s)"
    # Utilisation de rsync pour Linux/macOS
    elif [ "$(uname -s)" == "Linux" ] || [ "$(uname -s)" == "Darwin" ]; then
        #rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_destination" "$chemin_source"
        echo "Dossier copié avec succès."
        
    # Utilisation de Robocopy pour Windows
    elif [ "$(uname -s)" == "CYGWIN"* ] || [ "$(uname -s)" == "MINGW"* ]; then
        robocopy "\\$adresse_distante\$utilisateur_distante\$chemin_destination" "$chemin_source"  /MIR
        echo "Dossier copié avec succès."
        
    else
        echo "Système d'exploitation non pris en charge."
        exit 1
    fi
    
    
}


function synchroniser_depuis_local() {

    # Récupérer l'adresse IP de l'ordinateur local
    adresse_locale=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n 1)

    echo "adresse_locale $adresse_locale"

    # Vérifier si l'adresse IP locale est présente dans la liste
    if [[ " ${adresses_ip[@]} " =~ " $adresse_locale " ]] && [ '1' == '1' ]; then

        # Récupérer l'indice correspondant
        j=0
        for ip in "${adresses_ip[@]}"; do
            if [ "$ip" == "$adresse_locale" ]; then
                break
            fi
            ((j++))
        done

        # Boucle à travers les répertoires associés à l'adresse IP
        Liste_repertoires=("${Liste_repertoires[@]:3}")
        for k in "${!Liste_repertoires[@]}"; do
            echo " k : $k "
            IFS=' ' read -ra liste_repertoire <<< "${Liste_repertoires[$k]}"
            liste_repertoire=("${liste_repertoire[@]:1}")
            repertoires_dossiers=("${liste_repertoire[@]:0:$nb_ordi}")
            echo "Contenu de repertoires_dossiers : ${repertoires_dossiers[@]}"

            dossiers_exclure=("${liste_repertoire[@]:$nb_ordi}")
    
            echo "Contenu de dossiers_exclure : ${dossiers_exclure[@]}"
   
            # Construire le chemin source en utilisant l'indice correspondant
            chemin_source="${repertoires_dossiers[$j]}"

            # Boucle à travers les répertoires à synchroniser
            for ((l=0; l<${#adresses_ip[@]}; l++)); do
                if [ "$l" != "$j" ]; then
                    chemin_destination="${repertoires_dossiers[$l]}"
                    echo "Synchronisation de $chemin_source vers $chemin_destination"
                    expoter_locale_to_distant "${utilisateurs[$l]}" "${adresses_ip[$l]}" "$chemin_source" "$chemin_destination" "${mot_de_passe_ssh[$l]}" "${dossiers_exclure[@]}"
                fi
            done
    done

    else
        echo "L'adresse IP locale n'est pas dans la liste des adresses IP."
    fi
}

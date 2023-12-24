#!/bin/bash


# Liste de répertoires et dossiers à exclure
Liste_repertoires=(
    "utilisateurs themezeguillaume guillaume equipepuce isabellebouchoule"
    "adresses_ip 192.168.0.24 10.117.53.101 10.117.51.227  10.117.48.25"
    "mot_de_passe_ssh 36363636 atomsheep PuceRubidium87 isabellenoeud9L"
    "analyses_Guillaume /Users/themezeguillaume/Documents/Ordi_Isa/analyses_Guillaume /home/guillaume/Documents/Documents_synchro/analyses_Guillaume /mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume /home/isabellebouchoule/Puce/analysedata/analyses_jupyter/analyses_Guillaume Figures-Resultat"
    "OrdiProgrammation /Users/themezeguillaume/Desktop/Documents_Clef/Traveaux/Git/Mes-Projets/Ordi_Programmation /home/guillaume/Documents/Documents_synchro/Ordi_Programmation /mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume/Ordi_Programmation /home/isabellebouchoule/Puce/analysedata/analyses_jupyter/analyses_Guillaume/Ordi_Programmation Figures-Resultat"
    "synchronise /Users/themezeguillaume/Desktop/Documents_Clef/Traveaux/Git/Mes-Projets/Ordi_Programmation/Connection_machine/synchroniser_ordi.sh /home/guillaume/Documents/Documents_synchro/synchroniser_ordi.sh Chemin_equipepuce Chemin_machine Figures-Resultat"
    "sshpass_instal /Users/themezeguillaume/Desktop/Documents_Clef/Traveaux/Git/Mes-Projets/Ordi_Programmation/Connection_machine/sshpass_instal.sh /home/guillaume/Documents/Documents_synchro/sshpass_instal.sh  Chemin_equipepuce Chemin_machine Figures-Resultat"
    "Dataparametre /Users/themezeguillaume/Documents/Ordi_Isa/Donnees/ /home/guillaume/Documents/.. /mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyse_DR_2022/parameters.py Rep_M "
    "scan059mnt /Users/themezeguillaume/Documents/Ordi_Isa/Donnees/mnt/ /home/guillaume/Documents/.. /mnt/data/DonneesEquipePuce/analysedata/2023-10-04/scan059 Rep_M "
    "scan059media /Users/themezeguillaume/Documents/Ordi_Isa/Donnees/media/ /home/guillaume/Documents/.. /media/pucemanip/manip/data/2023-10-04/scan059 Rep_M "
    #"analyses_Lea /Users/themezeguillaume/Documents/Ordi_Isa /Users/themezeguillaume/Desktop/Etude2023/PHD/Etudes/Ordi_Programmation /mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea /home/isabellebouchoule/Puce/analysedata/analyses_jupyter/analyses_Lea"
    "Documentsynchro /Users/themezeguillaume/Documents/Doucments_synchro /home/guillaume/Documents/Documents_synchro /mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Guillaume/Documents_synchro /home/isabellebouchoule/Puce/analysedata/analyses_jupyter/Documents_synchro "
    "repertoire1 rep_A1 rep_B1 rep_C1 rep_D1 Exc_11 Exc_12"
    "repertoire2 rep_A2 rep_B2 rep_C2 rep_D2 Exc_21 Exc_22"
    "repertoire3 rep_A3 rep_B3 rep_C3 rep_D3 Exc_31 Exc_32 Exc_33"
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

echo "utilisateurs : ${utilisateurs[@]}"
#for element in "${utilisateurs[@]}"; do echo "Élément : $element" done

echo "adresses_ip : ${adresses_ip[@]}"
#for element in "${adresses_ip[@]}"; do echo "Élément : $element" done

echo "mot_de_passe_ssh : ${mot_de_passe_ssh[@]}"
#for element in "${mot_de_passe_ssh[@]}"; do echo "Élément : $element" done

# Paramètres généraux
nb_ordi=${#adresses_ip[@]}

# Vérifier que les longueurs des tableaux sont égales
if [ ${#adresses_ip[@]} -eq ${#utilisateurs[@]} ] && [ ${#utilisateurs[@]} -eq ${#mot_de_passe_ssh[@]} ]; then
    echo "Les longueurs des tableaux sont égales."
else
    echo "Les longueurs des tableaux ne sont pas égales."
fi

# Définir un tableau pour stocker les noms des répertoires

Liste_repertoires=("${Liste_repertoires[@]:3}")
echo "Liste_repertoires : ${Liste_repertoires[@]}"

noms_repertoires=()
# Parcourir chaque ligne de Liste_repertoires
for ligne in "${Liste_repertoires[@]}"; do
    # Séparer la ligne en mots
    IFS=' ' read -ra elements <<< "$ligne"
    
    # Extraire les noms des répertoires (à partir du quatrième élément)
    noms_repertoires+=("${elements[0]}")
done

# Afficher les noms des répertoires
echo "Noms des répertoires : ${noms_repertoires[@]}"


# Installer sshpass s'il n'est pas déjà installé
chmod +x sshpass_instal.sh
./sshpass_instal.sh

# chemon parent
get_parent_path() {
    local chemin="$1"
    local chemin_parent=$(dirname "$chemin")
    echo "$chemin_parent"
}

# Fonction pour copier depuis une machine locale  vers une machine distante
function expoter_locale_to_distant() {
    local utilisateur_distant="$1"
    local adresse_distant="$2"
    local chemin_local="$3"
    local chemin_distant="$4"
    local password="$5"
    local dossiers_a_exclure=("${@:6}")
    
    echo "chemin_distant : $chemin_distant"
    #Chemin parent
    chemin_distant=$(get_parent_path "$chemin_distant")
    echo "chemin_distant parent : $chemin_distant"

    exclude_args=()
    for dossier in "${dossiers_a_exclure[@]}"; do
        exclude_args+=("--exclude=$dossier")
    done

    echo "Copie des modifications du local $chemin_local vers $chemin_distant de l'adresse $adresse_distant (en excluant ${dossiers_a_exclure[@]})"
    
    # Définir une deuxième condition (par exemple, la longueur du mot de passe doit être supérieure à 5)
    length_condition=$((${#password} > 5))
    
    # Vérifier si la variable password n'est pas égale à "vide" et que la longueur est supérieure à 5
    if [ -n "$password"  ] && [ "$password" != "vide" ] && [ "$length_condition" -eq 1 ]; then
        #sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        # Vérifier si le répertoire de destination existe sur le serveur distant
        sshpass -p "$password" ssh "$utilisateur_distant@$adresse_distant" "[ -d \"$chemin_distant\" ] || mkdir -p \"$chemin_distant\""

        # Exécuter rsync
        sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_local" "$utilisateur_distant@$adresse_distant:$chemin_distant"
        echo "Dossier copié avec succès."
    
    echo "Système d'exploitation : $(uname -s)"
    # Utilisation de rsync pour Linux/macOS
    elif [ "$(uname -s)" == "Linux" ] || [ "$(uname -s)" == "Darwin" ]; then
        #rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        #rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_source" "$utilisateur_distante@$adresse_distante:$chemin_destination"
        
        # Vérifier si le répertoire de destination existe sur le serveur distant
        sshpass -p "$password" ssh "$utilisateur_distant@$adresse_distant" "[ -d \"$chemin_distant\" ] || mkdir -p \"$chemin_distant\""

        # Exécuter rsync
        sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$chemin_local" "$utilisateur_distant@$adresse_distant:$chemin_distant"
        echo "Dossier copié avec succès."
        
    # Utilisation de Robocopy pour Windows
    elif [ "$(uname -s)" == "CYGWIN"* ] || [ "$(uname -s)" == "MINGW"* ]; then
        robocopy "$chemin_local" "\\$adresse_distant\$utilisateur_distant\$chemin_distant" /MIR
        
        # Vérifier si le répertoire de destination existe sur le serveur distant
        #$remotePath = "\\$adresse_distante\$utilisateur_distante\$chemin_destination"
        #if (-not (Test-Path "\\$adresse_distant\$utilisateur_distant\$chemin_distant")) {
        #    New-Item -Path $remotePath -ItemType Directory -Force
        #    }

        # Exécuter robocopy
        #robocopy "$chemin_source" "$remotePath" /MIR
        echo "Dossier copié avec succès."
        
    else
        echo "Système d'exploitation non pris en charge."
        exit 1
    fi
    
    
}


# Fonction pour copier depuis une machine distante vers une machine locale
function importer_distant_to_local() {
    local utilisateur_distant="$1"
    local adresse_distant="$2"
    local chemin_local="$3"
    local chemin_distant="$4"
    local password="$5"
    local dossiers_a_exclure=("${@:6}")
    
    echo "chemin_destination : $chemin_local"
    #Chemin parent
    chemin_local=$(get_parent_path "$chemin_local")
    echo "chemin_destination parent : $chemin_local"

    exclude_args=()
    for dossier in "${dossiers_a_exclure[@]}"; do
        exclude_args+=("--exclude=$dossier")
    done

    echo "Copie des modifications de $chemin_distant depuis $adresse_distant vers local $chemin_local (en excluant ${dossiers_a_exclure[@]})"
    
    # Récupérer la liste des dossiers à exclure pour ce chemin source
    dossiers_exclure=("${dossiers_a_exclure[$i]}")
    exclude_args=()
    for dossier in "${dossiers_exclure[@]}"; do
        exclude_args+=("--exclude=$dossier")
    done

    # Définir une deuxième condition (par exemple, la longueur du mot de passe doit être supérieure à 5)
    length_condition=$((${#password} > 5))
    # Vérifier si le répertoire de destination existe
    if [ ! -d "$chemin_source" ]; then
        mkdir -p "$chemin_source"
    fi
    # Vérifier si la variable password n'est pas égale à "vide" et que la longueur est supérieure à 5
    if [ -n "$password"  ] && [ "$password" != "vide" ] && [ "$length_condition" -eq 1 ]; then
        #sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_destination" "$chemin_source"
        # Vérifier si le répertoire de destination existe
        #sshpass -p "$password" ssh "$utilisateur_distant@$adresse_distant" "[ -d \"$chemin_distant\" ] || mkdir -p \"$chemin_local\""
        

        # Exécuter rsync
        sshpass -p "$password" rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distant@$adresse_distant:$chemin_distant" "$chemin_local"

        echo "Dossier copié avec succès."
    
    echo "Système d'exploitation : $(uname -s)"
    # Utilisation de rsync pour Linux/macOS
    elif [ "$(uname -s)" == "Linux" ] || [ "$(uname -s)" == "Darwin" ]; then
        #rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_source" "$chemin_destination"
        #rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distante@$adresse_distante:$chemin_destination" "$chemin_source"
        # Vérifier si le répertoire de destination existe
        #sshpass -p "$password" ssh "$utilisateur_distant@$adresse_distant" "[ -d \"$chemin_destination\" ] || mkdir -p \"$chemin_destination\""
        #if [ ! -d "$chemin_source" ]; then mkdir -p "$chemin_source" fi

        # Exécuter rsync
        rsync -avu --info=progress2 "${exclude_args[@]}" "$utilisateur_distant@$adresse_distant:$chemin_distant" "$chemin_local"
        echo "Dossier copié avec succès."
        
    # Utilisation de Robocopy pour Windows
    elif [ "$(uname -s)" == "CYGWIN"* ] || [ "$(uname -s)" == "MINGW"* ]; then
        robocopy "\\$adresse_distant\$utilisateur_distant\$chemin_distant" "$chemin_local"  /MIR
        # Chemin complet du répertoire de destination distant
        #$remotePath = "\\$adresse_distant\$utilisateur_distant\$chemin_distant"

        # Vérifier si le répertoire de destination existe sur le serveur distant
        #if (-not (Test-Path $remotePath)) {
        # Créer le répertoire de destination s'il n'existe pas
        #New-Item -Path $remotePath -ItemType Directory -Force
        #}

        # Exécuter robocopy
        #robocopy "$remotePath" "$chemin_local" /MIR
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

function importer_exporter_rep() {
    local bol_import="$1"
    local bol_export="$2"
    local utilisateur_distant="$3"
    local nom_repertoire="$4"

    # Vérifier si l'utilisateur distant est présent dans la liste
    if [[ " ${utilisateurs[@]} " =~ " $utilisateur_distant " ]]; then

        # Vérifier si le nom du répertoire est présent dans la liste
        if [[ " ${noms_repertoires[@]} " =~ " $nom_repertoire " ]]; then

            # Récupérer l'adresse IP de l'ordinateur local
            adresse_local=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n 1)

            echo "adresse_local $adresse_local"

            # Vérifier si l'adresse IP locale est présente dans la liste
            if [[ " ${adresses_ip[@]} " =~ " $adresse_local " ]]; then

                # Récupérer l'indice correspondant à l'adresse IP locale
                k=0
                for ip in "${adresses_ip[@]}"; do
                    if [ "$ip" == "$adresse_local" ]; then
                        break
                    fi
                    ((k++))
                done

                # Récupérer l'indice correspondant au nom du répertoire
                i=0
                for n_rep in "${noms_repertoires[@]}"; do
                    if [ "$n_rep" == "$nom_repertoire" ]; then
                        break
                    fi
                    ((i++))
                done

                # Récupérer l'indice correspondant à l'utilisateur distant
                j=0
                for user in "${utilisateurs[@]}"; do
                    if [ "$user" == "$utilisateur_distant" ]; then
                        break
                    fi
                    ((j++))
                done

                # Récupérer l'adresse distante et le mot de passe
                adresse_distant="${adresses_ip[$j]}"
                mot_de_passe="${mot_de_passe_ssh[$j]}"

                IFS=' ' read -ra elements <<< "${Liste_repertoires[$i]}"
                elements=("${elements[@]:1}")
                chemin_distant="${elements[$j]}"
                chemin_local="${elements[$k]}"
                dossiers_exclure=("${elements[@]:$nb_ordi}")
    
                # Vous pouvez utiliser les variables ci-dessus pour effectuer d'autres actions ou afficher des informations.
                echo "Adresse distante: $adresse_distant"
                echo "Mot de passe: $mot_de_passe"
                echo "Chemin source: $chemin_local"
                echo "Chemin destination: $chemin_distant"
                echo "Contenu de dossiers_exclure : ${dossiers_exclure[@]}"
                
                # On ne veut pas sauveau dans le mm repertoire
                if [ "$adresse_distant" != "$adresse_local" ] && [ "$chemin_distant" != "$chemin_local" ]; then
                    # ou [ "$j" != "$k" ]
                    
                    if [ "$bol_import" == "True" ]&&[ "$bol_export" == "True" ] ; then
                        echo "On import et on export"
                        exit 1
                    fi
                    # On import si true
                    if [[ "$bol_import" == "True" ]] ; then
                        echo "Synchronisation de $chemin_distant vers $chemin_local"
                        importer_distant_to_local "$utilisateur_distant" "$adresse_distant" "$chemin_local" "$chemin_distant" "$mot_de_passe" "${dossiers_exclure[@]}"
                
                    else
                        echo "bol_import : $bol_import"
                    fi
                    # On export si true
                    if [[ "$bol_export" == "True" ]] ; then
                        echo "Synchronisation de $chemin_local vers $chemin_distant"
                        expoter_locale_to_distant "$utilisateur_distant" "$adresse_distant" "$chemin_local" "$chemin_distant" "$mot_de_passe" "${dossiers_exclure[@]}"
                
                    else
                        echo "bol_export : $bol_export"
                    fi
                else
                    echo "Source et destination pareil adresse_local : $adresse_local , adresse_distant : $adresse_distant ,  chemin_distant : $chemin_distant , chemin_local : $chemin_local   "
                fi
            
            
            else
                echo "L'adresse IP locale : $adresse_local n'est pas dans la liste des adresses IP."
            fi
        
        else
            echo "Pas de nom de répertoire $nom_repertoire dans la base de données."
            exit 1
        fi
    
    else
        echo "Noms des utilisateur: ${utilisateurs[@]}"
        echo "Pas d'utilisateur $utilisateur_distant dans la base de données."
        exit 1
    fi
}

function connection_ssh(){
    local utilisateur_distant="$1"
    local nom_repertoire="$2"
    
    # Vérifier si l'utilisateur distant est présent dans la liste
    if [[ " ${utilisateurs[@]} " =~ " $utilisateur_distant " ]]; then
    
        # Vérifier si le nom du répertoire est présent dans la liste
        if [[ " ${noms_repertoires[@]} " =~ " $nom_repertoire " ]]; then
        
            # Récupérer l'indice correspondant à l'adresse IP locale
            #k=0
            #for ip in "${adresses_ip[@]}"; do
            #    if [ "$ip" == "$adresse_locale" ]; then
            #        break
            #    fi
            #    ((k++))
            #done

            # Récupérer l'indice correspondant au nom du répertoire
            i=0
            for n_rep in "${noms_repertoires[@]}"; do
                if [ "$n_rep" == "$nom_repertoire" ]; then
                    break
                fi
                ((i++))
            done

            # Récupérer l'indice correspondant à l'utilisateur distant
            j=0
            for user in "${utilisateurs[@]}"; do
                if [ "$user" == "$utilisateur_distant" ]; then
                    break
                fi
                ((j++))
            done
        
            # Récupérer l'adresse distante et le mot de passe
            adresse_distante="${adresses_ip[$j]}"
            mot_de_passe="${mot_de_passe_ssh[$j]}"
            
            IFS=' ' read -ra elements <<< "${Liste_repertoires[$i]}"
            elements=("${elements[@]:1}")
            chemin_destination="${elements[$j]}"
            #chemin_source="${elements[$k]}"
            #dossiers_exclure=("${elements[@]:$nb_ordi}")

            echo "Adresse distante: $adresse_distante"
            echo "Mot de passe: $mot_de_passe"
            #echo "Chemin source: $chemin_source"
            echo "Chemin destination: $chemin_destination"
            #echo "Contenu de dossiers_exclure : ${dossiers_exclure[@]}"
            
            # Récupérer l'adresse IP de l'ordinateur local
            adresse_locale=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -n 1)
            
            # On ne va pas dans le repertoir local
            if [ "$adresse_distante" != "$adresse_locale" ] ; then
            
                sshpass -p "$mot_de_passe" ssh "$utilisateur_distant"@"$adresse_distante" ls -l "$chemin_destination"
                #sshpass -p "$mot_de_passe" ssh "$utilisateur_distant"@"$adresse_distante" "cd '$chemin_destination' && votre_commande_ici"
                echo "cd  $chemin_destination"
                sshpass -p "$mot_de_passe" ssh "$utilisateur_distant"@"$adresse_distante"
                
            
            else
            
                echo "adresses pareil adresse_locale : $adresse_locale , adresse_distante : $adresse_distante   "
            
            fi
            
        else
            echo "Pas de nom de répertoire $nom_repertoire dans la base de données."
            exit 1
        
        fi
            
            

    
    else
        echo "Noms des utilisateur: ${utilisateurs[@]}"
        echo "Pas d'utilisateur $utilisateur_distant dans la base de données."
        exit 1
    fi
}


function afficher_liste(){
    local liste=("$@")  # Utiliser "$@" pour récupérer tous les arguments passés à la fonction

    for element in "${liste[@]}" ; do
        echo "- $element"
    done
}

function determine_utilisateur_rep {
    echo "Quel est l'ordinateur distant :"
    afficher_liste "${utilisateurs[@]}"
    read utilisateur
            
    echo "Quel est le répertoire  :"
    afficher_liste "${noms_repertoires[@]}"
    read n_rep
}



function afficher_commandes_bash {
    echo "Commandes de base en Bash :"
    echo "1. Afficher le répertoire de travail : pwd"
    echo "2. Liste des fichiers et répertoires : ls"
    echo "3. Créer un répertoire : mkdir nom_du_répertoire"
    echo "4. Changer de répertoire : cd chemin_du_répertoire"
    echo "5. Afficher le contenu d'un fichier : cat nom_du_fichier"
    echo "6. Éditer un fichier avec l'éditeur de texte nano : nano nom_du_fichier"
    echo "7. Copier des fichiers : cp source destination"
    echo "8. Déplacer ou renommer un fichier : mv ancien_nom nouveau_nom"
    echo "9. Supprimer un fichier : rm nom_du_fichier"
    echo "10. Supprimer un répertoire et son contenu : rm -r nom_du_répertoire"
    echo "11. Afficher le manuel d'une commande : man nom_de_la_commande"
}

# Appeler la fonction pour afficher les commandes de base en Bash
afficher_commandes_bash



PS3="Que souhaitez-vous faire ? "
options=("Connection SSH ('exit' pour sortir)" "Inporter" "Experter" "Synchroniser tous depuis cette ordinateur" "Quitter")
select opt in "${options[@]}"
do
    case $opt in
        "Connection SSH ('exit' pour sortir)")
        afficher_commandes_bash
        
        determine_utilisateur_rep
        
        
        
        echo "utilisateur : $utilisateur ,$n_rep"
        
        connection_ssh "$utilisateur" "$n_rep"
        
        ;;
        
        "Inporter")
                    
            determine_utilisateur_rep
            importer_exporter_rep "True" "False" "$utilisateur" "$n_rep"
            
            ;;
        "Experter")
            
            determine_utilisateur_rep
            importer_exporter_rep "False" "True" "$utilisateur" "$n_rep"
            
            ;;
        "Synchroniser tous depuis cette ordinateur")
            echo " On synchonise tout : "
            
            synchroniser_depuis_local
            
            ;;
        "Quitter")
            break
            ;;
        *) echo "Option invalide";;
    esac
done

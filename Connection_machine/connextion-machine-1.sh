#!/bin/bash
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

mkdir -p /usr/local/Homebrew/Library/Taps/mytap

class Sshpass < Formula
  desc "Non-interactive ssh password authentication"
  homepage "https://sourceforge.net/projects/sshpass/"
  url "https://sourceforge.net/projects/sshpass/files/sshpass/1.09/sshpass-1.09.tar.gz"
  sha256 "your_sha256_checksum_here" # Vous devrez remplacer ceci par la somme de contrôle correcte

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "sshpass"
  end
end

brew install mytap/sshpass


# Mot de passe SSH
password="PuceRubidium87"

echo "Voulez-vous vous connecter à l'ordinateur equipepuce (C) ou copier un dossier (D) ?"
read choix

if [ "$choix" == "C" ]; then
    # Demander l'utilisateur s'il veut afficher le contenu de Léa ou Guillaume
    echo "Voulez-vous afficher le contenu de Léa (L) ou Guillaume (G) ?"
    read contenu_choice

    if [ "$contenu_choice" == "L" ]; then
        chemin_repertoire="../../mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea"
    elif [ "$contenu_choice" == "G" ]; then
        chemin_repertoire="../../mnt/data/DonneesEquipePuce/analysedata/analysdata/analyses_jupyter/analyses_Guillaume"
    else
        echo "Choix invalide. Vous devez entrer 'L' pour Léa ou 'G' pour Guillaume."
        exit 1
    fi
    
    echo "Chemin du répertoire : $chemin_repertoire"
    
    # Connexion SSH à equipepuce@10.117.51.227
    echo "Connexion à equipepuce@10.117.51.227"
    sshpass -p "$password" ssh equipepuce@10.117.51.227 "cd $chemin_repertoire; exec \$SHELL -l"
    
elif [ "$choix" == "D" ]; then
    # Demander l'utilisateur s'il veut afficher le contenu de Léa ou Guillaume
    echo "Voulez-vous afficher le contenu de Léa (L) ou Guillaume (G) ?"
    read contenu_choice

    if [ "$contenu_choice" == "L" ]; then
        chemin_repertoire="/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea"
    elif [ "$contenu_choice" == "G" ]; then
        chemin_repertoire="/mnt/data/DonneesEquipePuce/analysedata/analysdata/analyses_jupyter/analyses_Guillaume"
    else
        echo "Choix invalide. Vous devez entrer 'L' pour Léa ou 'G' pour Guillaume."
        exit 1
    fi

    # Liste des fichiers dans le répertoire distant
    echo "Liste des fichiers dans le répertoire distant :"
    sshpass -p "$password" ssh equipepuce@10.117.51.227 "ls -l $chemin_repertoire"
    
    # Copier des dossiers depuis equipepuce@10.117.51.227
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
        echo "Copie du dossier $i en cours..."
        
        scp -r equipepuce@10.117.51.227:"$chemin_source" "$chemin_destination"
        echo "Dossier $i copié avec succès."
    done
else
    echo "Choix invalide. Veuillez entrer 'C' pour vous connecter ou 'D' pour copier un dossier."
fi

chemin_source="/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea/GHD_Code_Isabelle"

chemin_destination="/Users/themezeguillaume/Desktop/"
scp -r equipepuce@10.117.51.227:"$chemin_source" "$chemin_destination"


chemin_source="/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea/GHD_Code_Jerôme"
scp -r equipepuce@10.117.51.227:"$chemin_source" "$chemin_destination"

chemin_source="/mnt/data/DonneesEquipePuce/analysedata/analyses_jupyter/analyses_Lea/GHD_Code_Julia"

scp -r equipepuce@10.117.51.227:"$chemin_source" "$chemin_destination"

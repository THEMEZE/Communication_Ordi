#!/bin/bash

# Vérifier le système d'exploitation
if [[ "$(uname -s)" == "Linux" ]]; then
    echo "Système d'exploitation détecté : Linux"
    os="linux"
elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Système d'exploitation détecté : macOS"
    os="macos"
else
    echo "Système d'exploitation non pris en charge."
    exit 1
fi

# Installer Mono si nécessaire (uniquement pour Linux et macOS)
if [[ "$os" == "linux" || "$os" == "macos" ]]; then
    if ! command -v mono &>/dev/null; then
        echo "Mono n'est pas installé. Installation en cours..."
        if [[ "$os" == "linux" ]]; then
            sudo apt-get install -y mono-complete  # Installe Mono sous Linux
        elif [[ "$os" == "macos" ]]; then
            brew install mono  # Installe Mono sous macOS avec Homebrew (assurez-vous d'avoir Homebrew installé)
        fi
    else
        echo "Mono est déjà installé."
    fi
else
    echo "Mono n'est pas nécessaire sur ce système d'exploitation."
fi

# Demander le choix entre serveur et client
read -p "Entrez 'server' pour exécuter le serveur, 'client' pour exécuter le client : " choice

# Définir le chemin du fichier C# en fonction du choix
if [ "$choice" == "server" ]; then
    csharp_file="Communication_Ethernet/Server.cs"
elif [ "$choice" == "client" ]; then
    csharp_file="Communication_Ethernet/Client.cs"
else
    echo "Option invalide. Le programme n'a pas été exécuté."
    exit 1
fi

#read -p "Entrez le chemin du fichier C# source : " csharp_file

# Vérifier si le fichier C# existe
if [ -f "$csharp_file" ]; then
    # Compiler le fichier C#
    echo "Compilation du fichier C# en cours..."
    mcs "$csharp_file" -out:ClientServer.exe

    # Vérifier si la compilation a réussi
    if [ $? -eq 0 ]; then
        echo "Compilation réussie. Vous pouvez maintenant exécuter le programme."
        # Exécuter le programme (serveur ou client)
        mono ClientServer.exe "$choice"
    else
        echo "Erreur lors de la compilation du fichier C#."
    fi
else
    echo "Le fichier C# spécifié n'existe pas : $csharp_file"
fi

#!/bin/bash

# Fonction pour obtenir l'adresse IP sous Linux
get_ip_linux() {
    ip a | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -f1 -d'/'
}

# Fonction pour obtenir l'adresse IP sous macOS
get_ip_macos() {
    ipconfig getifaddr en0  # Interface réseau courante (en0 est couramment utilisée)
}

# Fonction pour obtenir l'adresse IP sous Windows
get_ip_windows() {
    ipconfig | findstr /i "ipv4"
}

# Déterminer le système d'exploitation
if [[ "$(uname -s)" == "Linux" ]]; then
    echo "Adresse IP sous Linux : $(get_ip_linux)"
elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Adresse IP sous macOS : $(get_ip_macos)"
elif [[ "$(uname -o)" == "Cygwin" || "$(uname -o)" == "Msys" ]]; then
    echo "Adresse IP sous Windows : $(get_ip_windows)"
else
    echo "Système d'exploitation non pris en charge."
    exit 1
fi


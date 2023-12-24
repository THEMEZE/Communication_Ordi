#!/bin/bash

# Vérifier le système d'exploitation
if [[ "$(uname -s)" == "Linux" ]]; then
    echo "Système d'exploitation détecté : Linux"
    os="linux"
elif [[ "$(uname -s)" == "Darwin" ]]; then
    echo "Système d'exploitation détecté : macOS"
    os="macos"
elif [[ "$(uname -s)" == "CYGWIN"* || "$(uname -s)" == "MINGW64"* ]]; then
    echo "Système d'exploitation détecté : Windows"
    os="windows"
else
    echo "Système d'exploitation non pris en charge."
    exit 1
fi

# Fonction pour vérifier l'adresse IP
check_ip() {
    if [[ "$os" == "linux" || "$os" == "macos" ]]; then
        local ip_address="$(ifconfig | grep 'inet ' | awk '{print $2}' | head -n 1)"
    elif [[ "$os" == "windows" ]]; then
        local ip_address="$(ipconfig | grep 'IPv4 Address' | awk '{print $NF}' | head -n 1)"
    fi

    if [ -n "$ip_address" ]; then
        echo "Adresse IP de l'ordinateur : $ip_address"
    else
        echo "Impossible de récupérer l'adresse IP."
    fi
}

# Fonction pour vérifier l'état du pare-feu (Windows uniquement)
check_firewall() {
    if [[ "$os" == "windows" ]]; then
        local port=12345  # Port à vérifier

        echo "Vérification de l'état du pare-feu pour le port $port..."
        netsh advfirewall firewall show rule name="AutoriserPort$port" | grep "Enabled: Yes" &> /dev/null
        if [ $? -eq 0 ]; then
            echo "La règle du pare-feu pour le port $port est activée."
        else
            echo "La règle du pare-feu pour le port $port n'est pas activée."
        fi
    fi
}

# Vérifier l'adresse IP
check_ip

# Vérifier l'état du pare-feu (Windows uniquement)
check_firewall

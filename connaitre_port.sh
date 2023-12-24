#!/bin/bash

# Fonction pour afficher les ports en écoute avec netstat
check_ports_with_netstat() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        netstat -tuln | grep LISTEN
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        netstat -tuln | grep LISTEN
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin" ]]; then
        # Windows (Git Bash, Cygwin, WSL)
        netstat -tuln | grep LISTEN
    else
        echo "Système d'exploitation non pris en charge."
        exit 1
    fi
}

# Fonction pour afficher les ports en écoute avec lsof
check_ports_with_lsof() {
    if [[ "$OSTYPE" == "darwin"* || "$OSTYPE" == "linux-gnu"* ]]; then
        lsof -i -n -P | grep LISTEN
    elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin" ]]; then
        echo "La commande lsof n'est pas disponible sur Windows."
    else
        echo "Système d'exploitation non pris en charge."
        exit 1
    fi
}

echo "Choisissez une méthode pour vérifier les ports en écoute :"
echo "1. Utiliser netstat"
echo "2. Utiliser lsof"
echo "3. Quitter"

read -p "Entrez le numéro de méthode (1/2/3) : " choice

case $choice in
    1)
        echo "Ports en écoute (netstat) :"
        check_ports_with_netstat
        ;;
    2)
        echo "Ports en écoute (lsof) :"
        check_ports_with_lsof
        ;;
    3)
        echo "Au revoir !"
        exit 0
        ;;
    *)
        echo "Option invalide. Veuillez choisir une méthode valide (1/2/3)."
        ;;
esac

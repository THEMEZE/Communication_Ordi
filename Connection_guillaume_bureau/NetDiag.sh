#!/bin/bash

# Adresse IP à tester
adresse_ip="10.117.51.101"
port="22"

# Fonction pour tester la connectivité via ping
function tester_ping {
    ping -c 4 "$adresse_ip"
    if [ $? -eq 0 ]; then
        echo "Ping réussi : $adresse_ip est atteignable."
    else
        echo "Ping échoué : $adresse_ip est injoignable."
    fi
}

# Fonction pour tester la connectivité SSH
function tester_ssh {
    ssh -p "$port" "$adresse_ip" -o ConnectTimeout=10 -o BatchMode=yes -o PasswordAuthentication=no -o 
StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null echo "Test SSH"
    if [ $? -eq 0 ]; then
        echo "SSH réussi : Connexion à $adresse_ip sur le port $port établie."
    else
        echo "SSH échoué : Connexion à $adresse_ip sur le port $port impossible."
    fi
}

# Exécution des tests
echo "Test de connectivité vers $adresse_ip sur le port $port :"

tester_ping
tester_ssh


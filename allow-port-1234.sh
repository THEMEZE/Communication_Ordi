#!/bin/bash

# Déterminer le système d'exploitation
if [[ "$(uname -s)" == "Linux" ]]; then
    # Linux (utilisant iptables)
    sudo iptables -A INPUT -p tcp --dport 12345 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --sport 12345 -j ACCEPT
    sudo iptables -L -n | grep 12345  # Vérifier la règle
elif [[ "$(uname -s)" == "Darwin" ]]; then
    # macOS (utilisant pfctl)
    sudo echo "pass in on any proto tcp from any to any port 12345" > /etc/pf.anchors/allow_port_12345_in
    sudo echo "pass out on any proto tcp from any to any port 12345" > /etc/pf.anchors/allow_port_12345_out
    sudo pfctl -e -f /etc/pf.anchors/allow_port_12345_in
    sudo pfctl -e -f /etc/pf.anchors/allow_port_12345_out
    sudo pfctl -sr | grep 12345  # Vérifier les règles
elif [[ "$(uname -o)" == "Cygwin" || "$(uname -o)" == "Msys" ]]; then
    # Windows (utilisant netsh)
    netsh advfirewall firewall add rule name="AutoriserPort12345In" dir=in action=allow protocol=TCP localport=12345
    netsh advfirewall firewall add rule name="AutoriserPort12345Out" dir=out action=allow protocol=TCP localport=12345
    netsh advfirewall firewall show rule name="AutoriserPort12345In"  # Vérifier la règle entrante
    netsh advfirewall firewall show rule name="AutoriserPort12345Out"  # Vérifier la règle sortante
else
    echo "Système d'exploitation non pris en charge."
    exit 1
fi

echo "Les règles de pare-feu ont été ajoutées avec succès pour le port 12345 (entrée et sortie)."

#!/bin/bash

# Script interactif pour configurer des règles de pare-feu personnalisées sur macOS

# Fonction pour ajouter une règle
add_rule() {
    read -p "Entrez la règle de pare-feu (par exemple, 'pass in proto tcp from any to any port 1234'): " rule
    echo "$rule" | sudo tee -a /etc/pf.anchors/my_firewall_rules.pf
    echo "Règle ajoutée avec succès."
}

# Fonction pour charger les règles
load_rules() {
    sudo pfctl -f /etc/pf.anchors/my_firewall_rules.pf
    echo "Règles chargées avec succès."
}

# Fonction pour activer le pare-feu
enable_firewall() {
    sudo pfctl -e
    echo "Pare-feu activé."
}

# Fonction pour désactiver le pare-feu
disable_firewall() {
    sudo pfctl -d
    echo "Pare-feu désactivé."
}

# Fonction pour afficher les règles actuelles
show_rules() {
    sudo pfctl -sa
}

# Menu principal
while true; do
    echo "Options :"
    echo "  1. Ajouter une règle de pare-feu"
    echo "  2. Charger les règles de pare-feu"
    echo "  3. Activer le pare-feu"
    echo "  4. Désactiver le pare-feu"
    echo "  5. Afficher les règles de pare-feu actuelles"
    echo "  6. Quitter"

    read -p "Choisissez une option (1/2/3/4/5/6) : " choice

    case $choice in
        1)
            add_rule
            ;;
        2)
            load_rules
            ;;
        3)
            enable_firewall
            ;;
        4)
            disable_firewall
            ;;
        5)
            show_rules
            ;;
        6)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Option invalide. Veuillez choisir une option valide."
            ;;
    esac
done

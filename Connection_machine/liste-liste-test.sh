#!/bin/bash

# Liste de répertoires et dossiers à exclure pour chaque ordinateur
Liste_repertoires=(
    "rep_A1 rep_B1 rep_C1 Exc_11 Exc_12"
    "rep_A2 rep_B2 rep_C2 Exc_21 Exc_22"
    "rep_A3 rep_B3 rep_C3 Exc_31 Exc_32 Exc_33"
)

# Accéder aux éléments de la Liste_repertoires
for i in "${!Liste_repertoires[@]}"; do
    repertoires_et_dossiers=(${Liste_repertoires[$i]})

    echo "Liste $((i+1)):"

    for element in "${repertoires_et_dossiers[@]}"; do
        IFS=' ' read -ra elements <<< "$element"

        echo "  Liste de répertoires:"
        for element in "${elements[@]:0:3}"; do
            echo "    Répertoire: $element"
        done

        echo "  Liste de dossiers à exclure:"
        for element in "${elements[@]:3}"; do
            echo "    Dossier à exclure: $element"
        done
    done
done

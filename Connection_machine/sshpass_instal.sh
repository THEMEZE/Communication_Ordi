if ! command -v sshpass &> /dev/null
then
    echo "sshpass n'est pas installé. Installation en cours..."
    brew install http://git.io/sshpass.rb
fi


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

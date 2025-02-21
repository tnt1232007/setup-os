#!/bin/bash
set -euo pipefail

USERNAME=$(whoami)

get_user_input() {
    read -p "❓ Install entertainment software (Plex, Spotify)? (y/n) " Install_Entertainment
    read -p "❓ Install programming software (JetBrains, Powershell)? (y/n) " Install_Programming
}

add_user_to_sudoers() {
    echo "🔧 Adding current user $USERNAME to sudoers..."
    if ! sudo grep -q "^$USERNAME" /etc/sudoers; then
        echo "$USERNAME    ALL=(ALL) ALL" | sudo tee -a /etc/sudoers > /dev/null
    fi
}

install_compulsory_packages() {
    echo "🔧 Installing compulsory packages..."
    export NONINTERACTIVE=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_compulsory_softwares() {
    echo "🔧 Installing compulsory softwares..."
    brew install git
    brew install --cask visual-studio-code
    git config --global user.name "Nhan Ngo"
    git config --global user.email tnt1232007@gmail.com
}

install_entertainment_softwares() {
    echo "🔧 Installing entertainment softwares..."
    brew install --cask plex-media-player
    brew install --cask spotify
}

install_programming_softwares() {
    echo "🔧 Installing programming softwares..."
    brew install node
    brew install --cask jetbrains-toolbox
    brew install --cask powershell
}

configure_git() {
    echo "🔧 Configuring git..."
    git config --global user.name "Nhan Ngo"
    git config --global user.email "tnt1232007@gmail.com"
    git config --global rebase.autoStash true
    git config --global pull.rebase true
}

echo "🚀 Starting setup script..."
get_user_input
add_user_to_sudoers
install_compulsory_packages
install_compulsory_softwares
if [ "$Install_Entertainment" == "y" ]; then
    install_entertainment_softwares
fi
if [ "$Install_Programming" == "y" ]; then
    install_programming_softwares
fi
echo "✅ Setup script completed successfully."
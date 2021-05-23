#!/bin/bash

function pullLatestChanges() {
    echo "Pulling latest changes from repo.."
    git pull origin main &>/dev/null
    echo "Done"
}

function installHomeBrew() {
    echo "Checking installation of Xcode"

    local xcode_cmd_utils="$(xcode-select -p)"
    if [ -d "$xcode_cmd_utils"]
    then
       echo "Xcode is installed"
    else
       echo "Xcode is not installed. Install Xcode via 'xcode-select --install', then re-run this installation script." 
       return 1 #installation was not completed sucessfully (missing xcode pre-req)
    fi

    echo "Checking installation of Homebrew"
    if command -v brew &>/dev/null
    then
        echo "Homebrew is installed"
    else
        echo "Homebrew is not installed"
        echo "Installing Homebrew"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        local brew_dr_output=$(brew doctor)
        local brew_dr_success_msg="Your system is ready to brew."
        if [ "$brew_dr_output" == "$brew_dr_success_msg" ]
        then
            echo "Installed Homebrew"
        else
            echo "Installed Homebrew **with warnings**, run 'brew doctor' and manually resolve issues"
        fi
    fi
}

function installOhMyZsh() {
    echo "Installing oh-my-zsh..."
    bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "Installed oh-my-zsh..."
}

function installPowerlineFonts() {
    echo "Installing Powerline Fonts..."
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
    echo "Installed Powerline Fonts..."
}

function syncDotFiles() {
    echo "Syncing dotfiles..."
    rsync --exclude ".git/" \
          --exclude ".macos" \
          --exclude "installer.sh" \
          --exclude "README.md" \
          --exclude "LICENSE" \
          -avh --no-perms . $HOME;
    echo "Synced dotfiles..."
}

function installHomeBrewApps() {
    echo "Installing Apps via HomeBrew"
    brew bundle --file ./brewfile
    echo "Installed Apps via HomeBrew"
}

pullLatestChanges
installHomeBrew
installOhMyZsh
installPowerlineFonts
syncDotFiles
installHomeBrewApps
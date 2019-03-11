#!/bin/bash

main() {
    setup
    install
    cleanup
}

setup() {
    echo "----- Setup -----"

    mv ~/.oh-my-zsh/ ~/oh-my-zsh/
}

install() {    
    echo "----- Install -----"

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

cleanup() {
    echo "----- Cleanup -----"

    rsync -vaPz ~/oh-my-zsh/ ~/.oh-my-zsh/
    rm -rf ~/oh-my-zsh/
}

main

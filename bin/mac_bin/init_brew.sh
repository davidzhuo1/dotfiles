#!/bin/bash

main() {
    export HOMEBREW_NO_ANALYTICS=1

    setup
    install
    cleanup
}

setup() {
    echo "----- Setup -----"

    # Run mystery internet script
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Setup tap (if not setup)
    # brew tap railwaycat/emacsmacport # for emacs-mac
    brew tap caskroom/homebrew-cask

    # Turn off analytics
    brew analytics off

    # Enable a bunch of permissions
    sudo chmod o+w /usr/local/bin
    sudo chown $(whoami) /usr/local/etc
    sudo chown $(whoami) /usr/local/share
    sudo chown -R $(whoami) /usr/local/share/locale
    sudo chown -R $(whoami) /usr/local/share/man
    sudo lock_brew
}

install() {
    echo "----- Install -----"

    # Define targets
    TARGETS=( dtrx the_silver_searcher wget autossh zsh-completions fzf colordiff jq shellcheck )
    CASK_TARGETS=( caskroom/versions/sublime-text-dev iterm2 dash alfred bettertouchtool wireshark docker emacs )

    for T in "${TARGETS[@]}"; do
        brew install $T
    done

    for T in "${CASK_TARGETS[@]}"; do
        brew cask install $T
    done
}

cleanup() {
    echo "----- Cleanup -----"

    # Cleanup
    brew cleanup -s
    brew cask cleanup
    brew doctor --verbose
    brew cask doctor --verbose
    sudo lock_brew -u
}

main

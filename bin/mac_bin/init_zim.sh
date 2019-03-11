#!/bin/bash

[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

setup() {
    echo "----- Setup -----"
    USERHOME="$1"
    
    mv ${USERHOME}/.zim/ ${USERHOME}/zim_tmp/
}

install() {    
    echo "----- Install -----"
    USERHOME="$1"

    git clone --recursive https://github.com/zimfw/zimfw.git ${USERHOME}/.zim
}

cleanup() {
    echo "----- Cleanup -----"
    USERHOME="$1"

    rsync -vaPz ${USERHOME}/zim_tmp/ ${USERHOME}/.zim/
    rm -rf ${USERHOME}/zim_tmp/
}

main() {
    USER=$(dscl . list /Users | grep -vE '_|root|daemon|nobody' | head -n1)
    echo "Setting up zim for ${USER}"
    USERHOME=$(su ${USER} -c 'echo $HOME')
    echo "User's home is ${USERHOME}"
    
    setup ${USERHOME}
    install ${USERHOME}
    cleanup ${USERHOME}

    chown -R ${USER} ${USERHOME}/.zim/
    chsh -s /bin/zsh ${USER}
}

main

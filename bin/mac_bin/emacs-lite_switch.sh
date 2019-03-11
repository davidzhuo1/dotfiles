#!/bin/bash

main() {
    cd $HOME
    delete_old
    make_new
}

delete_old() {
    git checkout master
    git branch -D emacs_lite
    git pull
}

make_new() {
    emacs -batch -f batch-byte-compile ~/.emacs.d/init-lite.el
    mv ~/.emacs.d/init-lite.elc ~/.emacs.d/init.el
    git checkout -b emacs_lite
    git add .
    git commit -m "Replaced .emacs.d/init.el with init-lite.elc"
}

main

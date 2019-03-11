#!/bin/bash

COMMITS=$(git log --no-color -- ~/.emacs | grep -- "^commit " | cut -d' ' -f2)

for commit in "${COMMITS[@]}"; do
    git show $commit -- $1
done

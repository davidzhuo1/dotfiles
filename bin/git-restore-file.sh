#!/bin/bash

COMMIT_HASH=$(git log -1 -- "$1" | head -n 1 | cut -d' ' -f 2)
git checkout $COMMIT_HASH^ -- "$1"

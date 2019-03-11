#!/bin/zsh

rm -rf clone/

GIT_ROOT=$(git rev-parse --show-toplevel)
git clone --depth 1 -b master --progress -- file://"$GIT_ROOT" clone

echo "-- -- -- -- Cleaning up the clone -- -- -- --"
cd clone
rm -rf .git
mv .gitignore ../.gitignore

echo "-- -- -- -- Starting fresh git history -- -- -- --"
git init
git config remote.origin.url git@github.com:davidzhuo1/dotfiles.git
git config user.name "David Zhuo"
git config user.email "davidzhuo1@github.com"

git add -f .
mv ../.gitignore .gitignore
git add -f .gitignore
git commit -m "Initial commit"

echo "-- -- -- -- Pushing -- -- -- --"
git push -f -u origin master

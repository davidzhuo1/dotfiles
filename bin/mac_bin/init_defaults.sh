#/bin/bash

[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"

# Make UI faster
defaults write com.apple.dock autohide-time-modifier -float 0.1
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write -g QLPanelAnimationDuration -float 0.001
defaults write -g NSWindowResizeTime -float 0.001
defaults write -g NSAutomaticWindowAnimationsEnabled -bool FALSE

defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25

# Safari
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false     # 'find' searches in the middle of words
defaults write com.apple.Safari IncludeDevelopMenu -bool true                   # include develop menu

# Increase key repeat speed
defaults write -g InitialKeyRepeat -int 20
defaults write -g KeyRepeat -float 1.3

# Finder tweaks
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true     # Default expand "save" screen
defaults write com.apple.finder QLEnableTextSelection -bool true                # Allow copy-pasta from quick look
defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE
defaults write com.apple.finder PathBarRootAtHome -bool TRUE
chflags nohidden ~/Library/

# Photos tweaks
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true    # Don't prompt to sync iPhone

# Print UI tweak
defaults write -g PMPrintingExpandedStateForPrint -bool TRUE

# Kill Dashboard
defaults write com.apple.dashboard mcx-disabled -boolean TRUE

# Enable ssh to wake device
pmset -c ttyskeepawake 1

killall Dock && killall Finder

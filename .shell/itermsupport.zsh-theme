#!/bin/zsh
# Sets iterm window color if available

# Manual override of window title
set_window_title() {
    export DISABLE_AUTO_TITLE='true'
    echo -e "\033];"$*"\007"
}

unset_window_title() {
    unset DISABLE_AUTO_TITLE
}

# If iterm session is detected, set the window color
if [[ -n "$ITERM_SESSION_ID" ]]; then
    tab-color() {
        echo -ne "\033]6;1;bg;red;brightness;$1\a\033]6;1;bg;green;brightness;$2\a\033]6;1;bg;blue;brightness;$3\a"
    }
    tab-red()      { tab-color 203 37 61 }
    tab-orange()   { tab-color 253 165 68 }
    tab-yellow()   { tab-color 140 140 30 }
    tab-green()    { tab-color 62 179 131 }
    tab-babyblue() { tab-color 160 160 255 }
    tab-blue()     { tab-color 12 158 220 }
    tab-reset()    { echo -ne "\033]6;1;bg;*;default\a" }

    iterm2_tab_precmd() {
        # Call signaller asynchronously
        if [[ "${PREV_PROC}" != 0 ]]; then
            kill -9 ${PREV_PROC} &> /dev/null
        fi

        signaller &!
        PREV_PROC=$!
    }

    signaller() {
        # Which signals to parent process
        sleep 2
        kill -s USR1 $$
    }

    TRAPUSR1() {
        # To reset the tab color
        tab-reset
        PREV_PROC=0
    }

    iterm2_tab_preexec() {
        if [[ "$1" =~ "^top" || "$1" =~ "^htop" ]]; then
            tab-red
        elif [[ "$1" =~ "^ssh " || "$1" =~ "^ash " || "$1" =~ "^ashhome" || "$1" =~ "^tmux " ]]; then
            tab-green
        elif [[ "$1" =~ "^python" ]]; then
            tab-blue
        elif [[ "$1" =~ "^emacs " || "$1" =~ "^em " || "$1" =~ "^edit_" ]]; then
            tab-orange
        else
            tab-babyblue
        fi
    }

    autoload -U add-zsh-hook
    add-zsh-hook precmd  iterm2_tab_precmd
    add-zsh-hook preexec iterm2_tab_preexec
fi

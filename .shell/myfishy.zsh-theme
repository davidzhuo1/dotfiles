#!/bin/zsh
# Custon ZSH Theme emulating the Fish shell's default prompt.

# Provide a pretty prompt
shorten_home_pwd() {
    pwd | perl -pe "
    BEGIN {
    binmode STDIN,  ':encoding(UTF-8)';
    binmode STDOUT, ':encoding(UTF-8)';
    };
    s|^$HOME|~|g;
    "
}

[ $UID -eq 0 ] && user_color='red'
local NEWLINE=$'\n'
PROMPT='%{$fg[blue]%}$(shorten_home_pwd) %{$fg[grey]%}%n@%m ${NEWLINE}%{$fg[green]%}%(!.#.>)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

local return_status="%{$fg_bold[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

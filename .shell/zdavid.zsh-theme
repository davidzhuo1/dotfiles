# vim:et sts=2 sw=2 ft=zsh
# Requires the `git-info` zmodule to be included in the .zimrc file.

prompt_zdavid_help () {
  cat <<EOH
This prompt can be customized with:

    prompt zdavid [username_color] [hostname_color] [pwd_color] [branch_color]
        [unindexed_color] [unindexed_indicator]
        [indexed_color] [indexed_indicator]
        [untracked_color] [untracked_indicator]
        [stashed_color] [stashed_indicator]

The default values for each parameter, for 256-color terminals (or otherwise)
are the following:

 1. username color: 135 (or magenta)
 2. hostname color: 166 (or yellow)
 3. current working directory color: 118 (or green)
 4. git branch name color: 81 (or cyan)
 5. git unindexed color: 166 (or yellow)
 6. git unindexed indicator: ●
 7. git indexed color: 118 (or green)
 8. git indexed indicator: ●
 9. git untracked color: 161 (or red)
10. git untracked indicator: ●

The git stashed color and indicator are not defined by default, and will not be
shown unless defined.
EOH
}

prompt_zdavid_git() {
  [[ -n ${git_info} ]] && print -n " ${(e)git_info[prompt]}"
}

prompt_zdavid_virtualenv() {
  [[ -n ${VIRTUAL_ENV} ]] && print -n " (%F{blue}${VIRTUAL_ENV:t}%f)"
}

prompt_zdavid_precmd() {
  (( ${+functions[git-info]} )) && git-info
}

prompt_zdavid_return_status() {
  print -n "%(?.. (%F{red}%?%f%))"
}

prompt_zdavid_return_time() {
  print -n " %{%F{${7}}%D{%b/%d %H:%M:%S}%f%}"
}

prompt_zdavid_setup() {
  [[ -n ${VIRTUAL_ENV} ]] && export VIRTUAL_ENV_DISABLE_PROMPT=1

  local col_user
  local col_host
  local col_pwd
  local col_brnch
  local col_unidx
  local col_idx
  local col_untrk
  # use extended color palette if available
  if (( terminfo[colors] >= 256 )); then
    col_user="%F{${1:-135}}"
    col_host="%F{${2:-166}}"
    col_pwd="%F{${3:-118}}"
    col_brnch="%F{${4:-81}}"
    col_unidx="%F{${5:-166}}"
    col_idx="%F{${7:-118}}"
    col_untrk="%F{${9:-161}}"
  else
    col_user="%F{${1:-magenta}}"
    col_host="%F{${2:-yellow}}"
    col_pwd="%F{${3:-green}}"
    col_brnch="%F{${4:-cyan}}"
    col_unidx="%F{${5:-yellow}}"
    col_idx="%F{${7:-green}}"
    col_untrk="%F{${9:-red}}"
  fi
  local ind_unidx=${6:-●}
  local ind_idx=${8:-●}
  local ind_untrk=${10:-●}
  local col_stash=${11:+%F{${11}}}
  local ind_stash=${12}

  autoload -Uz add-zsh-hook && add-zsh-hook precmd prompt_zdavid_precmd

  prompt_opts=(cr percent sp subst)

  zstyle ':zim:git-info' verbose 'yes'
  zstyle ':zim:git-info:branch' format '%b'
  zstyle ':zim:git-info:commit' format '%c'
  zstyle ':zim:git-info:action' format "(${col_idx}%s%f)"
  zstyle ':zim:git-info:unindexed' format "${col_unidx}${ind_unidx}"
  zstyle ':zim:git-info:indexed' format "${col_idx}${ind_idx}"
  zstyle ':zim:git-info:untracked' format "${col_untrk}${ind_untrk}"
  zstyle ':zim:git-info:stashed' format "${col_stash}${ind_stash}"
  zstyle ':zim:git-info:keys' format \
    'prompt' "(${col_brnch}%b%c%I%i%u%f%S%f)%s"

  PS1="
${col_user}%n%f at ${col_host}%m%f in ${col_pwd}%~%f\$(prompt_zdavid_git)\$(prompt_zdavid_virtualenv)\$(prompt_zdavid_return_time)\$(prompt_zdavid_return_status)
> "
  RPS1=""
}

prompt_zdavid_preview () {
  if (( ${#} )); then
    prompt_preview_theme zdavid "${@}"
  else
    prompt_preview_theme zdavid
    print
    prompt_preview_theme zdavid magenta yellow green cyan magenta '!' green '+' red '?' yellow '$'
  fi
}

# redraw_prompt() {
#     PS1="hi hi hi"
#     zle && zle reset-prompt
# }

prompt_zdavid_setup "${@}"

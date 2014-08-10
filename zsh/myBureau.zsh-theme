# oh-my-zsh Bureau Theme + fino theme

### NVM

ZSH_THEME_NVM_PROMPT_PREFIX="%B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="↑"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR=%{$fg[green]%}

ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="↓"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR=%{$fg[red]%}

ZSH_THEME_GIT_PROMPT_STASHED_BUREAU="◇"
ZSH_THEME_GIT_PROMPT_STASHED_BUREAU_COLOR=%{$fg[cyan]%}

bureau_git_remote_status() {
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

        if [ $ahead -gt 0 ] && [ $behind -eq 0 ]
            then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
            git_remote_status_detailed=" $ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
        elif [ $behind -gt 0 ] && [ $ahead -eq 0 ]
            then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
            git_remote_status_detailed=" $ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]
            then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
            git_remote_status_detailed=" $ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR|$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        fi

    # Handle stashed commit                
    if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
        git_remote_status_detailed="$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_STASHED_BUREAU_COLOR$ZSH_THEME_GIT_PROMPT_STASHED_BUREAU$(git_stashes_count)%{$reset_color%}"
    fi
    if [ $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]
        then
        git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX$git_remote_status_detailed%{$fg[yellow]%}$remote$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
    fi
    echo $git_remote_status
fi
}

git_stashes_count () {
  st_num=$(/usr/bin/git stash list 2> /dev/null | wc -l | tr -d ' ')
  if [[ $st_num != "0" ]]; then
    echo $st_num
  fi
}

bureau_git_prompt () {
  local _branch=$(git_prompt_info)
  local _status=$(git_prompt_status)
  _status+=$(bureau_git_remote_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result$_status"
  fi
  _result="$_result"
fi
echo $_result
}

RETURN_CODE="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
_PATH="%{$fg_bold[grey]%}:%{$FG[202]%}%~%{$reset_color%}"

if [[ "%#" == "#" ]]; then
  _USERNAME="%{$fg_bold[red]%}%n"
  _LIBERTY="%{$fg[red]%}#"
else
  _USERNAME="%{$FG[057]%}%n"
  _LIBERTY="%{$fg[green]%}$"
fi
_USERNAME="$_USERNAME%{$reset_color%}%{$fg_bold[grey]%}@%{$reset_color%}%{$FG[068]%}%m%{$reset_color%}"
_LIBERTY="$_LIBERTY%{$reset_color%}"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}} 
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))
  
  for i in {0..$LENGTH}
  do
      SPACES="$SPACES "
  done

  echo $SPACES
}

_1LEFT="%{$fg_bold[grey]%}┌%{$reset_color%}$_USERNAME$_PATH"
_1RIGHT="%{$fg_bold[grey]%}[%*]%{$reset_color%} "

bureau_precmd () {
  _1SPACES=`get_space $_1LEFT $_1RIGHT`
  print 
  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

setopt prompt_subst
PROMPT='%{$fg_bold[grey]%}└>%{$reset_color%}$_LIBERTY'
RPROMPT='$RETURN_CODE $(nvm_prompt_info) $(bureau_git_prompt)'

autoload -U add-zsh-hook
add-zsh-hook precmd bureau_precmd

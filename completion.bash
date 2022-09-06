#/usr/bin/env bash
_up () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local LS=$(echo $PWD)
  local LSARRAY=${LS//\// }
  COMPREPLY=( $(compgen -W "${LSARRAY}" -- $cur) )
  return 0
}
complete -F _up up
_tmx () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local TMUX=$(tmux ls -F#{session_name} 2>&1)
  if [[ "$TMUX" != *"no server running"* ]]; then
    COMPREPLY=( $(compgen -W "${TMUX}" -- $cur) )
  fi
  return 0
}
complete -F _tmx tmx

#/usr/bin/env bash
_up () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local LS="$PWD"
  local LSARRAY=${LS//\// }
  COMPREPLY=( $(compgen -W "${LSARRAY}" -- $cur) )
  return 0
}
complete -F _up up
_tmx () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  case $3 in
    # autocomplete directories
    -d)
      compopt -o nospace
      COMPREPLY=( $(compgen -d -o default -- $cur) )
      ;;
    # else autocomplete tmx session names
     *)
       local TMUX_ACTIVE=$(tmux ls -F#{session_name} 2>&1)
       if [[ "$TMUX_ACTIVE" == *"no server running"* ]] || [[ "$TMUX_ACTIVE" == *"error connecting to"* ]]; then
         TMUX_ACTIVE=""
       fi
       local TMUX_SAVED=$(cat ~/bin/.tmux.formats | sed 's/::.*//')
       local TMUX="$TMUX_ACTIVE $TMUX_SAVED"
       COMPREPLY=( $(compgen -W "${TMUX}" -- $cur) )
      ;;
  esac
  return 0
}
complete -F _tmx tmx

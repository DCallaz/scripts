#/usr/bin/env bash
_up () {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local LS=$(echo $PWD)
  local LSARRAY=${LS//\// }
  COMPREPLY=( $(compgen -W "${LSARRAY}" -- $cur) )
  return 0
}
complete -F _up up

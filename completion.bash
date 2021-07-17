#/usr/bin/env bash
LS=$(echo $PWD)
LSARRAY=${LS//\// }
complete -W "$LSARRAY" up

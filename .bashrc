source ~/completion.bash
export EDITOR=vim
export VISUAL=vim
export JAVA_HOME="/usr/lib/jvm/default-java"
export D4J_HOME="~/subjects/masters/Defects4J-multifault/docker/resources/defects4j"
export COVERAGE_DIR="~/subjects/masters/Defects4J-multifault/docker/resources/fault_data"
export TMP_DIR="../tmp"
export RANGE_ANALYZER=~/subjects/masters/Defects4J-multifault/docker/resources/java_analyzer/target/java-analyzer-1.0-SNAPSHOT-shaded.jar
export PATH="${PATH}:${D4J_HOME}/framework/bin"
export FLITSR_HOME="$HOME/subjects/masters/flitsr"
export PATH="$HOME/bin:$FLITSR_HOME:$PATH"
export LIBS="-L/home/dfe/Archive/boost_1_44_0/stage/lib"
export CPPFLAGS="-I/home/dfe/Archive/boost_1_44_0"
#For ANTLR
export CLASSPATH=".:/usr/local/lib/antlr-4.9-complete.jar:$CLASSPATH"
alias antlr4='java -Xmx500M -cp "/usr/local/lib/antlr-4.9-complete.jar:$CLASSPATH" org.antlr.v4.Tool'
alias grun='java -Xmx500M -cp "/usr/local/lib/antlr-4.9-complete.jar:$CLASSPATH" org.antlr.v4.gui.TestRig'

#No <ctrl>-s
if [[ -t 0 && $- = *i* ]]
then
      stty -ixon
fi

#My aliases
alias c='clear'

alias ls='ls -Fh --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias lj='ls -la *.java'
alias lc='ls -la *.c'

alias ga='git add'
alias gc='git commit'
alias gm='git commit -m'
alias gpl='git pull'
alias gps='git push'
alias gs='git status'
alias gk='gitk'
alias img='cacaview '
alias ebrc='vim ~/.bashrc'
alias gucci='cc -Wall -ansi -pedantic -o'
alias updots='~/repos/.dotfilesMinimal/update.sh'
alias vid='vim ~/'
# Search files in the current folder
alias f="find . | grep "
alias ascii="xdg-open ~/.ascii.gif"

#grep stuff
export GREP_OPTIONS='--color=auto'

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest > 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest > 0 ]]; then bind "set show-all-if-ambiguous On"; fi

#Colors
export CLICOLOR=1
export LS_COLORS="no=00:fi=00:di=00;35:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:*.java=00;33:*.txt=00;91:*.pdf=1;35:*.tar.bz2=01;33:*.c=38;5;14:ex=38;5;205:"
#export GREP_OPTIONS='--color=auto' #deprecated
unset GREP_OPTIONS

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

#functions
# Extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in $*; do
		if [ -f $archive ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

#Adds a given tmx format to the list of known formats
addTmxFormat () {
  if [ "$#" == "2" ]; then
    if [ "$(grep "^$1" ~/bin/.tmux.formats)" != "" ]; then
      sed -i "s/^$1::.*/$1::$2/" ~/bin/.tmux.formats
    else
      echo "$1::$2" >> ~/bin/.tmux.formats
    fi
  else
    printf "USAGE: addTmxFormat <name> <format string>\n"
  fi 
}

#Finds a source code directory below the current and goes there
src () {
  LS=$(echo */)
  LSARRAY=($LS)
  while [ "${LSARRAY[0]}" != "*/" ]; do
    if [[ "${LSARRAY[@]}" =~ "main/" ]]; then
      cd main
      echo "changed to main"
    elif [[ "${LSARRAY[@]}" =~ "src/" ]]; then
      cd src
      echo "changed to src"
    else
      cd "${LSARRAY[0]}"
      echo "changed to ${LSARRAY[0]}"
    fi
  LS=$(echo */)
  LSARRAY=($LS)
  done
}

# Goes up to the given direcotry
up () {
  LS=$(echo $PWD)
  LSARRAY=(${LS//\// })
  i=1
  if [[ $LS == *$1/* ]]; then
    FIND=$1
    if [[ $1 == */* ]]; then
      ARR=(${FIND//\// })
      FIND=${ARR[${#ARR[@]}-1]}
    fi
    while [ "${LSARRAY[${#LSARRAY[@]}-$i]}" != "$FIND" ] && [ $i != ${#LSARRAY[@]} ]; do
      #echo ${LSARRAY[${#LSARRAY[@]}-$i]}
      cd ../
      i=$(($i+1))
    done
    exec bash
  else
    echo "Did not find directory $1"
  fi
}

up2 () {
  local path=$PWD
  case $1 in
    (''|'..')
      cd ..; return ;;
    (.)
      cd .; return ;;
    (/)
      cd /; return ;;
    (*/*)
      printf '"%s" %s\n' "$1" 'contains forward slashes, up will not work' >&2
      return 1 ;;
  esac
  if [[ $path != /* ]]; then
    printf '%s\n' 'PWD is not an absolute path, up will not work' >&2
    return 1
  fi
  until [[ $path = / ]]; do
    path=${path%/*}
    path=${path:-/}
    if [[ ${path%"$1"} != "$path" ]] && [[ -d ${path%"$1"} ]]
    then
      cd -- "$path"
      return
    fi
  done
  printf '%s "%s" %s\n' 'Directory' "$1" 'not found' >&2
  return 1
}

# Goes up a specified number of directories  (i.e. up 4)
cdup () {
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# Sets the name of the terminal
sett () {
	if [[ -z "$ORIG" ]]; then
		ORIG=$PS1
	fi
	TITLE="\[\e]2;$*\a\]"
	PS1=${ORIG}${TITLE}
}
export -f sett

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[35m\]\u\[\e[m\]\[\e[37m\]@\[\e[m\]\[\e[35m\]\h\[\e[m\]\[\e[32m\]\`parse_git_branch\`\[\e[m\]-\[\e[33m\]\A\[\e[m\]\[\e[31m\]\w\[\e[m\]\[\e[36m\]\\$\[\e[m\]\n> "
#neofetch --ascii ~/.config/noefetch/rpi_ascii --ascii_colors 2
#neofetch

PATH="/home/dylan/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/dylan/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/dylan/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/dylan/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/dylan/perl5"; export PERL_MM_OPT;

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

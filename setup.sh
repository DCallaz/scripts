FILES=$(ls -a)
SCRIPTS=$(pwd)
# Create symbolic links to home directory
for file in $FILES; do
  if [[ "$file" != ".." ]] && [[ "$file" != "." ]] && [[ "$file" != ".git" ]] &&
    [[ "$file" != "setup.sh" ]] && [ "$file" != "README.md" ] && [ ! -f ~/"$file" ]; then
    #echo $file
    cd ~/
    ln -sf "$SCRIPTS/$file"
    #echo "$SCRIPTS/$file"
  else
    echo "Not copying $file"
  fi
done
# Set up bash_global link
if [ -f ~/.bashrc ]; then
  if [ "$(grep "# Include global settings" ~/.bashrc)" != "" ]; then
    echo "Found set-up bashrc already"
  elif [ "$(head -n 1 ~/.bashrc)" == "#!/bin/bash" ]; then
    # Add below shebang
    sed -i '2s;^;# Include global settings\nsource ~/.bash_global\n\n;' ~/.bashrc
  else
    # Add as first line
    sed -i '1s;^;# Include global settings\nsource ~/.bash_global\n\n;' ~/.bashrc
  fi
else
    # Create new file
    echo -e "#!/bin/bash\n# Include global settings\nsource ~/.bash_global\n" > ~/.bashrc
fi
# Set up python "global" virtual environment
if command  -v python3 2>&1 >/dev/null; then
  python3 -m venv --clear --upgrade-deps ~/.global_python_venv
  # remove prompt prefix for global env
  sed -i "s/(\.global_python_venv) //g" ~/.global_python_venv/bin/*
fi
# Set up vim plug and load all plugins
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
fi
# Set up tmux plugin manager & plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
# install latex and texfot if not installed
# TODO
# install powerline-fonts for vim airline
powerline_install=0
if [ -f "/etc/os-release" ]; then
  distro="$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed 's/"//g')"
  if [ "$distro" == "Ubuntu" ]; then
    sudo apt-get install fonts-powerline
    if [ $? -eq 0 ]; then
      powerline_install=1
    fi
  elif [ "$distro" == "Fedora" ]; then
    sudo dnf install powerline-fonts
    if [ $? -eq 0 ]; then
      powerline_install=1
    fi
  fi
fi
if [ "$powerline_install" -eq 0 ]; then
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
fi
echo "DONE: Reload the terminal to source all files"

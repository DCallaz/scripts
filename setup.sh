FILES=$(ls -a)
SCRIPTS=$(pwd)
# Create symbolic links to home directory
for file in $FILES; do
  if [[ "$file" != ".." ]] && [[ "$file" != "." ]] && [[ "$file" != ".git" ]] &&
    [[ "$file" != "setup.sh" ]] && [ "$file" != "README.md" ]; then
    #echo $file
    cd ~/
    ln -sf "$SCRIPTS/$file"
    #echo "$SCRIPTS/$file"
  fi
done
# Set up bash_global link
if [ -f ~/.bashrc ]; then
  if [ "$(head -n 1 ~/.bashrc)" == "#!/bin/bash" ]; then
    # Add below shebang
    sed -i '2s;^;# Include global settings\nsource ~/.bash_global\n\n;' ~/.bashrc
  else
    # Add as first line
    sed -i '1s;^;# Include global settings\nsource ~/.bash_global\n\n;' ~/.bashrc
  fi
else
    # Create new file
    echo -e "# Include global settings\nsource ~/.bash_global\n" > ~/.bashrc
fi
# Set up vim plug and load all plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
# install latex and texfot if not installed
# TODO
# install powerline-fonts for vim airline
if [ -f "/etc/os-release" ]; then
  distro="$(awk -F= '/^NAME/{print $2}' /etc/os-release | sed 's/"//g')"
  if [ "$distro" == "Ubuntu" ]; then
    sudo apt-get install fonts-powerline
  elif [ "$distro" == "Fedora" ]; then
    sudo dnf install powerline-fonts
  else
    git clone https://github.com/powerline/fonts.git --depth=1
    cd fonts
    ./install.sh
    cd ..
    rm -rf fonts
  fi
fi
echo "DONE: Reload the terminal to source all files"

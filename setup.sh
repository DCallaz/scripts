FILES=$(ls -a)
SCRIPTS=$(pwd)
# Create symbolic links to home directory
for file in $FILES
do
  if [[ "$file" != ".." ]] && [[ "$file" != "." ]] && [[ "$file" != ".git" ]] &&
    [[ "$file" != "setup.sh" ]]; then
    #echo $file
    cd ~/
    ln -sf "$SCRIPTS/$file"
    #echo "$SCRIPTS/$file"
  fi
done
# Set up vim plug and load all plugins
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
# install latex and texfot if not installed
# TODO
echo "DONE: Reload the terminal to source all files"

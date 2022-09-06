FILES=$(ls -a)
SCRIPTS=$(pwd)
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
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
echo "DONE: Reload the terminal to source all files"

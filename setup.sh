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
echo "DONE: Reload the terminal to source all files"

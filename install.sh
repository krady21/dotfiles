#!/bin/bash

sudo apt-get update
sudo apt-get install -y vim-gtk tmux zathura
sudo apt-get install dconf-cli uuid-runtime # used by gogh

# Installs gruvbox themes on the terminal
echo "61 62" | bash -c  "$(wget -qO- https://git.io/vQgMr)" 

cp .vimrc ~/.vimrc
cp .tmux.conf ~/.tmux.conf
cp -r zathurarc ~/.config/zathura/zathurarc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.vim/plugged ~/.vim/undodir

vim +PlugInstall +q +q

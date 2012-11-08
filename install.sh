#!/bin/sh
sudo apt-get install ncurses-term exuberant-ctags
git submodule update --init
ln -s ~/.vim/vimrc ~/.vimrc

# this installs fonts
sudo cp -R ./fonts/source-code-pro-powerline /usr/share/fonts/truetype
sudo fc-cache -fv

#!/bin/bash

$now_install = "n"

echo "Select an option:"

echo "1: Copy repo's Neovim configuration to the user directory"
echo "2: Copy current Neovim configuration to the current directory"
echo "3: Install all languages and dependancies"

read choice

if [[ $choice == 1 ]]; then
  cp ./init.lua $HOME/.config/nvim/init.lua
  echo "Copied repo's Neovim configuration to the user directory"
fi

if [[ $choice == 2 ]]; then
  cp $HOME/.config/nvim/init.lua ./init.lua
  echo "Copied user's Neovim configuration to the current directory"
fi

if [[ $choice == 3 ]]; then
  echo "Sudo needed to install dependencies"
  sudo apt update
  sudo apt-get install -y neovim golang-go npm python3 python3-pip python3-venv python3-dev python3-pynvim composer
  echo "Finished installing dependencies"
fi

if [[ $choice == 3 ]]; then
  echo "Would you like to install the neovim configuration now? (y/n)"
  read now_install
fi

if [[ $now_install == "y" ]]; then
  cp ./init.lua $HOME/.config/nvim/init.lua
  echo "Copied repo's Neovim configuration to the user directory"
fi

if [[ $now_install == "n" ]]; then
  echo "Exiting"
fi

#!/usr/bin/env bash
echo "1: Ubuntu/Debian (apt)"
echo "2: Arch (pacman)"

read choice

if [[ "$choice" == 1 ]]; then
	sudo add-apt-repository ppa:avengemedia/danklinux
	sudo add-apt-repository ppa:avengemedia/dms
	sudo add-apt-repository ppa:neovim-ppa/unstable
	sudo apt update && sudo apt upgrade -y && sudo apt install ripgrep 
	sudo apt install niri dms build-essential git python3-pip
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source "$HOME/.cargo/env"
	sudo apt install wayland-protocols \
	libwayland-dev \
	libegl1-mesa-dev \
	libgles2-mesa-dev \
	libdrm-dev \
	libgbm-dev \
	libinput-dev \
	libxkbcommon-dev \
	libgudev-1.0-dev \
	libpixman-1-dev \
	libsystemd-dev \
	cmake \
	libpng-dev \
	libavutil-dev \
	libavcodec-dev \
	libavformat-dev \
	ninja-build \
	meson -y
	sudo apt install libxcb-composite0-dev \
        libxcb-icccm4-dev \
        libxcb-image0-dev \
        libxcb-render0-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev \
        libxcb-xinput-dev \
        libx11-xcb-dev -y
	sudo apt install wl-clipboard xclip -y
	sudo apt install dmenu swaybg swayidle swaylock tmux neovim luarocks golang-go zsh -y
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	npm install -g tree-sitter-cli
fi

if [[ "$choice" == 2 ]]; then
	sudo pacman -Syu ripgrep kitty nvm npm docker zsh 
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

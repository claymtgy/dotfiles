#!/usr/bin/env bash
# Ubuntu/Debian vs Arch: same role, distro-appropriate package names.
# niri + DMS (Ubuntu: PPAs; Arch: official niri + AUR helper for DMS when available).

echo "1: Ubuntu/Debian (apt)"
echo "2: Arch Linux (pacman)"

read -r choice

install_oh_my_zsh() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_tree_sitter_cli() {
	if command -v npm >/dev/null 2>&1; then
		npm install -g tree-sitter-cli
	else
		echo "npm not found; skip tree-sitter-cli (install nodejs/npm first)."
	fi
}

# DMS on Arch is not in official repos; use AUR when yay/paru exists.
install_dms_arch() {
	if command -v yay >/dev/null 2>&1; then
		yay -S --needed dms-shell-bin
	elif command -v paru >/dev/null 2>&1; then
		paru -S --needed dms-shell-bin
	else
		echo "DMS: install from AUR, e.g. yay -S dms-shell-bin (or dms-shell-niri)"
	fi
}

if [[ "$choice" == 1 ]]; then
	sudo add-apt-repository -y ppa:avengemedia/danklinux
	sudo add-apt-repository -y ppa:avengemedia/dms
	sudo add-apt-repository -y ppa:neovim-ppa/unstable

	sudo apt update
	sudo apt upgrade -y

	# Compositor + shell + toolchain + VCS
	sudo apt install -y \
		niri dms \
		build-essential git python3-pip \
		ripgrep \
		cmake ninja-build meson \
		neovim tmux zsh \
		golang-go luarocks \
		nodejs npm \
		docker.io \
		alacritty fuzzel \
		dmenu swaybg swayidle swaylock \
		wl-clipboard xclip \
		pipewire wireplumber pipewire-pulse \
		playerctl brightnessctl

	# Wayland / DRM / niri build deps (building from source or other tools)
	sudo apt install -y \
		wayland-protocols libwayland-dev \
		libegl1-mesa-dev libgles2-mesa-dev \
		libdrm-dev libgbm-dev \
		libinput-dev libxkbcommon-dev \
		libgudev-1.0-dev libpixman-1-dev libsystemd-dev \
		libpng-dev \
		libavutil-dev libavcodec-dev libavformat-dev \
		libxcb-composite0-dev libxcb-icccm4-dev libxcb-image0-dev \
		libxcb-render0-dev libxcb-xfixes0-dev libxcb-xinput-dev \
		libx11-xcb-dev

	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	# shellcheck source=/dev/null
	source "$HOME/.cargo/env"

	install_oh_my_zsh
	install_tree_sitter_cli
fi

if [[ "$choice" == 2 ]]; then
	sudo pacman -Syu

	# Groups: base-devel ~ build-essential
	sudo pacman -S --needed base-devel

	sudo pacman -S --needed \
		git python-pip rustup \
		niri \
		ripgrep neovim tmux zsh \
		go luarocks \
		nodejs npm \
		docker \
		alacritty fuzzel \
		dmenu swaybg swayidle swaylock \
		wl-clipboard xclip \
		pipewire wireplumber pipewire-pulse \
		playerctl brightnessctl \
		cmake ninja meson \
		mesa libdrm libinput libxkbcommon libgudev pixman systemd libpng \
		ffmpeg \
		wayland wayland-protocols \
		libxcb xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-xrm libx11 \
		curl wget

	rustup default stable 2>/dev/null || true

	install_dms_arch

	install_oh_my_zsh
	install_tree_sitter_cli
fi

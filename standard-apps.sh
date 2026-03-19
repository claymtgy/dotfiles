echo "1: Ubuntu/Debian (apt)"
echo "2: Arch (pacman)"

read choice

if [[ $choice == 1 ]]; then
	sudo apt update && sudo apt upgrade -y && sudo apt install ripgrep 
	sudo add-apt-repository ppa:avengemedia/danklinux
	sudo add-apt-repository ppa:avengemedia/dms
	sudo apt install niri dms build-essential git python3-pip
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
	meson
	sudo apt install libxcb-composite0-dev \
        libxcb-icccm4-dev \
        libxcb-image0-dev \
        libxcb-render0-dev \
        libxcb-xfixes0-dev \
        libxkbcommon-dev \
        libxcb-xinput-dev \
        libx11-xcb-dev
	sudo apt install dmenu
	sudo apt install swaybg
	sudo apt install swayidle
	sudo apt install swaylock
fi

if [[ $choice == 2 ]]; then
	sudo pacman -Syu ripgrep kitty nvm npm docker zsh 
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

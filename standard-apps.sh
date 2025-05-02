echo "1: Ubuntu/Debian (apt)"
echo "2: Arch (pacman)"

read choice

if [[ $choice == 1 ]]; then
	sudo apt update && sudo apt upgrade -y && sudo apt install ripgrep 
fi

if [[ $choice == 2 ]]; then
	sudo pacman -Syu ripgrep kitty nvm npm docker 
fi

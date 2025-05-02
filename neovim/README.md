# nvim-config
My personal configuration for Neovim.

This is largely a branch off from [kickstart](https://github.com/nvim-lua/kickstart.nvim)

## Installation:
Just download the code, change to the directory of the download, run 
```sudo chmod +x ./installation.sh```
and select your options you'd like to follow.

This is now a Lua config. Currently using Lazy.nvim
Ensure you have ripgrep installed

The servers that I have installed by default are Volar (for vue.js), tsserver (typescript), phpactor (One for PHP), One for Python.

## PHP LSP
If you wish to use the PHP server, ensure you have Composer installed
(The installation option 3 will do this for you if you're on Linux)

### On Debian-based Linux Distros (i.e. Ubuntu):
```sudo apt update && sudo apt install composer```
(The installation option 3 will do this for you if you're on Linux)

### On Mac (with Homebrew):
```brew install composer```

## Vue LSP
If you wish to use Volar, ensure you have node installed.
(The installation option 3 will do this for you if you're on Linux)

### On Debian-based Linux Distros (i.e. Ubuntu):
``` sudo apt update && sudo apt install node```

### On Mac (with Homebrew):
```brew install node```

## Start:
From there, open Neovim. It should start installing all the plugins. 

Run ```:checkhealth``` to see if everything was installed correctly.

You will probably have to run ```:MasonUpdate``` to update the LSP side of things fully. 

Run :Lazy to check plugins status.

## Keys:
```<leader>``` is configured to " "

```<leader> sf``` will run "find files" using Telescope

```<leader> sg``` will search contents of files


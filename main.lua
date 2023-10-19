local pacman = require("utils.pacman")
local shell_files = require("shell/generate")


-- install packages
local packages = {
    "exa", 
    "ripgrep", 
    "bat", 
    "fd", 
    "tokei", 
    "grex"
}

pacman.install_packages(packages)


-- generate shell files
shell_files.root_path = "./output"
shell_files.bash()
shell_files.zsh()

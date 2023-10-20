#!/bin/env bash

# install_system
source "recipes/system-deb.sh"
install_system

# install starship
source "recipes/starship-rs.sh"
install_starship

# asdf
source "recipes/asdf.sh"
install_asdf
install_asdf_languages

# sdkman
source "recipes/sdkman.sh"
install_sdkman
install_sdkman_languages

# rustup
source "recipes/rustup.sh"
install_rustup
install_rustup_languages

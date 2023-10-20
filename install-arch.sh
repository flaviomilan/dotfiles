source recipes/system.sh
source recipes/asdf.sh
source recipes/sdkman.sh
source recipes/rustup.sh

install_system

# asdf
install_asdf
install_asdf_languages

# sdkman
install_sdkman
install_sdkman_languages

# rustup
install_rustup
install_rustup_languages
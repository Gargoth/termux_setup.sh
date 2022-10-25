#!/bin/bash

# Run with the command below
# curl -sLf <replace with URL to raw> | bash

# WARNING: Only run this script on a fresh install of termux, entire directories may be lost when the script runs

# Logging functions
info () {
    printf "\r  [\033[00;34m...\033[0m ] $1\n"
}

warning () {
    printf "\r  [ \033[00;36m\!\!\033[0m ] $1\n"
}

user () {
    printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
    printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
}

# Packages to install
# Each package must have a corresponding install function with the format `install_$package`
packages=(
    'tsu'
    'fish'
    'fisher'
    'hydro'
    'node'
    'yarn'
    'neovim'
    'glow'
    'exa'
    'bat'
    'delta'
    'gh'
    'python'
    'speedtest'
    'font'
)

ensure_requirements() {
    info "Upgrading packages"
    pkg upgrade -y
    info "Ensuring wget, curl, tar, and git are installed"
    pkg install wget curl tar git -qy
}

install_tsu() {
    info "Installing tsu"
    pkg install tsu -qy && success "tsu installed" || fail "tsu failed to install"
}

install_fish() {
    info "Installing fish"
    pkg install fish -qy && success "fish installed" || fail "fish failed to install"

    info "Changing default shell to fish"
    chsh -s fish

    info "Cloning fish config repo to config folder"
    cd ~
    rm -rf ~/.config/fish && info "current fish config deleted" | info "current fish config deletion failed"
    mkdir -p .config/fish
    cd ~/.config/fish/
    git clone https://github.com/Gargoth/fish-config.git . && success "fish configs cloned" || fail "fish configs failed to clone"
    cd ~
}

install_fisher() {
    info "Installing fisher"
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher && success "fisher installed" || fail "fisher failed to install"
}

install_hydro() {
    info "Installing hydro"
    fisher install jorgebucaran/hydro && success "hydro installed" || fail "hydro failed to install"

}

install_node() {
    info "Installing node latest"
    pkg install nodejs -qy
}

install_yarn() {
    info "Installing yarn"
    npm i -g yarn && success "yarn installed" || fail "yarn failed to install"
}

install_neovim() {
    info "Installing neovim nightly release"
    pkg install neovim-nightly -qy && success "neovim nightly installed" || fail "neovim nightly failed to install"

    info "Cloning nvim config repo to config folder"
    cd ~
    rm -rf ~/.config/nvim/
    mkdir -p ~/.config/nvim/
    cd ~/.config/nvim/
    git clone https://github.com/Gargoth/nvim-config.git . && success "nvim config cloned" || fail "nvim config failed to clone"
    cd ~

    info "Installing vimplug"
    cd ~
    mkdir -p ~/.local/share/nvim/site/autoload/ 
    curl -sLf https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > ~/.local/share/nvim/site/autoload/plug.vim && success "vimplug installed" || fail "vimplug failed to install"

    info "Installing neovim plugins"
    nvim --headless +PlugInstall +qall && success "Neovim plugins installed" || fail "Neovim plugins failed to install"
}

install_glow() {
    info "Installing glow"
    pkg install glow -qy && success "glow installed" || fail "glow failed to install"
}

install_exa() {
    info "Installing exa"
    pkg install exa -qy && success "exa installed" || fail "exa failed to install"
}

install_bat() {
    info "Installing bat"
    pkg install bat -qy && success "bat installed" || fail "bat failed to install"
}

install_delta() {
    info "Installing git-delta"
    pkg install git-delta -qy && success "git-delta installed" || fail "git-delta failed to install"
}

install_gh() {
    info "Installing gh (Github CLI)"
    pkg install gh -qy && success "gh installed" || fail "gh failed to install"
}

install_python() {
    info "Installing python"
    pkg install python -qy && success "python installed" || fail "python failed to install"
    python3 -m pip install --upgrade pip && success "pip installed" || fail "pip failed to install"
}

install_speedtest() {
    info "Installing speedtest-cli (Ookla)"
    python3 -m pip install speedtest-cli && success "speedtest-cli installed" || fail "speedtest-cli failed to install"
}

install_font() {
    info "Installing JetBrains Font"
    curl -Slf "https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf?raw=true" > ~/.termux/font.ttf && success "Font installed" || fail "Font failed to install"
}

# Execute

cd ~

ensure_requirements

for package in "${packages[@]}"
do
    install_${package}
done

pkg autoclean && success "successfully ran (pkg autoclean)" || fail "failed to run (pkg autoclean)"

user "POST-INSTALL:"
user " - Log-in through gh-cli"
user " - Set git-delta config"

#!/usr/bin/env bash
# set -x

apt_packages=(
    build-essential
    automake
    autoconf
    g++
    bison
    ninja-build
    gdb-multiarch
    make
    cmake
    wget
    git
    tig
    htop
    tree
    curl
    neovim
    docker.io
    paper-icon-theme
    gnome-tweak-tool
    clangd-12
)

sudo add-apt-repository universe
sudo add-apt-repository -y ppa:snwh/ppa # paper icons
sudo add-apt-repository -y ppa:neovim-ppa/unstable # neovim

sudo apt-get update 
sudo apt-get install ${apt_packages[@]} -y

# clangd
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100

# golang
sudo rm -rf /usr/local/go
sudo curl -sL https://go.dev/dl/go1.17.8.linux-amd64.tar.gz | sudo tar -C /usr/local -xz
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup completions bash > ~/.local/share/bash-completion/completions/rustup
rustup completions bash cargo > ~/.local/share/bash-completion/completions/cargo
rustup toolchain install nightly
rustup component add rust-src clippy rustfmt

rustup +nightly component add rust-analyzer-preview
sudo update-alternatives --install /usr/bin/rust-analyzer rust-analyzer ~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer 100

# docker
sudo groupadd docker
sudo usermod -aG docker $USER

# haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# nvm, npm, node
node_packages=(
    tldr
    meta
    pyright
    typescript
    typescript-language-server
    bash-language-server
)

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install node
nvm use node

npm install -g ${node_packages[@]}

cargo install ripgrep
cargo install fd-find
cargo install git-delta
cargo install --git https://github.com/latex-lsp/texlab.git --locked

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

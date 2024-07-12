sudo dnf update -y
sudo dnf install -y \
  tree \
  git \
  neovim \
  tldr \
  cargo \
  ranger \
  zoxide \
  fzf \
  axel \
  plocate \
  trash-cli \
  duf \
  gh \
  bat \
  htop \
  httping \
  aria2 \
  tmux \
  speedtest-cli \
  httpie \
  fuse3

cargo install \
  du-dust \
  eza \
  procs \
  ripgrep

echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
echo 'export PATH="$PATH:/home/wenzexu/.cargo/bin"' >> ~/.bashrc
echo 'alias bat="batcat"' >> ~/.bashrc
echo 'alias vi="nvim"' >> ~/.bashrc
echo 'alias vim="nvim"' >> ~/.bashrc
echo 'alias rm="trash-put"' >> ~/.bashrc
echo 'alias ll="eza -al -s=time"' >> ~/.bashrc
echo 'alias cd="z"' >> ~/.bashrc

source ~/.bashrc

git config --global user.name "wenzexu"
git config --global user.email "ricol.xwz@outlook.com"

sudo pacman -Syu
sudo pacman -S --noconfirm \
  glibc \
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
  github-cli \
  bat \
  htop \
  httping \
  aria2 \
  tmux \
  speedtest-cli \
  httpie \
  fuse2 \
  --noconfirm
cargo install \
  du-dust \
  eza \
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

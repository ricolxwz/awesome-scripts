sudo apt update -y
sudo apt install \
  locales \
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
  libfuse2 \
  -y
cargo install \
  eza
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

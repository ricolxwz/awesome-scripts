sudo apt update -y
sudo apt install \
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
  gping \
  speedtest-cli \
  httpie \
  -y
cargo install \
  du-dust \
  eza \
  procs \
  ripgrep \
  --quiet
sudo snap install \
  bandwhich \
  dog
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
echo 'export PATH="$PATH:/home/wenzexu/.cargo/bin"' >> ~/.bashrc
echo 'alias bat="batcat"' >> ~/.bashrc
echo 'alias vi="nvim"' >> ~/.bashrc
echo 'alias vim="nvim"' >> ~/.bashrc
echo 'alias rm="trash-put"' >> ~/.bashrc
echo 'alias ll="eza -al -s=time"' >> ~/.bashrc
echo 'alias cd="z"' >> ~/.bashrc
echo 'alias jn="jupyter notebook --no-browser --ServerApp.root_dir=\'/home/wenzexu/jupyter\' --IdentityProvider.token=hzndyh8cpnwscc4heicqq7esnovaud --ServerApp.allow_origin=\'*\' --port=65520 --ServerApp.port_retries=0"' >> ~/.bashrc
source .bashrc
git config --global user.name "wenzexu"
git config --global user.email "ricol.xwz@outlook.com"

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
  libfuse2t64 \
  -y
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
source .bashrc
git config --global user.name "wenzexu"
git config --global user.email "ricol.xwz@outlook.com"
token=""
read -p "请输入Ubuntu Pro Token (按Enter跳过): " token
if [ -z "$token" ]; then
    echo "没有输入Token，跳过安装。"
else
    sudo apt update && sudo apt install -y ubuntu-advantage-tools
    sudo pro attach $token
    sudo apt update -y
fi

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
  speedtest-cli \
  httpie \
  libfuse2 \
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
sudo locale-gen zh_CN.UTF-8 en_US.UTF-8
echo 'export LANG=zh_CN.UTF-8' >> ~/.bashrc
echo 'export LANGUAGE=' >> ~/.bashrc
echo 'export LC_CTYPE="en_US.UTF-8"' >> ~/.bashrc
echo 'export LC_NUMERIC=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_TIME=zh_CN.UTF-8' >> ~/.bashrc
echo 'export LC_COLLATE="en_US.UTF-8"' >> ~/.bashrc
echo 'export LC_MONETARY=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_MESSAGES="en_US.UTF-8"' >> ~/.bashrc
echo 'export LC_PAPER=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_NAME=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_ADDRESS=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_TELEPHONE=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_MEASUREMENT=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_IDENTIFICATION=en_US.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=' >> ~/.bashrc
source ~/.bashrc
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

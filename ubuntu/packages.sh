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
  du-dust \
  eza \
  ripgrep
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
echo 'export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
source .bashrc
nvm install --lts
nvm use --lts
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
token=""
read -p "请输入Ubuntu Pro Token (按Enter跳过): " token
if [ -z "$token" ]; then
    echo "没有输入Token，跳过安装。"
else
    sudo apt update && sudo apt install -y ubuntu-advantage-tools
    sudo pro attach $token
    sudo apt update -y
fi

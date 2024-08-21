sudo pacman -Syu
sudo pacman -S --needed --noconfirm \
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
  sof-firmware alsa-firmware alsa-ucm-conf \
  firefox \
  ark \
  packagekit-qt6 packagekit appstream-qt appstream \
  gwenview \
  base-devel \
  timeshift \
  xclip
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ~
sudo pacman -S --needed --noconfirm base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ~
cargo install \
  du-dust \
  eza \
  ripgrep
yay -S --needed --noconfirm nvm
echo 'source /usr/share/nvm/init-nvm.sh' >> ~/.bashrc
source /usr/share/nvm/init-nvm.sh
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

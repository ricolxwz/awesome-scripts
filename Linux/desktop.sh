cd ~
sudo apt install unzip wget -y
sudo add-apt-repository universe
sudo apt install \
  gnome-tweak-tool \
  gnome-shell-extension-manager \
  gnome-software \
  ibus-rime -y
wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict1.tar.gz"
wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict2.tar.gz"
wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict3.tar.gz"
wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict4.tar.gz"
wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict5.tar.gz"
tar -xzvf dict1.tar.gz dict1
tar -xzvf dict2.tar.gz dict2
tar -xzvf dict3.tar.gz dict3
tar -xzvf dict4.tar.gz dict4
tar -xzvf dict5.tar.gz dict5
rm *.tar.gz
mkdir ~/dicts
mv dict1/* ~/dicts/
mv dict2/* ~/dicts/
mv dict3/* ~/dicts/
mv dict4/* ~/dicts/
mv dict5/* ~/dicts/
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/IosevkaTerm.zip"
wget "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/UbuntuMono.zip"
unzip Iosevka.zip -d Iosevka
unzip IosevkaTerm.zip -d IosevkaTerm
unzip UbuntuMono.zip -d UbuntuMono
mkdir -p ~/.local/share/fonts
mv Iosevka ~/.local/share/fonts/
mv IosevkaTerm ~/.local/share/fonts/
mv UbuntuMono ~/.local/share/fonts/
rm Iosevka.zip
rm IosevkaTerm.zip
rm UbuntuMono.zip
fc-cache -v
wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo dpkg -i code.deb

cd ~
sudo apt install unzip wget -y
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
rm -rf Iosevka
rm -rf IosevkaTerm
rm -rf UbuntuMono
fc-cache -v

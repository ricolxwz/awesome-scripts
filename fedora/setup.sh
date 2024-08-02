sudo dnf update -y
sudo dnf install wget -y
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/docker.sh"
# wget -O pyenv.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/pyenv.sh"
wget -O sing-box.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/sing-box.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/desktop.sh"
wget -O locale.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/fedora/locale.sh"
chmod a+x *.sh
./user.sh
./packages.sh
./docker.sh
# ./pyenv.sh
./desktop.sh
./sing-box.sh
./network.sh
./locale.sh
cd ~
rm -rf *.sh

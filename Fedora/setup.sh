sudo dnf update -y
sudo dnf install wget -y
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/docker.sh"
# wget -O pyenv.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/pyenv.sh"
wget -O sing-box.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/sing-box.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/desktop.sh"
wget -O locale.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Fedora/locale.sh"
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

sudo apt update -y
sudo apt install wget
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/docker.sh"
# wget -O pyenv.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/pyenv.sh"
wget -O sing-box.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/sing-box.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/desktop.sh"
wget -O locale.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/debian/locale.sh"
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

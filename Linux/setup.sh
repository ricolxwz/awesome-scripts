sudo apt update -y
sudo apt install wget
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/docker.sh"
wget -O pyenv.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/pyenv.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/desktop.sh"
chmod a+x *.sh
./user.sh
./packages.sh
./docker.sh
./pyenv.sh
./network.sh
./desktop.sh
cd ~
rm -rf *.sh

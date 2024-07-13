sudo apt update -y
sudo apt install wget
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Ubuntu/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Ubuntu/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Ubuntu/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Mint/docker.sh"
wget -O pyenv.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Ubuntu/pyenv.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Ubuntu/desktop.sh"
chmod a+x *.sh
./user.sh
./packages.sh
./docker.sh
./pyenv.sh
./desktop.sh
./network.sh
cd ~
rm -rf *.sh

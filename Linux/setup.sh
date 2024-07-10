sudo apt update -y
sudo apt install wget
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/input.sh"
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/docker.sh"
wget -O pyenv.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/Linux/pyenv.sh"
chmod a+x *.sh
./input.sh
./user.sh
./network.sh
./packages.sh
./docker.sh
./pyenv.sh

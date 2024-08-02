sudo apt update -y
sudo apt install wget
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/ubuntu/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/ubuntu/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/ubuntu/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/mint/docker.sh"
# wget -O pyenv.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/ubuntu/pyenv.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/ubuntu/desktop.sh"
wget -O locale.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/ubuntu/locale.sh"
chmod a+x *.sh
./user.sh
./packages.sh
./docker.sh
# ./pyenv.sh
./desktop.sh
./network.sh
./locale.sh
cd ~
rm -rf *.sh

sudo pacman -Syu --noconfirm
sudo pacman -S wget --needed --noconfirm
cd ~
wget -O user.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/user.sh"
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/network.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/docker.sh"
wget -O sing-box.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/sing-box.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/desktop.sh"
wget -O locale.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/locale.sh"
wget -O vm.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/vm.sh"
chmod a+x *.sh
./user.sh
./packages.sh
./docker.sh
./desktop.sh
./network.sh
./locale.sh
cd ~
rm -rf *.sh

sudo pacman -Syu --noconfirm
sudo pacman -S wget --needed --noconfirm
cd ~
wget -O network.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/network.sh"
wget -O network-bare.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/network-bare.sh"
wget -O extra-bare.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/extra-bare.sh"
wget -O alias.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/alias.sh"
wget -O packages.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/packages.sh"
wget -O docker.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/docker.sh"
wget -O sing-box.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/sing-box.sh"
wget -O desktop.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/desktop.sh"
wget -O locale.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/locale.sh"
wget -O conda.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/conda.sh"
chmod a+x *.sh
./packages.sh
./docker.sh
./conda.sh
./sing-box.sh
./desktop.sh
./alist.sh
read -p "Bare Metal Arch? (y/n, default to y): " bare_metal
if [ "$bare_metal" = "n" ]; then
    ./network.sh
else
    ./network-bare.sh
    ./extra-bare.sh
fi
./locale.sh
cd ~
rm -rf *.sh

read -p "是否需要安装桌面环境和相关软件？(y/n): " answer
if [ "$answer" = "y" ]; then
    cd ~
    sudo dnf install unzip wget -y
    read -p "桌面是否为Gnome? (y/n): " gnome
    if [ "$gnome" = "y" ]; then
        sudo dnf install \
          gnome-tweaks \
          ibus-rime -y
    fi
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/config.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/opencc.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict1.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict2.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict3.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict4.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Linux/rime/dict5.tar.gz"
    tar -xzvf config.tar.gz
    tar -xzvf opencc.tar.gz
    tar -xzvf dict1.tar.gz
    tar -xzvf dict2.tar.gz
    tar -xzvf dict3.tar.gz
    tar -xzvf dict4.tar.gz
    tar -xzvf dict5.tar.gz
    rm *.tar.gz
    mkdir ~/dicts
    mv dict1/* ~/dicts/
    mv dict2/* ~/dicts/
    mv dict3/* ~/dicts/
    mv dict4/* ~/dicts/
    mv dict5/* ~/dicts/
    mkdir -p ~/.config/ibus/rime
    mv ~/dicts ~/.config/ibus/rime/
    mv ~/opencc ~/.config/ibus/rime/
    mv ~/config/* ~/.config/ibus/rime/
    rm -rf ~/config
    rm -rf ~/opencc
    rm -rf ~/dicts
    rm -rf dict*
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
    rm Iosevka.zip
    rm IosevkaTerm.zip
    rm UbuntuMono.zip
    fc-cache -v
    mkdir ~/software
    read -p "是否为ARM架构？(y/n, 留空或其他为amd64架构): " arm_answer
    if [ "$arm_answer" = "y" ]; then
        wget -O code.rpm "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-arm64"
    else
        wget -O code.rpm "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
    fi
    mv code.rpm software/
    sudo dnf localinstall ~/software/code.rpm -y
    sudo chown -R $(whoami) /usr/share/code
else
    echo "未执行任何操作."
fi

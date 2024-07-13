read -p "是否需要安装桌面环境和相关软件? (y/n, 默认为不安装): " answer
if [ "$answer" = "y" ]; then
    cd ~
    sudo apt install unzip wget fonts-wqy-zenhei -y
    sudo apt remove fcitx* -y
    sudo apt remove fcitx-module* -y
    sudo apt remove fcitx-frontend* -y
    sudo apt purge fcitx* -y
    sudo apt autoclean && sudo apt autoremove -y
    sudo apt install -y \
        ibus \
        ibus-rime
    echo "export GTK_IM_MODULE=ibus" >> ~/.bashrc
    echo "export XMODIFIERS=@im=ibus" >> ~/.bashrc
    echo "export QT_IM_MODULE=ibus" >> ~/.bashrc
    source ~/.bashrc
    read -p "请输入桌面类型(gnome/kde/xfce/cinnamon): " desktop_version
    if [ "$desktop_version" = "gnome" ]; then
        sudo add-apt-repository universe -y
        sudo apt install -y \
          gnome-tweak-tool \
          gnome-shell-extension-manager \
          gnome-software
    fi
    if [ "$desktop_version" = "kde" ]; then
        mkdir -p ~/.config
        echo "[Formats]
            LANG=zh_CN.UTF-8
            LC_CTYPE=en_US.UTF-8
            LC_NUMERIC=en_US.UTF-8
            LC_TIME=zh_CN.UTF-8
            LC_COLLATE=en_US.UTF-8
            LC_MONETARY=en_US.UTF-8
            LC_MESSAGES=en_US.UTF-8
            LC_PAPER=en_US.UTF-8
            LC_NAME=en_US.UTF-8
            LC_ADDRESS=en_US.UTF-8
            LC_TELEPHONE=en_US.UTF-8
            LC_MEASUREMENT=en_US.UTF-8
            LC_IDENTIFICATION=en_US.UTF-8
            
            [Translations]
            LANGUAGE=zh_CN" | tr -d ' ' > ~/.config/plasma-localerc
    fi
    if [ "$desktop_version" = "xfce" ]; then
        :
    fi
    if [ "$desktop_version" = "cinnamon" ]; then
        :
    fi
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Ubuntu/rime/config.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Ubuntu/rime/opencc.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Ubuntu/rime/dict1.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Ubuntu/rime/dict2.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Ubuntu/rime/dict3.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Ubuntu/rime/dict4.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/Ubuntu/rime/dict5.tar.gz"
    tar -xzvf config.tar.gz config
    tar -xzvf opencc.tar.gz opencc
    tar -xzvf dict1.tar.gz dict1
    tar -xzvf dict2.tar.gz dict2
    tar -xzvf dict3.tar.gz dict3
    tar -xzvf dict4.tar.gz dict4
    tar -xzvf dict5.tar.gz dict5
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
        wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"
    else
        wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    fi
    mv code.deb software/
    sudo dpkg -i ~/software/code.deb
    sudo chown -R $(whoami) /usr/share/code
else
    echo "未执行任何操作."
fi

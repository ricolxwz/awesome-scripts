read -p "是否需要安装桌面环境和相关软件？(y/n): " answer
if [ "$answer" = "y" ]; then
    cd ~
    sudo dnf install unzip wget wqy-zenhei-fonts -y
    sudo dnf remove fcitx* -y
    sudo dnf remove fcitx-module* -y
    sudo dnf remove fcitx-frontend* -y
    sudo dnf remove fcitx* --setopt="clean_requirements_on_remove=true" -y
    sudo dnf install -y \
        ibus \
        ibus-rime
    echo "export GTK_IM_MODULE=ibus" >> ~/.bashrc
    echo "export XMODIFIERS=@im=ibus" >> ~/.bashrc
    echo "export QT_IM_MODULE=ibus" >> ~/.bashrc
    source ~/.bashrc
    read -p "Desktop distribution? (gnome/kde/xfce/cinnamon): " desktop_version
    if [ "$desktop_version" = "gnome" ]; then
        sudo dnf install -y \
            gnome-tweaks \
            gnome-extensions-app \
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
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/config.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/opencc.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict1.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict2.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict3.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict4.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict5.tar.gz"
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
    read -p "ARM? (y/n, default amd64): " arm_answer
    if [ "$arm_answer" = "y" ]; then
        wget -O code.rpm "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-arm64"
    else
        wget -O code.rpm "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
    fi
    mv code.rpm software/
    sudo dnf localinstall ~/software/code.rpm -y
    sudo chown -R $(whoami) /usr/share/code
else
    echo "Pass."
fi

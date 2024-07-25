read -p "是否需要安装桌面环境和相关软件? (y/n, 默认为不安装): " answer
if [ "$answer" = "y" ]; then
    cd ~
    sudo pacman -S --needed unzip wget wqy-zenhei --noconfirm
    sudo pacman -Rns fcitx ibus --noconfirm
    sudo pacman -Scc --noconfirm
    read -p "请输入桌面类型(gnome/kde/xfce/cinnamon): " desktop_version
    if [ "$desktop_version" = "gnome" ]; then
        sudo pacman -S --needed gnome-tweaks gnome-shell-extensions gnome-software --noconfirm
        read -p "请输入缩放因子(0-无穷): " scale_factor
        gsettings set org.gnome.desktop.interface scaling-factor $scale_factor
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
        sudo pacman -S --needed xfce4 xfce4-goodies --noconfirm
    fi
    if [ "$desktop_version" = "cinnamon" ]; then
        sudo pacman -S --needed cinnamon --noconfirm
    fi
    read -p "请输入输入法版本(ibus/fcitx5): " im_version
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
    if [ "$im_version" = "ibus" ]; then
        sudo pacman -S --needed ibus ibus-rime --noconfirm
        echo "export GTK_IM_MODULE=ibus" >> ~/.bashrc
        echo "export XMODIFIERS=@im=ibus" >> ~/.bashrc
        echo "export QT_IM_MODULE=ibus" >> ~/.bashrc
        source ~/.bashrc
        mkdir -p ~/.config/ibus/rime
        mv ~/dicts ~/.config/ibus/rime/
        mv ~/opencc ~/.config/ibus/rime/
        mv ~/config/* ~/.config/ibus/rime/
    fi
    if [ "$im_version" = "fcitx5" ]; then
        sudo pacman -S --needed fcitx5 fcitx5-rime --noconfirm
        echo "export GTK_IM_MODULE=fcitx5" >> ~/.bashrc
        echo "export XMODIFIERS=@im=fcitx5" >> ~/.bashrc
        echo "export QT_IM_MODULE=fcitx5" >> ~/.bashrc
        source ~/.bashrc
        mkdir -p ~/.local/share/fcitx5/rime
        mv ~/dicts ~/.local/share/fcitx5/rime/
        mv ~/opencc ~/.local/share/fcitx5/rime/
        mv ~/config/* ~/.local/share/fcitx5/rime/
        rm ~/.local/share/fcitx5/rime/ibus_rime.custom.yaml
    fi
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
    sudo pacman -U ~/software/code.deb --noconfirm
    sudo chown -R $(whoami) /usr/share/code
    curl -f http://zed.dev/install.sh | sh
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
else
    echo "未执行任何操作."
fi
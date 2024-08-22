read -p "Install desktop env? (y/n, default n): " answer
if [ "$answer" = "y" ]; then
    cd ~
    sudo pacman -S --needed unzip wget --noconfirm
    yay -S --needed --noconfirm ttf-harmonyos-sans
    sudo mkdir -p /etc/fonts
    printf '%s\n' '<?xml version="1.0"?>' \
    '<!DOCTYPE fontconfig SYSTEM "fonts.dtd">' \
    '<fontconfig>' \
    '  <alias>' \
    '    <family>sans-serif</family>' \
    '    <prefer>' \
    '      <family>UbuntuMono Nerd Font Mono</family>' \
    '      <family>HarmonyOS Sans SC</family>' \
    '      <family>HarmonyOS Sans TC</family>' \
    '    </prefer>' \
    '  </alias>' \
    '  <alias>' \
    '    <family>serif</family>' \
    '    <prefer>' \
    '      <family>UbuntuMono Nerd Font Mono</family>' \
    '      <family>HarmonyOS Sans SC</family>' \
    '      <family>HarmonyOS Sans TC</family>' \
    '    </prefer>' \
    '  </alias>' \
    '  <alias>' \
    '    <family>monospace</family>' \
    '    <prefer>' \
    '      <family>UbuntuMono Nerd Font Mono</family>' \
    '      <family>HarmonyOS Sans SC</family>' \
    '      <family>HarmonyOS Sans TC</family>' \
    '    </prefer>' \
    '  </alias>' \
    '</fontconfig>' | sudo tee /etc/fonts/local.conf > /dev/null
    if pacman -Qq | grep -q "^fcitx"; then
        sudo pacman -Rns $(pacman -Qq | grep "^fcitx") --noconfirm
    fi
    if pacman -Qq | grep -q "^fcitx5"; then
        sudo pacman -Rns $(pacman -Qq | grep "^fcitx5") --noconfirm
    fi
    if pacman -Qq | grep -q "^ibus"; then
        sudo pacman -Rns $(pacman -Qq | grep "^ibus") --noconfirm
    fi
    sudo pacman -Scc --noconfirm
    read -p "Desktop distribution? (gnome/kde/xfce/cinnamon): " desktop_version
    read -p "GUI backend? (wayland/x11): " gui_backend
    if [ "$desktop_version" = "gnome" ]; then
        sudo pacman -S --needed gnome-tweaks gnome-shell-extensions gnome-software gnome-terminal --noconfirm
        read -p "Scale? (0-infty): " scale_factor
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
        :
    fi
    if [ "$desktop_version" = "cinnamon" ]; then
        :
    fi
    read -p "IM? (ibus/fcitx5): " im_version
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/config.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/opencc.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict1.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict2.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict3.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict4.tar.gz"
    wget "https://github.com/ricolxwz/awesome-scripts/raw/master/rime/dict5.tar.gz"
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
        sudo pacman -S --needed  --noconfirm \
            fcitx5 \
            fcitx5-rime \
            fcitx5-configtool \
            fcitx5-gtk \
            fcitx5-qt \
            fcitx5-chinese-addons \
            fcitx5-breeze
        mkdir -p ~/.local/share/fcitx5/rime
        mv ~/dicts ~/.local/share/fcitx5/rime/
        mv ~/opencc ~/.local/share/fcitx5/rime/
        mv ~/config/* ~/.local/share/fcitx5/rime/
        rm ~/.local/share/fcitx5/rime/ibus_rime.custom.yaml
        if [ "$desktop_version" = "kde" ]; then
            mkdir -p ~/.config/fcitx5/conf
            echo "Vertical Candidate List=False
            WheelForPaging=True
            Font="Sans 10"
            MenuFont="Sans 10"
            TrayFont="Sans Bold 10"
            TrayOutlineColor=#000000
            TrayTextColor=#ffffff
            PreferTextIcon=False
            ShowLayoutNameInIcon=True
            UseInputMethodLanguageToDisplayText=True
            Theme=plasma
            DarkTheme=plasma
            UseDarkTheme=False
            UseAccentColor=True
            PerScreenDPI=True
            ForceWaylandDPI=0
            EnableFractionalScale=True" > ~/.config/fcitx5/conf/classicui.conf
        fi
        if [ "$gui_backend" = "x11" ]; then
            echo "GTK_IM_MODULE=fcitx" | sudo tee -a /etc/environment > /dev/null
            echo "XMODIFIERS=@im=fcitx" | sudo tee -a /etc/environment > /dev/null
            echo "QT_IM_MODULE=fcitx" | sudo tee -a /etc/environment > /dev/null
            echo "SDL_IM_MODULE=fcitx" | sudo tee -a /etc/environment > /dev/null
            echo "GLFW_IM_MODULE=ibus" | sudo tee -a /etc/environment > /dev/null
        fi
        if [ "$gui_backend" = "wayland" ]; then
            echo "XMODIFIERS=@im=fcitx" | sudo tee -a /etc/environment > /dev/null
        fi
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
    yay -S --noconfirm --needed \
        visual-studio-code-bin
        # visual-studio-code-insiders-bin
    sudo chown -R $(whoami) /opt/visual-studio-code
    # sudo chown -R $(whoami) /opt/visual-studio-code-insiders
    read -p "Install other useful programs? (y/n, default n): " extra_programs
    if [ "$extra_programs" = "y" ]; then
        read -p "ARM? (y/n, default amd64) " arm_answer
        if [ "$arm_answer" = "y" ]; then
            sudo pacman -S --needed --noconfirm spectacle okular
        else
            # yay -S --needed --noconfirm picgo
            sudo pacman -S --needed --noconfirm spectacle okular kate ktorrent kget yakuake kfind ksystemlog partitionmanager isoimagewriter filelight
            # sudo pacman -S --needed --noconfirm imwheel
            # echo "\".*\"
            # None,      Up,   Button4, 1
            # None,      Down, Button5, 1
            # Control_L, Up,   Control_L|Button4
            # Control_L, Down, Control_L|Button5
            # Shift_L,   Up,   Shift_L|Button4
            # Shift_L,   Down, Shift_L|Button5" > ~/.imwheelrc
            # sudo touch /etc/profile.d/imwheeld.sh
            # sudo sh -c 'echo -e "#!/bin/sh\nimwheel -b \"45\"" > /etc/profile.d/imwheeld.sh && chmod +x /etc/profile.d/imwheeld.sh'
            cd ~
            curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
            git clone https://aur.archlinux.org/1password.git
            cd 1password
            makepkg -si --needed --noconfirm
            cd ~
        fi
    fi
else
    echo "Pass."
fi

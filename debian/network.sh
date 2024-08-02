DEFAULT_IP=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
DEFAULT_DNS=$(ip route | grep default | awk '{print $3}')
OLD_PROFILE=$(nmcli -t -f NAME,TYPE connection show | grep 'ethernet' | head -n 1 | cut -d: -f1)
echo '
alias proxy="
    export http_proxy=http://127.0.0.1:5353;
    export https_proxy=http://127.0.0.1:5353;
    export all_proxy=http://127.0.0.1:5353;
    export no_proxy=http://127.0.0.1:5353;
    export HTTP_PROXY=http://127.0.0.1:5353;
    export HTTPS_PROXY=http://127.0.0.1:5353;
    export ALL_PROXY=http://127.0.0.1:5353;
    export NO_PROXY=http://127.0.0.1:5353;"
alias unproxy="
    unset http_proxy;
    unset https_proxy;
    unset all_proxy;
    unset no_proxy;
    unset HTTP_PROXY;
    unset HTTPS_PROXY;
    unset ALL_PROXY;
    unset NO_PROXY"
' >> ~/.bashrc
source ~/.bashrc
ip r
ip a
sudo apt install NetworkManager -y
sudo systemctl restart NetworkManager
read -p "请输入公钥: " key
interface=$(ip -o -4 route show to default | awk '{print $5}')
read -p "请输入静态IP地址 [默认: $DEFAULT_IP]: " ip
ip=${ip:-$DEFAULT_IP}
read -p "请输入网关IP地址 [默认: $DEFAULT_GATEWAY]: " gateway
gateway=${gateway:-$DEFAULT_GATEWAY}
read -p "请输入DNS地址 [默认: $DEFAULT_DNS]: " dns
dns=${dns:-$DEFAULT_DNS}
read -p "是否为桌面版本? (y/n) [默认: n]: " is_desktop
is_desktop=${is_desktop:-n}
if [[ "$is_desktop" == "y" ]]; then
    renderer="NetworkManager"
else
    renderer="networkd"
fi
sudo apt install openssh-client -y
sudo apt install openssh-server -y
sudo systemctl enable ssh
mkdir -p ~/.ssh
cd ~/.ssh
echo "$key" > authorized_keys
cd /etc/ssh
sudo sed -i '/PrintLastLog/c\PrintLastLog no' sshd_config
cd /etc/pam.d
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+motd=\/run\/motd\.dynamic/s/^/#/' sshd
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+noupdate/s/^/#/' sshd
echo "请输入用于Github的SSH私钥(请使用ed25519加密, 输入完成后换行输入EOF回车):"
ssh_private_key=""
while IFS= read -r line; do
    if [ "$line" == "EOF" ]; then
        break
    fi
    ssh_private_key+="$line"$'\n'
done
if [ -n "$ssh_private_key" ]; then
    echo "$ssh_private_key" > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
else
    echo "未输入SSH私钥, 跳过保存过程"
fi
sudo nmcli con add type ethernet con-name static-ip ifname ${interface} ipv4.addresses ${ip}/24 ipv4.gateway ${gateway} ipv4.dns ${dns} ipv4.method manual connection.autoconnect yes
echo "Bye Bye~, 请尝试用新的IP访问此机器"
sudo systemctl restart ssh
sudo nmcli con up static-ip
sudo nmcli con delete "$OLD_PROFILE"

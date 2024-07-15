DEFAULT_IP=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
DEFAULT_DNS=$(ip route | grep default | awk '{print $3}')
echo '
alias proxy="
    export http_proxy=socks5://127.0.0.1:7890;
    export https_proxy=socks5://127.0.0.1:7890;
    export all_proxy=socks5://127.0.0.1:7890;
    export no_proxy=socks5://127.0.0.1:7890;
    export HTTP_PROXY=socks5://127.0.0.1:7890;
    export HTTPS_PROXY=socks5://127.0.0.1:7890;
    export ALL_PROXY=socks5://127.0.0.1:7890;
    export NO_PROXY=socks5://127.0.0.1:7890;"
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
cd /etc/netplan
sudo rm -rf *
echo "
network:
  version: 2
  renderer: $renderer
  ethernets:
    ${interface}:
      dhcp4: false
      dhcp6: false
      addresses:
        - ${ip}/24
      routes:
        - to: default
          via: ${gateway}
      nameservers:
        addresses: [${dns}]" | sudo tee /etc/netplan/01-netcfg.yaml > /dev/null
sudo chmod 600 01-netcfg.yaml
echo "Bye Bye~, 请尝试用新的IP访问此机器"
sudo systemctl restart ssh
sudo netplan generate
sudo netplan apply

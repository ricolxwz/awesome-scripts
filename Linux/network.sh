DEFAULT_IP="192.168.91.100"
DEFAULT_GATEWAY="192.168.91.2"
DEFAULT_DNS="192.168.91.2"
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
cd ~/.ssh
echo "$key" > authorized_keys
cd /etc/ssh
sudo sed -i '/PrintLastLog/c\PrintLastLog no' sshd_config
cd /etc/pam.d
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+motd=\/run\/motd\.dynamic/s/^/#/' sshd
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+noupdate/s/^/#/' sshd
read -p "请输入用于Github的SSH私钥(请使用ed25519加密, 若没有输入, 则跳过): " ssh_private_key
if [ -n "$ssh_private_key" ]; then
    echo "$ssh_private_key" > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
else
    echo "未输入SSH私钥，跳过保存过程。"
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
sudo systemctl restart ssh
sudo netplan generate
sudo netplan apply

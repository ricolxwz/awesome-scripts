cd ~/.ssh
# read -p "请输入公钥: " key
echo "$key" > authorized_keys
cd /etc/ssh
sudo sed -i '/PrintLastLog/c\PrintLastLog no' sshd_config
cd /etc/pam.d
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+motd=\/run\/motd\.dynamic/s/^/#/' sshd
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+noupdate/s/^/#/' sshd
sudo systemctl restart ssh
# read -p "请输入网卡名称: " interface
# read -p "请输入静态ip地址: " ip
# read -p "请输入网关ip地址: " gateway
# read -p "请输入dns地址: " dns
cd /etc/netplan
sudo rm -rf 50*
echo "
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: false
      dhcp6: false
      addresses:
        - $ip/24
      routes:
        - to: default
          via: $gateway
      nameservers:
        addresses: [$dns]" | sudo tee /etc/netplan/01-netcfg.yaml > /dev/null
sudo chmod 600 01-netcfg.yaml
sudo netplan generate
sudo netplan apply

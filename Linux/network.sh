cd ~/.ssh
read -p "请输入公钥: " key
echo "$key" > authorized_keys
sudo sed -i '/PrintLastLog/c\PrintLastLog no' sshd_config
cd /etc/pam.d
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+motd=\/run\/motd\.dynamic/s/^/#/' sshd
sudo sed -i '/session\s\+optional\s\+pam_motd\.so\s\+noupdate/s/^/#/' sshd
sudo systemctl restart ssh
cd /etc/netplan
sudo rm -rf 50*
read -p "请输入网卡名称: " interface
echo "
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: false
      dhcp6: false
      addresses:
        - 192.168.91.100/24
      routes:
        - to: default
          via: 192.168.91.2
      nameservers:
        addresses: [192.168.91.2]" | sudo tee /etc/netplan/01-netcfg.yaml > /dev/null
sudo chmod 600 01-netcfg.yaml
sudo netplan generate
sudo netplan apply

cd /etc/netplan
sudo rm -rf 50*
sudo touch 01-netcfg.yaml
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

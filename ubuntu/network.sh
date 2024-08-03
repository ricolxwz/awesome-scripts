DEFAULT_IP=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
DEFAULT_DNS=$(ip route | grep default | awk '{print $3}')
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
read -p "Dev public key: " key
interface=$(ip -o -4 route show to default | awk '{print $5}')
read -p "Static IP [default: $DEFAULT_IP]: " ip
ip=${ip:-$DEFAULT_IP}
read -p "Gateway [default: $DEFAULT_GATEWAY]: " gateway
gateway=${gateway:-$DEFAULT_GATEWAY}
read -p "Nameserver [default: $DEFAULT_DNS]: " dns
dns=${dns:-$DEFAULT_DNS}
read -p "Desktop version? (y/n default n): " is_desktop
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
echo "Github private key (using ed25519 encryption, enter EOF to execute): "
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
    echo "Pass."
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
echo "Bye Bye~, Using new IP!"
sudo systemctl restart ssh
sudo netplan generate
sudo netplan apply

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

sudo systemctl disable dhcpcd
sudo systemctl stop dhcpcd
sudo systemctl enable systemd-networkd
sudo systemctl start systemd-networkd

read -p "Dev public key: " key
interface=$(ip -o -4 route show to default | awk '{print $5}')
read -p "Static IP [default: $DEFAULT_IP]: " ip
ip=${ip:-$DEFAULT_IP}
read -p "Gateway [default: $DEFAULT_GATEWAY]: " gateway
gateway=${gateway:-$DEFAULT_GATEWAY}
read -p "Nameserver [default: $DEFAULT_DNS]: " dns
dns=${dns:-$DEFAULT_DNS}

sudo pacman -S --needed --noconfirm openssh
sudo systemctl enable sshd
sudo systemctl start sshd

mkdir -p ~/.ssh
echo "$key" > ~/.ssh/authorized_keys

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

echo "[Match]
Name=${interface}
[Network]
Address=${ip}/24
Gateway=${gateway}
DNS=${dns}" | sudo tee /etc/systemd/network/99-vm.network > /dev/null

sudo systemctl restart systemd-networkd

echo "Bye Bye~, Using new IP!"

sudo systemctl restart sshd

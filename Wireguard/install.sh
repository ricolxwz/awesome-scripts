apt update -y
apt install wireguard resolvconf iptables -y
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
cd /etc/wireguard/
chmod 0777 /etc/wireguard
umask 077
wg genkey > server.key
wg pubkey < server.key > server.key.pub
wg genkey > client1.key
wg pubkey < client1.key > client1.key.pub
ip addr
read -p "Please enter the name of main interface: " interface
echo "
[Interface]
PrivateKey = $(cat server.key)
Address = 10.0.8.1, fd86::1/128
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $interface -j MASQUERADE
ListenPort = 996
DNS = 8.8.8.8, 2001:4860:4860::8888
MTU = 1420
[Peer]
PublicKey =  $(cat client1.key.pub)
AllowedIPs = 10.0.8.0/24, fd86::0/112" > wg0.conf
systemctl enable wg-quick@wg0
wg-quick up wg0
cat server.key && cat server.key.pub && cat client1.key && cat client1.key.pub

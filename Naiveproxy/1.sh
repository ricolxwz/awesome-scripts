apt update -y
apt install wget sudo curl -y
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT	
iptables -P OUTPUT ACCEPT
iptables -F
apt-get purge netfilter-persistent
reboot

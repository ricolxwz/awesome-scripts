iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT	
iptables -P OUTPUT ACCEPT
iptables -F
apt purge netfilter-persistent
reboot

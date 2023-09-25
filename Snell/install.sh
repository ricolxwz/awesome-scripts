echo "---------- IPv6 Configuration ----------"
cd /root
echo "net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0" >> /etc/sysctl.conf
sysctl -p
echo "---------- Prefer Ipv4 over Ipv6 ----------"
echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf
echo "---------- Snell Configuration ----------"
cd /root
wget https://dl.nssurge.com/snell/snell-server-v4.0.1-linux-amd64.zip
unzip snell-server-v*
./snell-server
echo "---------- DNS Configuration ----------"
cd /root
apt install resolvconf -y
> /etc/resolvconf/resolv.conf.d/head
echo -e "nameserver 8.8.8.8
nameserver 2001:4860:4860::8888" >> /etc/resolvconf/resolv.conf.d/head
echo "---------- PSK ----------"
echo "---------- Port ----------"
echo "---------- Reboot ----------"
echo "Enter reboot to reboot!"

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
sed -i 's/ipv6 = false/ipv6 = true\nobfs = http/' snell-server.conf
mkdir -p /usr/local/etc/snell
mv snell-server.conf /usr/local/etc/snell/snell-server.conf
mv snell-server /usr/local/bin/snell-server
echo "----- Add Service -----"
cd /etc/systemd/system
touch snell.service
echo -e "[Unit]
Description=snell service
After=network.target nss-lookup.target

[Service]
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH
ExecStart=/usr/local/bin/snell-server -c /usr/local/etc/snell/snell-server.conf
ExecReload=/bin/kill -HUP \x24MAINPID
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/snell.service
systemctl start snell.service
systemctl enable snell.service
echo "---------- DNS Configuration ----------"
cd /root
apt install resolvconf -y
> /etc/resolvconf/resolv.conf.d/head
echo -e "nameserver 8.8.8.8
nameserver 2001:4860:4860::8888" >> /etc/resolvconf/resolv.conf.d/head
echo "---------- PSK ----------"
cd /usr/local/etc/snell
grep "psk" snell-server.conf | awk '{print $3}'
echo "---------- Port ----------"
cd /usr/local/etc/snell
grep "listen" snell-server.conf | awk -F: '{print $2}'
echo "---------- Reboot ----------"
echo "Enter reboot to reboot!"

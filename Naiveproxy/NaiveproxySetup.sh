apt update -y
apt install wget sudo curl -y
cd /root
wget https://raw.githubusercontent.com/Ricolxwz/BGFW-sh/master/Naiveproxy/1.sh
chmod 777 1.sh
cat > /etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
 
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
 
[Install]
WantedBy=multi-user.target
EOF
chmod +x /etc/rc.local
echo "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
cd /root
./1.sh
exit 0" > /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT	
iptables -P OUTPUT ACCEPT
iptables -F
apt-get purge netfilter-persistent
reboot

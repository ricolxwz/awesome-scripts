apt update -y
apt install wget sudo curl -y
cd /root
wget https://github.com/Ricolxwz/BGFW-sh/blob/master/Naiveproxy/1.sh
chmod 777 1.sh
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
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT	
iptables -P OUTPUT ACCEPT
iptables -F
apt-get purge netfilter-persistent
reboot

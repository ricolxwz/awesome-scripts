read -p "Please Enter your Domain: " domain
wget https://raw.githubusercontent.com/salesforce/jarm/master/jarm.py
python3 jarm.py $domain
read -p "Please Enter your Hide Domain:(contain https://) " hide
sed -i "/reverse_proxy/d" Caddyfile
sed -i "/upstream_hostport/i  reverse_proxy $hide {" Caddyfile
reboot

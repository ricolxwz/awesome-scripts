read -p "Please Enter your Domain: " domain
wget https://raw.githubusercontent.com/salesforce/jarm/master/jarm.py
python3 jarm.py $domain
cd /etc/nginx
read -p "Please Enter your Hide Domain:(do not contain https://) " hide
sed -i "/proxy_pass https:\/\/www.bing.com;/a proxy_pass https:\/\/$hide;" nginx.conf
sed -i "/proxy_pass https:\/\/www.bing.com;/d" nginx.conf
sed -i "/sub_filter \"www.bing.com\"/a sub_filter \"$hide\" \$server_name;" nginx.conf
sed -i "/sub_filter \"www.bing.com\"/d" nginx.conf
sed -i "/proxy_set_header Host \"www.bing.com\"/a proxy_set_header Host \"$hide\";" nginx.conf
sed -i "/proxy_set_header Host \"www.bing.com\"/d" nginx.conf
reboot

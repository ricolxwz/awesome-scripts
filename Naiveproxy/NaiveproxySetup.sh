echo "[Unit]  
Description=restart  
After=default.target  
[Service]  
ExecStart=/root/NaiveproxySetup.sh
[Install]  
WantedBy=default.target" > /lib/systemd/system/restart.service
systemctl daemon-reload  
systemctl enable restart.service
sed -i '1,11d' NaiveproxySetup.sh
reboot

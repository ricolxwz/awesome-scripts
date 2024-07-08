cd ~
sudo apt install curl -y
sudo curl -fsSL https://sing-box.app/gpg.key -o /etc/apt/keyrings/sagernet.asc
sudo chmod a+r /etc/apt/keyrings/sagernet.asc
echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/sagernet.asc] https://deb.sagernet.org/ * *" | \
  sudo tee /etc/apt/sources.list.d/sagernet.list > /dev/null
sudo apt-get update
sudo apt-get install sing-box # or sing-box-beta
while true; do
    read -n 1 -p "请将config.json文件放到用户目录下, 放好请输入y: " key
    if [[ $key == "y" ]]; then
        break
    fi
done
mkdir -p /etc/sing-box
sudo mv config.json /etc/sing-box/
sudo systemctl enable sing-box
sudo systemctl restart sing-box

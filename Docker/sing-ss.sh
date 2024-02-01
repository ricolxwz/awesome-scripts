read -p "Enter Port: " port
echo "net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0" | sudo tee -a /etc/sysctl.conf > /dev/null
sudo sysctl -p
echo "precedence ::ffff:0:0/96  100" | sudo tee -a /etc/gai.conf > /dev/null
sudo apt update -y
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
CONFIG='{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64",
  "experimental": true,
  "ip6tables": true
}'
FILE="/etc/docker/daemon.json"
if [ -f "$FILE" ]; then
    sudo cp $FILE ${FILE}.bak
    echo "$CONFIG" | sudo tee $FILE > /dev/null
else
    echo "$CONFIG" | sudo tee $FILE > /dev/null
fi
sudo systemctl restart docker
sudo docker pull ghcr.io/sagernet/sing-box:latest
sudo mkdir -p /var/lib/sing-box
sudo mkdir -p /etc/sing-box
echo -e "{
    \x22inbounds\x22: [
      {
        \x22type\x22: \x22shadowsocks\x22,
        \x22listen\x22: \x22::\x22,
        \x22listen_port\x22: $port,
        \x22method\x22: \x22aes-128-gcm\x22,
        \x22password\x22: \x22$(openssl rand -base64 6)\x22,
        \x22multiplex\x22: {
            \x22enabled\x22: true
        }
      }
    ],
    \x22outbounds\x22: [
        {
            \x22type\x22: \x22direct\x22
        }
    ]
}" | sudo tee /etc/sing-box/config.json > /dev/null
sudo docker run -d \
        -v /etc/sing-box:/etc/sing-box/ \
        --name=sing-box \
        --restart=always \
        -p 80:80 \
        -p 80:80/udp \
        -p 443:443 \
        -p 443:443/udp \
        -p $port:$port \
        -p $port:$port/udp \
        --device=/dev/net/tun:/dev/net/tun \
        --cap-add=NET_ADMIN \
        ghcr.io/sagernet/sing-box \
        -D /var/lib/sing-box \
        -C /etc/sing-box/ run
cat /etc/sing-box/config.json | sed 's/,/\n/g' | grep "password" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g' | sed 's/"//g' | tr -d ' '
sudo reboot

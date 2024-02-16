sudo apt update -y
sudo apt install curl -y
echo "net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0" | sudo tee -a /etc/sysctl.conf > /dev/null
sudo sysctl -p
echo "precedence ::ffff:0:0/96  100" | sudo tee -a /etc/gai.conf > /dev/null
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
sudo mkdir -p /etc/frp
echo -e "
quicBindPort = $(shuf -i 1-65535 -n 1)
auth.token = \x22$(openssl rand -base64 20)\x22
webServer.port = $(shuf -i 1-65535 -n 1)
webServer.user = "admin"
webServer.password = \x22$(openssl rand -base64 20)\x22
" | sudo tee /etc/frp/frps.toml > /dev/null
sudo docker run --restart=always --network host -d -v /etc/frp/frps.toml:/etc/frp/frps.toml --name frps snowdreamtech/frps
echo "quicBindPort = $(sudo grep 'quicBindPort' /etc/frp/frpc.toml | awk -F '= ' '{print $2}')"
echo "auth.token = $(sudo grep 'auth.token' /etc/frp/frpc.toml | awk -F '= ' '{print $2}' | tr -d '\"')"
echo "webServer.port = $(sudo grep 'webServer.port' /etc/frp/frpc.toml | awk -F '= ' '{print $2}')"
echo "webServer.user = $(sudo grep 'webServer.user' /etc/frp/frpc.toml | awk -F '= ' '{print $2}' | tr -d '\"')"
echo "webServer.password = $(sudo grep 'webServer.password' /etc/frp/frpc.toml | awk -F '= ' '{print $2}' | tr -d '\"')"
sudo reboot

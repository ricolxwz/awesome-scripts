echo "---------- IPv6 Configuration ----------"
cd /root
echo "net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0" >> /etc/sysctl.conf
sysctl -p
echo "---------- Prefer Ipv4 over Ipv6 ----------"
echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf
echo "---------- git Configuration ----------"
cd /root
apt install git -y
echo "---------- DDNS Configuration ----------"
cd /root
git clone https://github.com/timothymiller/cloudflare-ddns.git
cd cloudflare-ddns
touch config.json
read -p "Enter api_token: " api
read -p "Enter zone_id: " zone
echo -e "{
  \x22cloudflare\x22: [
    {
      \x22authentication\x22: {
        \x22api_token\x22: \x22$api\x22
      },
      \x22zone_id\x22: \x22$zone\x22,
      \x22subdomains\x22: [
        {
          \x22name\x22: \x22\x22,
          \x22proxied\x22: false
        }
      ]
    }
  ],
  \x22a\x22: true,
  \x22aaaa\x22: true,
  \x22purgeUnknownRecords\x22: false,
  \x22ttl\x22: 300
}" > config.json
apt install python3 python3-venv -y
python3 -m venv venv
./start-sync.sh
echo "---------- Crontab Configuration ----------"
cd /var/spool/cron/crontabs
touch root
echo "*/15 * * * * cd /root/cloudflare-ddns && ./start-sync.sh" >> root
echo "@reboot cd /root/cloudflare-ddns && ./start-sync.sh" >> root
systemctl restart cron
echo "---------- ACME Configuration ----------"
cd /root
curl https://get.acme.sh | sh
read -p "Enter email: " email
read -p "Enter domain: " domain
read -p "Enter port (usually 443): " port
read -p "Enter target website for reality (do not include https://): " website
~/.acme.sh/acme.sh --register-account -m $email
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/private.key --fullchain-file /root/cert.crt
echo "---------- Sing-box Configuration ----------"
cd /root
git clone -b main https://github.com/SagerNet/sing-box
cd sing-box
./release/local/install_go.sh
./release/local/install.sh
touch /usr/local/etc/sing-box/config.json
echo -e "{
    \x22inbounds\x22: [
        {
            \x22type\x22: \x22shadowtls\x22,
            \x22listen\x22: \x22::\x22,
            \x22listen_port\x22: $port,
            \x22detour\x22: \x22shadowsocks-in\x22,
            \x22handshake\x22: {
                \x22server\x22: \x22$website\x22,
                \x22server_port\x22: 443
            },
            \x22strict_mode\x22: true
        },
        {
            \x22type\x22: \x22shadowsocks\x22,
            \x22tag\x22: \x22shadowsocks-in\x22,
            \x22listen\x22: \x22127.0.0.1\x22,
            \x22method\x22: \x222022-blake3-aes-128-gcm\x22,
            \x22password\x22: \x22$(sing-box generate uuid)\x22
        }
    ],
    \x22outbounds\x22: [
        {
            \x22type\x22: \x22direct\x22
        }
    ]
}" > /usr/local/etc/sing-box/config.json
set -e -o pipefail
systemctl enable sing-box
systemctl start sing-box
echo "---------- DNS Configuration ----------"
cd /root
apt install resolvconf -y
> /etc/resolvconf/resolv.conf.d/head
echo -e "nameserver 8.8.8.8
nameserver 2001:4860:4860::8888" >> /etc/resolvconf/resolv.conf.d/head
echo "---------- Password ----------"
cd /usr/local/etc/sing-box
cat config.json | sed 's/,/\n/g' | grep "password" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g' | sed 's/"//g' | tr -d ' '
echo "---------- Reboot ----------"
echo "Enter reboot to reboot!"

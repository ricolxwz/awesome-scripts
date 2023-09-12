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
read -p "Enter port: " port
read -p "Enter target website for reality: " website
~/.acme.sh/acme.sh --register-account -m $email
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/private.key --fullchain-file /root/cert.crt
echo "---------- Sing-box Configuration ----------"
echo "----- Build From Source -----"
cd /root
apt install golang -y
go install -v -tags with_reality_server,with_utls github.com/sagernet/sing-box/cmd/sing-box@latest
cd go/bin
mv sing-box /usr/local/bin/sing-box
chmod 777 /usr/local/bin/sing-box
mkdir -p /var/lib/sing-box
mkdir -p /usr/local/etc/sing-box
touch /usr/local/etc/sing-box/config.json
echo "----- Generate ShortID -----"
shortID=''
for i in {1..8}; do
    shortID="${shortID}$(( $RANDOM % 10 ))"
done
echo "----- Generate Reality Keypair -----"
key=$(sing-box generate reality-keypair)
PrivateKey=$(echo $key|grep 'PrivateKey'|awk -F 'PrivateKey: ' '{print $2}'|awk '{print $1}')
PublicKey=$(echo $key|grep 'PublicKey'|awk -F 'PublicKey: ' '{print $2}'|awk '{print $1}')
echo "----- Configure the server -----"
echo -e "{
    \x22inbounds\x22: [
        {
            \x22type\x22: \x22vless\x22,
            \x22listen\x22: \x22::\x22,
            \x22listen_port\x22: $port,
            \x22users\x22: [
                {
                    \x22uuid\x22: \x22$(sing-box generate uuid)\x22,
                    \x22flow\x22: \x22xtls-rprx-vision\x22
                }
            ],
            \x22tls\x22: {
                \x22enabled\x22: true,
                \x22server_name\x22: \x22$domain\x22,
                \x22reality\x22: {
                    \x22enabled\x22: true,
                    \x22handshake\x22: {
                        \x22server\x22: \x22$website\x22,
                        \x22server_port\x22: 443
                    },
                    \x22private_key\x22: \x22$PrivateKey\x22,
                    \x22short_id\x22: [
                        \x22$shortID\x22
                    ]
                }
            }
        }
    ],
    \x22outbounds\x22: [
        {
            \x22type\x22: \x22direct\x22
        }
    ]
}" > /usr/local/etc/sing-box/config.json
echo "----- Add Service -----"
cd /etc/systemd/system
touch sing-box.service
echo -e "[Unit]
Description=sing-box service
Documentation=https://sing-box.sagernet.org
After=network.target nss-lookup.target

[Service]
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_SYS_PTRACE CAP_DAC_READ_SEARCH
ExecStart=/usr/local/bin/sing-box -D /var/lib/sing-box -C /usr/local/etc/sing-box run
ExecReload=/bin/kill -HUP \x24MAINPID
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/sing-box.service
set -e -o pipefail
systemctl daemon-reload
systemctl enable sing-box
systemctl start sing-box
echo "---------- DNS Configuration ----------"
cd /root
apt install resolvconf -y
> /etc/resolvconf/resolv.conf.d/head
echo -e "nameserver 8.8.8.8
nameserver 2001:4860:4860::8888" >> /etc/resolvconf/resolv.conf.d/head
echo "---------- UUID ----------"
cd /usr/local/etc/sing-box
cat config.json | sed 's/,/\n/g' | grep "uuid" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g'
echo "---------- PrivateKey ----------"
echo "$PrivateKey"
echo "---------- PublicKey ----------"
echo "$PublicKey"
echo "---------- ShortID ----------"
echo "$shortID"
echo "---------- Reboot ----------"
echo "Enter reboot to reboot!"

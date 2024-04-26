echo "---------- IPv6启动 ----------"
echo "net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0" >> /etc/sysctl.conf
sysctl -p
echo "---------- IPv4优先级更高 ----------"
echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf
echo "---------- 安装常用依赖 ----------"
zypper --non-interactive install ca-certificates git cronie socat
echo "---------- DDNS安装配置 ----------"
cd /root
git clone https://github.com/timothymiller/cloudflare-ddns.git
cd cloudflare-ddns
touch config.json
read -p "请输入DNS服务商API: " api
read -p "请输入域名区域id: " zone
read -p "请输入二级域名: " sub_domain
echo -e "{
  \x22cloudflare\x22: [
    {
      \x22authentication\x22: {
        \x22api_token\x22: \x22$api\x22
      },
      \x22zone_id\x22: \x22$zone\x22,
      \x22subdomains\x22: [
        {
          \x22name\x22: \x22$sub_domain\x22,
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
zypper --non-interactive install python311
python3.11 -m venv venv
./start-sync.sh
echo "---------- Crontab配置 ----------"
cd /var/spool/cron/tabs
touch root
echo "*/15 * * * * cd /root/cloudflare-ddns && ./start-sync.sh" >> root
echo "@reboot cd /root/cloudflare-ddns && ./start-sync.sh" >> root
systemctl restart cron
echo "---------- ACME配置 ----------"
cd /root
curl https://get.acme.sh | sh
read -p "请输入邮箱: " email
read -p "请输入域名: " domain
echo "请选择一个SSL证书机构:"
options=("letsencrypt" "buypass" "zerossl" "ssl.com" "google")
select opt in "${options[@]}"
do
    case $opt in
        "letsencrypt")
            echo "Switching to Let's Encrypt"
            ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
            break
            ;;
        "buypass")
            echo "Switching to Buypass"
            ~/.acme.sh/acme.sh --set-default-ca --server buypass
            break
            ;;
        "zerossl")
            echo "Switching to ZeroSSL"
            ~/.acme.sh/acme.sh --set-default-ca --server zerossl
            break
            ;;
        "ssl.com")
            echo "Switching to SSL.com"
            ~/.acme.sh/acme.sh --set-default-ca --server ssl.com
            break
            ;;
        "google")
            echo "Switching to Google Public CA"
            ~/.acme.sh/acme.sh --set-default-ca --server google
            break
            ;;
        *) echo "Invalid option. Please try again.";;
    esac
done
echo "你选择的SSL证书机构为: $opt"
~/.acme.sh/acme.sh --register-account -m $email
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/private.key --fullchain-file /root/cert.crt
echo "---------- Install Go ----------"
cd /root
wget "https://go.dev/dl/$(curl -s https://go.dev/VERSION?m=text|awk 'NR==1 {print $1}').linux-amd64.tar.gz"
tar -xf go*.linux-amd64.tar.gz -C /usr/local/
echo 'export GOROOT=/usr/local/go' >> /etc/profile
echo 'export PATH=$GOROOT/bin:$PATH' >> /etc/profile
source /etc/profile
echo "---------- Build From Source ----------"
go install -v github.com/sagernet/sing-box/cmd/sing-box@latest
cd go/bin
mv sing-box /usr/local/bin/sing-box
chmod 777 /usr/local/bin/sing-box
echo "---------- Sing-box Configuration ----------"
touch /usr/local/etc/sing-box/config.json
echo -e "{
    \x22inbounds\x22: [
        {
            \x22type\x22: \x22vmess\x22,
            \x22tag\x22: \x22vmess-in\x22,
            \x22listen\x22: \x22::\x22,
            \x22listen_port\x22: $port,
            \x22multiplex\x22: {
                \x22enabled\x22: true
            },
            \x22users\x22: [
                {
                    \x22uuid\x22: \x22$(uuidgen)\x22,
                    \x22alterId\x22: 0
                }
            ],
            \x22transport\x22: {
                \x22type\x22: \x22ws\x22,
                \x22path\x22: \x22$path\x22,
                \x22headers\x22: {},
                \x22max_early_data\x22: 2048,
                \x22early_data_header_name\x22: \x22Sec-WebSocket-Protocol\x22
            }
        }
    ],
    \x22outbounds\x22: [
        {
            \x22type\x22: \x22direct\x22
        }
    ]
}" > /usr/local/etc/sing-box/config.json
echo "---------- Add Service ----------"
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
echo "---------- 密钥 ----------"
cd /etc/sing-box
cat config.json | sed 's/,/\n/g' | grep "uuid" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g' | sed 's/"//g' | tr -d ' '
echo "---------- 重启 ----------"
reboot

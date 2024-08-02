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
echo "---------- 配置vmess监听端口 ----------"
read -p "请输入vmess所使用的port: " port
read -p "请输入websocket路径: " path
echo "---------- Sing-box Configuration ----------"
mkdir -p /usr/local/etc/sing-box
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
echo "---------- Nginx Configuration ----------"
cd /root
zypper --non-interactive install nginx
echo -e "user nobody;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enakbled/*.conf;
events {
        worker_connections 768;
        # multi_accept on;
}
http {
server {
        listen 443 ssl;
        listen [::]:443 ssl;
        server_name $domain;
        ssl_certificate       /root/cert.crt;
        ssl_certificate_key   /root/private.key;
        ssl_session_timeout 1d;
        ssl_session_cache shared:MozSSL:10m;
        ssl_session_tickets off;
        ssl_protocols         TLSv1.2 TLSv1.3;
        ssl_ciphers           ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;
        location / {
                proxy_pass https://www.bing.com;
                proxy_ssl_server_name on;
                proxy_redirect off;
                sub_filter_once off;
                sub_filter \x22www.bing.com\x22 \x24server_name;
                proxy_set_header Host \x22www.bing.com\x22;
                proxy_set_header Referer \x24http_referer;
                proxy_set_header X-Real-IP \x24remote_addr;
                proxy_set_header User-Agent \x24http_user_agent;
                proxy_set_header X-Forwarded-For \x24proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Accept-Encoding \x22\x22;
                proxy_set_header Accept-Language \x22zh-CN\x22;
        }
        location $path {
                proxy_redirect off;
                proxy_pass http://127.0.0.1:$port; 
                proxy_http_version 1.1;
                proxy_set_header Upgrade \x24http_upgrade;
                proxy_set_header Connection \x22upgrade\x22;
                proxy_set_header Host \x24host;
                proxy_set_header X-Real-IP \x24remote_addr;
                proxy_set_header X-Forwarded-For \x24proxy_add_x_forwarded_for;
        }
}
server {
        listen 80;
        server_name $domain;
        rewrite ^(.*)\x24 https://\x24{server_name}\x241 permanent;
}
}" > /etc/nginx/nginx.conf
systemctl restart nginx
systemctl enable nginx
echo "---------- 密钥 ----------"
cd /usr/local/etc/sing-box
cat config.json | sed 's/,/\n/g' | grep "uuid" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g' | sed 's/"//g' | tr -d ' '
echo "---------- 重启 ----------"
reboot

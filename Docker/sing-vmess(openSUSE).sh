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
cd /var/spool/cron
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
echo "---------- 安装docker ----------"
dnf install -y docker
systemctl start docker
systemctl enable docker
echo "---------- 配置容器默认启用IPv6 ----------"
CONFIG='{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64",
  "experimental": true,
  "ip6tables": true
}'
FILE="/etc/docker/daemon.json"
if [ -f "$FILE" ]; then
    cp $FILE ${FILE}.bak
    echo "$CONFIG" | > $FILE
else
    echo "$CONFIG" | > $FILE
fi
echo "---------- 创建docker网络 ----------"
docker network create my-network
systemctl restart docker
echo "---------- 下载sing-box镜像 ----------"
docker pull ghcr.io/sagernet/sing-box:latest
mkdir -p /var/lib/sing-box
mkdir -p /etc/sing-box
echo "---------- 配置vmess监听端口 ----------"
read -p "请输入vmess所使用的port: " port
read -p "请输入websocket路径: " path
echo "---------- sing-box配置文件 ----------"
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
}" > /etc/sing-box/config.json
echo "---------- sing-box容器配置 ----------"
docker run -d \
    -v /etc/sing-box:/etc/sing-box/ \
    --name sing-box \
    --network my-network \
    --restart unless-stopped \
    ghcr.io/sagernet/sing-box \
    -D /var/lib/sing-box \
    -C /etc/sing-box/ run
echo "---------- 下载nginx镜像 ----------" 
docker pull nginx
echo "---------- nginx配置文件 ----------" 
cd /root
mkdir /etc/nginx
cd /etc/nginx
touch nginx.conf
echo -e "user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
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
                proxy_pass http://sing-box:$port; 
                proxy_http_version 1.1;
                proxy_set_header Upgrade \x24http_upgrade;
                proxy_set_header Connection \x22upgrade\x22;
                proxy_set_header Host \x24host;
                proxy_set_header X-Real-IP \x24remote_addr;
                proxy_set_header X-Forwarded-For \x24proxy_add_x_forwarded_for;
        }
    }
}" > /etc/nginx/nginx.conf
echo "---------- nginx容器配置 ----------"
docker run -d \
    -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /root/cert.crt:/root/cert.crt \
    -v /root/private.key:/root/private.key \
    --name nginx \
    --network my-network \
    --restart unless-stopped \
    -p 443:443 \
    -p 443:443/udp \
    --device /dev/net/tun \
    --cap-add NET_ADMIN \
    nginx
echo "---------- 密钥 ----------"
cd /etc/sing-box
cat config.json | sed 's/,/\n/g' | grep "uuid" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g' | sed 's/"//g' | tr -d ' '
echo "---------- 重启 ----------"
reboot

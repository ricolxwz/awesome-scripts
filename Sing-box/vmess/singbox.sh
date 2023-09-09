echo "---------- IPv6 Configuration ----------"
echo "net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0" >> /etc/sysctl.conf
sysctl -p
echo "---------- git Configuration ----------"
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
echo "*/15 * * * * /root/cloudflare-ddns/start-sync.sh" >> root
systemctl restart cron
echo "---------- ACME Configuration ----------"
curl https://get.acme.sh | sh
read -p "Enter email: " email
read -p "Enter domain: " domain
read -p "Enter port: " port
read -p "Enter wspath: " path
~/.acme.sh/acme.sh --register-account -m $email
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/private.key --fullchain-file /root/cert.crt
echo "---------- Sing-box Configuration ----------"
git clone -b main https://github.com/SagerNet/sing-box
cd sing-box
./release/local/install_go.sh
./release/local/install.sh
touch /usr/local/etc/sing-box/config.json
echo -e "{
    \x22inbounds\x22: [
        {
            \x22type\x22: \x22vmess\x22,
            \x22tag\x22: \x22vmess-in\x22,
            \x22listen\x22: \x22127.0.0.1\x22,
            \x22listen_port\x22: $port,
            \x22users\x22: [
                {
                    \x22uuid\x22: \x22$(sing-box generate uuid)\x22,
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
echo "---------- Nginx Configuration ----------"
apt install nginx -y
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
./release/local/enable.sh
systemctl start sing-box
systemctl enable sing-box
echo "---------- DNS Configuration ----------"
apt install resolvconf -y
> /etc/resolvconf/resolv.conf.d/head
echo -e "nameserver 2001:4860:4860::8888
nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/head
echo "---------- UUID ----------"
cd /usr/local/etc/sing-box
cat config.json | sed 's/,/\n/g' | grep "uuid" | sed 's/:/\n/g' | sed '1d' | sed 's/}//g'
echo "---------- Reboot ----------"
echo "Enter reboot to reboot!"

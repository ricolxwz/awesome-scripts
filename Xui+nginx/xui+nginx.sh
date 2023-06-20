apt install -y curl socat
curl https://get.acme.sh | sh
read -p "Enter email: " email
read -p "Enter domain: " domain
read -p "Enter port: " port
read -p "Enter xuiport: " xuiport
read -p "Enter wspath: " path
read -p "ENter xuipath: " xuipath
~/.acme.sh/acme.sh --register-account -m $email
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/private.key --fullchain-file /root/cert.crt
bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh)
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
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP \x24remote_addr;
                proxy_set_header X-Forwarded-For \x24proxy_add_x_forwarded_for;
        }
        location $xuipath {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:$xuiport$xuipath;
        proxy_http_version 1.1;
        proxy_set_header Host \x24host;
        }
}
server {
        listen 80;
        server_name $domain;
        rewrite ^(.*)\x24 https://\x24{server_name}\x241 permanent;
}
}" > /etc/nginx/nginx.conf
systemctl restart nginx

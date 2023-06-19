bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
read -p "Enter uuid: " uuid
read -p "Enter email: " email
read -p "Enter Websocket path: " path
read -p "Enter xray port: " port
echo "{
  "log": {
    "loglevel": "warning",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access.log"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": $port,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$uuid"
            "email": "$email"
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "$path"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ]
}" > /usr/local/etc/xray/conf.json
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
apt update -y
apt install caddy
read -p "Enter domain: " domain
echo "{
	order reverse_proxy before route
	admin off
	log {
		output file /var/log/caddy/error.log
		level ERROR
	} 
	email $email

	servers :443 {
		protocols h1 h2
	}
}

:443, $domain {
	tls {
		ciphers TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256 TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
		curves x25519 secp521r1 secp384r1 secp256r1
		alpn http/1.1 h2
	}

	@vmws {
		path $path
		header Connection *Upgrade*
		header Upgrade websocket
	}
	reverse_proxy @vmws 127.0.0.1:$port

	@host {
		host $domain
	}
	route @host {
		header {
			Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
		}
		file_server {
			root /var/www/html
		}
	}
}" > /etc/caddy/Caddyfile
systemctl restart xray
systemctl restart caddy

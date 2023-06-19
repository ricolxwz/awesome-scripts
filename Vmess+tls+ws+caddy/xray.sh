bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
read -p "Enter uuid: " uuid
read -p "Enter email: " email
read -p "Enter Websocket path: " path
read -p "Enter xray port: " port
echo -e "{
    \x22log\x22: {
      \x22loglevel\x22: \x22warning\x22,
      \x22error\x22: \x22/var/log/xray/error.log\x22,
      \x22access\x22: \x22/var/log/xray/access.log\x22
    },
    \x22inbounds\x22: [
      {
        \x22listen\x22: \x22127.0.0.1\x22,
        \x22port\x22: $port,
        \x22protocol\x22: \x22vmess\x22,
        \x22settings\x22: {
          \x22clients\x22: [
            {
              \x22id\x22: \x22$uuid\x22,
              \x22email\x22: \x22$email\x22
            }
          ]
        },
        \x22streamSettings\x22: {
          \x22network\x22: \x22ws\x22,
          \x22security\x22: \x22none\x22,
          \x22wsSettings\x22: {
            \x22path\x22: \x22$path\x22
          }
        },
        \x22sniffing\x22: {
          \x22enabled\x22: true,
          \x22destOverride\x22: [
            \x22http\x22,
            \x22tls\x22
          ]
        }
      }
    ],
    \x22routing\x22: {
      \x22rules\x22: [
        {
          \x22type\x22: \x22field\x22,
          \x22protocol\x22: [
            \x22bittorrent\x22
          ],
          \x22outboundTag\x22: \x22blocked\x22
        }
      ]
    },
    \x22outbounds\x22: [
      {
        \x22protocol\x22: \x22freedom\x22,
        \x22settings\x22: {}
      },
      {
        \x22tag\x22: \x22blocked\x22,
        \x22protocol\x22: \x22blackhole\x22,
        \x22settings\x22: {}
      }
    ]
  }" > /usr/local/etc/xray/config.json
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
			Strict-Transport-Security "max-age=31536000\; includeSubDomains\; preload"
		}
		file_server {
			root /var/www/html
		}
	}
}" > /etc/caddy/Caddyfile
systemctl restart xray
systemctl restart caddy

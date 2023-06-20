bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --beta
read -p "Enter port(443): " port
read -p "Enter uuid(xray uuid): " uuid
read -p "Enter xray version(x.x.x): " xray
read -p "Enter privatekey(xray x25519): " privatekey
read -p "Enter shortid(https://suijimimashengcheng.bmcx.com): " shortid
read -p "Enter target website: " website
echo "{
  \x22log\x22: {
    \x22loglevel\x22: \x22warning\x22
  },
  \x22inbounds\x22: [ 
    {
      \x22listen\x22: \x220.0.0.0\x22,
      \x22port\x22: $port,
      \x22protocol\x22: \x22vless\x22,
      \x22settings\x22: {
        \x22clients\x22: [
          {
            \x22id\x22: \x22$uuid\x22,
            \x22flow\x22: \x22xtls-rprx-vision\x22
          }
        ],
        \x22decryption\x22: \x22none\x22
      },
      \x22streamSettings\x22: {
        \x22network\x22: \x22tcp\x22,
        \x22security\x22: \x22reality\x22,
        \x22realitySettings\x22: {
          \x22show\x22: false,
          \x22dest\x22: \x22$website:443\x22, 
          \x22xver\x22: 0,
          \x22serverNames\x22: [
            \x22$website\x22
          ],
          \x22privateKey\x22: \x22$privatekey\x22,
          \x22minClientVer\x22: \x22$xray\x22,
          \x22shortIds\x22: [ 
            \x22$shortid\x22
          ]
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
        \x22outboundTag\x22: \x22blocked\x22,
        \x22ip\x22: [
          \x22geoip:cn\x22,
          \x22geoip:private\x22
        ] 
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
systemctl restart xray
systemctl status xray

# Common

## Warp

"inbounds":
```json
"inbounds": [
  // ... inbound fields
  "sniff": true,
  "sniff_override_destination": true,
  "sniff_timeout": "300ms"
]
```

"outbounds": 
```json
"outbounds": [
  {
    "type": "direct",
    "tag": "DIRECT"
  },
  {
    "type": "socks",
    "tag": "socks-out",
    "server": "127.0.0.1",
    "server_port": 40000,
    "version": "5"
  }
]
```

"routes": 
```json
"route": {
  "geosite": {
    "path": "geosite.db",
    "download_url": "https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db",
    "download_detour": "DIRECT"
  },
  "rules": [
    "geosite": [
      "openai",
      "netflix"
    ],
    "outbound": "socks-out"
  ],
  "final": "DIRECT"
}

```

### 查询代理后的地址

```
curl ifconfig.me --proxy socks5://127.0.0.1:40000
```

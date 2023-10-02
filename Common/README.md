# Common

## Warp

"inbounds":
```json
{
  "sniff": true,
  "sniff_override_destination": true,
  "sniff_timeout": "300ms"
}
```

"outbounds": 
```json
{
  "type": "socks",
  "tag": "socks-out",
  "server": "127.0.0.1",
  "server_port": 40000,
  "version": "5"
}
```

"routes": 
```json
"rules": [
  "geosite": [
    "openai",
    "netflix"
  ],
  "outbound": "socks-out"
]
```

### 查询代理后的地址

```
curl ifconfig.me --proxy socks5://127.0.0.1:40000
```

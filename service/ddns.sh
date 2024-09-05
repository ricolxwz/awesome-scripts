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
        },
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
touch /var/spool/cron/crontabs/root
echo "*/15 * * * * cd /root/cloudflare-ddns && ./start-sync.sh" > /var/spool/cron/crontabs/root
systemctl restart cron

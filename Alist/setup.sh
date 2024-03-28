apt update -y
apt install git -y
echo "---------- DDNS Configuration ----------"
cd /root
git clone https://github.com/timothymiller/cloudflare-ddns.git
cd cloudflare-ddns
touch config.json
read -p "Enter api_token: " api
read -p "Enter zone_id: " zone
read -p "Enter sub_domain: " sub_domain
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
apt install python3 python3-venv -y
python3 -m venv venv
./start-sync.sh
echo "---------- Crontab Configuration ----------"
cd /var/spool/cron/crontabs
touch root
echo "*/15 * * * * cd /root/cloudflare-ddns && ./start-sync.sh" >> root
echo "@reboot cd /root/cloudflare-ddns && ./start-sync.sh" >> root
systemctl restart cron
echo "---------- ACME Configuration ----------"
cd /root
curl https://get.acme.sh | sh
read -p "Enter email: " email
read -p "Enter domain: " domain
echo "Please choose an SSL provider:"
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
echo "You have selected: $opt"
~/.acme.sh/acme.sh --register-account -m $email
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/private.key --fullchain-file /root/cert.crt
echo "---------- Alist Configuration ----------"
curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install
cd /opt/alist
read -p "Enter alist admin password: " password
./alist admin set $password
read -p "Enter https port: " port
config_file="/opt/alist/data/config.json"
sed -i "s/\"https_port\": [^,]*/\"https_port\": $port/" $config_file
sed -i 's/"force_https": false/"force_https": true/' $config_file
sed -i 's|"key_file": "[^"]*"|"key_file": "/root/private.key"|' $config_file
sed -i 's|"cert_file": "[^"]*"|"cert_file": "/root/cert.crt"|' $config_file
systemctl restart alist

wget "https://go.dev/dl/$(curl -s https://go.dev/VERSION?m=text|awk 'NR==1 {print $1}').linux-amd64.tar.gz"
tar -xf go*.linux-amd64.tar.gz -C /usr/local/
echo 'export GOROOT=/usr/local/go' >> /etc/profile
echo 'export PATH=$GOROOT/bin:$PATH' >> /etc/profile
source /etc/profile
go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive
read -p "Please Enter your Domain: " domain
read -p "Please Enter your Email: " email
read -p "Please Enter your Username for naiveproxy: " username
read -p "Please Enter your Password for naiveproxy: " password
read -p "Please Enter port for naiveproxy: " port
echo ":$port, $domain
tls $email
route {
 forward_proxy {
   basic_auth $username $password
   hide_ip
   hide_via
   probe_resistance
  }
 reverse_proxy  https://bing.com  {
   header_up  Host  {upstream_hostport}
   header_up  X-Forwarded-Host  {host}
  }
}" > Caddyfile
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
npm install pm2 -g
pm2 start ./caddy -n caddy -- run --config Caddyfile
pm2 save
pm2 startup

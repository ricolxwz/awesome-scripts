echo "---------- 安装基础依赖 ----------"
apt install cron git curl wget unzip -y
echo "---------- 安装php ----------"
apt install php -y
echo "---------- 安装sqlite3 ----------"
apt install sqlite3 -y
echo "---------- 安装nginx ----------"
apt install php-fpm -y
systemctl stop apache2
systemctl disable apache2
apt purge apache2 -y
apt autoremove -y
apt install nginx -y
echo "---------- 安装redis ----------"
apt install redis -y
echo "---------- 安装php扩展 ----------"
apt install php-mysqli php-sqlite3 php-curl php-mbstring php-imagick php-redis php-dom php-bcmath -y
systemctl restart nginx
echo "---------- 建立网站 ----------"
read -p "Please input download url: " download_url
cd /var/www/html
rm -rf * .*
wget $download_url
unzip *
ls -a | grep 'zip' | xargs -d '\n' rm
systemctl reload nginx
echo "---------- 配置nginx ----------"
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
chmod 755 /var/www/html/.env
chown www-data:www-data /var/www/html/.env
cd /etc/nginx/sites-available
echo -e "server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /var/www/html/public;
	server_name _;
 	index index.php;
	location / {
	  try_files \x24uri \x24uri/ /index.php?\x24query_string;
	}
	location ~ \.php\x24 {
	  include snippets/fastcgi-php.conf;
	  fastcgi_pass unix:/run/php/php8.2-fpm.sock;
	}
}" > default
systemctl restart nginx
echo "---------- 配置env ----------"
cd /var/www/html
php artisan key:generate
read -p "Please input host: " app_url
read -p "Please input serial no: " serial_no
read -p "Please input secret: " app_secret
sed -i "s|APP_URL=.*|APP_URL=${app_url}|" .env
sed -i "s|APP_SERIAL_NO=.*|APP_SERIAL_NO=${serial_no}|" .env
sed -i "s|APP_SECRET=.*|APP_SECRET=${app_secret}|" .env
echo "---------- Crontab配置2 ----------"
cd /var/spool/cron/crontabs
echo "* * * * * cd /www/wwwroot/lsky-pro && php artisan schedule:run >> /dev/null 2>&1" >> root
systemctl restart cron

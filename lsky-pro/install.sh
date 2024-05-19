echo "---------- 安装基础依赖 ----------"
apt install cron git curl wget unzip -y
echo "---------- 安装php ----------"
apt install php -y
echo "---------- 安装mysql ----------"
apt install gnupg -y
wget https://dev.mysql.com/get/mysql-apt-config_0.8.30-1_all.deb
dpkg -i mysql-apt-config*
apt update
apt install mysql-server -y
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
apt install php-mysqli php-curl php-mbstring php-imagick php-redis php-dom -y
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
cd /etc/nginx/sites-available
echo "---------- 配置env ----------"
cd /var/www/html
php artisan key:generate
read -p "Please input host: " app_url
read -p "Please input serial no: " serial_no
read -p "Please input secret: " app_secret
sed -i "s|APP_URL=.*|APP_URL=${app_url}|" .env
sed -i "s|APP_SERIAL_NO=.*|APP_URL=${serial_no}|" .env
sed -i "s|APP_SECRET=.*|APP_URL=${app_secret}|" .env

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
apt install php-mysqli php-curl php-mbstring php-imagick php-redis -y
systemctl restart nginx
echo "---------- 建立网站 ----------"
read -p "Please input download url: " download_url
cd /var/www/html
wget $download_url
unzip *
ls -a | grep 'zip' | xargs -d '\n' rm
systemctl reload nginx

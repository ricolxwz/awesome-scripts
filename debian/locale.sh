sudo locale-gen zh_CN.UTF-8
sudo locale-gen en_US.UTF-8
echo 'LANG=zh_CN.UTF-8' | sudo tee /etc/locale.conf
echo 'LC_CTYPE=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_NUMERIC=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_TIME=zh_CN.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_COLLATE=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_MONETARY=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_MESSAGES=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_PAPER=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_NAME=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_ADDRESS=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_TELEPHONE=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_MEASUREMENT=en_US.UTF-8' | sudo tee -a /etc/locale.conf
echo 'LC_IDENTIFICATION=en_US.UTF-8' | sudo tee -a /etc/locale.conf

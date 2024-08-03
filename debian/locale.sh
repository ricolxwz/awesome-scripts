sudo sed -i '/#zh_CN.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo sed -i '/#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sudo locale-gen
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

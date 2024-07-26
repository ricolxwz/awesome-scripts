sudo pacman -S --needed --noconfirm docker
sudo systemctl enable docker.service
sudo systemctl enable docker.socket
sudo systemctl start docker.service
sudo systemctl start docker.socket
sudo groupadd docker
sudo usermod -aG docker $USER

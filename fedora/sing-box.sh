sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://sing-box.app/sing-box.repo
sudo dnf install sing-box -y
sudo systemctl enable sing-box
sudo systemctl restart sing-box

sudo pacman -S open-vm-tools
sudo systemctl enable vmtoolsd
sudo systemctl start vmtoolsd
sudo systemctl enable vmware-vmblock-fuse
sudo systemctl start vmware-vmblock-fuse
sudo pacman -S gtkmm3

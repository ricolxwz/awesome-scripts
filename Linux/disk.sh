cd ~
sudo mkdir -p /mnt/hgfs
echo "vmhgfs-fuse /mnt/hgfs fuse defaults,allow_other,_netdev 0 0" | sudo tee -a /etc/fstab > /dev/null

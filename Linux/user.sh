cd /etc
sudo chmod 640 sudoers
echo '${USER} ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
sudo chmod 440 sudoers

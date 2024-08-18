sudo systemctl enable --now bluetooth
sudo pacman -S power-profiles-daemon --needed --noconfirm
sudo pacman -S linux-lts linux-lts-headers --needed --noconfirm
sudo grub-mkconfig -o /boot/grub/grub.cfg
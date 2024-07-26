# cdrom系统下操作

## 禁用reflector服务(可选)
systemctl stop reflector.service

## 确认是否处于UEFI模式
ls /sys/firmware/efi/efivars

## 连接无线网络(可选)
iwctl
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect wifi-name
exit
ping www.bilibili.com

## 更新时钟
timedatectl set-ntp true
timedatectl status

## 分区
parted /dev/nvme0n1
mktable gpt
mkpart EFI fat32 0% 800MB
mkpart PRI ext4 800MB 100%
print
quit
fdisk -l

## 挂载
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
df -h

## 系统安装
pacstrap /mnt base base-devel linux linux-headers linux-firmware
pacstrap /mnt dhcpcd iwd vi vim sudo bash-completion

## 生成fstab
genfstab -U /mnt >> /mnt/etc/fstab

# 切换到/mnt下操作
arch-chroot /mnt

## 设置主机名
echo "vmware-archlinux" > /etc/hostname

## 设置hosts文件
echo "127.0.0.1   localhost
::1         localhost
127.0.1.1   myarch" > /etc/hosts

## 设置root密码
passwd root

## 设置时区
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

## 硬件时间设置
hwclock --systohc

## 安装微码(根据芯片选)
pacman -S intel-ucode
pacman -S amd-ucode

## 安装引导程序
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
vim /etc/default/grub
  # 1. 去掉 GRUB_CMDLINE_LINUX_DEFAULT 一行中最后的 quiet 参数
  # 2. 把 loglevel 的数值从 3 改成 5。这样是为了后续如果出现系统错误，方便排错
  # 3. 加入 nowatchdog 参数，这可以显著提高开关机速度
grub-mkconfig -o /boot/grub/grub.cfg

## 退出
exit
umount -R /mnt
reboot

# 进入新系统

## 测试网络
systemctl start dhcpcd
curl cip.cc

## 升级所有包
pacman -Syu

## 创建用户
useradd -m -G wheel -s /bin/bash wenzexu

## 设置用户密码
passwd wenzexu

## 开启32位库支持
vim /etc/pacman.conf
  # 去掉[multilib]一节中的注释
pacman -Syyu

## 安装KDE(可选)
pacman -S plasma-meta konsole dolphin # xorg
  # plasma-meta 元软件包、konsole 终端模拟器和 dolphin 文件管理器
pacman -S  plasma-workspace xdg-desktop-portal # wayland
  # N卡用户需要额外安装egl-wayland,xdg-desktop-portal包是为了如obs此类工具录制屏幕使用
  # xdg-desktop-portal包组提供了不同环境下使用的软件包
  # 例如kde用户可选择xdg-desktop-portal-kde包

## 配置启动sddm
systemctl enable sddm
systemctl start sddm

# 进入图形操作界面

## 执行自动化安装程序
cd ~
wget -O setup.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/setup.sh"
chmod a+x setup.sh
./setup.sh

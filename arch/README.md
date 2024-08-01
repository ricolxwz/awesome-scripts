```sh
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
lsblk
parted /dev/nvme0n1
mktable gpt
mkpart EFI 0% 800MB
mkpart PRI 800MB 100%
print
quit
fdisk -l

## 格式化
mkfs.vfat /dev/nvme0n1p1
# mkfs.ext4 /dev/nvme0n1p2
mkfs.btrfs /dev/nvme0n1p2

## 挂载
# mount /dev/nvme0n1p2 /mnt
# mkdir /mnt/efi
# mount /dev/nvme0n1p1 /mnt/efi
# df -h
mount -t btrfs -o compress=zstd /dev/nvme0n1p2 /mnt
  # 为了创建子卷, 必须先挂载子卷所属的文件系统
btrfs subvolume create /mnt/@
# btrfs subvolume create /mnt/@home
umount /mnt
  # 想要挂载子卷, 必须先卸载子卷所属的文件系统
mount -t btrfs -o subvol=/@,compress=zstd /dev/nvme0n1p2 /mnt
  # 将子卷@挂载到/mnt上
# mkdir /mnt/home
# mount -t btrfs -o subvol=/@home,compress=zstd /dev/nvme0n1p2 /mnt/home
  # 将子卷@home挂载到/mnt/home上
mkdir -p /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
  # 将/dev/nvme0n1p1挂载到/mnt/efi上
df -h

## 挂载(AA64)
mount -t btrfs -o compress=zstd /dev/vda2 /mnt
btrfs subvolume create /mnt/@
umount /mnt
mount -t btrfs -o subvol=/@,compress=zstd /dev/vda2 /mnt/install
mkdir -p /mnt/install/efi
mount /dev/vda1 /mnt/install/efi

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
# grub-install --target=arm64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
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
systemctl enable dhcpcd
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
pacman -S plasma-meta konsole dolphin # 基本包
  # plasma-meta 元软件包、konsole 终端模拟器和 dolphin 文件管理器
pacman -S  plasma-workspace # 若还需要wayland支持, 安装这些包
  # N卡用户需要额外安装egl-wayland,xdg-desktop-portal包是为了如obs此类工具录制屏幕使用
  # xdg-desktop-portal包组提供了不同环境下使用的软件包
  # 例如kde用户可选择xdg-desktop-portal-kde包

## 配置启动sddm
systemctl enable sddm
systemctl start sddm

# 进入图形操作界面

## 切换到root
su

## 将当前用户添加到sudoers
cd /etc
chmod 600 sudoers
echo "wenzexu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod 400 sudoers

## 安装VMware工具(可选)
pacman -S open-vm-tools
systemctl enable vmtoolsd
systemctl enable vmware-vmblock-fuse
pacman -S gtkmm3
reboot

## 安装UTM工具(可选)
pacman -S spice-vdagent
reboot

## 执行自动化安装程序 (检查必须在用户wenzexu下运行)
cd ~
sudo pacman -S --needed --noconfirm wget
wget -O setup.sh "https://raw.githubusercontent.com/ricolxwz/awesome-scripts/master/arch/setup.sh"
chmod a+x setup.sh
./setup.sh
```

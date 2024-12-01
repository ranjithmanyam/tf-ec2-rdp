#!/bin/bash
apt-get update
apt-get upgrade -y

# Install XFCE Desktop Environment
apt-get install -y xfce4 xfce4-goodies

# Install XRDP for Remote Desktop
apt-get install -y xrdp
systemctl enable xrdp
systemctl start xrdp

# Set up XFCE session for XRDP
echo "xfce4-session" > /root/.xsession
echo "xfce4-session" > /home/ubuntu/.xsession
chown ubuntu:ubuntu /home/ubuntu/.xsession

# Allow XRDP to use Polkit
adduser xrdp ssl-cert

# Restart services
systemctl restart xrdp

sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

sudo apt update --fix-missing
sudo apt upgrade -y


echo "ubuntu:${instance_password}" | chpasswd
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

#sudo apt install -y midori
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt --fix-broken install

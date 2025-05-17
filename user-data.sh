#!/bin/bash

# Log all output to a file for debugging
exec > /var/log/user-data.log 2>&1

apt-get update -y
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

# Install required utilities and add universe repository
apt-get install -y wget apt-transport-https software-properties-common
add-apt-repository universe -y
apt-get update -y

# Install dependencies for Google Chrome
apt-get install -y fonts-liberation libxss1 libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libatk1.0-0 libcups2 libgbm1 libnspr4 libnss3 libu2f-udev xdg-utils

# Download and install Google Chrome
wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i /tmp/google-chrome-stable_current_amd64.deb || true
apt-get install -y -f  # Fix broken dependencies

# Clean up
rm /tmp/google-chrome-stable_current_amd64.deb
apt-get autoremove -y
apt-get clean

# Verify installation
if command -v google-chrome >/dev/null 2>&1; then
    echo "Google Chrome installed successfully"
    google-chrome --version
else
    echo "Google Chrome installation failed"
    exit 1
fi

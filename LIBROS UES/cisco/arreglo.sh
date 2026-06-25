#! /bin/bash

mkdir ~/solution
cd ~/solution/

cat << EOF > ~/solution/sources.list
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse

deb http://archive.canonical.com/ubuntu focal partner
deb-src http://archive.canonical.com/ubuntu focal partner
EOF

sed -i "s/focal/$(lsb_release -c -s)/" ~/solution/sources.list
rm /etc/apt/sources.list
cp ~/solution/sources.list /etc/apt/sources.list

sudo mv /etc/apt/sources.list.d/* ~/solution
apt-get update 

#Instalar SimpleScreenRecorder
sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder
apt-get update
sudo apt-get install simplescreenrecorder -y 
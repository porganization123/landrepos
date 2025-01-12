#!/bin/bash
# Install and start nexus as a service 
# This script works on RHEL 7 & 8 OS 
# Your server must have atleast 4GB of RAM
# become the root / admin user via: sudo su -
# Amz linux: wget https://raw.githubusercontent.com/porganization123/landrepos/refs/heads/master/installNexus.sh && sh installNexus.sh
#1. Create nexus user to manage the nexus
# As a good security practice, Nexus is not advised to run nexus service as a root user, so create a new user called nexus and grant sudo access to manage nexus services as follows.
sudo useradd nexus
#4 Give sudo access to nexus user
sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus
sudo sudo su - nexus << EOF
cd /opt
# 1.Install prerequisit: JAVA, git, unzip
sudo yum install git unzip -y
sudo yum install java-11 java-1.8.0 -y
# 2. Download nexus software and extract it (unzip)
#sudo wget http://download.sonatype.com/nexus/3/nexus-3.15.2-01-unix.tar.gz 
#sudo tar -zxvf nexus-3.15.2-01-unix.tar.gz
#sudo mv /opt/nexus-3.15.2-01 /opt/nexus
#sudo rm -f  nexus-3.15.2-01-unix.tar.gz
sudo wget https://download.sonatype.com/nexus/3/nexus-3.76.0-03-unix.tar.gz
sudo tar -zxvf nexus-3.76.0-03-unix.tar.gz
sudo mv /opt/nexus-3.76.0-03 /opt/nexus
sudo rm -f  nexus-3.76.0-03-unix.tar.gz
#5 Change the owner and group permissions to /opt/nexus and /opt/sonatype-work directories.
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
sudo chmod -R 775 /opt/nexus
sudo chmod -R 775 /opt/sonatype-work
#6 Open /opt/nexus/bin/nexus.rc file and  uncomment run_as_user parameter and set as nexus user.
# vi /opt/nexus/bin/nexus.rc
sudo echo 'run_as_user="nexus"'>> /opt/nexus/bin/nexus.rc
#7 CONFIGURE NEXUS TO RUN AS A SERVICE 
sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
#9 Enable and start the nexus services
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus
echo "end of nexus installation"
EOF

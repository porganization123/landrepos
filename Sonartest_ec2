# Size: t2medium for Rhel or t2small for amazonlinux
# Amazonlinux: wget https://raw.githubusercontent.com/porganization123/landrepos/refs/heads/master/InstallSonar.sh && sh InstallSonar.sh
# Rhel: sudo yum install wget -y &&  wget https://raw.githubusercontent.com/porganization123/landrepos/refs/heads/master/InstallSonar.sh && sh InstallSonar.sh

sudo hostnamectl set-hostname sonar
cd /opt
sudo yum install unzip wget git cronie java-17 -y
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.8.100196.zip
sudo unzip sonarqube-9.9.8.100196.zip
sudo rm -rf sonarqube-9.9.8.100196.zip
sudo mv sonarqube-9.9.8.100196 sonarqube
sudo chown -R ec2-user:ec2-user /opt/sonarqube/
sudo chmod -R 775 /opt/sonarqube/
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start 
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh status
sudo systemctl start crond.service
sudo systemctl enable crond.service
echo "@reboot  /opt/sonarqube/bin/linux-x86-64/sonar.sh start" > /opt/sonarqube/cronsonar
crontab < /opt/sonarqube/cronsonar

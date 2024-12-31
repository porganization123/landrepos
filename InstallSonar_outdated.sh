# Size: t2medium for Rhel or t2small for amazonlinux
sudo useradd sonar
# Grand sudo access to sonar user
sudo echo "sonar ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/sonar
# set hostname for the sonarqube server
sudo hostnamectl set-hostname sonar
#echo -e "sudo su - sonar << EOF \nsh /opt/sonarqube/bin/linux-x86-64/sonar.sh start \nEOF" >> .bash_profile
sudo su - sonar << EOF
#sudo passwd sonar
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service sshd restart
cd /opt
sudo yum -y install unzip wget git cronie
sudo yum install  java-11 -y
#sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.8.zip
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.8.100196.zip
#sudo unzip sonarqube-7.8.zip
sudo unzip sonarqube-9.9.8.100196.zip
#sudo rm -rf sonarqube-7.8.zip
#sudo mv sonarqube-7.8 sonarqube
sudo mv sonarqube-9.9.8.100196 sonarqube
sudo chown -R sonar:sonar /opt/sonarqube/
sudo chmod -R 775 /opt/sonarqube/
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start 
sh /opt/sonarqube/bin/linux-x86-64/sonar.sh status
sudo systemctl start crond.service
sudo systemctl enable crond.service
echo "@reboot  /opt/sonarqube/bin/linux-x86-64/sonar.sh start" > /opt/sonarqube/cronsonar
crontab < /opt/sonarqube/cronsonar
EOF

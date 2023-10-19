#Create Redhat EC2 T2.micro Instance.
# open port 8080 ..etc
# change hostname to tomcat
sudo hostnamectl set-hostname tomcat
#sudo su - ec2-user
sudo yum install git wget -y
sudo yum install java-11 -y
sudo yum install wget unzip -y
sudo curl https://tomcat.apache.org/download-90.cgi > latesttom
cd /opt
sudo wget $(grep -o 'https://dlcdn[^"]*\.[0-9][0-9]\.zip' /home/ec2-user/latesttom)
sudo unzip apache*.zip
sudo rm -rf apache*zip
sudo rm -f /home/ec2-user/latesttom
### rename tomcat for good naming convention
sudo mv apache*[0-9] tomcat9  
### assign executable permissions to the tomcat home directory
sudo chmod 777 -R /opt/tomcat9
sudo chown ec2-user -R /opt/tomcat9
### start tomcat
sh /opt/tomcat9/bin/startup.sh
# create a soft link to start and stop tomcat
sudo ln -s /opt/tomcat9/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/tomcat9/bin/shutdown.sh /usr/bin/stoptomcat
starttomcat
sudo sed -i '/^  <Valve*/i <!--' /opt/tomcat9/webapps/manager/META-INF/context.xml
sudo sed -i '/^         allow*/a -->' /opt/tomcat9/webapps/manager/META-INF/context.xml
sudo sed -i '/^<\/tomcat-users>/i <user username="admin" password="admin" roles="manager-gui,manager-script"\/>' /opt/tomcat9/conf/tomcat-users.xml
sudo su ec2-user

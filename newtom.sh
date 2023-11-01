sudo curl -s https://tomcat.apache.org/download-90.cgi > latesttom

#default_vers=$(grep -o 'https://dlcdn[^"]*\.[0-9][0-9]\.zip' /home/ec2-user/latesttom | grep -o '[0-9].[0-9].[0-9][0-9]'| grep -m 1 [0-9].[0-9].[0-9][0-9])
default_vers=$(grep -o 'https://dlcdn[^"]*\.[0-9]\{1,2\}\.zip' /home/ec2-user/latesttom | grep -o '[0-9].[0-9].[0-9]\{1,2\}'| grep -m 1 '[0-9].[0-9].[0-9]\{1,2\}')
found=false
while [ "$found" = "false" ]; do
echo -n "what version are you planning to install [$default_vers]: "
read tomvers
url="https://archive.apache.org/dist/tomcat/tomcat-9/v$tomvers/bin/apache-tomcat-$tomvers.zip"

if [ ! -z "$tomvers" ] && [ "$tomvers" != "$default_vers" ]; then
   if curl -s --head --fail "$url" > /dev/null 2>&1; then
      found=true
   else
   echo "wrong"    
   fi
else
   found=true
fi

done
if [ -z "$tomvers" ] || [ "$tomvers" = "default_vers" ]; then
   link=https://dlcdn.apache.org/tomcat/tomcat-9/v$default_vers/bin/apache-tomcat-$default_vers.zip

else
   link=https://archive.apache.org/dist/tomcat/tomcat-9/v$tomvers/bin/apache-tomcat-$tomvers.zip 
fi

echo  -n "what's your desired username: "
read username

echo -n "provide your password please: "
read password

echo -n "desired role [ manager-gui manager-script separate each role by a coma]: "
read roles

#####
#Create Amazon Linux EC2 T2.micro Instance.
# open port 8080 ..etc
# change hostname to tomcat
sudo hostnamectl set-hostname tomcat
#sudo su - ec2-user
sudo yum install git wget java-11 unzip cronie -y
cd /opt
### Downloading latest tomcat ######
sudo wget $link
sudo unzip apache*.zip
sudo rm -rf apache*.zip
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
sudo sed -i "/^<\/tomcat-users>/i <user username=\"$username\" password=\"$password\" roles=\"$roles\"\/>" /opt/tomcat9/conf/tomcat-users.xml
sudo systemctl start crond.service
sudo systemctl enable crond.service
echo "@reboot  starttomcat" > /opt/tomcat9/crontom
crontab < /opt/tomcat9/crontom
sudo su ec2-user

# install Java JDK 11+ as a pre-requisit for maven to run.
sudo hostnamectl set-hostname maven
#sudo su - ec2-user
sudo yum install wget tree unzip git java-11 -y
curl https://maven.apache.org/download.cgi > latestmaven
cd /opt
sudo wget $(grep -o 'https://dlcdn[^"]*/3.9[^"]*bin\.zip' /home/ec2-user/latestmaven)
sudo unzip apache*.zip
sudo rm -rf apache*.zip
sudo mv apache*/ maven
cd
echo 'export M2_HOME=/opt/maven' >> .bash_profile
echo 'export PATH=$PATH:$M2_HOME/bin' >> .bash_profile
source ~/.bash_profile
mvn -version
echo "NOW RUN THIS COMMAND: source .bash_profile"

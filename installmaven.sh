# install Java JDK 11+ as a pre-requisit for maven to run.
sudo hostnamectl set-hostname maven
#sudo su - ec2-user
cd /opt
sudo yum install wget nano tree unzip git -y
sudo yum install java-11 -y
sudo wget https://dlcdn.apache.org/maven/maven-3/3.9.3/binaries/apache-maven-3.9.3-bin.zip
sudo unzip apache-maven-3.9.3-bin.zip
sudo rm -rf apache-maven-3.9.3-bin.zip
sudo mv apache-maven-3.9.3/ maven
cd
echo 'export M2_HOME=/opt/maven' >> .bash_profile
echo 'export PATH=$PATH:$M2_HOME/bin' >> .bash_profile
source ~/.bash_profile
mvn -version
echo "NOW RUN THIS COMMAND: source .bash_profile"

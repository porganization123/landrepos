sudo curl https://tomcat.apache.org/download-90.cgi > latesttom

default_vers=$(grep -o 'https://dlcdn[^"]*\.[0-9][0-9]\.zip' /home/ec2-user/latesttom | grep -o '[0-9].[0-9].[0-9][0-9]'| grep -m 1 [0-9].[0-9].[0-9][0-9])

echo -n "what version are you planning to install [$default_vers]: "
read tomvers
url="https://archive.apache.org/dist/tomcat/tomcat-9/v$tomvers/bin/apache-tomcat-$tomvers.zip"
while [ ! -z "$tomvers" ] && ( [ "$tomvers" != "$default_vers" ] || curl -s --head --fail "$url" | grep "Not Found" ); do
    echo "Please provide a correct version! What your version number [$default_vers]: "
    read tomvers
done
echo "bingo"


#if [ "$tomvers" = "9.0.82" ]; 
#then echo "bingo" 
#fi

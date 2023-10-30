sudo curl https://tomcat.apache.org/download-90.cgi > latesttom

default_vers=$(grep -o 'https://dlcdn[^"]*\.[0-9][0-9]\.zip' /home/ec2-user/latesttom | grep -o '[0-9].[0-9].[0-9][0-9]'| grep -m 1 [0-9].[0-9].[0-9][0-9])
found=false
while [ "$found" = "false" ]; do
echo -n "what version are you planning to install [$default_vers]: "
read tomvers
url="https://archive.apache.org/dist/tomcat/tomcat-9/v$tomvers/bin/apache-tomcat-$tomvers.zip"

if [ ! -z "$tomvers" ] && [ "$tomvers" != "$default_vers" ]; then
   if curl -s --head --fail "$url"; then
      found=true
   else
   echo "wrong"    
   fi
else
   found=true
fi

done
if [ -z "$tomvers" ] || [ "$tomvers" = "default_vers" ]; then
if curl -s --head --fail "$url"; then
      found=true
   else
   echo "wrong"    
   fi
else
   found=true
fi

done
if [ -z "$tomvers" ] || [ "$tomvers" = "default_vers" ]; then
   wget https://dlcdn.apache.org/tomcat/tomcat-9/v$default_vers/bin/apache-tomcat-$default_vers.zip

else
   wget https://archive.apache.org/dist/tomcat/tomcat-9/v$tomvers/bin/apache-tomcat-$tomvers.zip

fi

echo "bingo"

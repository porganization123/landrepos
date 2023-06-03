#!/bin/bash
echo -n " provide the file name: "
read filename
echo "creating g11team and g11backup ..."
mkdir g11team
mkdir g11backup
echo "creating the file  ... "
cd g11team
touch $filename
echo "I'm currently a member of the group g11." > $filename
cp $filename ../g11backup
echo " showing the content of the file in g11team"
cat $filename
echo " showing the content of the file in g11backup"
cat ../g11backup/$filename

# I really like this script
# I've just added another line to my script

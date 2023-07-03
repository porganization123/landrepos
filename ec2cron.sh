# This installation is for Amazon Linux. Not sure it will work with RHEL
sudo yum install cronie -y
sudo systemctl start crond.service
sudo systemctl enable crond.service
echo "0 */4 * * * shutdown --poweroff +5 'The system is going down in five minutes.'" > cronjob001
crontab -T cronjob001
crontab < cronjob001
crontab -l
sudo systemctl status crond.service

#!/bin/bash

jeshile='\e[40;38;5;82m' 
jo='\e[0m'  
red='\e[31m'
yellow='\e[0;93m'

sudo apt update  
sudo apt install -y --force-yes lsb-core 

clear
sleep 1
echo " "
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo -e "${jeshile} ?          installer mysql 5.5.62              ? \e[0m"
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo " " 
sleep 5
echo " "
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo -e "${jeshile} ?               Update System                  ? \e[0m"
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo " " 
sudo apt update
sudo apt install whiptail -y

osname=$(lsb_release -si)
osrelease=$(lsb_release -sr)
oscodename=$(lsb_release -sc) 
osDisc=$(lsb_release -sd)
arch=$(uname -m)
file=/etc/rc.local
type mysql >/dev/null 2>&1 && mysqlstatus="y" || mysqlstatus="n"	 
rm -rf /usr/local/mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz

echo " "
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo -e "${jeshile} ?            Checking System Version           ? \e[0m"
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo " " 
sleep 5
if [ "$osname" == "Ubuntu"  ] && [ "$arch" == "x86_64"  ] ;  then
 
 if [ $mysqlstatus = "y" ]  ; then

if whiptail   --title "Mysql already installed" --yesno "do you want to uninstall mysql ?" 8 78 --defaultno; then

if (whiptail --title "database phpmyadmin." --yesno "Do you want to database backup ?" 8 78); then   
backup="y"
else
backup="n"	 
fi 
if [ $backup = "y" ];then
while true; do
echo " " 
mysqlpassword=$(whiptail --title "MariaDB Password" --passwordbox "Please enter your mysql password." 10 60 3>&1 1>&2 2>&3)
echo " "  
RESULT=`mysqlshow --user=root --password=$mysqlpassword mysql | grep -v Wildcard | grep -o mysql `
[ "$RESULT" = "mysql" ] && break
done

sleep 1
mysqldump -uroot -p"$mysqlpassword" --all-databases > /root/all_databases.sql
sleep 1
fi 

sudo apt-get remove --purge mysql* -y
sleep 1
sudo apt-get purge mysql* -y
sudo rm -rf /usr/local/mysql
sudo rm -rf /home/lemp/mysql
sudo rm -rf /usr/local/bin/mysql*
sudo rm -rf /usr/local/bin/innochecksum  
sudo rm -rf /usr/local/bin/myisam_ftdump 
sudo rm -rf /usr/local/bin/my_print_defaults  
sudo rm -rf /usr/local/bin/resolveip
sudo rm -rf /usr/local/bin/msql2mysql  
sudo rm -rf /usr/local/bin/myisamlog  
sudo rm -rf /usr/local/bin/perror    
sudo rm -rf /usr/local/bin/resolve_stack_dump
sudo rm -rf /usr/local/bin/myisamchk  
sudo rm -rf /usr/local/bin/myisampack  
sudo rm -rf /usr/local/bin/replace
sudo rm -rf /etc/my.cnf
sudo rm -rf /etc/init.d/mysql.server
sudo rm -rf /etc/init.d/my.cnf
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get remove dbconfig-mysql -y
#sudo apt-get dist-upgrade -y  

else
echo " "
fi
fi

type mysql >/dev/null 2>&1 && mysqlstatus="y" || mysqlstatus="n"	 

if [ $mysqlstatus = "n" ]; then
  
while true; do
echo " " 
MySQL=$(whiptail --title "MySQL Password" --passwordbox "Enter your New password for the MySQL " 10 60 3>&1 1>&2 2>&3)
echo " " 
MySQL2=$(whiptail --title "MySQL Password" --passwordbox "Enter your Repeat password for the MySQL " 10 60 3>&1 1>&2 2>&3)
echo " "
[ "$MySQL" = "$MySQL2" ] && break
done
 
echo " "
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo -e "${jeshile} ?           Install MySQL Server               ? \e[0m"
echo -e "${jeshile} ???????????????????????????????????????????????? \e[0m"
echo " " 

groupadd mysql
sleep 1
useradd -r -g mysql mysql
sleep 1
sudo apt  install  -y --force-yes libaio1 
sleep 1

if [ "$osrelease" == "16.04" ] ; then 
sudo apt install  -y --force-yes libfile-copy-recursive-perl 
sleep 1
sudo apt install  -y --force-yes sysstat   
fi

sleep 1

if [ "$osrelease" == "19.04" ] ; then 
sudo apt install  -y --force-yes libncurses5  
fi


while true; do
wget https://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz -P /usr/local
sleep 1
 [ -f /usr/local/mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz ] && break
done
sleep 1
cd /usr/local
#wget https://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz
sudo tar -xvf mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz
sleep 1
sudo mv  mysql-5.5.62-linux-glibc2.12-x86_64 mysql
sleep 1
cd /usr/local/mysql
sleep 1
sudo chown -R mysql:mysql *
sleep 1
sudo scripts/mysql_install_db --user=mysql
sleep 1
echo -e " \n "
sleep 1
sudo chown -R root .
sleep 1
sudo chown -R mysql data
sleep 1
sudo cp support-files/my-medium.cnf /etc/my.cnf
sleep 1
sudo bin/mysqld_safe --user=mysql &
sleep 2
echo -e " \n "
sleep 1
sudo cp support-files/mysql.server /etc/init.d/mysql.server
sleep 1
sudo bin/mysqladmin -u root password $MySQL2 
sleep 1
sleep 1
ln -s /usr/local/mysql/bin/* /usr/local/bin/
sleep 1
sudo /etc/init.d/mysql.server start
sleep 1
sudo /etc/init.d/mysql.server status
sleep 1

if [ -f "$file" ]
then
sed --in-place '/exit 0/d' /etc/rc.local 
echo "sleep 2" >> /etc/rc.local
echo "sudo /etc/init.d/mysql.server start" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
else 
echo "#!/bin/sh -e" >> /etc/rc.local
echo "#">> /etc/rc.local
echo "# rc.local">> /etc/rc.local
echo "#">> /etc/rc.local
echo "# This script is executed at the end of each multiuser runlevel." >> /etc/rc.local
echo "# value on error." >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# In order to enable or disable this script just change the execution" >> /etc/rc.local
echo "# bits." >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# By default this script does nothing." >> /etc/rc.local
echo -e " \n " >> /etc/rc.local
echo "sleep 2" >> /etc/rc.local
echo "sudo /etc/init.d/mysql.server start" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
sleep 1
chmod +x /etc/rc.local  
fi

if (whiptail --title "Restart." --yesno "Do you want to restart now ?" 8 78); then   
reboot
else
echo " "   	
fi  

fi

else

echo -e "${red} ???????????????????????????????????????????????? \e[0m"
echo -e "${red} ?[+]        The system is not supported        ? \e[0m"
echo -e "${red} ???????????????????????????????????????????????? \e[0m"
sleep 5
exit 3
echo " "

fi

exit 3

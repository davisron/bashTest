#!/bin/bash


mysql_user="root" 
mysql_password="root" 
mysql_host="feng" 
mysql_port="3306"
backup_db_arr=("mysql")
backup_location=/backup  
expire_backup_delete="ON" 
expire_days=3 

backup_time=`date +%Y%m%d%H%M`  
backup_Ymd=`date +%Y%m%d` 
backup_3ago=`date -d '3 days ago' +%Y%m%d` 
backup_dir=$backup_location/mysql/$backup_Ymd  
welcome_msg="Welcome to use MySQL backup tools!" 

mysql_ps=`ps -ef |grep mysql |wc -l`
mysql_listen=`netstat -an |grep LISTEN |grep $mysql_port|wc -l`
if [ [$mysql_ps == 0] -o [$mysql_listen == 0] ]; then
	echo "ERROR:MySQL is not running! backup stop!"
	exit
else
	echo $welcome_msg
fi

mysql -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password <<end
use mysql;
select host,user from user where user='root' and host='localhost';
exit
end

flag=`echo $?`
if [ $flag != "0" ]; then
	echo "ERROR:Can't connect mysql server! backup stop!"
	exit
else
	echo "MySQL connect ok! Please wait......"
	if [ "$backup_db_arr" != "" ];then
		#dbnames=$(cut -d ',' -f1-5 $backup_database)
		#echo "arr is (${backup_db_arr[@]})"
		for dbname in ${backup_db_arr[@]}
		do
               	        echo "database $dbname backup start..."
                	`mkdir -p $backup_dir`
                	`mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password $dbname > $backup_dir/$dbname$backup_time.sql`
                	flag=`echo $?`
                	if [ $flag == "0" ];then
                        	echo "database $dbname success backup to $backup_dir/$dbname$backup_time.sql"
                	else
                        	echo "database $dbname backup fail!"
                	fi
			
		done
	else
		echo "ERROR:No database to backup! backup stop"
		exit
	fi
	if [ "$expire_backup_delete" == "ON" -a  "$backup_location" != "" ];then
		`find $backup_location/mysql/ -type d -o -type f -ctime +$expire_days -exec rm -rf {} \;`
		 echo "Expired backup data delete complete!"
	fi
	echo "All database backup success! Think you!"
	exit
fi


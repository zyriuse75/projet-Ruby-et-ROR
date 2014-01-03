#!/bin/bash
DATE=`date +%y_%m_%d`
USER="USER"
PWD="PASSWORD"
DB_NAME="$1"
MDUMP="/usr/bin/mysqldump"
DBDUMP="-u$USER -p$PWD -q -e --single-transaction"
DROPDB="-u$USER -p$PWD -e "
MYSQBIN=$(which mysql)

 $MDUMP $DBDUMP $DB_NAME | bzip2 > /tmp/$DB_NAME.$DATE.sql.bz

RE=$?

  if [ "$RE" -eq 0 ];then
	echo "Copy Backup file on the backup server "
         scp /tmp/$DB_NAME.$DATE.sql.bz  backup01:/data/backup

 	 $MYSQBIN $DROPDB "drop database $DB_NAME;"
	 
  else
	echo "problem during the backup"
  fi

exit 0

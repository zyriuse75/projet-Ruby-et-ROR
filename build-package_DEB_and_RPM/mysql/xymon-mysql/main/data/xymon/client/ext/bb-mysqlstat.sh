#!/bin/sh

#
# BBPROG SHOULD JUST CONTAIN THE NAME OF THIS FILE
# USEFUL WHEN YOU GET ENVIRONMENT DUMPS TO LOCATE
# THE OFFENDING SCRIPT...
#
BBPROG=bb-mysqlstat.sh; export BBPROG

#
# TEST NAME: THIS WILL BECOME A COLUMN ON THE DISPLAY
# IT SHOULD BE AS SHORT AS POSSIBLE TO SAVE SPACE...
# NOTE YOU CAN ALSO CREATE A HELP FILE FOR YOUR TEST
# WHICH SHOULD BE PUT IN www/help/$TEST.html.  IT WILL
# BE LINKED INTO THE DISPLAY AUTOMATICALLY.
#
TEST="mysql"

#
# BBHOME CAN BE SET MANUALLY WHEN TESTING.
# OTHERWISE IT SHOULD BE SET FROM THE BB ENVIRONMENT
#

#if test "$BBHOME" = ""
#then
#	echo "BBHOME is not set... exiting"
#	exit 1
#fi

#if test ! "$BBTMP"                      # GET DEFINITIONS IF NEEDED
#then
#	echo "*** LOADING BBDEF ***"
#	. $BBHOME/etc/bbdef.sh          # INCLUDE STANDARD DEFINITIONS
#fi

#
# NOW COLLECT SOME DATA
# IN THIS CASE, IT'S THE CURRENT MEMORY USAGE OF THE SYSTEM

#
# GET CURRENT VALUES
#
MYSQLADMIN=`/usr/bin/mysqladmin --user=hobbit --password=Higfy! status`
MYSQL_UPTIME=`echo $MYSQLADMIN | $AWK '{ print $2; }'`
MYSQL_THREADS=`echo $MYSQLADMIN | $AWK '{ print $4; }'`
MYSQL_SLOWQ=`echo $MYSQLADMIN | $AWK '{ print $9; }'`
MYSQL_QPSFRAC=`echo $MYSQLADMIN | $AWK '{ print $22; }'`
MYSQL_QPS=${MYSQL_QPSFRAC%%.*}

$BBHOME/ext/mysqlreport.pl --user=hobbit --password=Higfy! > $BBTMP/myreport.txt
MYSQLREPORT=$(cat $BBTMP/myreport.txt)

#
# GET OLD VALUES
#
MYSQL_OLDUPTIME=`$CAT $BBTMP/$MACHINE.$TEST.mysqluptime.log`
MYSQL_OLDSLOWQ=`$CAT $BBTMP/$MACHINE.$TEST.mysqlslowq.log`

#
# WRITE OUR OWN VALUES TO LOG
#
echo $MYSQL_UPTIME > $BBTMP/$MACHINE.$TEST.mysqluptime.log
echo $MYSQL_SLOWQ > $BBTMP/$MACHINE.$TEST.mysqlslowq.log

#
# COMPUTE DIFFERENCES
#
MYSQL_DSLOWQ=$(($MYSQL_SLOWQ - $MYSQL_OLDSLOWQ))

COLOR="green"
STATUS="Mysql OK"

#
# HANDLE YELLOW CONDITIONS
#
if [ $MYSQL_UPTIME -le $MYSQL_OLDUPTIME ]
then
	COLOR="yellow"
	STATUS="Mysql Recently Restarted"
fi

if [ $MYSQL_THREADS -ge 80 ]
then
	COLOR="yellow"
	STATUS="Mysql high threads"
fi

if [ $MYSQL_DSLOWQ -ge 50 ]
then
	COLOR="yellow"
	STATUS="Mysql slow queries"
fi

#
# HANDLE RED CONDITIONS
#
if [ $MYSQL_THREADS -ge 150 ]
then
	COLOR="red"
	STATUS="Mysql very high threads"
fi

if [ $MYSQL_DSLOWQ -ge 100 ]
then
	COLOR="red"
	STATUS="Mysql very slow queries"
fi

###################################################################

#
# Send values to hobbit server
#
$BB $BBDISP "status $MACHINE.$TEST $COLOR `date` - $STATUS
$MYSQLADMIN

Detailed Report
----------------
$MYSQLREPORT"

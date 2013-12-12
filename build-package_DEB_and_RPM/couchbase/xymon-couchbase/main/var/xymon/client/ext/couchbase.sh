#!/bin/sh
#
# Ce script a pour but de monitorer couchbase.
#
# Par OMR janvier 2013
#
####################################################################
set -x 
# Variables
############
FS='

'
VALGREEN=80
VALRED=95
TEST="couchbase"
PORT="11210"
BO="$(hostname):$PORT"
HOBBITMP="/tmp/couchbase.tmp"
BUCKETRAMUSED=$(/usr/local/couchbase/bin/couchbase-cli bucket-list -c 127.0.0.1:8091 -u root -p 'rtpl1$couchbase' |egrep "ramUsed" |cut -d: -f2)
BUCKETRAMQUOTA=$(/usr/local/couchbase/bin/couchbase-cli bucket-list -c 127.0.0.1:8091 -u root -p 'rtpl1$couchbase' |egrep "ramQuota" |cut -d: -f2)
PERCENT=$(echo "scale=2;($BUCKETRAMUSED/$BUCKETRAMQUOTA) * 100" | bc )
NUMBER_POURCENT=$(printf %.0f "$PERCENT" 2>/dev/null ) #convert floating number to integer
RAMUSED="Ram Quota are used at $NUMBER_POURCENT %."

# For Hobbit
COLOR="green"
echo "&green no problem detected" > $HOBBITMP

RES=$(/usr/local/couchbase/bin/cbstats $BO all | egrep "cmd_set|cmd_get")

if [ $NUMBER_POURCENT -lt $VALGREEN ];then
    echo "&green no problem detected. Memory is used less than $VALGREEN%." > $HOBBITMP
  elif [ $NUMBER_POURCENT -ge $VALGREEN]; then
       COLOR="yellow"
     echo "&yellow More than $VALGREEN% of the Ram Quota are used Exactly there is $NUMBER_POURCENT %." > $HOBBITMP
  elif [ $NUMBER_POURCENT -ge $VALRED ]; then
       COLOR="red"
     echo "&red The ram is used greater than or equal to $VALRED % exactly at $NUMBER_POURCENT %. " > $HOBBITMP  
fi
echo >> $HOBBITMP
# FORMAT IT PROPERLY FOR Hobbit...
LINE="status $MACHINE.$TEST $COLOR `date`
$RES 
$RAMUSED
"

# SEND THE DATA 
$BB $BBDISP "$LINE"

#for multi graph
#$RRD $BB $SERVER "data $host.trends"

# At last, do some cleaning...
#rm $HOBBITMP

# End of script
################

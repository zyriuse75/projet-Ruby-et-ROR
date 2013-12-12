#! /bin/bash
#
# version 0.1
# script permettant de surveiller la bonne santé du cluster ElasticSearch
# La sonde se connecte sur chaque ibackend, afin de valider que le nombre de nodes se trouve = a la variable NODES.
# elle vérifie aussi l'etat des Backend
#
set -x
# Variables
############
IFS='

'
BO="NBBO"
NODES="NBNODES"
TEST="escluster"
HOBBITMP="/tmp/escluster.tmp"
ESGRAPH=$(curl -Xget bo0$BO:9200/_cluster/health?pretty=true 2> /dev/null |egrep "active_primary|active_shards|relocating|initializing_shards|unassigned_shards"  |sed s/\"//g |sed s/\,//g)

COLOR="green"
echo "&green no problem detected" > $HOBBITMP

for ((i=0; i<$NODES; i++)) do
  CURLNODES=$(curl -Xget bo0$BO:9200/_cluster/health 2> /dev/null | cut -d: -f5 | cut -d, -f1 |awk '{print $1}'| sed s/\"//g ) 
 if [ $CURLNODES != $NODES ];then
   COLOR="red"
  echo "&red $CURLNODES something s wrong" > $HOBBITMP
  exit 0 
 fi

   for (( i=0; i<$BO; i++)) do
	YCURL=$(curl -Xget bo0$BO:9200/_cluster/health 2> /dev/null | cut -d: -f3 | cut -d, -f1 |awk '{print $1}'| sed s/\"//g)
#        HEALTHCURL=$(curl -Xget bo0$BO:9200/_cluster/health?pretty=true )
     
       if [ "$YCURL" == "yellow" ];then
         COLOR="yellow"
           echo "$ESGRAPH &yellow Cluster in unstable state " > $HOBBITMP
      elif [ "$YCURL" == "red" ];then
         COLOR="red"
           echo "$ESGRAPH &yellow Cluster in unstable state " > $HOBBITMP
      fi
   done
done


echo >> $HOBBITMP
# FORMAT IT PROPERLY FOR Hobbit...
#LINE="status $HOSTNAME.$NAME $COLOR `date`"
LINE="status $MACHINE.$TEST $COLOR `date`
$ESGRAPH
"

# SEND THE DATA 
$BB $BBDISP "$LINE"

# At last, do some cleaning...
#rm $HOBBITMP

# End of script
################

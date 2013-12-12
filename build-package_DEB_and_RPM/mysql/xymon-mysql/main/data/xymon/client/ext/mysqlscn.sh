#!/bin/sh
#
# Ce script a pour but de monitorer la composition des QUESTIONS de MySQL.
# Nous allons nous servir de l'outil genialissime 'mysqlreport' dispo a 
# cette adresse avec d'autres explications et outils indispensables.
#
# http://hackmysql.com/mysqlreport
#
# Le fichier ainsi genere sera repris par Hobbit pour les graphes.
#
# Par TS (Oct. 2008)
#
####################################################################

# Variables
############
HOBBITMP="$BBHOME/tmp/mysqlscn.tmp"

# This report needs to be made by 'mysqlreport.pl'
MYREPTMP="$BBHOME/tmp/myreport.txt"
MYREPSCN="$BBHOME/tmp/myreport.txt.scn"

# For Hobbit
TEST="myscn"
COLOR="green"

####################################################################

# Main script
#############

cp $MYREPTMP $MYREPSCN

SCAN=$(cat $MYREPSCN | grep -A5 "and Sort" | grep Scan | awk '{print $NF}')
RANGE=$(cat $MYREPSCN | grep -A5 "and Sort" | grep Range | grep -v check | awk '{print $NF}')
FJOIN=$(cat $MYREPSCN | grep -A5 "and Sort" | grep "Full join" | awk '{print $NF}')
RGCHK=$(cat $MYREPSCN | grep -A5 "and Sort" | grep "Range check" | awk '{print $NF}')
FRGJN=$(cat $MYREPSCN | grep -A5 "and Sort" | grep rng | awk '{print $NF}')

# Print results into file
#########################
cat >$HOBBITMP<< EOF
scan: $SCAN
range: $RANGE
fulljoin: $FJOIN
rangecheck: $RGCHK
fullrngjoin: $FRGJN
EOF

# FORMAT IT PROPERLY FOR Hobbit...
LINE="status $MACHINE.$TEST $COLOR `date`
`cat $HOBBITMP`
"

# SEND THE DATA 
$BB $BBDISP "$LINE"

# At last, do some cleaning...
rm $HOBBITMP $MYREPSCN

# End of script
#################

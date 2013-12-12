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
HOBBITMP="$BBHOME/tmp/mysqlqueries.tmp"

# This report needs to be made by 'mysqlreport.pl'
MYREPTMP="$BBHOME/tmp/myreport.txt"
MYREPQRY="$BBHOME/tmp/myreport.txt.qry"

# For Hobbit
TEST="myqry"
COLOR="green"

####################################################################

# Main script
#############

cp $MYREPTMP $MYREPQRY

QCHITS=$(cat $MYREPQRY | grep -A7 Questions | grep QC | awk '{print $NF}')
DMSPCT=$(cat $MYREPQRY | grep -A7 Questions | grep DMS | sed '1q;d' | awk '{print $NF}')
COMPCT=$(cat $MYREPQRY | grep -A7 Questions | grep Com | awk '{print $NF}')
COMQPCT=$(cat $MYREPQRY | grep -A7 Questions | grep COM | awk '{print $NF}')
UNKPCT=$(cat $MYREPQRY | grep -A7 Questions | grep Unknown | awk '{print $NF}')
SLWPCT=$(cat $MYREPQRY | grep -A7 Questions | grep Slow | awk '{print $6}')

# Print results into file
#########################
cat >$HOBBITMP<< EOF
querycachehits: $QCHITS
dmsqueries: $DMSPCT
comqueries: $COMPCT
comquit: $COMQPCT
unknown: $UNKPCT
slowqueries: $SLWPCT
EOF

# FORMAT IT PROPERLY FOR Hobbit...
LINE="status $MACHINE.$TEST $COLOR `date`
`cat $HOBBITMP`
"

# SEND THE DATA 
$BB $BBDISP "$LINE"

# At last, do some cleaning...
rm $HOBBITMP $MYREPQRY

# End of script
#################

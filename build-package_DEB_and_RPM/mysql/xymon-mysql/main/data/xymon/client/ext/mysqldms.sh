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
HOBBITMP="$BBHOME/tmp/mysqldms.tmp"

# This report needs to be made by 'mysqlreport.pl'
MYREPTMP="$BBHOME/tmp/myreport.txt"
MYREPDMS="$BBHOME/tmp/myreport.txt.dms"

# For Hobbit
TEST="mydms"
COLOR="green"

####################################################################

# Main script
#############

cp $MYREPTMP $MYREPDMS

SELECT=$(cat $MYREPDMS | grep -A5 ^DMS | grep SELECT | awk '{print $NF}')
UPDATE=$(cat $MYREPDMS | grep -A5 ^DMS | grep UPDATE | awk '{print $NF}')
DELETE=$(cat $MYREPDMS | grep -A5 ^DMS | grep DELETE | awk '{print $NF}')
INSERT=$(cat $MYREPDMS | grep -A5 ^DMS | grep INSERT | awk '{print $NF}')
REPLACE=$(cat $MYREPDMS | grep -A5 ^DMS | grep REPLACE | awk '{print $NF}')

# Print results into file
#########################
cat >$HOBBITMP<< EOF
select: $SELECT
update: $UPDATE
delete: $DELETE
insert: $INSERT
replace: $REPLACE
EOF

# FORMAT IT PROPERLY FOR Hobbit...
LINE="status $MACHINE.$TEST $COLOR `date`
`cat $HOBBITMP`
"

# SEND THE DATA 
$BB $BBDISP "$LINE"

# At last, do some cleaning...
rm $HOBBITMP $MYREPDMS

# End of script
#################

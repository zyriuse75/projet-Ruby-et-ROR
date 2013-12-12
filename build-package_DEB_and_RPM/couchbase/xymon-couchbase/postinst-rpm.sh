#!/bin/sh

INCLUDE="/var/xymon/client/etc/include.cfg"
PACKAGE="couchbase"
FILE="/var/xymon/client/etc/conf.d/$PACKAGE.cfg"

if [ -f $INCLUDE ]; then
        line=$(grep "$PACKAGE.cfg" $INCLUDE)

        if [ -z "$line" ]; then
                echo "include $FILE" >> $INCLUDE
        fi
else
        echo "include $FILE" >> $INCLUDE
fi

/etc/init.d/xymon start



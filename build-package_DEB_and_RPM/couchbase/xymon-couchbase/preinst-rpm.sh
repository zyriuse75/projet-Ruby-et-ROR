#!/bin/sh
if [ -f /var/xymon/client/logs/clientlaunch.$(hostname).pid ]; then
  /etc/init.d/xymon stop
fi

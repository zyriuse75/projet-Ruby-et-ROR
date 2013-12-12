#!/bin/sh
if [ -x /etc/init.d/elasticsearch ]; then
  curl -Xdelete http://127.0.0.1:9200/_flush
  /etc/init.d/elasticsearch stop
fi


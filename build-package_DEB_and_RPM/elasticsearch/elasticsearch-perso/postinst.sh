#!/bin/sh
if [ ! -f /etc/init.d/elasticsearch ]; then
  ln -s /usr/local/conf/elasticsearch/bin/service/elasticsearch /etc/init.d/elasticsearch
fi
/etc/init.d/elasticsearch start

echo "You now need to reindex your instance"

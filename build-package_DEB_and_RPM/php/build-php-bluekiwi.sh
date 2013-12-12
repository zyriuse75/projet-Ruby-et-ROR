#!/bin/sh
# blueKiwi debian package builder
# author: FDV <fdv@bluekiwi-software.com>
# Package: 
### 

###
# Variables
############

PACKAGE="php-custom"
VERSION="5.4.3-$(date +%Y%m%d%H%M)"
DESC=" PHP stack custom "
AUTHOR='Olivier Morel'
PLATFORM=$1 # should be main, dev, qualif, prod or vm
DEPS="-d libapache2-mod-php5 (>= 5.4.3), php5-apc (>= 5.4.3), php5-cli (>= 5.4.3), php5-common (>= 5.4.3), php5-curl (>= 5.4.3), php5-gd (>= 5.4.3), php5-ldap (>= 5.4.3), php5-memcache (>= 5.4.3), php5-mysql (>= 5.4.3), php5-xmlrpc (>= 5.4.3), php5-xsl (>= 5.4.3) "

###
# You probably don't need to change these ones
###############################################
BUILDDIR="/data/builds"
INSTALLDIR="$BUILDDIR/$PACKAGE/$PLATFORM"

###################################################################
# DO NOT CHANGE ANYTHING PASSED THIS LINE OR THOU SHALL REGRET IT #
###################################################################

if [ ! -d $INSTALLDIR ]; then
  echo "Package $PACKAGE for $PLATFORM missing in $BUILDDIR"
  exit 1
fi

fpm -s dir -t deb -n $PACKAGE -v $VERSION -C $INSTALLDIR -a x86_64 \
  -S $VERSION -p "$PACKAGE-$VERSION"_x86_64.deb \
  -m "$AUTHOR" \
  --description "$DESC" \
  --pre-install $BUILDDIR/$PACKAGE/preinst.sh \
  --post-install $BUILDDIR/$PACKAGE/postinst.sh \
  "$DEPS"
  .

scp "$PACKAGE-$VERSION"_x86_64.deb IP-SRV-DEBIAN:/data/debian/debian/dists/$PLATFORM/binary-amd64
ssh IP-SRV-DEBIAN "/root/scripts/refresh-debian.sh"


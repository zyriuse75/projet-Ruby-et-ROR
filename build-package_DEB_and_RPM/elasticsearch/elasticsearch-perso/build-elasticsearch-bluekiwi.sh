#!/bin/sh
# blueKiwi debian package builder
# author: FDV <fdv@bluekiwi-software.com>
# Package: 
### 

###
# Variables
############

PACKAGE="elasticsearch-perso"
VERSION="0.19.9"
DESC="Elasticseach core package"
AUTHOR='olivier morel'
#PLATFORM=$1 # should be main, dev, qualif, prod or vm
PLATFORM="main"
DEPS="-d sun-java6-jre (>= 6.26)"

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

scp "$PACKAGE-$VERSION"_x86_64.deb IP-SRV:/data/debian/debian/dists/debian/$PLATFORM/binary-amd64
ssh IP-SRV "/root/scripts/refresh-debian.sh"


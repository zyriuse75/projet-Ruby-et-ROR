#!/bin/sh
# debian package builder
# Package:  bk-xymon-beanstalk
### 

###
# Variables
############

PACKAGE="xymon-couchbase"
VERSION="1.0"
DESC="Xymon couchbase package"
AUTHOR='Olivier Morel'
#PLATFORM=$1 # should be main, dev, qualif, prod or vm
PLATFORM="main"
#DEPS="-d "

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

### RPM Package
fpm -s dir -t rpm -n $PACKAGE -v $VERSION -C $INSTALLDIR -a x86_64 \
  -S $VERSION -p "$PACKAGE-$VERSION"_x86_64.rpm \
  -m "$AUTHOR" \
  --description "$DESC" \
  --pre-install $BUILDDIR/$PACKAGE/preinst-rpm.sh \
  --post-install $BUILDDIR/$PACKAGE/postinst-rpm.sh \
#  -d "" \
  .



scp "$PACKAGE-$VERSION"_x86_64.deb IP-SRV:/data/debian/debian/dists/$PLATFORM/binary-amd64
ssh IP-SRV "/root/scripts/refresh-debian.sh"

scp "$PACKAGE-$VERSION"_x86_64.deb IP-SRV:/data/depot/centos/dists/$PLATFORM/binary-amd64
ssh IP-SRV "/root/scripts/refresh-debian.sh"


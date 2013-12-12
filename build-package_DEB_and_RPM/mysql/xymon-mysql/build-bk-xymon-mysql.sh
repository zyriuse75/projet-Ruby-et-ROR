#!/bin/sh
# blueKiwi debian package builder
# author: FDV <fdv@bluekiwi-software.com>
# Package: 
### 

###
# Variables
############
FILE=PackageVersion
PACKAGE="xymon-mysql"
VERSION=$(cat PackageVersion)
DESC="Xymon MySQL package"
AUTHOR='Olivier Morel '
#PLATFORM=$1 # should be main, dev, qualif, prod or vm
PLATFORM="main"

###
# You probably don't need to change these ones
###############################################
BUILDDIR="/data/builds/xymon-mysql-RPM-DEB"
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
  --pre-install $BUILDDIR/$PACKAGE/preinst-deb.sh \
  --post-install $BUILDDIR/$PACKAGE/postinst-deb.sh \
  -d "bk-xymon-core (>= 1.1)" \
  .

### RPM Package
fpm -s dir -t rpm -n $PACKAGE -v $VERSION -C $INSTALLDIR -a x86_64 \
  -S $VERSION -p "$PACKAGE-$VERSION"_x86_64.rpm \
  -m "$AUTHOR" \
  --description "$DESC" \
  --pre-install $BUILDDIR/$PACKAGE/preinst-rpm.sh \
  --post-install $BUILDDIR/$PACKAGE/postinst-rpm.sh \
 -d "bk-xymon-core > 1" \
  .

echo $VERSION | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}' > "$FILE"




scp "$PACKAGE-$VERSION"_x86_64.deb IP-SRV-DEB:/data/debian/debian/dists/$PLATFORM/binary-amd64
ssh IP-SRV-DEB "/root/scripts/refresh-debian.sh"

scp "$PACKAGE-$VERSION"_x86_64.rpm IP-SRV-CENTOS:/data/rpm/CentOS/5/updates/x86_64/RPMS
ssh IP-SRV-CENTOS "/root/scripts/refresh-debian.sh"


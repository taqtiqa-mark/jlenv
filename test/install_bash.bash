#!/bin/bash
set -o errexit          # Exit on most errors (see the manual)
# set -o errtrace         # Make sure any error trap is inherited
# set -o nounset          # Disallow expansion of unset variables
# set -o pipefail         # Use last non-zero exit code in a pipeline
set -o xtrace          # Trace the execution of the script (debug)

if [ -z $INSTALL_BASH_VERSION ]; then
    echo "No \$INSTALL_BASH_VERSION, using default Bash"
    exit
fi

set -u

echo "Installing bash $INSTALL_BASH_VERSION..."

mkdir -p bash
cd bash
wget -N https://ftpmirror.gnu.org/bash/bash-$INSTALL_BASH_VERSION.tar.gz
tar xvf bash-$INSTALL_BASH_VERSION.tar.gz
pushd bash-$INSTALL_BASH_VERSION

patches="../bash-$INSTALL_BASH_VERSION-patches/bash$(echo $INSTALL_BASH_VERSION | tr -d .)-???"
for patch in $(find .. -wholename "$patches" | sort); do
    echo "Applying $patch"
    patch -f -p0 <$patch
done

./configure --exec-prefix /
make
sudo make install

popd
rm -rf bash-$INSTALL_BASH_VERSION

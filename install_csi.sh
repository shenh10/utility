sudo apt-get install -y gcc make linux-headers-$(uname -r) git-core
sudo apt-get install -y iw
# build and install modified wireless driver

CSITOOL_KERNEL_TAG=csitool-$(uname -r | cut -d . -f 1-2)
git clone https://github.com/dhalperi/linux-80211n-csitool.git
cd linux-80211n-csitool
git checkout ${CSITOOL_KERNEL_TAG}
UBUNTU_KERNEL_TAG=$1
# Modify the line above with your Ubuntu kernel tag. First, determine your full kernel
# version by reading /proc/version_signature; then, look up the Ubuntu kernel tag at:
# http://people.canonical.com/~kernel/info/kernel-version-map.html

. /etc/lsb-release
git remote add ubuntu git://kernel.ubuntu.com/ubuntu/ubuntu-${DISTRIB_CODENAME}.git
git pull --no-edit ubuntu ${UBUNTU_KERNEL_TAG}
make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi modules
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi INSTALL_MOD_DIR=updates \
    modules_install
sudo depmod
cd ..

# install modified firmware
git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git
for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done
sudo cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/
sudo ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode

# build userspace logging tool
make -C linux-80211n-csitool-supplementary/netlink


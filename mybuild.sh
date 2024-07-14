#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

CONFLINE="MACHINE = \"raspberrypi5\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"

cat <<EOT >> conf/local.conf
MACHINE ??= "raspberrypi5"
LICENSE_FLAGS_ACCEPTED = "synaptics-killswitch"
MACHINE_FEATURES:append= " vc4graphics "
DISTRO_FEATURES:append = " directfb directfb-examples kmsdrm opengl gles2 drm-gl alsa"
CORE_IMAGE_EXTRA_INSTALL += "glmark2 kmscube "
IMAGE_INSTALL:append = " strace packagegroup-core-buildessential libgl-mesa-dev libsdl2-dev libsdl2-image-dev "
EOT
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi


#bitbake-layers show-layers | grep "meta-aesd" > /dev/null
#layer_info=$?

#if [ $layer_info -ne 0 ];then
#	echo "Adding meta-aesd layer"
#	bitbake-layers add-layer ../meta-aesd
#else
#	echo "meta-aesd layer already exists"
#fi

bitbake-layers add-layer ../meta-raspberrypi
bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-aesd 
bitbake-layers show-layers

set -e
bitbake core-image-aesd

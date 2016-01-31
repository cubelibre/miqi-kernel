#!/bin/bash

LINUX_KERNEL_DIR=${PWD}
LINUX_HWPACK_OUT=$LINUX_KERNEL_DIR/output

make rockchip_defconfig
make -j4 rk3288-box.img
make -j4 modules

if [ -d ${LINUX_HWPACK_OUT} ]; then
    rm -rf ${LINUX_HWPACK_OUT}
fi

mkdir ${LINUX_HWPACK_OUT}
make INSTALL_MOD_PATH=${LINUX_HWPACK_OUT} modules_install
make INSTALL_FW_PATH=${LINUX_HWPACK_OUT}/lib/firmware firmware_install

KERNEL_VER=`make kernelrelease`
(
  cd ${LINUX_HWPACK_OUT}/lib/modules/${KERNEL_VER}
  rm build source
  ln -s ../../src/linux-rockchip build
  ln -s ../../src/linux-rockchip source
)

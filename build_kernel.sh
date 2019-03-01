#!/bin/bash

############################
#                          #
# Build script for         #
# Flashpoint Kernel        #
#                          #
############################


### Clean Up #####

rm AnyKernel2/dtb
rm AnyKernel2/zImage
rm -rf output/
make clean && make mrproper


### Build Kernel ####

export ARCH=arm
export CROSS_COMPILE=$(pwd)/arm-eabi-5.3/bin/arm-eabi-
mkdir output

make -C $(pwd) O=output VARIANT_DEFCONFIG=apq8084_sec_trlte_vzw_defconfig apq8084_sec_defconfig SELINUX_DEFCONFIG=selinux_defconfig
make -C $(pwd) O=output

cp output/arch/arm/boot/zImage $(pwd)/AnyKernel2/zImage
./tools/dtbTool -o ./AnyKernel2/dtb -s 4096 -p ./output/scripts/dtc/ ./output/arch/arm/boot/dts/
for i in $(find "output" -name '*.ko'); do
	cp -av "$i" ./AnyKernel2/modules/system/lib/modules/;
done;

### Build Zip ###

cd AnyKernel2;
	zip -r9 Flashpoint.v5.zip * -x .git README.md *placeholder *.zip


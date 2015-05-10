#!/bin/bash
TOOLCHAIN="/home/nando/dev/toolchains/uber49/bin"
JOBS="-j$(grep -c ^processor /proc/cpuinfo)"
echo "Cleaning old files"
make clean && make mrproper
echo "Making kernel"
DATE_START=$(date +"%s")
export ARCH=arm
export SUBARCH=arm
make CROSS_COMPILE=$TOOLCHAIN/arm-eabi- e9wifi_defconfig
make CROSS_COMPILE=$TOOLCHAIN/arm-eabi- $JOBS
echo "End of compiling kernel!"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."


echo "Making dt.img"
#./dtbToolCM -2 -o /home/nando/dev/padtemp/dt.img -s 2048 -p /home/nando/dev/kernel_v700/scripts/dtc/ /home/nando/dev/kernel_v700/arch/arm/boot/
# mkbootimg --kernel /home/nando/dev/kernel_v700/arch/arm/boot/zImage --ramdisk temp/boot.img-ramdisk.gz --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 msm_rtb.filter=0x37 androidboot.hardware=e9wifi ignore_loglevel" --pagesize 2048 --base 0x00000000 --ramdisk_offset 0x01000000 --tags_offset 0x01e00000 --dt /path/to/your/dt.img -o boot.img


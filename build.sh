#!/bin/bash
TOOLCHAIN="/home/nando/dev/toolchains/uber49/bin"
JOBS="-j$(grep -c ^processor /proc/cpuinfo)"
IMAGENAME="boot-"$1

read -p "Compile (y/n/s/n)? : " dchoice
	case "$dchoice" in
		y|Y|s|S)

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

	esac


read -p "Build boot.img (y/n/s/n)? : " dchoice
	case "$dchoice" in
		y|Y|s|S)

		echo "Making dt.img"
		./dtbToolCM -2 -o /home/nando/dev/padtemp/dt.img -s 2048 -p /home/nando/dev/kernel_v700/scripts/dtc/ /home/nando/dev/kernel_v700/arch/arm/boot/
		rm /home/nando/dev/padtemp/temp/boot.img-zImage
		cp /home/nando/dev/kernel_v700/arch/arm/boot/zImage /home/nando/dev/padtemp/temp/boot.img-zImage
		cd /home/nando/dev/padtemp
		./mkbootimg --kernel /home/nando/dev/kernel_v700/arch/arm/boot/zImage --ramdisk temp/boot.img-ramdisk.gz --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 msm_rtb.filter=0x37 androidboot.hardware=e9wifi ignore_loglevel" --pagesize 2048 --base 0x00000000 --ramdisk_offset 0x01000000 --tags_offset 0x01e00000 --dt /home/nando/dev/padtemp/dt.img -o boot.img --output /home/nando/dev/OUT/$IMAGENAME.img
		/home/nando/dev/padtemp/open_bump.py /home/nando/dev/OUT/$IMAGENAME.img
		cd /home/nando/dev/kernel_v700

			exit 0;;
		n|N )
			exit 0;;
		* )
			echo "Invalid...";;
	esac

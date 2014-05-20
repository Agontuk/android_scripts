#!/bin/bash

echo "********************************"
echo "*                              *"
echo "*      Recovery Installer      *"
echo "*         By Agontuk           *"
echo "*                              *"
echo "********************************"

echo "1) Pushing necessary tools...."
echo ""

adb kill-server
adb start-server
adb wait-for-device
adb remount
adb push image_tools/ /system/bin/
adb push new_recovery.sh /data/local/
adb push boot.img /data/local/tmp/
adb push initrd.gz /data/local/tmp/
echo ""

echo "2) Fixing permission...."
echo ""
adb shell chmod 755 /data/local/new_recovery.sh
adb shell chmod 755 /system/bin/kernel_make
adb shell chmod 755 /system/bin/kernel_dump
adb shell chmod 755 /system/bin/mkbootfs

echo "3) Running new_recovery.sh...."
echo ""
adb shell /data/local/new_recovery.sh

echo "4) Copying new boot.img to current directory...."
echo ""
adb pull /data/local/tmp/boot/boot.img ./new_boot.img
echo ""

echo "5) Cleaning up...."
echo ""
adb shell rm -rf /data/local/new_recovery.sh
adb shell rm -rf /data/local/tmp/boot.img
adb shell rm -rf /data/local/tmp/initrd/
adb shell rm -rf /data/local/tmp/stock_ramdisk/

sleep 2

echo "********************************"
echo "*                              *"
echo "*     New boot.img created     *"
echo "*           Enjoy :)           *"
echo "*                              *"
echo "********************************"

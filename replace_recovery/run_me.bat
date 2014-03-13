@echo off
echo ****************************************
echo *                                      *
echo *          Recovery Installer          *
echo *             By NoobCoder             *
echo *                                      *
echo ****************************************
echo.
echo Pushing necessary tools....
echo.
adb kill-server
adb start-server
adb wait-for-device
adb remount
adb push image_tools /system/bin/
adb push new_recovery.sh /data/local/
adb push boot.img /data/local/tmp/
adb push initrd.gz /data/local/tmp/
echo Fixing permission....
echo.
adb shell chmod 755 /data/local/new_recovery.sh
adb shell chmod 755 /system/bin/kernel_make
adb shell chmod 755 /system/bin/kernel_dump
adb shell chmod 755 /system/bin/mkbootfs
echo Running new_recovery.sh....
echo.

adb shell /data/local/new_recovery.sh
echo Copying new boot.img to current directory....
echo.
adb pull /data/local/tmp/boot/boot.img ./new_boot.img
echo Cleaning up....
echo.
adb shell rm -rf /data/local/new_recovery.sh
adb shell rm -rf /data/local/tmp/boot/
adb shell rm -rf /data/local/tmp/boot.img
adb shell rm -rf /data/local/tmp/initrd/
adb shell rm -rf /data/local/tmp/stock_ramdisk/
ping 1.1.1.1 -n 1 -w 2000 > nul
echo ****************************************
echo *                                      *
echo *         New boot.img created         *
echo *               Enjoy :)               *
echo *                                      *
echo ****************************************

#!/sbin/sh

{
cd /data/local/tmp
mkdir -p boot/ramdisk
mkdir initrd
mkdir stock_ramdisk

# extract kernel & ramdisk
kernel_dump boot boot.img

cd boot/ramdisk

# extract ramdisks
gunzip < ../initrd.gz | cpio -id
cd ../../initrd
gunzip < ../initrd.gz | cpio -id
cd ../stock_ramdisk
gunzip < ../initrd/sbin/ramdisk.gz | cpio -id

# replace all ramdisk files with boot.img's ramdisk files
#cp -R ../boot/ramdisk/* ./
find / -maxdepth 1 -type f -exec cp {} ./ \;
rm ./sbin/recovery_ramdisk.gz
rm ./sbin/bootrec
cd ../

# repack the ramdisks
mkbootfs ./stock_ramdisk | gzip > ramdisk.gz
mv ramdisk.gz ./initrd/sbin/
mkbootfs ./initrd | gzip > initrd.gz
mv initrd.gz ./boot/
cd boot

# make the new boot.img
kernel_make zImage initrd.gz cmdline boot.img
} &> /dev/null


#!/sbin/sh

{
cd /data/local/tmp
mkdir -p boot/ramdisk
mkdir initrd
mkdir stock_ramdisk

# extract kernel & ramdisk
kernel_dump boot boot.img

cd boot/ramdisk

# extract boot.img ramdisk
gunzip < ../initrd.gz | cpio -uid
cd ../../initrd
# extract my ramdisk
gunzip < ../initrd.gz | cpio -uid
cd ../stock_ramdisk
gunzip < ../initrd/sbin/ramdisk.gz | cpio -uid

# replace all ramdisk files with boot.img's ramdisk files
find ../boot/ramdisk -maxdepth 1 -type f -exec cp {} ./ \;
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


#!/system/bin/sh

#
# system/app odex-er by Paul O'Brien @ www.MoDaCo.com
#
# modded for HTC Desire by Klutsh @ www.klutsh.com
#
# experimental - nandroid backup before you run this script!
#
# version 0.1, 24th July 2010

cd /sdcard/app

for filename in `find . -name '*.apk'`
do

	# copy each odexd file to /system/app/
	if [ -f `echo $filename | sed 's/\(.*\.\)apk/\1odex/'` ]
	then
		#rm /system/app/$filename
		#rm /system/app/`echo $filename | sed 's/\(.*\.\)apk/\1odex/'`
		#mv $filename /system/app/
		#mv `echo $filename | sed 's/\(.*\.\)apk/\1odex/'` /system/app/
	fi

done;

#rm -r /sdcard/app

# clear dalvik-cache
#rm -r /data/dalvik-cache/*
#rm -r /cache/dalvik-cache/*

# reboot to recovery
echo Now reboot phone


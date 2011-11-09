#!/system/bin/sh

#
# system/app odex-er by Paul O'Brien @ www.MoDaCo.com
#
# modded for HTC Desire by Klutsh @ www.klutsh.com
#
# experimental - nandroid backup before you run this script!
#
# version 0.1, 24th July 2010

# set permissions
chmod 4755 /data/odex/dexopt-wrapper
chmod 4755 /data/odex/zip
chmod 4755 /data/odex/zipalign
chmod 4755 /data/odex/appupdate.sh

mkdir /sdcard/odexed
mkdir /sdcard/odexed/app
mkdir /sdcard/odexed/framework

cd /      #Checkpoint
cd /system/framework



for filename in `find . -name '*.apk'`
do

	# copy each none odexd file to sd card
	if [ ! -f `echo $filename | sed 's/\(.*\.\)apk/\1odex/'` ]
	then
		echo "At file: $filename. Copying to /sdcard/odexed/framework/$filename..."
		cp $filename /sdcard/odexed/framework/
	fi

done;

# change to system/app and process each apk!
cd /sdcard/odexed/framework
echo

for filename in `find . -name '*.apk'`
do

	# step 1 - odex the apk
	echo "Odexing $filename..."
	/data/odex/dexopt-wrapper $filename `echo $filename | sed 's/\(.*\.\)apk/\1odex/'`

	# step 2 - did we succesfully odex?
	if [ -f `echo $filename | sed 's/\(.*\.\)apk/\1odex/'` ]
	then
		echo "Finishing steps odexing $filename"
		echo "		Removing Classes.dex..."
		# step 3 - remove the classes.dex from the apk
		/data/odex/zip -d $filename classes.dex
		
		echo "		Zipaligning..."
		# step 4 - zipalign, just in case
		/data/odex/zipalign -f -v 4 $filename $filename.new
		mv $filename.new $filename
	fi

done;

# clear dalvik cache
#rm -r /data/dalvik-cache/*
#rm -r /cache/dalvik-cache/*

# reboot to recovery
#echo rebooting to recovery
#reboot recovery
echo "/system/framework is now odexed!"
touch /sdcard/fr.odexed
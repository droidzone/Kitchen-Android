#!/system/bin/sh
#Contributors to code: Drodizone/Klutsh/PaulOBrien
#Revised on Nov 9,2011 - Droidzone

# Modified by Droidzone - Added framework odexing, and safe odexing for Rom devs
# Can work in both recovery and while booted (if S-off)
#Ensure mounted in recovery
if [ ! -d /system ]; then mount /system; fi;
if [ ! -d /sdcard ]; then mount /sdcard; fi;
if [ ! -d /sdcard/odexed ]; then mkdir /sdcard/odexed; fi;
if [ ! -d /sdcard/odexed/app ]; then mkdir /sdcard/odexed/app; fi;

#Set exec permisions
chmod 4755 /data/odex/dexopt-wrapper
chmod 4755 /data/odex/zip
chmod 4755 /data/odex/zipalign
chmod 4755 /data/odex/appupdate.sh

cd /system/app

echo "Starting Odex process"
echo
echo "Copying /system/app/*"

for filename in `find . -name '*.apk'`
do

	# copy each none odexd file to sd card
	if [ ! -f `echo $filename | sed 's/\(.*\.\)apk/\1odex/'` ]
	then
		echo "At file: $filename. Copying to /sdcard/odexed/app/$filename..."
		cp $filename /sdcard/odexed/app/
	fi

done;

# change to system/app and process each apk!
cd /sdcard/odexed/app
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

echo "It is done!"
touch /sdcard/apps.odexed


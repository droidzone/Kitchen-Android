#!/system/bin/sh
#Contributors to code: Drodizone/Klutsh/PaulOBrien
#Revised on Nov 9,2011 - Droidzone

# Modified by Droidzone - Added framework odexing, and safe odexing for Rom devs
# Can work in both recovery and while booted (if S-off)
#Ensure mounted in recovery

if [ -d /sdcard/odexed ]
then 
  if [ -d /sdcard/odexed/app ]
    cd /sdcard/odexed/app
    rm -rf /sdcard/odexed/app/*
    cd ..
    rmdir /sdcard/odexed/app
  fi
  
  if [ -d /sdcard/odexed/framework ]
    cd /sdcard/odexed/framework
    rm -rf /sdcard/odexed/framework/*
    cd ..
    rmdir /sdcard/odexed/framework
  fi

  echo "Made targets clean!"
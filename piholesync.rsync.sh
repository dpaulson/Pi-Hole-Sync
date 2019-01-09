#!/bin/bash

# Version 0.1

#Direct output to piholesync.log
exec >  >(tee -ia piholesync.log)
exec 2> >(tee -ia piholesync.log >&2)

#Check if file was passed as a parameter
if [ -z "$1" ]; then
  echo "Error: No file supplied, cannot sync!"
else
#VARS
PIHOLEDIR=/etc/pihole #working dir of pihole
PIHOLE2=192.168.1.38 #IP of 2nd PiHole
HAUSER=pi #user of second pihole
FILE=$1

echo "Syncing: $FILE to $PIHOLE2"
if [[ -f $FILE ]]; then
  RSYNC_COMMAND="rsync -aiu $FILE $HAUSER@$PIHOLE2:$PIHOLEDIR"
  if [[ -n "${RSYNC_COMMAND}" ]]; then
    echo "$FILE synced successfully to $PIHOLE2"
    if [[ $FILE == "$PIHOLEDIR/adlists.list" ]]; then
	  # rsync copied adlists.list, update GRAVITY
	  echo "Was adlist.list, updating Gravity on $PIHOLE2"
	  ssh $HAUSER@$PIHOLE2 "sudo -S pihole -g"
	  echo "Gravity update command sent to $PIHOLE2"
    else
	  # rsync copied a different file, restart service
	  echo "Was NOT adlist.list, restarting FTL on $PIHOLE2"
	  echo "Sending stop FTL command to $PIHOLE2"
	  ssh $HAUSER@$PIHOLE2 "sudo -S service pihole-FTL stop"
	  echo "Sending kill FTL to $PIHOLE2"
	  ssh $HAUSER@$PIHOLE2 "sudo -S pkill pihole-FTL"
	  echo "Sending start FTL command to $PIHOLE2"
	  ssh $HAUSER@$PIHOLE2 "sudo -S service pihole-FTL start"
	  echo "FTL restart commands all sent to $PIHOLE2"
    fi
	echo "Done Syncing with $PIHOLE2"
  else
    echo "Error: Failed to sync $FILE to $PIHOLE2"
  fi
else
  echo "Error: Problem with $FILE"
fi
fi
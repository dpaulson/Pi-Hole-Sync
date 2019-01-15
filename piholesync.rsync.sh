#!/bin/bash

#Version 0.8

#README: refer to README.md
#https://raw.githubusercontent.com/dpaulson/Pi-Hole-Sync/master/README.md

#Touch log file first to verify existance
touch piholesync.log

#Direct output to piholesync.log
exec >  >(tee -ia piholesync.log)
exec 2> >(tee -ia piholesync.log >&2)

#Check if file was passed as a parameter
if [ -z "$1" ]; then
	echo "Error: No file supplied, cannot sync!"
else

	#VARS
	PIHOLEDIR=/etc/pihole #working dir of SECONDARY Pi-Hole
	PIHOLE2=192.168.1.38 #IP of 2nd Pi-Hole
	HAUSER=pi #user of second Pi-Hole
	FILE=$1

	echo "Syncing: $FILE to $PIHOLE2"
	if [[ -f $FILE ]]; then
		echo "Executing rsync"
		OPTIONS="-aiu"
		rsync "$OPTIONS" "$FILE" "$HAUSER@$PIHOLE2:$PIHOLEDIR"
		if [[ $FILE == "$PIHOLEDIR/adlists.list" ]]; then
			# rsync copied adlists.list, update GRAVITY
			echo "Was adlist.list, updating Gravity on $PIHOLE2"
			COMMAND="sudo -S pihole -g"
			echo "Executing: ssh $HAUSER@$PIHOLE2 $COMMAND"
			ssh "$HAUSER@$PIHOLE2" "$COMMAND"
			echo "Gravity Update sent to $PIHOLE2"
		else
			# rsync copied a different file, restart service
			echo "Was NOT adlist.list, restarting FTL on $PIHOLE2"
			COMMAND="sudo -S service pihole-FTL stop"
			echo "Executing: ssh $HAUSER@$PIHOLE2 $COMMAND"
			ssh "$HAUSER@$PIHOLE2" "$COMMAND"
			COMMAND="sudo -S pkill pihole-FTL"
			echo "Executing: ssh $HAUSER@$PIHOLE2 $COMMAND"
			ssh "$HAUSER@$PIHOLE2" "$COMMAND"
			echo "Sleeping for 3 seconds to allow FTL stop/kill to complete"
			sleep 3
			COMMAND="sudo -S service pihole-FTL start"
			echo "Executing: ssh $HAUSER@$PIHOLE2 $COMMAND"
			ssh "$HAUSER@$PIHOLE2" "$COMMAND"
			echo "FTL restart commands all sent to $PIHOLE2"
		fi
			echo "Done Syncing with $PIHOLE2"
	else
		echo "Error: Problem with $FILE"
	fi

fi

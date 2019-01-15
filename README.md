#README
#-----------------------------
#Credit to redditor /u/jvinch76  https://www.reddit.com/user/jvinch76 for creating the basis for this modification.
#-----------------------------
#
#************Previous************
#Original Source https://www.reddit.com/r/pihole/comments/9gw6hx/sync_two_piholes_bash_script/
#Previous Pastebin https://pastebin.com/KFzg7Uhi
#Reddit link https://www.reddit.com/r/pihole/comments/9hi5ls/dual_pihole_sync_20/
#-----------------------------
#
#************Current************
#GitHub link https://github.com/dpaulson/Pi-Hole-Sync
#Improvements:  Added logging to piholesync.log
#Complete rsync script rewrite that checks if FTL or Gravity needs to be updated and executes appropriate SSH command
#Script usage: bash piholesync.rsync.sh <FILEPATH/FILENAME>
#-----------------------------
#
#************Installation************
#----Prerequisites----
#1.  execute 'sudo apt-get install inotify-tools' <--- install the inotify tools necessary for watching the files
#
#----Script Installation----
#On PRIMARY Pi-Hole
#2.  Login to PRIMARY Pi-Hole
#3.  execute 'wget https://raw.githubusercontent.com/dpaulson/Pi-Hole-Sync/master/piholesync.rsync.sh'
#4.  execute 'wget https://raw.githubusercontent.com/dpaulson/Pi-Hole-Sync/master/piholesync.watch.list'
#5.  edit piholesync.rsync.sh and change:
#5a. PIHOLE2 your SECONDARY Pi-Hole's IP
#5b. PIHOLEDIR your SECONDARY Pi-Hole's pihole directory
#5c. HAUSER to your SECONDARY Pi-Hole's user account
#6.  save and exit
#7.  execute 'chmod +x ~/piholesync.rsync.sh' to make they rsync script executable
#8.  
#
#----Generate SSH Keys----
#9.   execute 'ssh-keygen -t rsa'
#9a.  "Enter" 3 times to accept default location and no passphrase (otherwise passphrase may be needed for passing remote commands)
#10.   execute 'eval "$(ssh-agent)"
#11.   execute 'ssh-add ~/.ssh/id_rsa' <--- looking for 'Identity added: id_rsa (id_rsa)' in response to this command
#12.  execute 'ssh-copy-id -i ~/.ssh/id_rsa HAUSER@PIHOLE2' <--- copies the key to the remote server and adds to the accepted keys
#12a. execute 'yes' <--- you must fully type out yes
#13.  execute 'ssh HAUSER@PIHOLE2 uname -a' <--- looking for 'Linux <Remote Hostname> 4.XX.XX-vX (version) ... armv71 GNU/Linux' in response to this command (on a Raspberry Pi)

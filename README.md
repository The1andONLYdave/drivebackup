drivebackup
===========

Backupscript which copy only once a day (perfect for putting in autostart and taskscheduler for daily run)

USAGE:
.xml is for windows taskscheduler
.bat is the script
xxexist.chk go to root of drive D: and E:
xxonce.chk go to e: or get created automatically


it first check if drives exist, if unmounted or something cancel script
then checks if backup run already at today (if xxonce.chk dont exist it run and create it with filedate from today)
then backup folders in googledrive, and ondrive directory 
and start both desktop clients(dont ever start onedrive client if your drive with onedrive-folder isn't available because it will log you out and you'd need to manually relogin)


Change paths to your gdrive/onedrive folders AND change line 94 (username of path from onedrive)
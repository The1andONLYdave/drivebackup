::@echo off
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: XCOPY/robocopy Once a day batch file.
::
:: You can by-pass the once-a-day check by specifying an argument.
:: This batch file was made a little fancy, but the key point here
:: is the first xcopy line below (/L /D:%stra%).
::
:: The first xcopy line lists the chk file with today's timestamp.
:: If the file is absent or it is not of today, none will be listed.
:: The exit code reflect the result:
::
:: Exit code == 0 if chk file exists (job has been done today).
:: Exit code == 100 if chk file is not found (job not done yet). //valid for xcopy?
::
:: Here, the contents of the file is printed as the acknowledgement
:: of the job done (and do nothing else).
::
:: Alternatively, you could write it so that it quietly jumps to
:: the end. Use the following line for the if statement instead,
::
:: if errorlevel 0 goto end
::
:: Here, the check file was created inside "e:\" but it
:: can be elsewhere under any other (unique) name.
::
:: Created: 2001-07-23 Kan Yabumoto
::	Edited: 2014-10-20 David-Lee Kulsch 
:: rewrite for xcopy and robocopy which are out of the box on windows 7 available
:: robocopy part modified from http://tambnguyen.com
:: available on http://github.com/The1andONLYdave/drivebackup
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not "%1" == "" goto start
::commandline arguments can force to skip all checks (drive d exist, drive e exits, backup yesterday or older)

::first check availability of harddisks in drive bay
xcopy "e:\xxexist.chk" /L  /Y >nul
if %ERRORLEVEL% == 0 goto gdrive
echo.
MSG * "Drive E unavailable or e:\xxexist.chk file deleted." 
goto end

:gdrive
xcopy "d:\xxexist.chk" /L /Y >nul
if %ERRORLEVEL% == 0 goto onedrive
echo.
MSG * "Drive D unavailable or d:\xxexist.chk file deleted." 
goto end



:onedrive
::convert german date
set str=%DATE%
set year=%str:~6,4%
set month=%str:~3,2%
set day=%str:~0,2%
set stra=%month%-%day%-%year%
echo %stra%

::if backup yesterday or older(filedate xxonce.chk) goto start, else popup "backup already run"
xcopy "e:\xxonce.chk" /L /D:%stra% /Y >nul
if errorlevel 1 goto start
echo.
type "e:\xxonce.chk"
echo.
MSG * "Daily Backup run today already" 
del "e:\xxonce.chk"
goto end
::
:start
MSG * "Beginn daily Backup" 
::
:: The following section is executed once a day.
:: If the execution is aborted, the whole thing will be repeated.
::
robocopy "C:\Users\Dell\Documents" "E:\Google Drive\autobackup\Documents" /S /MIR /R:3 /W:1 /LOG:"E:\mirror_drive.log" /NP /V /XJD /XJF
robocopy "C:\Users\Dell\Music" "E:\Google Drive\autobackup\Music" /S /MIR /R:3 /W:1 /LOG+:"E:\mirror_drive.log" /NP /V /XJD /XJF
robocopy "C:\Users\Dell\Pictures" "E:\Google Drive\autobackup\Pictures" /S /MIR /R:3 /W:1 /LOG+:"E:\mirror_drive.log" /NP /V /XJD /XJF
robocopy "C:\Users\Dell\Saved Games" "E:\Google Drive\autobackup\Saved Games" /S /MIR /R:3 /W:1 /LOG+:"E:\mirror_drive.log" /NP /V /XJD /XJF
robocopy "C:\Users\Dell\Videos" "E:\Google Drive\autobackup\Videos" /S /MIR /R:3 /W:1 /LOG+:"E:\mirror_drive.log" /NP /V /XJD /XJF
::after we copied every folder in google drive we use the complete folder to mirror at oneDrive too
robocopy "E:\Google Drive\autobackup" "D:\Online\OneDrive\autobackup" /S /MIR /R:3 /W:1 /LOG:"E:\mirror_drive2.log" /NP /V /XJD /XJF
IF %ERRORLEVEL% GTR 7 MSG * "Something went wrong with mirroring Google Drive. Check log!" 
::  /V für ausgelassene dateien
::  /XJD /XJF für nicht folgen von links auf directories und files
::
:: The echo line below creates the chk file when this is complete.
::
okay drives exists, robocopy finishes, now start onedrive and googledrive
start "Google Drive Sync" "C:\Program Files (x86)\Google\Drive\googledrivesync.exe"
start "OneDrive Sync" "C:\Users\Dell\AppData\Local\Microsoft\SkyDrive\SkyDrive.exe"

echo "Hello, XXCOPY. It's done, today" >"e:\xxonce.chk"
:end
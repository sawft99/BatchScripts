@echo off
SETLOCAL ENABLEEXTENSIONS
title Windows 7 and 10 OS Repair Script...
color 0a
echo This will run an SFC scan for Windows 7 and a CHKNTFS command will be set to run on reboot.
echo DISM will also run if this is Windows 10.
echo.
Pause
echo.
echo Repair script running...
echo.
sfc /scannow
echo.
echo SFC scan done...
echo.
echo Scheduling CHKNTFS  and CHKDSK on next reboot
chkntfs /c %Systemdrive%
cd /d C:\
chkdsk /f /r /x /b
echo.
echo Check scheduled.
echo.
echo Checking for Windows 10...
Ver | find /i "Version 10."
if %errorlevel% == 0 goto Run else goto Exit
:Run
echo.
dism /online /cleanup-image /restorehealth /startcomponentcleanup /resetbase
goto Exit
:Exit
echo.
echo Done...
echo.
pause
endlocal
exit

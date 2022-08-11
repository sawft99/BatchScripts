@echo off
SETLOCAL ENABLEEXTENSIONS
title Windows 7 and up OS Repair Script...
color 0a
echo This will run an SFC, CHKDSK, and CHKNTFS scan for Windows 7.
echo DISM will also run if this is Windows 10 and up.
echo.
Pause
echo.
echo Repair script running...
echo.
sfc /scannow
echo.
echo SFC scan done...
echo.
echo Scheduling CHKNTFS and CHKDSK on next reboot
chkntfs /c %Systemdrive%
cd /d C:\
chkdsk /f /r /x /b
echo.
echo Check scheduled.
echo.
echo Checking if Windows 10 or higher...
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

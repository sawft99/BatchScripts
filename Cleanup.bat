::File to clean out various parts of the system. It can be fairly aggressive so be careful.

@echo off
color 0a
setlocal enableextensions
SETLOCAL
pushd %SystemDrive%
Title Cleanup Script...
set starttime=%TIME%
echo.
echo Will execute as %USERDOMAIN%\%USERNAME% on %COMPUTERNAME%. Run as admin or failures will likely occur!
echo.
pause

:confirmstage
cls
net localgroup | findstr /X /c:"*Administrators"
if %errorLevel% == 1 (
	echo Doesn't look like you're running this as a local admin...
	echo.
	set /p confirm="Continue anyway? Failures will likely occur otherwise unless you are sure.(Y,N): "
	if "%confirm%"=="yes" goto start else (goto wronginput)
	if "%confirm%"=="y" goto start else (goto wronginput)
	if "%confirm%"=="YES" goto start else (goto wronginput)
	if "%confirm%"=="Y" goto start else (goto wronginput)
	if "%confirm%"=="no" goto noanswer else (goto wronginput)
	if "%confirm%"=="NO" goto noanswer else (goto wronginput)
	if "%confirm%"=="n" goto noanswer else (goto wronginput)
	if "%confirm%"=="N"goto noanswer else (goto wronginput)
) else ( goto wronginput )

if %errorlevel% == 0 goto start

:wronginput
echo Please just try a "yes or no" style answer...
pause
cls 
goto confirmstage

:noanswer
cls
echo.
echo Okay, closing then...
echo.
pause
exit
	
:start
cls
echo  Starting cleanup ...
echo  --------------------------
echo.
echo Cleaning old windows files from upgrades and updates...
echo.
::Clear out windows update folder

:updateconfirmstage
set /p updateconfirm="Clear windows updates cache (SoftwareDistribution folder)? Don't if updates are queued to be installed...(Y,N): "
	if "%updateconfirm%"=="yes" goto updatecleanup else (goto wrongupdateinput)
	if "%updateconfirm%"=="y" goto updatecleanup else (goto wrongupdateinput)
	if "%updateconfirm%"=="YES" goto updatecleanup else (goto wrongupdateinput)
	if "%updateconfirm%"=="Y" goto updatecleanup else (goto wrongupdateinput)
	if "%updateconfirm%"=="no" goto therest else (goto wrongupdateinput)
	if "%updateconfirm%"=="NO" goto therest else (goto wrongupdateinput)
	if "%updateconfirm%"=="n" goto therest else (goto wrongupdateinput)
	if "%updateconfirm%"=="N"goto therest else (goto wrongupdateinput)

:wrongupdateinput
echo.
echo Please just try a "yes or no" style answer...
echo.
pause
cls
goto updateconfirmstage

:updatecleanup
echo.
if exist "%systemdrive%\windows\SoftwareDistribution\Download" (
	net stop wuauserv
	takeown /F "%systemdrive%\windows\SoftwareDistribution\Download\*" /R /A /D Y
	echo y| cacls "%systemdrive%\windows\SoftwareDistribution\Download\*" /T /grant %userdomain%\%username%:F
	Del /f /s /q "%systemdrive%\windows\SoftwareDistribution\Download\*"
	rmdir /s /q "%systemdrive%\windows\SoftwareDistribution\Download\"
	net start wuauserv
	) else (
		echo.
		echo No such folder exists, moving on...
		echo.
		goto therest)
		
:therest
:: Previous Windows versions cleanup.
if exist %SystemDrive%\Windows.old\ (
	takeown /F %SystemDrive%\Windows.old /R /A /D Y
	echo y| cacls %SystemDrive%\Windows.old\*.* /T /grant %userdomain%\%username%:F
	rmdir /S /Q %SystemDrive%\Windows.old
	)
)
if exist %SystemDrive%\$Windows.~BT\ (
	takeown /F %SystemDrive%\$Windows.~BT /R /A /D Y
	echo y| cacls %SystemDrive%\Windows.old\*.*/T /grant %userdomain%\%username%:F
	rmdir /S /Q %SystemDrive%\$Windows.~BT\*.*
	)
)
if exist %SystemDrive%\$Windows.~WS (
	takeown /F %SystemDrive%\$Windows.~WS\* /R /A /D Y
	echo y| cacls %SystemDrive%\Windows.old\*.* /T /grant %userdomain%\%username%:F
	rmdir /S /Q %SystemDrive%\$Windows.~WS\
	)
)

echo.
echo Done...
echo.
echo Cleaning up all users appdata/temp files...
echo.
:: Appdata cleanup (Chrome, IE, Flash, Java)
if /i "%WIN_VER:~0,9%"=="Microsoft" (
	for /D %%x in ("%SystemDrive%\Documents and Settings\*") do (
		del /F /S /Q "%%x\Application Data\Adobe\Flash Player\*" 2>NUL
		del /F /S /Q "%%x\Application Data\Macromedia\Flash Player\*" 2>NUL
		del /F /S /Q "%%x\Application Data\Microsoft\Dr Watson\*" 2>NUL
		del /F /S /Q "%%x\Application Data\Microsoft\Windows\WER\ReportArchive\*" 2>NUL
		del /F /S /Q "%%x\Application Data\Microsoft\Windows\WER\ReportQueue\*" 2>NUL
		del /F /S /Q "%%x\Application Data\Sun\Java\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\ApplicationHistory\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\Google\Chrome\User Data\Default\Cache\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\Google\Chrome\User Data\Default\JumpListIconsOld\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\Google\Chrome\User Data\Default\JumpListIcons\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\Google\Chrome\User Data\Default\Local Storage\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\Google\Chrome\User Data\Default\Media Cache\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\Microsoft\Internet Explorer\Recovery\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Application Data\Microsoft\Terminal Server Client\Cache\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Temp\*" 2>NUL
		del /F /S /Q "%%x\Local Settings\Temporary Internet Files\*" 2>NUL
		del /F /S /Q "%%x\My Documents\*.tmp" 2>NUL
		del /F /S /Q "%%x\Recent\*" 2>NUL
	)
) else (
	for /D %%x in ("%SystemDrive%\Users\*") do ( 
		del /F /S /Q "%%x\*.blf" 2>NUL
		del /F /S /Q "%%x\*.regtrans-ms" 2>NUL
		del /F /S /Q "%%x\AppData\LocalLow\Sun\Java\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Google\Chrome\User Data\Default\Cache\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Google\Chrome\User Data\Default\JumpListIconsOld\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Google\Chrome\User Data\Default\JumpListIcons\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Google\Chrome\User Data\Default\Local Storage\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Google\Chrome\User Data\Default\Media Cache\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Internet Explorer\Recovery\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Terminal Server Client\Cache\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Windows\Caches\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Windows\Explorer\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Windows\zCache\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Windows\WER\ReportArchive\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Windows\WER\ReportQueue\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Microsoft\Windows\WebCache\*" 2>NUL
		del /F /S /Q "%%x\AppData\Local\Temp\*" 2>NUL
		del /F /S /Q "%%x\AppData\Roaming\Adobe\Flash Player\*" 2>NUL
		del /F /S /Q "%%x\AppData\Roaming\Macromedia\Flash Player\*" 2>NUL
		del /F /S /Q "%%x\AppData\Roaming\Microsoft\Windows\Recent\*" 2>NUL
		del /F /S /Q "%%x\Documents\*.tmp" 2>NUL
	)
)

:: Firefox cleanup
if exist "%systemdrive%\Users\" for /D %%a in ("%systemdrive%\Users\*") do (
	for /D %%b in ("%%a\AppData\Local\Mozilla\Firefox\Profiles\*") do (
		del /F /S /Q "%%b\cache2\entries\*"
	)
)
:: Firefox cleanup 2
for /D %%a in ("%systemdrive%\Users\*") do (
	for /D %%b in ("%%a\AppData\Roaming\Mozilla\Firefox\Profiles\*") do (
		del /F /S /Q "%%b\sessionstore-backups\*"
		del /F /S /Q "%%b\cookies*"
REM		del /F /S /Q "%%b\*" (Will eat everything and reset all settings in Firefox)
	)
)
:: IE Cleanup/reset
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8

:: Win 10 Edge cleanup (WIP)
REM echo %WIN_VER% | findstr /i /c:"Version 10.*"
REM if not %ERRORLEVEL%==0 for /D %%a in (%systemdrive%\Users\*) do (
REM for /D %%a in ("%systemdrive%\Users\*") do (
REM		for /D %%b in ("%%a\AppData\Local\Packages\Microsoft.MicrosoftEdge*") do (
REM			for /D %%c in ("%%b\AC") do (
REM			del "%%c\*"
REM			rmdir "%%c\*"
REM			)
REM		)
REM	)
REM )

echo.
echo. Done.
echo.
echo   Cleaning other system temp files...
echo.


:: Remove everything in downloads
REM FOR /i %%x in %systemdrive%\users\* do (
REM 	del %%x\downloads\*)
REM )

:: Root drive garbage
REM rmdir /S /Q %SystemDrive%\Temp 2>NUL
REM for %%i in (bat,txt,log,jpg,jpeg,tmp,bak,backup,exe) do (
REM			del /F /Q "%SystemDrive%\*.%%i" 2>NUL
REM	 )

:: System temp files
del /F /S /Q "%WINDIR%\TEMP\*" 2>NUL

:: Remove files left over from installing Nvidia/ATI/AMD/Dell/Intel/HP drivers
for /D %%i in (NVIDIA,ATI,AMD,Dell,Intel,HP) do (
			rmdir /S /Q "%SystemDrive%\%%i" 2>NUL
		)
	)
:: Clear additional unneeded files from NVIDIA driver installs
if exist "%ProgramFiles%\Nvidia Corporation\Installer2" rmdir /s /q "%ProgramFiles%\Nvidia Corporation\Installer2"
if exist "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService" del /f /q "%ALLUSERSPROFILE%\NVIDIA Corporation\NetService\*.exe"

:: Clear Windows Search Temp Data + Index
if exist "%ALLUSERSPROFILE%\Microsoft\Search\Data\Temp" rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Search\Data\Temp"
echo.
echo Stopping search service to wipe search data and index...
echo.
net stop Wsearch
echo.
if exist %SystemDrive%\ProgramData\Microsoft\Search\Data\Applications\Windows (
	del /F /S /Q %SystemDrive%\ProgramData\Microsoft\Search\Data\Applications\Windows\*
	)
)
echo.
net start Wsearch
echo.

:: Remove the Office installation cache.
if exist %SystemDrive%\MSOCache rmdir /S /Q %SystemDrive%\MSOCache

:: Remove the Windows installation cache.
if exist %SystemDrive%\i386 rmdir /S /Q %SystemDrive%\i386

:: Empty all recycle bins in XP and up
if exist %SystemDrive%\RECYCLER rmdir /s /q %SystemDrive%\RECYCLER
if exist %SystemDrive%\$Recycle.Bin rmdir /s /q %SystemDrive%\$Recycle.Bin

:: Delete Recycle Bins on other drives
REM for /D %%N in (D E F G H I J K L M O P Q R S T U V W X Y Z) DO (
REM IF EXIST %%N\$Recycle.Bin del %%N\$Recycle.Bin\*.* )

:: Clear MUI cache
reg delete "HKCU\SOFTWARE\Classes\Local Settings\Muicache" /f

:: Clear Windows Error Reporting
if exist "%ALLUSERSPROFILE%\Microsoft\Windows\WER\ReportArchive" rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Windows\WER\ReportArchive"
if exist "%ALLUSERSPROFILE%\Microsoft\Windows\WER\ReportQueue" rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Windows\WER\ReportQueue"

:: Clear Windows Defender Scan Results
if exist "%ALLUSERSPROFILE%\Microsoft\Windows Defender\Scans\History\Results\Quick" rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Windows Defender\Scans\History\Results\Quick"
if exist "%ALLUSERSPROFILE%\Microsoft\Windows Defender\Scans\History\Results\Resource" rmdir /s /q "%ALLUSERSPROFILE%\Microsoft\Windows Defender\Scans\History\Results\Resource"

:: Clear Windows update logs
if exist %WINDIR%\*.log del /F /Q %WINDIR%\*.log 2>NUL
if exist %WINDIR%\*.txt del /F /Q %WINDIR%\*.txt 2>NUL

:: Because that guided tour thing is annoying
REM if /i "%WIN_VER:~0,9%"=="Microsoft" (
REM	if exist %WINDIR%\system32\dllcache\tourstrt.exe del %WINDIR%\system32\dllcache\tourstrt.exe 2>NUL
REM	if exist %WINDIR%\system32\dllcache\tourW.exe del %WINDIR%\system32\dllcache\tourW.exe 2>NUL
REM	if exist %WINDIR%\Help\Tours rmdir /S /Q %WINDIR%\Help\Tours 2>NUL
REM	)

:: Windows Server: remove built-in media files (all Server versions)
REM echo %WIN_VER% | findstr /i /c:"server" >NUL
REM if %ERRORLEVEL%==0 do (
REM		if exist %WINDIR%\Media takeown /f %WINDIR%\Media /r /d y 2>NUL && echo.
REM		if exist %WINDIR%\Media icacls %WINDIR%\Media /grant administrators:F /t  && echo.
REM		if exist %WINDIR%\Media rmdir /S /Q %WINDIR%\Media 2>NUL )
REM

:: CBS Log cleaner
if exist %WINDIR%\Logs\CBS del /F /Q %WINDIR%\Logs\CBS\* 2>NUL
echo.

:End
echo -----------------------------------------------------------
echo Cleanup started at %starttime% and finished at %TIME%
echo -----------------------------------------------------------
echo.
Pause
ENDLOCAL
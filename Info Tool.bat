@echo off
setlocal enableextenions
Title Computer Info
color 0a

:Start
cls
echo ====================
echo Info gathering tool
echo ====================
echo.
echo Info & Tools:
echo.
echo 1) Basic Computer Info (Name, OS, CPU, etc)
echo 2) Network Info (IP, Subnet, Etc)
echo 3) Network Test (Ping and Tracert)
echo 4) Exit
echo.
choice /n /c 1234 /m "Select 1-4: "
if %ERRORLEVEL% ==1 goto Computerinfo
if %ERRORLEVEL% ==2 goto Networkinfo
if %ERRORLEVEL% ==3 goto Networktests
if %ERRORLEVEL% ==4 goto Exit

:Computerinfo
cls
echo ====================
echo Computer System Info
echo ====================
wmic computersystem get Manufacturer, Model, NumberOfProcessors, SystemFamily
wmic systemenclosure get SerialNumber
echo ====================
echo   Motherboard Info
echo ====================
wmic baseboard get Product, Manufacturer, Model
echo ====================
echo       OS Info
echo ====================
wmic os get Caption, CSName, OSArchitecture, Version, InstallDate
echo ====================
echo      BIOS Info
echo ====================
wmic bios get Manufacturer, Name, Version, SerialNumber, ReleaseDate
wmic bios get SMBIOSBIOSVersion, Description, Caption
echo ====================
echo      CPU Info
echo ====================
wmic cpu get NumberOfCores, NumberOfLogicalProcessors, Name, ThreadCount
echo ====================
echo     Memory Info
echo ====================
wmic memorychip get Caption, Capacity, ConfiguredClockSpeed, DataWidth, DeviceLocator
echo ====================
echo      Login Info
echo ====================
wmic netlogin get Name, BadPasswordCount
echo ====================
echo     Domain Info
echo ====================
wmic ntdomain get Caption, DomainControllerAddress, DomainControllerName, DomainName, DNSForestName, DomainName, Status
echo.
echo Note: date format YYYY/MM/DD~
echo.
pause
goto Start

:Networkinfo
cls
echo ====================
echo Connected Interfaces
echo ====================
echo.
netsh int ipv4 show interfaces store=active | findstr /v "disconnected"
echo.
set /p netineterface=Enter which interface you would like to see via the IDX#: 
echo.
netsh int ipv4 show addresses %netineterface%
if %ERRORLEVEL% ==1 (Echo Not a valid interface. Enter the coresponding IDX number to check an interface.
	echo.
	pause
	goto Networkinfo)
netsh int ipv4 show dnsservers %netineterface% | Findstr /v "Register"
echo.
choice /n /m "View another interface? [Y,N]: "
if %ERRORLEVEL% ==1 goto Networkinfo
goto start

:Networktests
cls
echo =============
echo Network Tests
echo =============
echo.
echo Select what type of test you would like:
echo.
echo 1) Ping DC server (DNS and IP)
echo 2) Tracert DC server (DNS and IP)
echo 3) Ping Internet (DNS and IP)
echo 4) Tracert Google (DNS and IP)
echo 5) Specify a target to ping
echo 6) Specify a target to tracert
echo 7) Specify a target to pathping
echo 8) Back to main menu
echo.
choice /n /c 12345678 /m "Select 1-6: "
if %ERRORLEVEL% ==1 goto Googleping
if %ERRORLEVEL% ==2 goto Googletrace
if %ERRORLEVEL% ==3 goto Customping
if %ERRORLEVEL% ==4 goto customtracert
if %ERRORLEVEL% ==5 goto custompathping
if %ERRORLEVEL% ==6 goto Start

:Googleping
cls
echo ===================
echo Google ping...
echo ===================
ping -4 8.8.8.8
ping -4 google.com
echo.
pause
goto Networktests

:Googletrace
cls
echo ===================
echo Google trace...
echo ===================
tracert -4 8.8.8.8
tracert -4 google.com
echo.
pause
goto Networktests

:Customping
cls
echo ================
echo Custom Ping...
echo ================
echo.
set target=
set /p target=Enter IP/Name to ping: 

:custompingrepeat
ping -4 %target%
echo.
choice /m "Ping target again?"
if %ERRORLEVEL% ==1 goto custompingrepeat
echo.
choice /m "Ping something else?"
if %ERRORLEVEL% ==1 goto Customping
goto Networktests

:customtracert
cls
echo ================
echo Custom Trace...
echo ================
echo.
set target=
set /p target=Enter IP/Name to trace: 

:customtracerepeat
tracert -4 %target%
echo.
choice /m "Trace target again?"
if %ERRORLEVEL% ==1 goto customtracerepeat
echo.
choice /m "Trace soemthing else?"
if %ERRORLEVEL% ==1 goto Customtracert
goto Networktests

:custompathping
cls
echo ================
echo Custom Pathping...
echo ================
echo.
set target=
set /p target=Enter IP/Name to pathping: 

:custompathpingrepeat
pathping -4 %target%
echo.
choice /m "Pathping target again?"
if %ERRORLEVEL% == 1 goto custompathpingrepeat
echo.
choice /m "Pathping something else?"
if %ERRORLEVEL% == 1 goto custompathping
goto Networktests

:Exit
echo.
echo Exiting...
echo.
pause
endlocal
exit

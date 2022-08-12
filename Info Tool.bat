@echo off
setlocal enableextenions
Title Computer Info
color 0a

:Start
cls
echo ============================
echo Basic Info and Network Tests
echo ============================
echo.
echo Operations:
echo.
echo 1) Get Basic Computer Info (Name, OS, CPU, etc)
echo 2) Get Network Info (IP, Subnet, Etc)
echo 3) Test Network (Ping and Tracert)
echo 4) Exit
echo.
choice /n /c 1234 /m "Select 1-4: "
if %ERRORLEVEL% ==1 goto ComputerInfo
if %ERRORLEVEL% ==2 goto NetworkInfo
if %ERRORLEVEL% ==3 goto NetworkTests
if %ERRORLEVEL% ==4 goto Exit

:ComputerInfo
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

wmic computersystem | Findstr /i "WORKGROUP" >NUL
if %errorlevel% ==1 (
	echo ====================
	echo     Domain Info
	echo ====================
	wmic ntdomain get Caption, DomainControllerAddress, DomainControllerName, DomainName, DNSForestName, DomainName, Status
	echo.
	echo Note: date format YYYY/MM/DD~
	echo.
	pause
	goto Start
) else (
	echo.
	echo Note: date format YYYY/MM/DD~
	echo.
	pause
	goto Start
)

:NetworkInfo
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
if %ERRORLEVEL% ==1 goto NetworkInfo
goto start

:NetworkTests
cls
echo =============
echo Network Tests
echo =============
echo.
echo Select type of test to run:
echo.
echo 1) Ping Google (DNS and IP)
echo 2) Tracert Google (IP)
echo 3) Specify a target to Ping
echo 4) Specify a target to Tracert
echo 5) Specify a target to Pathping
echo 6) Back to main menu
echo.
choice /n /c 123456 /m "Select 1-6: "
if %ERRORLEVEL% ==1 goto GooglePing
if %ERRORLEVEL% ==2 goto GoogleTracert
if %ERRORLEVEL% ==3 goto CustomPing
if %ERRORLEVEL% ==4 goto CustomTracert
if %ERRORLEVEL% ==5 goto CustomPathping
if %ERRORLEVEL% ==6 goto Start

:GooglePing
cls
echo ===================
echo Google Ping...
echo ===================
ping -4 8.8.8.8
ping -4 google.com
echo.
pause
goto Networktests

:GoogleTracert
cls
echo ===================
echo Google Tracert...
echo ===================
tracert -4 8.8.8.8
echo.
pause
goto Networktests

:CustomPing
cls
echo ================
echo Custom Ping...
echo ================
echo.
set target=
set /p target=Enter IP/Name to ping: 

:CustomPingRepeat
ping -4 %target%
echo.
choice /m "Ping target again?"
if %ERRORLEVEL% ==1 goto custompingrepeat
echo.
choice /m "Ping something else?"
if %ERRORLEVEL% ==1 goto Customping
goto Networktests

:CustomTracert
cls
echo ================
echo Custom Tracert...
echo ================
echo.
set target=
set /p target=Enter IP/Name to trace: 

:CustomTracertRepeat
tracert -4 %target%
echo.
choice /m "Trace target again?"
if %ERRORLEVEL% ==1 goto customtracerepeat
echo.
choice /m "Trace soemthing else?"
if %ERRORLEVEL% ==1 goto Customtracert
goto Networktests

:CustomPathping
cls
echo ================
echo Custom Pathping...
echo ================
echo.
set target=
set /p target=Enter IP/Name to pathping: 

:CustomPathpingRepeat
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

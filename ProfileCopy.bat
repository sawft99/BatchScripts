@echo off
set /p Share="Enter share (Ex. Fileserver.domain.local\Users): "
set /p User="Enter local username to copy: "
robocopy /ZB /NOCOPY /MIR /XJ /MT:16 /R:3 /W:3 /TBD /V /ETA "C:\Users\%User%" "\\%Share%"
echo.
echo Done.
echo.
Pause
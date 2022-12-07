@echo off
rem Repo location
set repo=C:\PathToRepo
cls
echo.
echo Safety before executing rebase on %repo%
echo.
pause
cd /d %repo%
if not %ERRORLEVEL% == 0 echo Location does not exist & echo. & pause & exit
rem Create and switch to new branch "tmp"
git checkout --orphan tmp
rem Add files
git add -A
rem Commit to new branch
git commit -am "Init"
rem Delete "main" branch
git branch -D main
rem Rename "tmp" branch to "main"
git branch -m main
choice /m "Continue with final push?
if %ERRORLEVEL% == 1 goto push
if not %ERRORLEVEL% == 1 exit
rem Update repository
:push
git push -f origin main
echo.
pause

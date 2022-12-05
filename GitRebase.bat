rem Repo location
echo Safety before executing
echo.
pause
set repo=C:\PathToRepo\.git
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
rem Update repository
git push -f origin main
echo.
pause

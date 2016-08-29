@echo off
echo Check for Admn
net sessions
if %errorlevel%==0 (
echo Success, Obtained Admin Rights
) else (
echo Failure, No Admin Rights
pause
exit
)
net accounts /minpwlen:10
net accounts /maxpwage:30
net accounts /minpwage:1
net accounts

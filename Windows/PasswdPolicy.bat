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
REM Passwords must be 10 digits
net accounts /minpwlen:10
REM Passwords must be changed every 30 days
net accounts /maxpwage:30
REM Passwords can only be changed after 1 day has passed
net accounts /minpwage:1
REM Display current password policy
net accounts

REM Add other things if could be automated, RUN THIS AS ADMIN
@echo off
echo Check for Admn
net sessions
if %errorlevel%==0 (
echo Success
) else (
echo No admin
pause
exit
)
REM Windows Defender scan 
cd C:\Program Files\Windows Defender\
MpCmdRun.exe -Scan 2
REM Listing possible penetrations
cd C:\
echo Staring to output active processes to dir C:\!
wmic process list brief > BriefProcesses.txt
if %errorlevel%==1 echo Brief Processes failed to write
wmic process list full >FullProcesses.txt
if %errorlevel%==1 echo Full Processes failed to write
wmic startup list full > StartupLists.txt
if %errorlevel%==1 echo Startup Processes failed to write
net start > StartedProcesses.txt
if %errorlevel%==1 echo Started processes failed to write
reg export HKLM\Software\Microsoft\Windows\CurrentVersion\Run  Run.reg
if %errorlevel%==1 echo Run processes failed to write
REM Passwords must be 10 digits
net accounts /minpwlen:10
REM Passwords must be changed every 30 days
net accounts /maxpwage:30
REM Passwords can only be changed after 1 day has passed
net accounts /minpwage:1
REM Display current password policy
net accounts

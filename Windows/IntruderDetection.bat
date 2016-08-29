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

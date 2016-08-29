REM Add other things if could be automated, RUN THIS AS ADMIN
@echo off
REM Windows Defender scan 
cd C:\Program Files\Windows Defender\
MpCmdRun.exe -Scan 2
REM Listing possible penetrations
@echo on
echo Staring to output active processes!
wmic process list brief > BriefProcesses.txt
if %errorlevel%==1 echo Brief Processes failed to write
wmic process list full >FullProcesses.txt
if %errorlevel%==1 echo Full Processes failed to write
wmic startup list full > StartupLists.txt
if %errorlevel%==1 echo Startup Processes failed to write

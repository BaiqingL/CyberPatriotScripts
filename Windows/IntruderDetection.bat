REM Add other things if could be automated, RUN THIS AS ADMIN
@echo off
REM Windows Defender scan 
cd C:\Program Files\Windows Defender\
MpCmdRun.exe -Scan 2
REM Listing possible penetrations
@echo on
echo Staring to output active processes!
wmic process list brief > BriefProcesses.txt
wmic process list full >FullProcesses.txt
wmic startup list full > StartupLists.txt

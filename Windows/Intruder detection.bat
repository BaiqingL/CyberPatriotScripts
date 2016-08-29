REM Add other things if could be automated, RUN THIS AS ADMIN
@echo off
REM Windows Defender scan 
cd C:\Program Files\Windows Defender\
MpCmdRun.exe -Scan 2
REM Listing possible penetrations
wmic process list brief > brief.txt
PAUSE
wmic process list full >fullprocess.txt
PAUSE
wmic startup list full > startuplists.txt
PAUSE

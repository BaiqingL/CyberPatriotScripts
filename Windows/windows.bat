REM Add other things if could be automated, RUN THIS AS ADMIN
@echo off
REM Windows Defender scan 
C:\Program Files\Windows Defender\MpCmdRun.exe -Scan 2
REM Listing possible penetrations
wmic process list brief
PAUSE
wmic process list full
PAUSE
wmic startup list full
PAUSE
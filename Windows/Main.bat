REM Add other things if could be automated, RUN THIS AS ADMIN
REM Everything is added, including PowerShell command execution and "wget" lol
REM Admin checking...
@echo off
echo Checking if script contains Administrative rights...
net sessions
if %errorlevel%==0 (
echo Success!
) else (
echo No admin, please run with Administrative rights...
pause
exit
)
:MENU
echo Choose An option:
echo 1. Windows Defender Scan
echo 2. List Processes
echo 3. Changing Password Policies
echo 4. Enable UAC
echo 5. Disable Remote Desktop
echo 6. Enable Auto-Update
echo 7. Disable Weak services
echo 8. System Integrity Scan
echo 9. Powershell rootkit detection
echo 10. Check startup processes

CHOICE /C 123456789 /M "Enter your choice:"
if ERRORLEVEL 10 goto Ten
if ERRORLEVEL 9 goto Nine
if ERRORLEVEL 8 goto Eight
if ERRORLEVEL 7 goto Seven
if ERRORLEVEL 6 goto Six
if ERRORLEVEL 5 goto Five
if ERRORLEVEL 4 goto Four
if ERRORLEVEL 3 goto Three
if ERRORLEVEL 2 goto Two
if ERRORLEVEL 1 goto One
:One
REM Windows Defender scan 
echo "SCANNING WITH DEFAULT WINDOWS DEFENDER!"
cd C:\Program Files\Windows Defender\
MpCmdRun.exe -Scan 2
cd C:\
goto MENU
:Two
REM Listing possible penetrations
cd C:\
echo "STARTING TO OUTPUT PROCESS FILES DIRECTLY TO THE C:\ DRIVE!"
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
goto MENU
:Three
echo "OUTPUT DONE, CHANGING PASSWORD POLICIES!"
REM Passwords must be 10 digits
net accounts /minpwlen:10
REM Passwords must be changed every 30 days
net accounts /maxpwage:30
REM Passwords can only be changed after 1 day has passed
net accounts /minpwage:1
REM Display current password policy
echo "CURRENT POLICY"
PAUSE
net accounts
goto MENU
:Four
REM Turn on UAC
echo "TURNING ON UAC"
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f
goto MENU
:Five
REM No Remote Desktop
echo "DISABLING REMOTE DESKTOP"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
goto MENU
:Six
REM Windows auomatic updates
echo "ENABLING AUTO-UPDATES"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 3 /f
goto MENU
:Seven
REM Removing good ol' insecure stuff
echo "DISABLING WEAK SERVICES"
dism /online /disable-feature /featurename:IIS-WebServerRole
dism /online /disable-feature /featurename:IIS-WebServer
dism /online /disable-feature /featurename:IIS-CommonHttpFeatures
dism /online /disable-feature /featurename:IIS-HttpErrors
dism /online /disable-feature /featurename:IIS-HttpRedirect
dism /online /disable-feature /featurename:IIS-ApplicationDevelopment
dism /online /disable-feature /featurename:IIS-NetFxExtensibility
dism /online /disable-feature /featurename:IIS-NetFxExtensibility45
dism /online /disable-feature /featurename:IIS-HealthAndDiagnostics
dism /online /disable-feature /featurename:IIS-HttpLogging
dism /online /disable-feature /featurename:IIS-LoggingLibraries
dism /online /disable-feature /featurename:IIS-RequestMonitor
dism /online /disable-feature /featurename:IIS-HttpTracing
dism /online /disable-feature /featurename:IIS-Security
dism /online /disable-feature /featurename:IIS-URLAuthorization
dism /online /disable-feature /featurename:IIS-RequestFiltering
dism /online /disable-feature /featurename:IIS-IPSecurity
dism /online /disable-feature /featurename:IIS-Performance
dism /online /disable-feature /featurename:IIS-HttpCompressionDynamic
dism /online /disable-feature /featurename:IIS-WebServerManagementTools
dism /online /disable-feature /featurename:IIS-ManagementScriptingTools
dism /online /disable-feature /featurename:IIS-IIS6ManagementCompatibility
dism /online /disable-feature /featurename:IIS-Metabase
dism /online /disable-feature /featurename:IIS-HostableWebCore
dism /online /disable-feature /featurename:IIS-StaticContent
dism /online /disable-feature /featurename:IIS-DefaultDocument
dism /online /disable-feature /featurename:IIS-DirectoryBrowsing
dism /online /disable-feature /featurename:IIS-WebDAV
dism /online /disable-feature /featurename:IIS-WebSockets
dism /online /disable-feature /featurename:IIS-ApplicationInit
dism /online /disable-feature /featurename:IIS-ASPNET
dism /online /disable-feature /featurename:IIS-ASPNET45
dism /online /disable-feature /featurename:IIS-ASP
dism /online /disable-feature /featurename:IIS-CGI
dism /online /disable-feature /featurename:IIS-ISAPIExtensions
dism /online /disable-feature /featurename:IIS-ISAPIFilter
dism /online /disable-feature /featurename:IIS-ServerSideIncludes
dism /online /disable-feature /featurename:IIS-CustomLogging
dism /online /disable-feature /featurename:IIS-BasicAuthentication
dism /online /disable-feature /featurename:IIS-HttpCompressionStatic
dism /online /disable-feature /featurename:IIS-ManagementConsole
dism /online /disable-feature /featurename:IIS-ManagementService
dism /online /disable-feature /featurename:IIS-WMICompatibility
dism /online /disable-feature /featurename:IIS-LegacyScripts
dism /online /disable-feature /featurename:IIS-LegacySnapIn
dism /online /disable-feature /featurename:IIS-FTPServer
dism /online /disable-feature /featurename:IIS-FTPSvc
dism /online /disable-feature /featurename:IIS-FTPExtensibility
dism /online /disable-feature /featurename:TFTP
dism /online /disable-feature /featurename:TelnetClient
dism /online /disable-feature /featurename:TelnetServer
goto MENU
:Eight
REM START SYS INTEG SCAN!
echo "STARTING SYSTEM INTERGRITY SCAN"
Sfc.exe /scannow
goto MENU
:Nine
REM PowerShell RootKit detection start
echo "POWERSHELL ROOTKIT DETECTION WITH MALWAREBYTES ROOTKIT BETA"
powershell Invoke-WebRequest -OutFile MBRTKit.exe https://data-cdn.mbamupdates.com/web/mbar-1.09.3.1001.exe
MBRTKit.exe
goto MENU
:Ten
powershell Get-CimInstance Win32_StartupCommand | Select-Object Name, command, Location, User | Format-List
pause
goto MENU 
PAUSE

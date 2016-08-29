#Downloads rootkit detection from MalwareBytes
Invoke-WebRequest -OutFile MBRTKit.exe https://data-cdn.mbamupdates.com/web/mbar-1.09.3.1001.exe
#Executes file
.\MBRTKit.exe

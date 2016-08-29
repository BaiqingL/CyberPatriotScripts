#Downloads rootkit detection
Invoke-WebRequest -OutFile scan.exe http://www2.gmer.net/download.php?
Invoke-WebRequest -OutFile MBRTKit.exe https://data-cdn.mbamupdates.com/web/mbar-1.09.3.1001.exe
#Scan starts
.\MBRTKit.exe
.\scan.exe

@ECHO OFF
SETLOCAL
SET PathTo7Zip=
SET OutputFile="%~n1.exe"
SET SourceFiles="%TEMP%MakeEXE_files.txt"
SET Config="%TEMP%MakeEXE_config.txt"
SET Source7ZFile="%Temp%MakeEXE.7z"
IF EXIST %OutputFile% DEL %OutputFile%
ECHO "%~dpnx1" > %SourceFiles%
:AddInclude
IF {%2}=={} GOTO EndInclude
ECHO "%~dpnx2" >> %SourceFiles%
SHIFT /2
GOTO AddInclude
:EndInclude
"%PathTo7Zip%7za.exe" a %Source7ZFile% @%SourceFiles%
ECHO ;!@Install@!UTF-8! > %Config%
ECHO RunProgram="%~nx1" >> %Config%
ECHO ;!@InstallEnd@! >> %Config%
COPY /B "%PathTo7Zip%7zsd.sfx" + %Config% + %Source7ZFile% %OutputFile%
IF EXIST %SourceFiles% DEL %SourceFiles%
IF EXIST %Config% DEL %Config%
IF EXIST %Source7ZFile% DEL %Source7ZFile%
ENDLOCAL

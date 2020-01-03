@ECHO OFF
MODE CON:COLS=83
ECHO ===================================================================================
ECHO                                  --FILE FISHER--
ECHO    This utility will take in a root directory of your choice, and a target file, 
ECHO    and will recursively run through all subdirectories from the root looking for
ECHO    any file that shares the name. Once identified, all matching files are copied 
ECHO    and renamed to the name of the containing folder (retaining the file type).
ECHO    These are placed in the folder above the target root, in /_fishedFiles.
ECHO    A report containing the original paths of each file is put in _report.txt.
ECHO ===================================================================================
:: Creates a log file for advanced error checking, with the actual command output
ECHO = New Session: %date% %time%
GOTO :SetRoot

:: Sets the directory, but checks that it actually exists
:SetRoot
ECHO ===================================================================================
SET /P rootdir=" > Enter Root of Search Tree: "
DIR %rootdir% >nul 2>&1
IF %ERRORLEVEL% EQU 0 GOTO :SetTarget
IF %ERRORLEVEL% NEQ 0 GOTO :RootFnF

:: If the directory can't be found, users are directed to debugging
:RootFnF
ECHO = There was an error locating this root, please ensure you have quotes around the 
ECHO   path if there are any spaces, and check it's the full path, e.g. "C:\Windows\".
GOTO :SetRoot

:: Sets the target filename, but checks that at least one exists
:SetTarget
ECHO ===================================================================================
SET /P filename=" > Enter Target Filename: "
DIR %rootdir%\%filename% /S /B >nul 2>&1
IF %ERRORLEVEL% EQU 0 GOTO :Search
IF %ERRORLEVEL% NEQ 0 GOTO :TargetFnF

:: If not even a single matching file can be found, the user is notified
:TargetFnF
ECHO = In a preliminary scan, no files matching this name were found under the root,
ECHO   ensure that you have the right filename, including the type extension; And that
ECHO   if it includes spaces, that it is in quote marks, e.g. "Cool Video.mpg".
ECHO = You can also use wildcard characters to search for files with varying names, 
ECHO   more on this is available in the DOCUMENTATION/README.
GOTO :SetTarget

:: Create Dump Directory & Report
:Search
SET n=0
FOR /D %%I IN (%rootdir%) DO (SET dumpdir=%%~dpI)
SET dumpdir=%dumpdir%_fishedData\
SET report="%dumpdir%\_report.txt"
MD %dumpdir% >nul 2>&1
ECHO New Session: %date% %time% >> %report%
ECHO Search Root: %rootdir% >> %report%
ECHO Search Target: %filename% >> %report%
ECHO ===================================================================================
ECHO = Searching subdirectories for %filename%...
:: Recursively Search Subdirectories, and handle each Resulting Filepath
FOR /F "delims=" %%X IN ('DIR %rootdir%\%filename% /S /B') DO (CALL :NewSub "%%X")
ECHO ===================================================================================
ECHO = Total of %n% file(s) renamed and copied to:
ECHO   %dumpdir%				  
ECHO ===================================================================================
PAUSE
GOTO :EOF

:: Handle Resulting Filepaths
:NewSub
:: Set Local Variables, incremement File Counter
SET fp=%~1%
SET /A n+=1
:: Extract Parent Directory Name
FOR /D %%I IN ("%fp%\\..") DO (SET pd=%%~nxI) 
:: Extract Individual Filename (This includes the extension)
FOR /D %%I IN ("%fp%") DO (SET fn=%%~nxI)
COPY "%fp%" "%dumpdir%\%pd%_%fn%" /Y >nul 2>&1
:: Check the copy was successful, and provide info
ECHO ^> %fp%
ECHO. >> %report%
ECHO = Copied %fp% >> %report%
ECHO ^> Into %pd%_%fn% >> %report%
EXIT /B
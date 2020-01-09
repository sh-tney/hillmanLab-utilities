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
IF %ERRORLEVEL% EQU 0 GOTO :SetOutput
IF %ERRORLEVEL% NEQ 0 GOTO :TargetFnF

:: If not even a single matching file can be found, the user is notified
:TargetFnF
ECHO = In a preliminary scan, no files matching this name were found under the root,
ECHO   ensure that you have the right filename, including the type extension; And that
ECHO   if it includes spaces, that it is in quote marks, e.g. "Cool Video.mpg".
ECHO = You can also use wildcard characters to search for files with varying names, 
ECHO   more on this is available in the DOCUMENTATION/README.
GOTO :SetTarget

:: Sets the output directory, or a default option, checking for errors
:SetOutput
ECHO ===================================================================================
FOR /D %%I IN (%rootdir%) DO (SET outputdir=%%~dpI)
SET outputdir=%outputdir%_fishedData\
ECHO = Output to %outputdir%? 
GOTO :YN

:: Decision tree, returning the user to the prompt if they enter a non y/n answer
:YN
SET /P outputyn="> y/n (Choose 'n' to set your own output folder): "
IF NOT "%outputyn%" == "y" (
    IF "%outputyn%" == "n" (
        SET /P outputdir=" > Enter Custom Output Directory: "
    ) ELSE (
        GOTO :YN
    )
)
:: Attempt to create outputdir first, and check it exists after that
MD %outputdir% >nul 2>&1
IF %ERRORLEVEL% EQU 0 ECHO = Folder Not Found; Creating...
DIR %outputdir% >nul 2>&1
IF %ERRORLEVEL% EQU 0 GOTO :Search
IF %ERRORLEVEL% NEQ 0 GOTO :OutputFnF

:: If the directory doesn't already exist and couldn't be created, prompt again
:OutputFnF
ECHO = The output folder either didn't already exist, couldn't be created, or couldn't
ECHO   be located for some reason. Please ensure you enter the correct full path; and
ECHO   if it includes spaces, wrap the path in double quotes, e.g. "C:\New Folder".
GOTO :SetOutput

:: Search Subdirectories, Create Report
:Search
SET n=0
SET report="%outputdir%\_report.txt"
ECHO New Session: %date% %time% >> %report%
ECHO Search Root: %rootdir% >> %report%
ECHO Search Target: %filename% >> %report%
ECHO ===================================================================================
ECHO = Searching subdirectories for %filename%...
:: Recursively Search Subdirectories, and handle each Resulting Filepath
FOR /F "delims=" %%X IN ('DIR %rootdir%\%filename% /S /B') DO (CALL :NewSub "%%X")
ECHO ===================================================================================
ECHO = Total of %n% file(s) renamed and copied to:
ECHO   %outputdir%				  
ECHO ===================================================================================
PAUSE
ECHO. >> %report% 
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
COPY "%fp%" "%outputdir%\%pd%_%fn%" /Y >nul 2>&1
:: Check the copy was successful, and provide info
ECHO ^> %fp%
ECHO. >> %report%
ECHO = Copied %fp% >> %report%
ECHO ^> Into %pd%_%fn% >> %report%
EXIT /B
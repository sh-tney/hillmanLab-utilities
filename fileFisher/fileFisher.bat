@ECHO OFF
MODE CON:COLS=83
ECHO ===================================================================================
ECHO                                --FILE FISHER 1.2--
ECHO    This utility will take root directory of your choice, a target filename, and 
ECHO    searches through all subdirectories of the root for all matching targets, 
ECHO    copying them and placing them in a single default output folder, or a Custom
ECHO    output location, renaming each file to your preferred naming format. Along
ECHO    with these is a _report.txt file, containing a list of all original file
ECHO    locations, and their corresponding new names for clarity.
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
IF %ERRORLEVEL% EQU 0 GOTO :SetFormat
IF %ERRORLEVEL% NEQ 0 GOTO :TargetFnF

:: If not even a single matching file can be found, the user is notified
:TargetFnF
ECHO = In a preliminary scan, no files matching this name were found under the root,
ECHO   ensure that you have the right filename, including the type extension; And that
ECHO   if it includes spaces, that it is in quote marks, e.g. "Cool Video.mpg".
ECHO = You can also use wildcard characters to search for files with varying names, 
ECHO   more on this is available in the DOCUMENTATION/README.
GOTO :SetTarget

:: User selects their preferred naming conventions, looping if an invalied choice
:SetFormat
ECHO ===================================================================================
ECHO = The targeted files will be renamed to a uniform format of your choice:
ECHO   1. ^<filename^>.^<ext^>                  (This leaves your filenames unchanged)
ECHO   2. ^<foldername^>.^<ext^>   (Renames them to the name of the containing folder)
ECHO   3. ^<foldername^>_^<filename^>.^<ext^>     (Has both, with an underscore between)

:: Basic Decision Tree that enforces a valid format choice, that also doens't break goto
:F
SET /P format="> Select your preferred naming format (1/2/3): "
IF NOT %format% EQU 1 (
    IF NOT %format% EQU 2 (
        IF NOT %format% EQU 3 (
            GOTO :F
        ) ELSE (
            SET format=3
        )
    ) ELSE (
        SET format=2
    )
) ELSE (
    SET format=1
)
GOTO :SetOutput

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
ECHO = Navigate to this folder to find a _report.txt with a full file list if needed.
ECHO ===================================================================================
PAUSE
ECHO. >> %report% 
GOTO :EOF

:: Handle Resulting Filepaths
:NewSub
:: Get Fullpath Variable, Increment Filecounter
SET fp=%~1%
SET /A n+=1
:: Extract Parent Directory Name. %1 in formatting functions
FOR /D %%I IN ("%fp%\\..") DO (SET pd=%%~nxI) 
:: Extract Individual Filename. %2 in formatting functions
FOR /D %%I IN ("%fp%") DO (SET fn=%%~nI)
:: Extract File Extension. %3 in formatting functions
FOR /D %%I IN ("%fp%") DO (SET xt=%%~xI)
:: Report Progress
ECHO ^> Copying %fp%
ECHO. >> %report%
ECHO = Copied %fp% >> %report%
:: Jump to Relevant Filename Formatting Function to do actual copying & report
CALL :Format%format% %pd% %fn% %xt%
EXIT /B

:: This format keeps the original filename; <filename>.<extension>
:Format1
COPY "%fp%" "%outputdir%\%2%3" /Y >nul 2>&1
ECHO ^> Into %2%3 >> %report%
EXIT /B

:: This format renames files to <parentfolder>.<extension>
:Format2
COPY "%fp%" "%outputdir%\%1%3" /Y >nul 2>&1
ECHO ^> Into %1%3 >> %report%
EXIT /B

:: This format renames files to <parentfolder>_<filename>.<extension>
:Format3
COPY "%fp%" "%outputdir%\%1_%2%3" /Y >nul 2>&1
ECHO ^> Into %1_%2%3 >> %report%
EXIT /B
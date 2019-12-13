@ECHO OFF
SET n=0
:: Recursively search folders for all matching files
ECHO ===================================================================================
ECHO = Searching subdirectories for "VT1.mpg", renaming each to the name of the folder =
ECHO ===================================================================================
MD _data
FOR /F "delims=" %%x IN ('dir VT1.mpg /S /B') DO (CALL :Sub "%%x" "%%n")
ECHO = Total of %n% file(s) renamed and copied to \_data				  =
ECHO ===================================================================================
PAUSE
GOTO :EOF

:Sub
:: First trim the quote marks
SET a=%~1%
ECHO Found: ...%a:~-73%
:: Substring down to the Date (Starting with \20xx)
SET b=%a:*\20=%
:: Cut off the actual filename
SET c=%b:~,-8%
:: Reappend full date, file extension, and target path
SET d=%cd%\_data\20%c%.mpg
ECHO Copying to: ...%d:~-68%
COPY "%a%" "%d%"
SET /A %~2%+=1
ECHO ===================================================================================
EXIT /B
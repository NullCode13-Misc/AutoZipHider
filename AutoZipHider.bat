@echo off & color 8F & title AutoZipHider v2.0
mode con: cols=85 lines=30 & setlocal EnableDelayedExpansion

cls & echo                           _       _______       _    _ _     _           
echo                /\        ^| ^|     ^|___  (_)     ^| ^|  ^| (_)   ^| ^|          
echo               /  \  _   _^| ^|_ ___   / / _ _ __ ^| ^|__^| ^|_  __^| ^| ___ _ __ 
echo              / /\ \^| ^| ^| ^| __/ _ \ / / ^| ^| '_ \^|  __  ^| ^|/ _` ^|/ _ \ '__^| 
echo             / ____ \ ^|_^| ^| ^|^| (_) / /__^| ^| ^|_) ^| ^|  ^| ^| ^| (_^| ^|  __/ ^|   
echo            /_/    \_\__,_^|\__\___/_____^|_^| .__/^|_^|  ^|_^|_^|\__,_^|\___^|_^|   
echo                                          ^| ^| 
echo                                          ^|_^|                             
echo. & echo                                     By: NullCode & echo.

if [%1]==[] (
	echo ^[ WARN ^] Front door not provided^^! 
	echo ^[ QUIT ^] Exiting... 
	timeout /t 3 >nul & exit /b 1
)
echo ^[ INFO ^] Provided front door: & echo %1

call :sizecheck "to_hide\"
if %folstat%==Exit (timeout /t 4 >nul & exit /b 1)

cd to_hide\
if exist files.txt (del files.txt)
for /r . %%g in (*.*) do echo %%~nxg >> files.txt
echo. & echo ^[ INFO ^] Files to hide: & type files.txt & del files.txt

echo. & echo Creating zip file... & echo --------------------
cd "%~dp0\" & mkdir working

copy to_hide\*.* working\ >nul & cd working\
set zipname=!random!af
set imgname=!random!null
set extension=%~x1
set full="%imgname%%extension%"

echo. 
choice /c YN /n /m "Do you want to set a password? [Y/N]"
if %errorlevel%==1 (..\tools\7z.exe a -p %zipname%.zip)
if %errorlevel%==2 (..\tools\7z.exe a %zipname%.zip)
 
copy /b %1 + %zipname%.zip %full%
move %full% "%~dp0\"
cd "%~dp0\" & rmdir /s /q working\

cls & echo   ___ _      _    _           _ _ 
echo  ^| __(_)_ _ (_)__^| ^|_  ___ __^| ^| ^|
echo  ^| _^|^| ^| ' \^| (_-^< ' \/ -_) _` ^|_^|
echo  ^|_^| ^|_^|_^|^|_^|_/__/_^|^|_\___\__,_(_)                                
echo. & echo The files have been hidden inside^: %full% & timeout /t 4 >nul & exit /b 0
 
::::::::::::::::::::::::::::::::::::::Eelco Ligtvoet:::::::::::::::::::::::::::::::::::::::
:sizecheck
call :folcheck "%~f1" 
set RESULT=%ERRORLEVEL% 
if %RESULT% equ 999 (
	echo. & echo ^[ WARN ^] Hiding folder does not exist^^!
	mkdir to_hide\
	echo ^[ INFO ^] Put the files to hide in this folder
	echo. & echo ^[ EXIT ^] Exiting...
	set folstat=Exit
) 
if %RESULT% equ 1 (
	set folstat=NoEm
)	
if %RESULT% equ 0 (
	echo. & echo ^[ WARN ^] No files to hide^^!
	echo ^[ EXIT ^] Exiting...
	set folstat=Exit
)
exit /b

:folcheck 
if not exist "%~f1" exit /b 999 
for %%I in ("%~f1\*.*") do exit /b 1 
exit /b 0 
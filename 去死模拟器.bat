@echo off
title :(
taskkill /f /im explorer.exe
color 1F
cls

echo ================================================
echo A problem has been detected and Windows has been
echo shut down to prevent damage to your computer.
echo.
echo If this is the first time you've seen this stop
echo error screen, restart your computer. If this
echo screen appears again, follow these steps:
echo.
echo Check to make sure any new hardware or software
echo is properly installed. If this is a new
echo installation, ask your hardware or software
echo manufacturer for any Windows updates you might
echo need.
echo.
echo Technical information:
echo *** STOP: 0x0000007B (0xF78D2524, 0xC0000034, 0x00000000, 0x00000000)
echo.
echo Physical memory dump complete.
echo Contact your system administrator or technical
echo support group for further assistance.
echo ================================================
echo .

:input
echo Whether to resume? (Y/N)
set /p choice=Please type£º

if "%choice%"=="Y" goto resume
if "%choice%"=="N" goto fail

echo Invalid input. Please enter Y or N.
goto input

:resume
title Start Recovery
echo Start Recovery...
ping -n 10 127.0.0.1 >nul
echo Inspect for errors...
ping -n 10 127.0.0.1 >nul
echo Resuming...
ping -n 10 127.0.0.1 >nul
start C:\Windows\explorer.exe
title Successfully restored !
echo Successfully restored !
pause
exit /b
:fail
title Reply failed !
echo Reply failed !
echo.
echo The system will restart in 30 seconds...
pause
shutdown /r /t 30
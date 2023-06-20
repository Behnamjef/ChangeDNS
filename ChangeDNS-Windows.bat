@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
:--------------------------------------

:MainMenu
REM Retrieve the active network interfaces
for /F "skip=1 tokens=1,2 delims= " %%A in ('wmic nic where "NetConnectionID is not null" get index^, NetConnectionID ^| findstr /r /v "^$" ^| findstr /r /c:"[0-9]"') do (
    set "interface_index=%%A"
    set "interface_name=%%B"
    REM Use the first active interface found
    goto :SelectedInterface
)

:SelectedInterface
REM Check if the chosen network interface name is set
if not defined interface_name (
    echo No active network interface found. Exiting.
    exit /b 1
    pause
)

:OptionsMenu
REM Display a line divider
echo ------------------------------------------

REM Prompt the user to choose an option
echo DNS options:
echo 1. Set Shecan DNS
echo 2. Set Begzar DNS
echo 3. Set Electro DNS
echo 4. Set 403 DNS
echo 5. Clear DNS
echo 6. Show Current DNS
echo 7. Exit

set /p dns_choice=Enter your choice (1-7): 

REM Set the DNS based on the user's choice
if "%dns_choice%"=="1" (
    netsh interface ip set dns name="%interface_name%" static 178.22.122.100 primary validate=no
    netsh interface ip add dns name="%interface_name%" 185.51.200.2 index=2 validate=no
    echo Shecan DNS settings changed successfully.
    goto :OptionsMenu
) else if "%dns_choice%"=="2" (    
    netsh interface ip set dns name="%interface_name%" static 185.55.226.26 primary validate=no
    netsh interface ip add dns name="%interface_name%" 185.55.225.25 index=2 validate=no
    echo Begzar DNS settings changed successfully.
    goto :OptionsMenu
) else if "%dns_choice%"=="3" (    
    netsh interface ip set dns name="%interface_name%" static 78.157.42.101 primary validate=no
    netsh interface ip add dns name="%interface_name%" 78.157.42.100 index=2 validate=no
    echo Electro DNS settings changed successfully.
    goto :OptionsMenu
) else if "%dns_choice%"=="4" (    
    netsh interface ip set dns name="%interface_name%" static 10.202.10.202 primary validate=no
    netsh interface ip add dns name="%interface_name%" 10.202.10.102 index=2 validate=no
    echo 403 DNS settings changed successfully.
    goto :OptionsMenu
) else if "%dns_choice%"=="5" (
    netsh interface ip set dns name="%interface_name%" source=dhcp
    echo DNS settings cleared successfully.
    goto :OptionsMenu
) else if "%dns_choice%"=="6" (
    echo Current DNS settings:
    ipconfig /all | findstr /R "DNS Servers"
    goto :OptionsMenu
) else if "%dns_choice%"=="7" (
    echo Exiting.
) else (
    echo Invalid choice. Please try again.
    goto :OptionsMenu
)

pause

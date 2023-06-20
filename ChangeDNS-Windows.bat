@echo off

REM List available network interfaces
echo Available network interfaces:
wmic nic where "NetConnectionID is not null" get index, NetConnectionID | findstr /r /v "^$" | findstr /r /c:"[0-9]"

REM Prompt the user to choose a network interface by index
set /p interface_index=Enter the index corresponding to the network interface: 

REM Get the name of the chosen network interface
for /F "skip=1 tokens=1,2 delims= " %%A in ('wmic nic where "NetConnectionID is not null" get index^, NetConnectionID ^| findstr /r /v "^$" ^| findstr /r /c:"[0-9]"') do (
    if "%%A" equ "%interface_index%" (
        set interface_name=%%B
    )
)

REM Check if the chosen network interface name is set
if not defined interface_name (
    echo Invalid index. Exiting.
    exit /b 1
    pause
)

REM Prompt the user to choose an option
echo DNS options:
echo 1. Set Shecan DNS
echo 2. Set Begzar DNS
echo 3. Set Electro DNS
echo 4. Set 403 DNS
echo 5. Clear DNS

set /p dns_choice=Enter your choice (1, 2): 

REM Set the DNS based on the user's choice
if "%dns_choice%"=="1" (
    netsh interface ip set dns name="%interface_name%" static 178.22.122.100 primary validate=no
    netsh interface ip add dns name="%interface_name%" 185.51.200.2 index=2 validate=no
) else if "%dns_choice%"=="2" (    
    netsh interface ip set dns name="%interface_name%" static 185.55.226.26 primary validate=no
    netsh interface ip add dns name="%interface_name%" 185.55.225.25 index=2 validate=no
) else if "%dns_choice%"=="3" (    
    netsh interface ip set dns name="%interface_name%" static 78.157.42.101 primary validate=no
    netsh interface ip add dns name="%interface_name%" 78.157.42.100 index=2 validate=no
) else if "%dns_choice%"=="4" (    
    netsh interface ip set dns name="%interface_name%" static 10.202.10.202 primary validate=no
    netsh interface ip add dns name="%interface_name%" 10.202.10.102 index=2 validate=no
) else if "%dns_choice%"=="5" (
    netsh interface ip set dns name="%interface_name%" source=dhcp
) else (
    echo Invalid choice. Exiting.
    exit /b 1
    pause
)

echo DNS settings changed successfully.
pause
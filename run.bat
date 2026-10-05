@echo off
chcp 65001 > nul
cls

echo =======================================================
echo ip ...
echo =======================================================
echo.

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set "MY_IP=%%a"
)
set "MY_IP=%MY_IP: =%"

echo open:
echo.
echo    http://%MY_IP%:8080
echo.
echo =======================================================
echo.

:: scrempt
powershell -ExecutionPolicy Bypass -File "%~dp0server.ps1"

pause

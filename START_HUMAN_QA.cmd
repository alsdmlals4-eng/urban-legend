@echo off
setlocal
chcp 65001 >nul
set "SCRIPT=%~dp0tools\qa\start_afterlife_canon_v2_human_qa.ps1"

if not exist "%SCRIPT%" (
  echo [ERROR] One-click Human QA script not found.
  echo %SCRIPT%
  if not "%HUMAN_QA_NO_PAUSE%"=="1" pause
  exit /b 2
)

where pwsh.exe >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  pwsh.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" %*
) else (
  powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%" %*
)

set "EXIT_CODE=%ERRORLEVEL%"
if not "%HUMAN_QA_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%

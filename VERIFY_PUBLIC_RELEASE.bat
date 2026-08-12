@echo off
setlocal
cd /d "%~dp0"
set "PY="
where py.exe >nul 2>nul && set "PY=py.exe"
if not defined PY where python.exe >nul 2>nul && set "PY=python.exe"
if not defined PY where python3.exe >nul 2>nul && set "PY=python3.exe"
if not defined PY (
  echo Python not found.
  pause
  exit /b 1
)
"%PY%" VERIFY_PUBLIC_RELEASE.py
echo.
pause

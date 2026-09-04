@echo off
setlocal
set "ROOT=%~dp0"
set "GODOT=%ROOT%.tools\godot-4.6.2\Godot_v4.6.2-stable_win64.exe"
set "PROJECT_ARG=--path ""%ROOT%"""

if not exist "%GODOT%" (
    echo Portable Godot runner not found:
    echo %GODOT%
    pause
    exit /b 1
)

for /f "delims=" %%P in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$root = [System.IO.Path]::GetFullPath(''%ROOT%''); $match = Get-CimInstance Win32_Process | Where-Object { $_.Name -eq ''Godot_v4.6.2-stable_win64.exe'' -and $_.CommandLine -like ('*--path*' + $root.TrimEnd(''\'') + '*' ) }; if ($match) { ''running'' }"') do set "GODOT_ALREADY_RUNNING=%%P"

if /i "%GODOT_ALREADY_RUNNING%"=="running" (
    echo This project is already running in Godot.
    echo Close the existing game window first so you do not stack extra copies.
    pause
    exit /b 0
)

start "" "%GODOT%" --path "%ROOT%"

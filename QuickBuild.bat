@echo off
REM ========================================================================
REM Quick Build Script - Creates standalone EXE from Application Portal
REM ========================================================================

echo.
echo ===================================================================
echo  APPLICATION PORTAL - STANDALONE EXE BUILDER
echo ===================================================================
echo.
echo This will create a standalone .exe file that can be run on any PC
echo without needing PowerShell scripts visible.
echo.
echo Default: Creates "PortalBuilder.exe" with no custom icon
echo.
echo To customize, edit this batch file and set:
echo   SET EXE_NAME=YourAppName
echo   SET ICON_FILE=C:\Path\To\YourIcon.ico
echo.
echo ===================================================================
echo.

REM ========================================================================
REM CONFIGURATION - Edit these values to customize your build
REM ========================================================================

REM Name for your executable (without .exe)
SET EXE_NAME=PortalBuilder

REM Path to custom icon file (.ico format recommended)
REM Leave empty for default Windows icon
SET ICON_FILE=

REM Output folder (leave empty for current folder)
SET OUTPUT_FOLDER=

REM ========================================================================
REM BUILD EXECUTION - Don't edit below this line
REM ========================================================================

echo Starting build process...
echo.

if "%ICON_FILE%"=="" (
    if "%OUTPUT_FOLDER%"=="" (
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0BuildStandaloneExe.ps1" -ExeName "%EXE_NAME%"
    ) else (
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0BuildStandaloneExe.ps1" -ExeName "%EXE_NAME%" -OutputFolder "%OUTPUT_FOLDER%"
    )
) else (
    if "%OUTPUT_FOLDER%"=="" (
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0BuildStandaloneExe.ps1" -ExeName "%EXE_NAME%" -IconPath "%ICON_FILE%"
    ) else (
        powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0BuildStandaloneExe.ps1" -ExeName "%EXE_NAME%" -IconPath "%ICON_FILE%" -OutputFolder "%OUTPUT_FOLDER%"
    )
)

echo.
echo ===================================================================
echo Build script completed!
echo ===================================================================
echo.
pause

@echo off
REM ============================================================================
REM Application Portal Builder Launcher
REM ============================================================================
REM This batch file launches the Portal Builder without requiring 
REM PowerShell execution policy changes or bypass switches.
REM
REM Usage: Double-click this file to start the Portal Builder
REM ============================================================================

echo.
echo Application Portal Builder
echo ==========================
echo.
echo Starting Portal Builder...
echo.

cd /d "%~dp0"

REM Use VBScript launcher to avoid ExecutionPolicy issues
cscript //nologo RunBuilder.vbs

if errorlevel 1 (
    echo.
    echo ERROR: Failed to launch Portal Builder
    echo Please ensure PortalBuilder.ps1 is in the same folder.
    echo.
    pause
)

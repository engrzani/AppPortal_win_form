' ============================================================================
' Application Portal Builder - VBScript Launcher
' ============================================================================
' This script launches the Portal Builder without requiring ExecutionPolicy
' changes. It reads the PowerShell script and executes it using Get-Content
' and Invoke-Expression method.
' ============================================================================

Option Explicit

Dim objShell, objFSO, strScriptPath, strCommand

' Create objects
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
strScriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)

' Change to script directory
objShell.CurrentDirectory = strScriptPath

' Build PowerShell command that doesn't require ExecutionPolicy bypass
' This method pipes the script content to PowerShell
strCommand = "powershell.exe -NoProfile -Command ""& { Get-Content -Path 'PortalBuilder.ps1' -Raw | Invoke-Expression }"""

' Execute the command
objShell.Run strCommand, 1, True

' Cleanup
Set objShell = Nothing
Set objFSO = Nothing

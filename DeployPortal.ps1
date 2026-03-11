<#
.SYNOPSIS
    Automated deployment script for Application Portal

.DESCRIPTION
    This script automates deployment of the Application Portal to multiple
    target PCs. It can be run manually, via Group Policy, or logon script.
    
    The script will:
    - Copy portal files to target PC
    - Create desktop shortcuts for all users
    - Create Start Menu entry
    - Verify deployment success
    - Log all actions

.PARAMETER SourcePath
    Network path to the ApplicationPortal folder
    Example: \\server\share\ApplicationPortal

.PARAMETER TargetPath
    Local path where portal should be installed
    Default: C:\ApplicationPortal

.PARAMETER CreateShortcuts
    Create shortcuts for all users (Public Desktop and Start Menu)
    Default: $true

.NOTES
    File Name      : DeployPortal.ps1
    Author         : IT Department
    Prerequisite   : Run with appropriate permissions to write to target paths
    Version        : 1.0
    
.EXAMPLE
    .\DeployPortal.ps1 -SourcePath "\\server\share\ApplicationPortal"
    
    Deploys portal from network share to default location C:\ApplicationPortal

.EXAMPLE
    .\DeployPortal.ps1 -SourcePath "\\server\share\ApplicationPortal" -TargetPath "C:\Apps\Portal"
    
    Deploys portal to custom location
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,
    
    [Parameter(Mandatory=$false)]
    [string]$TargetPath = "C:\ApplicationPortal",
    
    [Parameter(Mandatory=$false)]
    [bool]$CreateShortcuts = $true
)

# ============================================================================
# CONFIGURATION
# ============================================================================

$LogPath = Join-Path $env:TEMP "PortalDeployment.log"
$PublicDesktop = "C:\Users\Public\Desktop"
$StartMenuPrograms = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"

# ============================================================================
# FUNCTION: Write-Log
# ============================================================================
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    Write-Host $logMessage
    Add-Content -Path $LogPath -Value $logMessage
}

# ============================================================================
# FUNCTION: Test-AdminRights
# ============================================================================
function Test-AdminRights {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# ============================================================================
# MAIN DEPLOYMENT LOGIC
# ============================================================================

Write-Log "========================================" "INFO"
Write-Log "Application Portal Deployment Started" "INFO"
Write-Log "========================================" "INFO"
Write-Log "Source Path: $SourcePath" "INFO"
Write-Log "Target Path: $TargetPath" "INFO"
Write-Log "Computer: $env:COMPUTERNAME" "INFO"
Write-Log "User: $env:USERNAME" "INFO"

# Check if running with sufficient privileges
if ($CreateShortcuts -and -not (Test-AdminRights)) {
    Write-Log "WARNING: Not running as administrator. Shortcut creation may fail." "WARN"
}

# Verify source path exists
if (-not (Test-Path $SourcePath)) {
    Write-Log "ERROR: Source path not found: $SourcePath" "ERROR"
    exit 1
}

# Verify required files exist in source
$requiredFiles = @("portal.ps1", "config.json", "items.json")
$missingFiles = @()

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $SourcePath $file
    if (-not (Test-Path $filePath)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Log "ERROR: Missing required files: $($missingFiles -join ', ')" "ERROR"
    exit 1
}

Write-Log "Source validation successful" "INFO"

# Create target directory if it doesn't exist
try {
    if (-not (Test-Path $TargetPath)) {
        Write-Log "Creating target directory: $TargetPath" "INFO"
        New-Item -Path $TargetPath -ItemType Directory -Force | Out-Null
    }
    else {
        Write-Log "Target directory already exists" "INFO"
    }
}
catch {
    Write-Log "ERROR: Failed to create target directory: $_" "ERROR"
    exit 1
}

# Copy portal files
try {
    Write-Log "Copying portal files from $SourcePath to $TargetPath" "INFO"
    
    # Copy all files and subdirectories
    Get-ChildItem -Path $SourcePath -Recurse | ForEach-Object {
        $targetFile = $_.FullName.Replace($SourcePath, $TargetPath)
        $targetDir = Split-Path $targetFile -Parent
        
        if ($_.PSIsContainer) {
            if (-not (Test-Path $targetDir)) {
                New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
            }
        }
        else {
            if (-not (Test-Path $targetDir)) {
                New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
            }
            Copy-Item -Path $_.FullName -Destination $targetFile -Force
        }
    }
    
    Write-Log "File copy successful" "INFO"
}
catch {
    Write-Log "ERROR: Failed to copy files: $_" "ERROR"
    exit 1
}

# Create shortcuts if requested
if ($CreateShortcuts) {
    Write-Log "Creating shortcuts..." "INFO"
    
    try {
        $shell = New-Object -ComObject WScript.Shell
        
        # Public Desktop shortcut
        $desktopShortcut = Join-Path $PublicDesktop "Application Portal.lnk"
        Write-Log "Creating desktop shortcut: $desktopShortcut" "INFO"
        
        $shortcut = $shell.CreateShortcut($desktopShortcut)
        $shortcut.TargetPath = Join-Path $TargetPath "LaunchPortal.bat"
        $shortcut.WorkingDirectory = $TargetPath
        $shortcut.Description = "Launch Application Portal"
        $shortcut.IconLocation = "$env:SystemRoot\System32\imageres.dll,3"
        $shortcut.Save()
        
        # Start Menu shortcut
        $startMenuShortcut = Join-Path $StartMenuPrograms "Application Portal.lnk"
        Write-Log "Creating Start Menu shortcut: $startMenuShortcut" "INFO"
        
        $shortcut = $shell.CreateShortcut($startMenuShortcut)
        $shortcut.TargetPath = Join-Path $TargetPath "LaunchPortal.bat"
        $shortcut.WorkingDirectory = $TargetPath
        $shortcut.Description = "Launch Application Portal"
        $shortcut.IconLocation = "$env:SystemRoot\System32\imageres.dll,3"
        $shortcut.Save()
        
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
        
        Write-Log "Shortcuts created successfully" "INFO"
    }
    catch {
        Write-Log "WARNING: Failed to create shortcuts: $_" "WARN"
    }
}

# Verify deployment
Write-Log "Verifying deployment..." "INFO"
$verified = $true

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $TargetPath $file
    if (-not (Test-Path $filePath)) {
        Write-Log "ERROR: Verification failed - missing file: $file" "ERROR"
        $verified = $false
    }
}

if ($verified) {
    Write-Log "========================================" "INFO"
    Write-Log "Deployment completed successfully!" "INFO"
    Write-Log "========================================" "INFO"
    Write-Log "Portal installed at: $TargetPath" "INFO"
    Write-Log "Users can launch from:" "INFO"
    Write-Log "  - Desktop shortcut" "INFO"
    Write-Log "  - Start Menu > Application Portal" "INFO"
    Write-Log "  - Direct: $TargetPath\LaunchPortal.bat" "INFO"
    Write-Log "Log file: $LogPath" "INFO"
    
    exit 0
}
else {
    Write-Log "========================================" "ERROR"
    Write-Log "Deployment completed with errors!" "ERROR"
    Write-Log "========================================" "ERROR"
    Write-Log "Log file: $LogPath" "INFO"
    
    exit 1
}

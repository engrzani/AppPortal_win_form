<#
.SYNOPSIS
    Removes Windows user profiles older than specified days from shared PCs

.DESCRIPTION
    This script identifies and removes user profiles that have not been used
    for a specified number of days. It cleans both the C:\Users folder and
    registry entries. Designed for shared PC environments to manage disk space.
    
    Features:
    - Identifies profiles older than threshold (default 90 days)
    - Removes profile folder from C:\Users
    - Removes registry entry from ProfileList
    - Protects system profiles (Administrator, Public, Default, etc.)
    - Comprehensive logging
    - Dry-run mode for testing
    - Automatic exclusion of currently logged-in users

.PARAMETER DaysOld
    Number of days of inactivity before profile is considered old. Default is 90.

.PARAMETER DryRun
    If specified, shows what would be deleted without actually deleting.

.PARAMETER ExcludeUsers
    Array of usernames to exclude from deletion (in addition to system accounts).

.PARAMETER LogPath
    Path where log file will be created. Default is script directory.

.NOTES
    File Name      : CleanOldProfiles.ps1
    Author         : IT Department
    Prerequisite   : PowerShell 3.0, Administrator privileges
    Version        : 1.0
    Date           : March 2026
    
    IMPORTANT: This script requires Administrator privileges.
    Always test with -DryRun first before actual deletion.

.EXAMPLE
    .\CleanOldProfiles.ps1 -DryRun
    Shows which profiles would be deleted without actually deleting them.

.EXAMPLE
    .\CleanOldProfiles.ps1 -DaysOld 90
    Removes profiles not used in the last 90 days.

.EXAMPLE
    .\CleanOldProfiles.ps1 -DaysOld 60 -ExcludeUsers @("john.doe", "it.admin")
    Removes profiles older than 60 days, excluding specific users.

.EXAMPLE
    .\CleanOldProfiles.ps1 -DaysOld 90 -LogPath "C:\Logs"
    Removes old profiles and saves log to C:\Logs folder.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$false)]
    [int]$DaysOld = 90,
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [string[]]$ExcludeUsers = @(),
    
    [Parameter(Mandatory=$false)]
    [string]$LogPath = $PSScriptRoot
)

# Check for Administrator privileges
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Error "This script requires Administrator privileges. Please run as Administrator."
    exit 1
}

# Setup logging
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$logFile = Join-Path $LogPath "ProfileCleanup_$timestamp.log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
    Add-Content -Path $logFile -Value $logMessage -Force
    
    switch ($Level) {
        "ERROR"   { Write-Host $logMessage -ForegroundColor Red }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        default   { Write-Host $logMessage }
    }
}

# System profiles that should never be deleted
$systemProfiles = @(
    "Administrator",
    "Default",
    "Default User",
    "Public",
    "All Users",
    "DefaultAppPool",
    "ADMINI~1",
    "systemprofile",
    "LocalService",
    "NetworkService"
)

# Get currently logged in users
$loggedInUsers = @()
try {
    $sessions = quser 2>$null
    if ($sessions) {
        foreach ($session in $sessions) {
            if ($session -match '^\s*(\S+)\s+') {
                $username = $Matches[1]
                if ($username -ne "USERNAME") {
                    $loggedInUsers += $username
                }
            }
        }
    }
}
catch {
    Write-Log "Could not determine logged in users. Proceeding with caution." "WARNING"
}

Write-Log "========================================="
Write-Log "Profile Cleanup Script Started"
Write-Log "========================================="
Write-Log "Computer: $env:COMPUTERNAME"
Write-Log "Threshold: $DaysOld days"
Write-Log "Dry Run: $DryRun"
Write-Log "Log File: $logFile"
Write-Log ""

# Calculate cutoff date
$cutoffDate = (Get-Date).AddDays(-$DaysOld)
Write-Log "Cutoff Date: $($cutoffDate.ToString('yyyy-MM-dd'))"
Write-Log ""

# Get all user profiles from registry
$profileListPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
$profiles = Get-ChildItem -Path $profileListPath | Where-Object { $_.PSChildName -like "S-1-5-21-*" }

$totalProfiles = 0
$deletedProfiles = 0
$skippedProfiles = 0
$errorProfiles = 0
$freedSpace = 0

Write-Log "Found $($profiles.Count) user profiles in registry"
Write-Log ""

foreach ($profile in $profiles) {
    $totalProfiles++
    
    $sid = $profile.PSChildName
    $profilePath = (Get-ItemProperty -Path $profile.PSPath).ProfileImagePath
    $username = Split-Path $profilePath -Leaf
    
    # Skip if profile path doesn't exist
    if (-not (Test-Path $profilePath)) {
        Write-Log "Profile path not found: $profilePath (Orphaned registry entry)" "WARNING"
        Write-Log "  SID: $sid" "WARNING"
        continue
    }
    
    # Get profile folder last write time
    try {
        $profileFolder = Get-Item $profilePath -Force
        $lastUsed = $profileFolder.LastWriteTime
        $daysInactive = (New-TimeSpan -Start $lastUsed -End (Get-Date)).Days
        
        # Determine if profile should be deleted
        $shouldDelete = $false
        $skipReason = ""
        
        # Check system profiles
        if ($systemProfiles -contains $username) {
            $skipReason = "System profile"
        }
        # Check excluded users
        elseif ($ExcludeUsers -contains $username) {
            $skipReason = "Excluded by parameter"
        }
        # Check currently logged in
        elseif ($loggedInUsers -contains $username) {
            $skipReason = "Currently logged in"
        }
        # Check age
        elseif ($daysInactive -lt $DaysOld) {
            $skipReason = "Used recently ($daysInactive days ago)"
        }
        else {
            $shouldDelete = $true
        }
        
        # Log profile info
        if ($shouldDelete) {
            $folderSize = 0
            try {
                $folderSize = (Get-ChildItem $profilePath -Recurse -Force -ErrorAction SilentlyContinue | 
                    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1MB
            }
            catch {
                $folderSize = 0
            }
            
            Write-Log "==========================================" "WARNING"
            Write-Log "PROFILE TO DELETE: $username" "WARNING"
            Write-Log "  Path: $profilePath" "WARNING"
            Write-Log "  SID: $sid" "WARNING"
            Write-Log "  Last Used: $($lastUsed.ToString('yyyy-MM-dd HH:mm:ss'))" "WARNING"
            Write-Log "  Days Inactive: $daysInactive" "WARNING"
            Write-Log "  Size: $([math]::Round($folderSize, 2)) MB" "WARNING"
            
            if ($DryRun) {
                Write-Log "  [DRY RUN] Would delete this profile" "WARNING"
                $deletedProfiles++
                $freedSpace += $folderSize
            }
            else {
                # Attempt deletion
                try {
                    Write-Log "  Deleting profile folder..." "WARNING"
                    Remove-Item -Path $profilePath -Recurse -Force -ErrorAction Stop
                    
                    Write-Log "  Deleting registry entry..." "WARNING"
                    Remove-Item -Path $profile.PSPath -Recurse -Force -ErrorAction Stop
                    
                    Write-Log "  Profile deleted successfully" "SUCCESS"
                    $deletedProfiles++
                    $freedSpace += $folderSize
                }
                catch {
                    Write-Log "  ERROR deleting profile: $($_.Exception.Message)" "ERROR"
                    $errorProfiles++
                }
            }
            Write-Log ""
        }
        else {
            Write-Log "Skipped: $username - $skipReason (Last used: $($lastUsed.ToString('yyyy-MM-dd')), $daysInactive days ago)"
            $skippedProfiles++
        }
    }
    catch {
        Write-Log "Error processing profile $username : $($_.Exception.Message)" "ERROR"
        $errorProfiles++
    }
}

# Summary
Write-Log ""
Write-Log "========================================="
Write-Log "Profile Cleanup Summary"
Write-Log "========================================="
Write-Log "Total Profiles Scanned: $totalProfiles"
Write-Log "Profiles Deleted: $deletedProfiles"
Write-Log "Profiles Skipped: $skippedProfiles"
Write-Log "Errors Encountered: $errorProfiles"
Write-Log "Estimated Space Freed: $([math]::Round($freedSpace / 1024, 2)) GB"
if ($DryRun) {
    Write-Log ""
    Write-Log "DRY RUN MODE - No profiles were actually deleted" "WARNING"
    Write-Log "Run without -DryRun to perform actual deletion" "WARNING"
}
Write-Log "========================================="
Write-Log "Log saved to: $logFile"
Write-Log "========================================="

# Return summary object
return [PSCustomObject]@{
    TotalScanned = $totalProfiles
    Deleted = $deletedProfiles
    Skipped = $skippedProfiles
    Errors = $errorProfiles
    SpaceFreedMB = [math]::Round($freedSpace, 2)
    SpaceFreedGB = [math]::Round($freedSpace / 1024, 2)
    DryRun = $DryRun.IsPresent
    LogFile = $logFile
}

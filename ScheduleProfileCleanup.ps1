<#
.SYNOPSIS
    Creates a scheduled task to automatically clean old user profiles

.DESCRIPTION
    This script creates a Windows scheduled task that runs CleanOldProfiles.ps1
    on a regular schedule (weekly by default). Useful for shared PC environments
    to automatically manage disk space.

.PARAMETER DaysOld
    Number of days before profile is considered old. Default is 90.

.PARAMETER ScheduleType
    When to run the cleanup: Daily, Weekly, or Monthly. Default is Weekly.

.PARAMETER DayOfWeek
    For weekly schedule, which day to run (Sunday, Monday, etc.). Default is Sunday.

.PARAMETER Time
    Time of day to run (24-hour format). Default is "02:00" (2 AM).

.PARAMETER ExcludeUsers
    Users to never delete, in addition to system accounts.

.NOTES
    File Name      : ScheduleProfileCleanup.ps1
    Prerequisite   : PowerShell 3.0, Administrator privileges
    Version        : 1.0
    
.EXAMPLE
    .\ScheduleProfileCleanup.ps1
    Creates weekly task on Sundays at 2 AM to delete profiles older than 90 days.

.EXAMPLE
    .\ScheduleProfileCleanup.ps1 -DaysOld 60 -ScheduleType Daily -Time "03:00"
    Creates daily task at 3 AM to delete profiles older than 60 days.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [int]$DaysOld = 90,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Daily", "Weekly", "Monthly")]
    [string]$ScheduleType = "Weekly",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")]
    [string]$DayOfWeek = "Sunday",
    
    [Parameter(Mandatory=$false)]
    [string]$Time = "02:00",
    
    [Parameter(Mandatory=$false)]
    [string[]]$ExcludeUsers = @()
)

# Check for Administrator privileges
$currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script requires Administrator privileges. Please run as Administrator."
    exit 1
}

$taskName = "CleanOldUserProfiles"
$taskDescription = "Automatically removes user profiles older than $DaysOld days to free disk space on shared PCs"

# Build script arguments
$scriptPath = Join-Path $PSScriptRoot "CleanOldProfiles.ps1"
if (-not (Test-Path $scriptPath)) {
    Write-Error "CleanOldProfiles.ps1 not found at: $scriptPath"
    exit 1
}

$arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`" -DaysOld $DaysOld"
if ($ExcludeUsers.Count -gt 0) {
    $userList = ($ExcludeUsers | ForEach-Object { "`"$_`"" }) -join ","
    $arguments += " -ExcludeUsers @($userList)"
}

# Create scheduled task action
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arguments

# Create trigger based on schedule type
switch ($ScheduleType) {
    "Daily" {
        $trigger = New-ScheduledTaskTrigger -Daily -At $Time
    }
    "Weekly" {
        $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $DayOfWeek -At $Time
    }
    "Monthly" {
        $trigger = New-ScheduledTaskTrigger -At $Time -Weekly -WeeksInterval 4
    }
}

# Create task principal (run as SYSTEM with highest privileges)
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Create task settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false `
    -MultipleInstances IgnoreNew

# Check if task already exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Scheduled task '$taskName' already exists. Updating..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Register the task
try {
    Register-ScheduledTask `
        -TaskName $taskName `
        -Description $taskDescription `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Settings $settings `
        -Force | Out-Null
    
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Scheduled Task Created Successfully!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Task Name: $taskName"
    Write-Host "Schedule: $ScheduleType"
    if ($ScheduleType -eq "Weekly") {
        Write-Host "Day: $DayOfWeek"
    }
    Write-Host "Time: $Time"
    Write-Host "Profile Age Threshold: $DaysOld days"
    Write-Host "Script: $scriptPath"
    Write-Host ""
    Write-Host "To view the task:" -ForegroundColor Cyan
    Write-Host "  Get-ScheduledTask -TaskName '$taskName' | fl" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To run manually:" -ForegroundColor Cyan
    Write-Host "  Start-ScheduledTask -TaskName '$taskName'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To remove the task:" -ForegroundColor Cyan
    Write-Host "  Unregister-ScheduledTask -TaskName '$taskName' -Confirm:`$false" -ForegroundColor Gray
    Write-Host "=========================================" -ForegroundColor Green
}
catch {
    Write-Error "Failed to create scheduled task: $($_.Exception.Message)"
    exit 1
}

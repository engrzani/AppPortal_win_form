<#
.SYNOPSIS
    Build standalone executable for Application Portal Builder

.DESCRIPTION
    This script compiles PortalBuilder.ps1 into a standalone .exe file using PS2EXE.
    The resulting executable:
    - Does NOT require PowerShell scripts to be visible
    - Can be renamed to any application name you want
    - Supports custom icons (.ico files)
    - Is completely portable - just copy and run
    - Protects your source code from viewing/modification

.PARAMETER ExeName
    Name for the output executable (without .exe extension)
    Default: "PortalBuilder"

.PARAMETER IconPath
    Path to custom .ico file for the application icon
    If not specified, uses default Windows icon

.PARAMETER OutputFolder
    Where to save the compiled EXE
    Default: Current script directory

.EXAMPLE
    .\BuildStandaloneExe.ps1
    Creates PortalBuilder.exe with default settings

.EXAMPLE
    .\BuildStandaloneExe.ps1 -ExeName "CompanyApps" -IconPath "C:\Icons\company.ico"
    Creates CompanyApps.exe with custom icon

.NOTES
    Requirements:
    - PowerShell 5.1 or higher
    - Internet connection (first run only, to download PS2EXE module)
    - .NET Framework 4.0+
    
    The PS2EXE module will be automatically installed if not present.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$ExeName = "PortalBuilder",
    
    [Parameter(Mandatory=$false)]
    [string]$IconPath = "",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFolder = ""
)

# ============================================================================
# CONFIGURATION
# ============================================================================

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
    $OutputFolder = $scriptDir
}

# Ensure ExeName doesn't have .exe extension
$ExeName = $ExeName -replace '\.exe$', ''

# ============================================================================
# FUNCTIONS
# ============================================================================

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-ColorOutput "═══════════════════════════════════════════════════════════" "Cyan"
    Write-ColorOutput " $Message" "Cyan"
    Write-ColorOutput "═══════════════════════════════════════════════════════════" "Cyan"
}

function Write-Success {
    param([string]$Message)
    Write-ColorOutput "✓ $Message" "Green"
}

function Write-Info {
    param([string]$Message)
    Write-ColorOutput "  $Message" "Gray"
}

function Write-Warning {
    param([string]$Message)
    Write-ColorOutput "⚠ $Message" "Yellow"
}

function Write-Failure {
    param([string]$Message)
    Write-ColorOutput "✗ $Message" "Red"
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-PS2EXE {
    Write-Step "Checking PS2EXE Module"
    
    $module = Get-Module -ListAvailable -Name PS2EXE
    
    if ($module) {
        Write-Success "PS2EXE module already installed (Version: $($module.Version))"
        return $true
    }
    
    Write-Info "PS2EXE module not found. Installing..."
    
    # Check if running as administrator
    if (-not (Test-Administrator)) {
        Write-Warning "Not running as Administrator"
        Write-Info "Attempting user-scope installation..."
        
        try {
            Install-Module -Name PS2EXE -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop
            Write-Success "PS2EXE installed successfully (CurrentUser scope)"
            return $true
        }
        catch {
            Write-Failure "Failed to install PS2EXE"
            Write-Info "Error: $($_.Exception.Message)"
            Write-Info ""
            Write-Warning "Please run PowerShell as Administrator and try again, OR"
            Write-Info "Manually install PS2EXE by running:"
            Write-Info "  Install-Module -Name PS2EXE -Scope CurrentUser -Force"
            return $false
        }
    }
    else {
        try {
            Install-Module -Name PS2EXE -Scope AllUsers -Force -AllowClobber -ErrorAction Stop
            Write-Success "PS2EXE installed successfully (AllUsers scope)"
            return $true
        }
        catch {
            Write-Failure "Failed to install PS2EXE"
            Write-Info "Error: $($_.Exception.Message)"
            return $false
        }
    }
}

function Test-IconFile {
    param([string]$Path)
    
    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $true  # No icon specified is OK
    }
    
    if (-not (Test-Path $Path)) {
        Write-Failure "Icon file not found: $Path"
        return $false
    }
    
    $extension = [System.IO.Path]::GetExtension($Path).ToLower()
    if ($extension -ne ".ico") {
        Write-Warning "Icon file should be .ico format for best compatibility"
        Write-Info "Current file: $extension"
        Write-Info "The compilation will continue, but consider converting to .ico"
    }
    
    return $true
}

function Compile-ToExe {
    param(
        [string]$SourceScript,
        [string]$OutputExe,
        [string]$Icon
    )
    
    Write-Step "Compiling to Standalone EXE"
    
    # Verify source script exists
    if (-not (Test-Path $SourceScript)) {
        Write-Failure "Source script not found: $SourceScript"
        return $false
    }
    
    Write-Info "Source Script:  $SourceScript"
    Write-Info "Output EXE:     $OutputExe"
    if (![string]::IsNullOrWhiteSpace($Icon)) {
        Write-Info "Icon File:      $Icon"
    } else {
        Write-Info "Icon File:      (default Windows icon)"
    }
    
    Write-Info ""
    Write-Info "Compiling... (this may take 30-60 seconds)"
    
    try {
        # Import the module
        Import-Module PS2EXE -ErrorAction Stop
        
        # Build parameters for PS2EXE
        $ps2exeParams = @{
            inputFile = $SourceScript
            outputFile = $OutputExe
            noConsole = $true
            noOutput = $true
            noError = $false
            requireAdmin = $false
            verbose = $false
            title = $ExeName
            description = "Application Portal Builder"
            company = "IT Department"
            product = "Application Portal"
            copyright = "© 2026"
            version = "1.0.0.0"
        }
        
        # Add icon if specified
        if (![string]::IsNullOrWhiteSpace($Icon) -and (Test-Path $Icon)) {
            $ps2exeParams.iconFile = $Icon
        }
        
        # Compile
        Invoke-PS2EXE @ps2exeParams
        
        # Verify output
        if (Test-Path $OutputExe) {
            $fileInfo = Get-Item $OutputExe
            $fileSizeMB = [math]::Round($fileInfo.Length / 1MB, 2)
            
            Write-Success "Compilation successful!"
            Write-Info "File: $OutputExe"
            Write-Info "Size: $fileSizeMB MB"
            return $true
        }
        else {
            Write-Failure "Compilation completed but EXE not found"
            return $false
        }
    }
    catch {
        Write-Failure "Compilation failed"
        Write-Info "Error: $($_.Exception.Message)"
        Write-Info ""
        Write-Info "Common issues:"
        Write-Info "  1. Antivirus blocking compilation"
        Write-Info "  2. .NET Framework not installed"
        Write-Info "  3. Insufficient permissions"
        return $false
    }
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

Clear-Host

Write-ColorOutput ""
Write-ColorOutput "╔══════════════════════════════════════════════════════════╗" "Cyan"
Write-ColorOutput "║                                                          ║" "Cyan"
Write-ColorOutput "║    APPLICATION PORTAL BUILDER - EXE COMPILER             ║" "Cyan"
Write-ColorOutput "║                                                          ║" "Cyan"
Write-ColorOutput "╚══════════════════════════════════════════════════════════╝" "Cyan"
Write-ColorOutput ""

# Display configuration
Write-Info "Build Configuration:"
Write-Info "  Output Name:    $ExeName.exe"
Write-Info "  Output Folder:  $OutputFolder"
if (![string]::IsNullOrWhiteSpace($IconPath)) {
    Write-Info "  Icon File:      $IconPath"
} else {
    Write-Info "  Icon File:      (default)"
}
Write-Info ""

# Step 1: Install PS2EXE if needed
if (-not (Install-PS2EXE)) {
    Write-ColorOutput ""
    Write-Failure "Build aborted: PS2EXE module not available"
    exit 1
}

# Step 2: Validate icon file
if (![string]::IsNullOrWhiteSpace($IconPath)) {
    if (-not (Test-IconFile -Path $IconPath)) {
        Write-ColorOutput ""
        Write-Failure "Build aborted: Icon file invalid"
        exit 1
    }
}

# Step 3: Compile to EXE
$sourceScript = Join-Path $scriptDir "PortalBuilder.ps1"
$outputExe = Join-Path $OutputFolder "$ExeName.exe"

if (-not (Compile-ToExe -SourceScript $sourceScript -OutputExe $outputExe -Icon $IconPath)) {
    Write-ColorOutput ""
    Write-Failure "Build failed!"
    exit 1
}

# ============================================================================
# SUCCESS SUMMARY
# ============================================================================

Write-ColorOutput ""
Write-ColorOutput "╔══════════════════════════════════════════════════════════╗" "Green"
Write-ColorOutput "║                                                          ║" "Green"
Write-ColorOutput "║                ✓  BUILD SUCCESSFUL!                      ║" "Green"
Write-ColorOutput "║                                                          ║" "Green"
Write-ColorOutput "╚══════════════════════════════════════════════════════════╝" "Green"
Write-ColorOutput ""

Write-Info "Your standalone executable is ready:"
Write-ColorOutput "  $outputExe" "Yellow"
Write-Info ""
Write-Info "What you can do now:"
Write-Info "  ✓ Copy this .exe to any Windows PC"
Write-Info "  ✓ Run it by double-clicking (no installation needed)"
Write-Info "  ✓ No PowerShell scripts required"
Write-Info "  ✓ Your source code is protected"
Write-Info ""
Write-Info "The EXE will show in:"
Write-Info "  • File Explorer (file icon)"
Write-Info "  • Desktop (if you create a shortcut)"
Write-Info "  • Taskbar (when running)"
Write-Info ""

Write-ColorOutput "Press any key to exit..." "Gray"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Standalone EXE Build Guide

## Complete Guide to Building a Standalone Executable

This guide explains how to compile your Application Portal Builder into a **standalone .exe file** that can be distributed and run on any Windows PC without requiring PowerShell scripts to be visible.

---

## Table of Contents

1. [Overview](#overview)
2. [What You Get](#what-you-get)
3. [Prerequisites](#prerequisites)
4. [Quick Start (Easiest Method)](#quick-start-easiest-method)
5. [Advanced Build Options](#advanced-build-options)
6. [Custom Icons](#custom-icons)
7. [Deployment](#deployment)
8. [Troubleshooting](#troubleshooting)
9. [FAQ](#faq)

---

## Overview

The standalone EXE build process converts your PowerShell-based application into a single executable file using **PS2EXE**, a PowerShell module that compiles scripts into Windows executables.

### Benefits of Standalone EXE

- **No visible source code** - PS1 files are compiled into the EXE, protected from viewing/modification  
- **Single file distribution** - Just copy one `.exe` file to target PCs  
- **Professional appearance** - Custom application name and icon  
- **No installation required** - Double-click to run, works immediately  
- **Corporate-friendly** - Works with security policies, no script execution concerns  
- **Icon everywhere** - Your custom icon shows in Explorer, taskbar, desktop, and Alt+Tab  

---

## What You Get

After building, you'll have:

```
CompanyApps.exe          ← Your standalone executable
  ├─ Application code      (compiled from PortalBuilder.ps1)
  ├─ Custom icon           (if provided)
  └─ All functionality     (no external files needed)
```

**You can:**
- Copy `CompanyApps.exe` directly to any Windows PC
- Place it on the desktop and double-click to launch
- No PowerShell scripts needed on target PC
- No installation or configuration required

**Deployment:**
```
Source PC (Build):              Target PC (Deploy):
┌─────────────────┐            ┌──────────────────┐
│ PortalBuilder/  │            │                  │
│ ├─ Scripts      │  ──────>   │  CompanyApps.exe │
│ ├─ Build tools  │   Copy     │                  │
│ └─ Icons        │    just    │  (Everything     │
└─────────────────┘   the EXE! │   is inside)     │
                                └──────────────────┘
```

---

## Prerequisites

### Required:
- Windows 7 or later
- PowerShell 5.1 or higher (pre-installed on Windows 10/11)
- .NET Framework 4.0+ (usually pre-installed)
- Internet connection (first build only, to download PS2EXE module)

### Optional:
- 📦 Administrator rights (for system-wide PS2EXE installation)
  - *Note: Not required - can install for current user only*
- Custom `.ico` file for application icon
  - *See ICON_GUIDE.md for details*

### Check Your PowerShell Version:
```powershell
$PSVersionTable.PSVersion
```
Should show version 5.1 or higher.

---

## Quick Start (Easiest Method)

### Step 1: One-Click Build

Simply **double-click** `QuickBuild.bat`

That's it! The script will:
1. Check if PS2EXE is installed
2. Install PS2EXE if needed (automatically)
3. Compile PortalBuilder.ps1 to PortalBuilder.exe
4. Show success message with file location

**First time build** will take 1-2 minutes (downloading PS2EXE module).  
**Subsequent builds** take 30-60 seconds.

### Step 2: Test Your EXE

After the build completes:

1. Find `PortalBuilder.exe` in your build folder
2. Double-click to run it
3. The Application Portal Builder should launch

---

## Advanced Build Options

### Option 1: Custom Application Name

Edit `QuickBuild.bat` before running:

```batch
REM Change the name of your executable
SET EXE_NAME=CompanyApps

REM Leave icon empty for now
SET ICON_FILE=
```

Run `QuickBuild.bat` → Creates `CompanyApps.exe`

### Option 2: Custom Name + Icon

Edit `QuickBuild.bat`:

```batch
REM Custom name
SET EXE_NAME=Corporate Application Portal

REM Custom icon (place MyIcon.ico in same folder)
SET ICON_FILE=MyIcon.ico
```

Run `QuickBuild.bat` → Creates `Corporate Application Portal.exe` with your icon

### Option 3: Full Control via PowerShell

For maximum control, run the PowerShell script directly:

```powershell
.\BuildStandaloneExe.ps1 `
    -ExeName "Corporate Apps" `
    -IconPath "C:\Icons\CompanyLogo.ico" `
    -OutputFolder "C:\Builds"
```

**Parameters:**
| Parameter | Description | Default |
|-----------|-------------|---------|
| `-ExeName` | Name of output EXE (without .exe) | PortalBuilder |
| `-IconPath` | Path to .ico file | (none - uses default) |
| `-OutputFolder` | Where to save the EXE | Current folder |

---

## Custom Icons

Adding a custom icon makes your application look professional and branded.

### Quick Icon Setup

1. **Get or Create Icon**
   - Use your company logo
   - Download from free icon sites
   - Create using online converter
   - See **ICON_GUIDE.md** for detailed instructions

2. **Place Icon File**
   - Save `.ico` file in PortalBuilder folder
   - Example: `CompanyLogo.ico`

3. **Configure Build**
   Edit `QuickBuild.bat`:
   ```batch
   SET EXE_NAME=CompanyPortal
   SET ICON_FILE=CompanyLogo.ico
   ```

4. **Build**
   - Run `QuickBuild.bat`
   - Your EXE now has the custom icon!

### Where Your Icon Appears

After building with a custom icon:

| Location | Appears |
|----------|---------|
| **File Explorer** | Your icon shows next to the .exe file |
| **Desktop Shortcut** | Desktop shortcut shows your icon |
| **Taskbar** | Running app shows your icon in taskbar |
| **Alt+Tab** | Window switcher shows your icon |
| **Properties** | File properties dialog shows your icon |

**For complete icon instructions, see [ICON_GUIDE.md](ICON_GUIDE.md)**

---

## Deployment

Once your standalone EXE is built, deployment is simple:

### Method 1: Manual Copy (Simplest)

1. Copy `YourApp.exe` to target PC
2. Place on desktop or in a folder (e.g., `C:\Apps\`)
3. Double-click to run
4. **Done!** No installation or configuration needed

### Method 2: Network Share

1. Place `YourApp.exe` on network share
2. Users can run directly from the share
3. Or copy to local PC for offline use

### Method 3: Automated Deployment

If deploying to many PCs:

**Option A: Group Policy**
```powershell
# Logon script
$sourcePath = "\\server\share\CompanyApps.exe"
$targetPath = "C:\Apps\CompanyApps.exe"

if (-not (Test-Path "C:\Apps")) {
    New-Item -Path "C:\Apps" -ItemType Directory
}

Copy-Item -Path $sourcePath -Destination $targetPath -Force

# Create desktop shortcut for all users
$shortcut = "C:\Users\Public\Desktop\Company Apps.lnk"
$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortcut($shortcut)
$sc.TargetPath = $targetPath
$sc.Save()
```

**Option B: Use Provided DeployPortal.ps1**
- Modify to deploy just the EXE instead of full folder
- See USER_GUIDE.md for deployment script details

### What Gets Deployed?

**Traditional deployment (old way):**
```
\\server\share\ApplicationPortal\
  ├─ PortalBuilder.ps1          ← Visible source code
  ├─ RunPortal.exe              ← Launcher
  ├─ Config files
  └─ Other scripts
```

**Standalone EXE deployment (new way):**
```
\\server\share\
  └─ CompanyApps.exe            ← Everything in one file!
```

---

## Troubleshooting

### Build Issues

#### Issue: "PS2EXE module not found" and installation failed

**Solution 1: Run as Administrator**
```powershell
# Right-click PowerShell → Run as Administrator
.\BuildStandaloneExe.ps1
```

**Solution 2: Manual Installation**
```powershell
# Run in PowerShell (as admin):
Install-Module -Name PS2EXE -Scope AllUsers -Force

# OR for current user only (no admin needed):
Install-Module -Name PS2EXE -Scope CurrentUser -Force
```

**Solution 3: Check PowerShell Gallery Access**
```powershell
# Test connection
Find-Module -Name PS2EXE

# If that fails, configure trusted repository:
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
```

---

#### Issue: Build fails with "Access Denied"

**Cause:** Antivirus blocking compilation

**Solution:**
1. Temporarily disable antivirus
2. Add build folder to antivirus exclusions
3. Rebuild
4. Re-enable antivirus

---

#### Issue: "Execution policy" error

**Solution:**
```batch
REM Run QuickBuild.bat as Administrator, OR
REM Set execution policy:
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force"
```

---

### Runtime Issues

#### Issue: Double-clicking EXE does nothing

**Diagnosis:**
1. Run from Command Prompt to see any error messages:
   ```cmd
   CompanyApps.exe
   ```

2. Check if .NET Framework is installed:
   ```cmd
   reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" /v Version
   ```

**Solution:**
- Install .NET Framework 4.8: https://dotnet.microsoft.com/download/dotnet-framework

---

#### Issue: Icon doesn't appear

**Solutions:**
1. Verify icon was included in build:
   - Right-click EXE → Properties
   - Icon should appear in properties dialog

2. Rebuild with correct icon path:
   ```batch
   SET ICON_FILE=C:\Full\Path\To\Icon.ico
   ```

3. Clear Windows icon cache (if icon shows in properties but not Explorer):
   ```cmd
   taskkill /f /im explorer.exe
   del /a /q "%localappdata%\IconCache.db"
   start explorer.exe
   ```

---

#### Issue: Antivirus flags EXE as suspicious

**Cause:** PS2EXE-generated executables are sometimes flagged by antivirus (false positive)

**Solutions:**

1. **Submit to antivirus vendor as false positive**
   - Most vendors have online submission forms
   - Usually resolved within 24-48 hours

2. **Add to antivirus exclusions**
   - Add your built EXE to exclusion list
   - Document for IT department

3. **Code signing (corporate environments)**
   - Sign the EXE with your company's code signing certificate
   - Eliminates most antivirus warnings
   ```powershell
   # After building EXE, sign it:
   signtool sign /f "C:\Certificates\CompanyCert.pfx" /p "password" /t http://timestamp.digicert.com "CompanyApps.exe"
   ```

---

## FAQ

### Q: Does the EXE really work without PowerShell scripts?

**A:** Yes! The PS2EXE module compiles your PowerShell script into a standalone Windows executable. The PowerShell code is embedded in the EXE. You do NOT need to distribute any `.ps1` files.

### Q: Can users see my source code?

**A:** No. The PowerShell script is compiled into the EXE. While it's theoretically possible to decompile (like any .NET application), it's much more protected than distributing raw `.ps1` files.

### Q: Can I rename the EXE after building?

**A:** Yes, you can rename the `.exe` file after building. However, it's better to use the `-ExeName` parameter during build so internal metadata matches the filename.

### Q: Does this work on Windows 7? Windows 11?

**A:** Yes! The compiled EXE works on:
- Windows 7, 8, 8.1, 10, 11
- Windows Server 2008 R2 and later

Requirements:
- .NET Framework 4.0+ (usually pre-installed)
- PowerShell installed (but users don't interact with it directly)

### Q: What's the file size of the EXE?

**A:** Typical size: **5-15 MB** depending on:
- Complexity of your PowerShell script
- Number of .NET assemblies loaded
- Whether icon is embedded

This is normal for compiled .NET applications.

### Q: Can I distribute the EXE commercially?

**A:** Yes. PS2EXE is open-source (license allows commercial use). Your compiled application can be distributed freely in commercial environments.

### Q: Does this require admin rights to run?

**A:** No. The compiled EXE runs with the same permissions as the original PowerShell script. If your script doesn't need admin rights, neither does the EXE.

### Q: How do I update the application?

**A:** 
1. Modify `PortalBuilder.ps1`
2. Run build process again
3. Replace old EXE with new EXE on target PCs

Consider adding version numbers to your EXE name for clarity:
```batch
SET EXE_NAME=CompanyApps_v2.0
```

### Q: Can I include multiple icons (for different files/sizes)?

**A:** Yes, `.ico` files can contain multiple resolutions. When you create your icon, include these sizes:
- 16x16 (small icons)
- 32x32 (standard)
- 48x48 (large icons)
- 256x256 (Windows 7+ high-res)

Most icon converters automatically create multi-resolution icons.

### Q: What if I want to change the icon later?

**A:** You have two options:

1. **Rebuild the EXE** (recommended)
   - Use new icon file
   - Run build process again
   - Produces EXE with new icon embedded

2. **Use Resource Editor** (advanced)
   - Tools like Resource Hacker can edit icons in existing EXE
   - Not recommended for beginners

### Q: Does this work with the actual Portal application too?

**A:** Yes! The same process can compile the generated Portal application. However, the Portal application (created by PortalBuilder) already includes its own EXE launcher in the output folder.

This build process is specifically for compiling the **Builder** itself into a standalone EXE.

---

## Build Process Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                     BUILD PROCESS                             │
└──────────────────────────────────────────────────────────────┘

Step 1: Prepare
├─ PortalBuilder.ps1     (your application)
├─ CompanyLogo.ico       (optional custom icon)
└─ BuildStandaloneExe.ps1 (build script)

                    ↓

Step 2: Run Build
├─ Execute: QuickBuild.bat
├─ PS2EXE checks and installs if needed
└─ Compilation begins (30-60 seconds)

                    ↓

Step 3: Output
└─ CompanyApps.exe  ✅
    ├─ Contains all application code
    ├─ Custom icon embedded
    └─ Ready to distribute

                    ↓

Step 4: Deploy
├─ Copy EXE to target PC
├─ Place on desktop or program folder
└─ Double-click to run - Done!
```

---

## Best Practices

1. **Version Control**
   - Keep source PS1 files in version control
   - Tag each release with version number
   - Name EXEs with version: `CompanyApps_v1.0.exe`

2. **Testing**
   - Test built EXE on a clean test PC before mass deployment
   - Verify icon appearance in all contexts
   - Confirm all functionality works

3. **Documentation**
   - Keep build notes (which icon, which version, build date)
   - Document any custom build parameters used
   - Maintain change log

4. **Security**
   - Consider code signing for corporate environments
   - Keep build machine secure (protects source code)
   - Don't distribute source PS1 files

5. **Deployment**
   - Test deployment process on few PCs first
   - Document any issues found
   - Plan for version updates

---

## Next Steps

✅ **You're ready to build!**

1. **First Build - Default Settings**
   ```
   Double-click: QuickBuild.bat
   Result: PortalBuilder.exe (with default icon)
   ```

2. **Custom Build - Your Branding**
   - Get/create your icon → See ICON_GUIDE.md
   - Edit QuickBuild.bat (set name and icon)
   - Run QuickBuild.bat
   - Result: Your branded EXE!

3. **Deploy**
   - Copy EXE to target PC
   - Test functionality
   - Deploy to all PCs

4. **Maintain**
   - Update source PS1 when needed
   - Rebuild EXE
   - Deploy updated version

---

## Additional Resources

- **ICON_GUIDE.md** - Complete guide to creating and using custom icons
- **USER_GUIDE.md** - How to use the Application Portal Builder
- **README.md** - Project overview and quick start
- **DeployPortal.ps1** - Automated deployment script

---

## Support

If you encounter issues:

1. Check **Troubleshooting** section above
2. Verify **Prerequisites** are met
3. Review error messages carefully
4. Try build on different PC to isolate issue

Common solutions solve 90% of problems:
- Run as Administrator
- Add antivirus exclusion
- Manually install PS2EXE module
- Check .NET Framework is installed

---

**Happy Building! 🎉**

Your standalone executable will provide a professional, secure way to distribute your Application Portal Builder.

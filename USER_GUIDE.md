# Application Portal Builder - User Guide

**Complete Step-by-Step Instructions**

This comprehensive guide will walk you through building, customizing, deploying, and managing your Application Portal from start to finish.

---

## Table of Contents

1. [Getting Started](#step-1-getting-started)
2. [Building Your First Portal](#step-2-building-your-first-portal)
3. [Customizing Your Portal](#step-3-customizing-your-portal)
4. [Building the Portal Package](#step-4-building-the-portal-package)
5. [Testing Your Portal](#step-5-testing-your-portal)
6. [Deploying to Target PCs](#step-6-deploying-to-target-pcs)
7. [User Instructions](#step-7-user-instructions)
8. [Updating Your Portal](#step-8-updating-your-portal)
9. [Profile Management for Shared PCs](#step-9-profile-management-for-shared-pcs-it-admin-only)
10. [Troubleshooting](#step-10-troubleshooting)

---

## Step 1: Getting Started

### 1. Extract the Files
- Extract all files from the ZIP archive to a folder (e.g., `C:\PortalBuilder`)
- Ensure all files are present: `PortalBuilder.ps1`, `RunBuilder.bat`, `RunBuilder.vbs`, `DeployPortal.ps1`

### 2. Verify System Requirements
- Windows 7 or higher
- PowerShell 3.0+ (Check: Open PowerShell and type `$PSVersionTable.PSVersion`)
- .NET Framework 4.0+ (usually pre-installed on Windows 7+)

---

## Step 2: Building Your First Portal

### 1. Launch the Portal Builder
- **Method 1 (Recommended):** Double-click `RunBuilder.bat`
- **Method 2:** Right-click `PortalBuilder.ps1` → Run with PowerShell
- **Method 3:** Double-click `RunBuilder.vbs` (completely silent launch)
- Wait a few seconds for the builder interface to appear

### 2. Add Programs from Your PC
- The builder automatically scans your Start Menu and displays available programs
- **Check the boxes** next to programs you want to include in your portal
- Programs will be organized by category (Productivity, Development, etc.)

### 3. Add Programs Not Installed on Build PC
- Click the **"Add Program"** button
- Enter the **Display Name**: `"Company ERP System"`
- Enter the **Target Path**: `C:\Apps\ERP\erp.exe` (where it exists on target PCs)
- **Optional:** Click **"Browse Icon"** to select a custom icon (.ico, .png, .jpg)
- Click **"Add"** to confirm
- Repeat for all custom programs

### 4. Add Website/URL Links
- Click the **"Add URL"** button
- Enter the **Display Name**: `"Company Intranet"`
- Enter the **URL**: `https://intranet.company.com`
- **Optional:** Click **"Browse Icon"** to select a custom icon
- Click **"Add"** to confirm
- Repeat for all websites you want to include

---

## Step 3: Customizing Your Portal

### 1. Open Customization Settings
- Go to **File → Customize Portal** (or click the Customize button)

### 2. Set Portal Branding
- **Portal Title:** Enter the main title (e.g., `"Company Applications"`)
- **Header Text:** Enter text to appear at the top (e.g., `"Welcome to IT Services"`)
- **Footer Text:** Enter bottom text (e.g., `"For support call x1234"`)

### 3. Choose Colors (RGB format: 0-255)
- **Header Color:** Example: `0,120,215` (Blue)
- **Background Color:** Example: `240,240,240` (Light Gray)
- **Tile Color:** Example: `255,255,255` (White)
- **Hover Color:** Example: `225,245,255` (Light Blue)
- **Tip:** Use Windows Color Picker or search "RGB color picker" online

### 4. Set Fonts
- **Font Name:** Enter font name (e.g., `Segoe UI`, `Arial`, `Calibri`)
- **Font Size:** Enter size in points (default: 10)

### 5. Add Logo and Icons
- **Portal Logo:** Click **"Browse"** → Select image (.png, .jpg, .ico)
  - This appears in the portal header
  - Recommended size: 100x100 pixels or similar
- **Desktop Shortcut Icon:** Click **"Browse"** → Select icon file
  - This is what users see on their desktop
  - Recommended: .ico file for best quality

### 6. Toggle Display Options
- ☑ **Show User Info** - Displays logged-in username
- ☑ **Show Time** - Displays current time in portal
- Click **"Save"** when done

---

## Step 4: Building the Portal Package

### 1. Build the Package
- Click the **"Build Portal Package"** button (usually prominent in the interface)
- A file dialog will appear

### 2. Choose Save Location
- Select where to save the portal (e.g., Desktop, Documents, Network Share)
- Enter folder name: `ApplicationPortal` (or custom name)
- Click **"Select Folder"** or **"OK"**

### 3. Wait for Build Process
The builder will:
- Create the portal structure
- Copy all necessary files
- Generate configuration files
- Create launcher scripts and shortcuts
- A success message will appear when complete

### 4. Verify the Output
Navigate to the save location. You should see a folder named `ApplicationPortal` containing:
- `ApplicationPortal.ps1` (main portal script)
- `RunPortal.vbs` (silent launcher)
- `Config.json` (configuration file)
- `Icons` folder (with all icons)
- Desktop shortcut file (.lnk)

---

## Step 5: Testing Your Portal

### 1. Test Locally Before Deployment
- Navigate to the `ApplicationPortal` folder
- Double-click `RunPortal.vbs`
- The portal should open without any PowerShell windows
- Verify all programs and URLs appear correctly
- Test launching a few programs
- Test the search feature

### 2. Test User Customization
- Click the **⚙ Settings** button in the portal
- Try **hiding** an app (uncheck it)
- Try **marking a favorite** (star icon)
- Close and reopen the portal - settings should persist

**Note:** When you mark an app as favorite (★), it moves to the TOP of your portal in a "Favorites" section. Look at the top of the portal to find your favorited apps - they won't disappear, they just relocate for easier access!

---

## Step 6: Deploying to Target PCs

### Option A: Manual Deployment (1-10 PCs)

#### 1. Copy Portal Folder
- Copy the entire `ApplicationPortal` folder to target PC
- Recommended location: `C:\ApplicationPortal`
- Alternative: Any location accessible by users (avoid network drives for performance)

#### 2. Create Desktop Shortcut
- Copy the included shortcut from `ApplicationPortal` folder
- Paste to: `C:\Users\Public\Desktop` (all users)
- Or paste to: `C:\Users\%USERNAME%\Desktop` (single user)

#### 3. Create Start Menu Entry (Optional)
- Copy shortcut to: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs`

#### 4. Instruct Users
- Tell users to double-click the desktop shortcut
- Portal opens instantly - they can start using it immediately

---

### Option B: Network Share Deployment (10-50 PCs)

#### 1. Place on Network Share
- Copy `ApplicationPortal` folder to network location
- Example: `\\server\apps\ApplicationPortal`
- Ensure all users have **Read** permissions

#### 2. Create Shortcuts on Each PC
- Create shortcut pointing to: `\\server\apps\ApplicationPortal\RunPortal.vbs`
- Distribute shortcut to each PC's desktop or Start Menu
- **Note:** Slight delay on launch due to network access

---

### Option C: Automated Deployment (50+ PCs or Enterprise)

#### 1. Prepare Source Location
- Place `ApplicationPortal` folder on network share
- Example: `\\fileserver\IT\ApplicationPortal`

#### 2. Open PowerShell as Administrator on Target PC
- Press `Win + X` → Select "Windows PowerShell (Admin)"

#### 3. Run Deployment Script
```powershell
# Basic deployment
.\DeployPortal.ps1 -SourcePath "\\fileserver\IT\ApplicationPortal"

# Custom location
.\DeployPortal.ps1 -SourcePath "\\fileserver\IT\ApplicationPortal" -TargetPath "D:\Apps\Portal"

# Without shortcuts
.\DeployPortal.ps1 -SourcePath "\\fileserver\IT\ApplicationPortal" -CreateShortcuts $false
```

#### 4. Verify Deployment
- Check that portal folder exists at target location
- Check desktop for shortcut
- Test launching the portal

#### 5. Deploy to Multiple PCs
- Use **Group Policy Startup Script** (runs on boot)
- Use **SCCM/Configuration Manager** (package deployment)
- Use **PDQ Deploy** (push to collections)
- Use **Remote PowerShell** (Invoke-Command)

---

## Step 7: User Instructions

**For End Users:**

### 1. Opening the Portal
- Double-click the **Application Portal** shortcut on desktop
- Portal opens instantly (no loading screens)

### 2. Launching Applications
- Click any tile to launch that application or website
- Portal stays open in background - can launch multiple apps

### 3. Using Search
- Type in the search box at top
- List filters in real-time as you type
- Press Enter or click result to launch

### 4. Personalizing Your View
- Click **⚙ Settings** button (top-right corner)
- **Hide Apps:** Uncheck apps you don't use (they disappear from your view)
- **Mark Favorites:** Click ★ next to apps you use often
  - **Important:** Favorited apps move to the TOP of your portal for quick access
  - Look at the top of the portal to find them - they appear in a "Favorites" section
  - They don't disappear, they just relocate!
- Click **"Save"** when done
- Settings are unique to your Windows login
- Click **"Reset to Default"** to restore all apps

### 5. Closing the Portal
- Click the **X** button in the top-right corner
- Or press **Alt + F4**
- Or simply minimize it (minimize button next to X)

---

## Step 8: Updating Your Portal

### 1. Make Changes in Portal Builder
- Open `PortalBuilder.ps1` again
- Add/remove programs
- Update customization (colors, logos, text)
- Click **"Build Portal Package"**

### 2. Replace Old Portal
- Build to same location (overwrites old version)
- Or build to new location and copy over the old one
- Users will see changes on next launch

### 3. Deploy Updates
- Use same deployment method as initial deployment
- Network share deployments update automatically (users see changes on next launch)
- Local deployments require copying updated files to each PC

---

## Step 9: Profile Management for Shared PCs (IT Admin Only)

### Manual Profile Cleanup

#### 1. Test First (Dry Run)
```powershell
# See what would be deleted without actually deleting
.\CleanOldProfiles.ps1 -DryRun
```

#### 2. Clean Old Profiles
```powershell
# Remove profiles not used in 90 days
.\CleanOldProfiles.ps1 -DaysOld 90

# Remove but exclude specific users
.\CleanOldProfiles.ps1 -DaysOld 90 -ExcludeUsers @("admin.user", "it.support")
```

#### 3. Review Results
- Check the log file in script directory
- Verify space freed (shown in output)

---

### Automated Profile Cleanup

#### 1. Schedule Weekly Cleanup
```powershell
# Sundays at 2 AM, remove profiles older than 90 days
.\ScheduleProfileCleanup.ps1
```

#### 2. Custom Schedule
```powershell
# Daily at 3 AM, remove profiles older than 60 days
.\ScheduleProfileCleanup.ps1 -ScheduleType Daily -Time "03:00" -DaysOld 60
```

#### 3. Verify Scheduled Task
- Open Task Scheduler (`taskschd.msc`)
- Look for "Cleanup Old User Profiles"
- Verify schedule and settings

---

## Step 10: Troubleshooting

### Problem: Portal Builder doesn't open
**Solutions:**
1. Try running `RunBuilder.bat` as Administrator
2. Check PowerShell version: Open PowerShell, type `$PSVersionTable.PSVersion` (need 3.0+)
3. Unblock files: Right-click `PortalBuilder.ps1` → Properties → Check "Unblock" → OK

### Problem: Portal opens but programs don't launch
**Solutions:**
- Verify paths are correct for target PC (not build PC)
- Check if programs are installed on target PC
- Test launching program manually first

### Problem: "Execution Policy" error
**Solutions:**
- Use `RunBuilder.vbs` instead of `.bat` or `.ps1`
- VBScript launcher bypasses execution policy restrictions

### Problem: User settings don't save
**Solutions:**
- Verify user has write access to `%APPDATA%` folder
- Check: `C:\Users\%USERNAME%\AppData\Roaming\ApplicationPortal`

### Problem: Icons don't display
**Solutions:**
- Verify icon files exist in `ApplicationPortal\Icons` folder
- Use absolute paths or ensure relative paths are correct
- Supported formats: .ico, .png, .jpg

### Problem: Network deployment is slow
**Solutions:**
- Copy portal to local drive instead of network share
- Use `DeployPortal.ps1` to automate local deployment

### Problem: Profile cleanup removes wrong profiles
**Solutions:**
- Use `-DryRun` first to preview
- Add users to `-ExcludeUsers` parameter
- Increase `-DaysOld` value to be more conservative

### Problem: Favorited apps seem to disappear
**Solution:**
- Favorited apps don't disappear - they move to the TOP of the portal!
- Close the settings dialog and scroll to the top of your portal
- You'll see a "Favorites" section with all your starred apps
- This is by design - makes your most-used apps easier to find

---

## Need More Help?

- Review the [README.md](README.md) for feature overview and technical details
- Check system requirements and compatibility
- Verify all required files are present
- Contact IT support for deployment assistance

---

**Version:** 1.0 | **Date:** March 2026  
**Copyright © 2026 - Internal Use Only**

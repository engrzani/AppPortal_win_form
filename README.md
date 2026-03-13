# Application Portal Builder

A professional, portable Windows application launcher that allows you to create custom program portals and deploy them across multiple PCs without installation or administrator rights.

## Features

- **Portable Deployment** - Build on one PC, copy to any Windows PC  
- **Custom Program Addition** - Add programs even if not installed on build PC  
- **URL/Website Support** - Add custom website links with icons  
- **Custom Icons** - Set unique icons for each program/URL and desktop shortcut  
- **User Customization** - Hide apps, mark favorites, settings per Windows user profile  
- **Full Customization** - Colors, fonts, logo, header/footer text  
- **User-Friendly Interface** - Close button, minimize/maximize, smooth animations  
- **Silent Launch** - No PowerShell windows, completely seamless user experience  
- **No Installation Required** - Zero configuration on target PCs  
- **No Admin Rights** - Runs with standard user permissions  
- **Corporate-Friendly .exe Launcher** - Compiled executable avoids .bat/.vbs security blocks  
- **Domain Policy Compliant** - Works with corporate security policies  
- **Professional UI** - Modern tile-based interface with search and categories  

## Files Included

### Application Portal Builder
- **PortalBuilder.ps1** - Main portal builder application
- **RunBuilder.exe** - Executable launcher (**RECOMMENDED for corporate environments**)
- **RunBuilder.bat** - Batch launcher (alternative)
- **RunBuilder.vbs** - Silent VBScript launcher (alternative)
- **CreateBuilderExe.ps1** - Script to recompile RunBuilder.exe if needed
- **DeployPortal.ps1** - Automated deployment script for IT

### Standalone EXE Build System (NEW!)
- **BuildStandaloneExe.ps1** - Compiles to standalone .exe with no visible scripts
- **QuickBuild.bat** - One-click build tool (easiest method)
- **BUILD_GUIDE.md** - Complete build and deployment guide
- **ICON_GUIDE.md** - How to create and use custom icons

### Profile Management (For Shared PCs)
- **CleanOldProfiles.ps1** - Removes user profiles older than specified days
- **ScheduleProfileCleanup.ps1** - Automates profile cleanup with scheduled task

## 🚀 Quick Start Options

### Option 1: Run the Builder Directly (Fastest)
Double-click **`RunBuilder.exe`** to start building your portal immediately.

### Option 2: Build Standalone EXE (Recommended for Distribution) 🎉 NEW!
Create a **single standalone executable** with your custom name and icon:

1. **Quick Build:** Double-click **`QuickBuild.bat`**
   - Creates `PortalBuilder.exe` in seconds
   - First build installs required components (1-2 minutes)
   - Subsequent builds take 30-60 seconds

2. **Custom Build with Your Branding:**
   - Edit `QuickBuild.bat`:
     ```batch
     SET EXE_NAME=CompanyApps
     SET ICON_FILE=YourIcon.ico
     ```
   - Run `QuickBuild.bat`
   - Result: **`CompanyApps.exe`** with your custom icon!

3. **Deploy:**
   - Copy the single `.exe` file to any Windows PC
   - Double-click to run - no installation needed!

**Benefits:**
- ✅ No PowerShell scripts visible (source code protected)
- ✅ Professional custom name and icon
- ✅ Single file distribution
- ✅ Works on any Windows PC (no setup required)

📖 **See [BUILD_GUIDE.md](BUILD_GUIDE.md) for complete standalone EXE instructions**  
🎨 **See [ICON_GUIDE.md](ICON_GUIDE.md) for custom icon creation**

---

## Documentation

📖 **[BUILD_GUIDE.md](BUILD_GUIDE.md)** - How to create standalone .exe with custom name and icon  
📖 **[ICON_GUIDE.md](ICON_GUIDE.md)** - Complete guide to creating and using custom icons  
📖 **[USER_GUIDE.md](USER_GUIDE.md)** - Complete step-by-step instructions for building, deploying, and managing your portal

## Step-by-Step User Guide

### Step 1: Getting Started

1. **Extract the Files**
   - Extract all files from the ZIP archive to a folder (e.g., `C:\PortalBuilder`)
   - Ensure all files are present: `PortalBuilder.ps1`, `RunBuilder.exe`, `RunBuilder.bat`, `RunBuilder.vbs`, `DeployPortal.ps1`

2. **Verify System Requirements**
   - Windows 7 or higher
   - PowerShell 3.0+ (Check: Open PowerShell and type `$PSVersionTable.PSVersion`)
   - .NET Framework 4.0+ (usually pre-installed on Windows 7+)

### Step 2: Building Your First Portal

1. **Launch the Portal Builder**
   - **Method 1 (RECOMMENDED):** Double-click `RunBuilder.exe` (best for corporate PCs)
   - **Method 2:** Double-click `RunBuilder.bat`
   - **Method 3:** Right-click `PortalBuilder.ps1` → Run with PowerShell
   - **Method 4:** Double-click `RunBuilder.vbs` (completely silent launch)
   - Wait a few seconds for the builder interface to appear

2. **Add Programs from Your PC**
   - The builder automatically scans your Start Menu and displays available programs
   - **Check the boxes** next to programs you want to include in your portal
   - Programs will be organized by category (Productivity, Development, etc.)

3. **Add Programs Not Installed on Build PC**
   - Click the **"Add Program"** button
   - Enter the **Display Name**: `"Company ERP System"`
   - Enter the **Target Path**: `C:\Apps\ERP\erp.exe` (where it exists on target PCs)
   - **Optional:** Click **"Browse Icon"** to select a custom icon (.ico, .png, .jpg)
   - Click **"Add"** to confirm
   - Repeat for all custom programs

4. **Add Website/URL Links**
   - Click the **"Add URL"** button
   - Enter the **Display Name**: `"Company Intranet"`
   - Enter the **URL**: `https://intranet.company.com`
   - **Optional:** Click **"Browse Icon"** to select a custom icon
   - Click **"Add"** to confirm
   - Repeat for all websites you want to include

### Step 3: Customizing Your Portal

1. **Open Customization Settings**
   - Go to **File → Customize Portal** (or click the Customize button)

2. **Set Portal Branding**
   - **Portal Title:** Enter the main title (e.g., `"Company Applications"`)
   - **Header Text:** Enter text to appear at the top (e.g., `"Welcome to IT Services"`)
   - **Footer Text:** Enter bottom text (e.g., `"For support call x1234"`)

3. **Choose Colors** (RGB format: 0-255)
   - **Header Color:** Example: `0,120,215` (Blue)
   - **Background Color:** Example: `240,240,240` (Light Gray)
   - **Tile Color:** Example: `255,255,255` (White)
   - **Hover Color:** Example: `225,245,255` (Light Blue)
   - **Tip:** Use Windows Color Picker or search "RGB color picker" online

4. **Set Fonts**
   - **Font Name:** Enter font name (e.g., `Segoe UI`, `Arial`, `Calibri`)
   - **Font Size:** Enter size in points (default: 10)

5. **Add Logo and Icons**
   - **Portal Logo:** Click **"Browse"** → Select image (.png, .jpg, .ico)
     - This appears in the portal header
     - Recommended size: 100x100 pixels or similar
   - **Desktop Shortcut Icon:** Click **"Browse"** → Select icon file
     - This is what users see on their desktop
     - Recommended: .ico file for best quality

6. **Toggle Display Options**
   - ☑ **Show User Info** - Displays logged-in username
   - ☑ **Show Time** - Displays current time in portal
   - Click **"Save"** when done

### Step 4: Building the Portal Package

1. **Build the Package**
   - Click the **"Build Portal Package"** button (usually prominent in the interface)
   - A file dialog will appear

2. **Choose Save Location**
   - Select where to save the portal (e.g., Desktop, Documents, Network Share)
   - Enter folder name: `ApplicationPortal` (or custom name)
   - Click **"Select Folder"** or **"OK"**

3. **Wait for Build Process**
   - The builder will:
     - Create the portal structure
     - Copy all necessary files
     - Generate configuration files
     - Create launcher scripts and shortcuts
   - A success message will appear when complete

4. **Verify the Output**
   - Navigate to the save location
   - You should see a folder named `ApplicationPortal` containing:
     - `ApplicationPortal.ps1` (main portal script)
     - `RunPortal.vbs` (silent launcher)
     - `Config.json` (configuration file)
     - `Icons` folder (with all icons)
     - Desktop shortcut file (.lnk)

### Step 5: Testing Your Portal

1. **Test Locally Before Deployment**
   - Navigate to the `ApplicationPortal` folder
   - Double-click `RunPortal.vbs`
   - The portal should open without any PowerShell windows
   - Verify all programs and URLs appear correctly
   - Test launching a few programs
   - Test the search feature

2. **Test User Customization**
   - Click the **⚙ Settings** button in the portal
   - Try **hiding** an app (uncheck it)
   - Try **marking a favorite** (star icon)
   - Close and reopen the portal - settings should persist

### Step 6: Deploying to Target PCs

#### Option A: Manual Deployment (1-10 PCs)

1. **Copy Portal Folder**
   - Copy the entire `ApplicationPortal` folder to target PC
   - Recommended location: `C:\ApplicationPortal`
   - Alternative: Any location accessible by users (avoid network drives for performance)

2. **Create Desktop Shortcut**
   - Copy the included shortcut from `ApplicationPortal` folder
   - Paste to: `C:\Users\Public\Desktop` (all users)
   - Or paste to: `C:\Users\%USERNAME%\Desktop` (single user)

3. **Create Start Menu Entry (Optional)**
   - Copy shortcut to: `C:\ProgramData\Microsoft\Windows\Start Menu\Programs`

4. **Instruct Users**
   - Tell users to double-click the desktop shortcut
   - Portal opens instantly - they can start using it immediately

#### Option B: Network Share Deployment (10-50 PCs)

1. **Place on Network Share**
   - Copy `ApplicationPortal` folder to network location
   - Example: `\\server\apps\ApplicationPortal`
   - Ensure all users have **Read** permissions

2. **Create Shortcuts on Each PC**
   - Create shortcut pointing to: `\\server\apps\ApplicationPortal\RunPortal.vbs`
   - Distribute shortcut to each PC's desktop or Start Menu
   - **Note:** Slight delay on launch due to network access

#### Option C: Automated Deployment (50+ PCs or Enterprise)

1. **Prepare Source Location**
   - Place `ApplicationPortal` folder on network share
   - Example: `\\fileserver\IT\ApplicationPortal`

2. **Open PowerShell as Administrator on Target PC**
   - Press `Win + X` → Select "Windows PowerShell (Admin)"

3. **Run Deployment Script**
   ```powershell
   # Basic deployment
   .\DeployPortal.ps1 -SourcePath "\\fileserver\IT\ApplicationPortal"
   
   # Custom location
   .\DeployPortal.ps1 -SourcePath "\\fileserver\IT\ApplicationPortal" -TargetPath "D:\Apps\Portal"
   
   # Without shortcuts
   .\DeployPortal.ps1 -SourcePath "\\fileserver\IT\ApplicationPortal" -CreateShortcuts $false
   ```

4. **Verify Deployment**
   - Check that portal folder exists at target location
   - Check desktop for shortcut
   - Test launching the portal

5. **Deploy to Multiple PCs**
   - Use **Group Policy Startup Script** (runs on boot)
   - Use **SCCM/Configuration Manager** (package deployment)
   - Use **PDQ Deploy** (push to collections)
   - Use **Remote PowerShell** (Invoke-Command)

### Step 7: User Instructions

**For End Users:**

1. **Opening the Portal**
   - Double-click the **Application Portal** shortcut on desktop
   - Portal opens instantly (no loading screens)

2. **Launching Applications**
   - Click any tile to launch that application or website
   - Portal stays open in background - can launch multiple apps

3. **Using Search**
   - Type in the search box at top
   - List filters in real-time as you type
   - Press Enter or click result to launch

4. **Personalizing Your View**
   - Click **⚙ Settings** button (top-right corner)
   - **Hide Apps:** Uncheck apps you don't use (they disappear from your view)
   - **Mark Favorites:** Click ★ next to apps you use often (they appear first)
   - Click **"Save"** when done
   - Settings are unique to your Windows login
   - Click **"Reset to Default"** to restore all apps

5. **Closing the Portal**
   - Click the **X** button in the top-right corner
   - Or press **Alt + F4**
   - Or simply minimize it (minimize button next to X)

### Step 8: Updating Your Portal

1. **Make Changes in Portal Builder**
   - Open `PortalBuilder.ps1` again
   - Add/remove programs
   - Update customization (colors, logos, text)
   - Click **"Build Portal Package"**

2. **Replace Old Portal**
   - Build to same location (overwrites old version)
   - Or build to new location and copy over the old one
   - Users will see changes on next launch

3. **Deploy Updates**
   - Use same deployment method as initial deployment
   - Network share deployments update automatically (users see changes on next launch)
   - Local deployments require copying updated files to each PC

### Step 9: Profile Management for Shared PCs (IT Admin Only)

#### Manual Profile Cleanup

1. **Test First (Dry Run)**
   ```powershell
   # See what would be deleted without actually deleting
   .\CleanOldProfiles.ps1 -DryRun
   ```

2. **Clean Old Profiles**
   ```powershell
   # Remove profiles not used in 90 days
   .\CleanOldProfiles.ps1 -DaysOld 90
   
   # Remove but exclude specific users
   .\CleanOldProfiles.ps1 -DaysOld 90 -ExcludeUsers @("admin.user", "it.support")
   ```

3. **Review Results**
   - Check the log file in script directory
   - Verify space freed (shown in output)

#### Automated Profile Cleanup

1. **Schedule Weekly Cleanup**
   ```powershell
   # Sundays at 2 AM, remove profiles older than 90 days
   .\ScheduleProfileCleanup.ps1
   ```

2. **Custom Schedule**
   ```powershell
   # Daily at 3 AM, remove profiles older than 60 days
   .\ScheduleProfileCleanup.ps1 -ScheduleType Daily -Time "03:00" -DaysOld 60
   ```

3. **Verify Scheduled Task**
   - Open Task Scheduler (`taskschd.msc`)
   - Look for "Cleanup Old User Profiles"
   - Verify schedule and settings

### Step 10: Troubleshooting

**Problem: Portal Builder doesn't open**
- **Solution 1:** Try running `RunBuilder.bat` as Administrator
- **Solution 2:** Check PowerShell version: Open PowerShell, type `$PSVersionTable.PSVersion` (need 3.0+)
- **Solution 3:** Unblock files: Right-click `PortalBuilder.ps1` → Properties → Check "Unblock" → OK

**Problem: Portal opens but programs don't launch**
- **Solution:** Verify paths are correct for target PC (not build PC)
- Check if programs are installed on target PC
- Test launching program manually first

**Problem: "Execution Policy" error**
- **Solution:** Use `RunBuilder.vbs` instead of `.bat` or `.ps1`
- VBScript launcher bypasses execution policy restrictions

**Problem: User settings don't save**
- **Solution:** Verify user has write access to `%APPDATA%` folder
- Check: `C:\Users\%USERNAME%\AppData\Roaming\ApplicationPortal`

**Problem: Icons don't display**
- **Solution:** Verify icon files exist in `ApplicationPortal\Icons` folder
- Use absolute paths or ensure relative paths are correct
- Supported formats: .ico, .png, .jpg

**Problem: Network deployment is slow**
- **Solution:** Copy portal to local drive instead of network share
- Use `DeployPortal.ps1` to automate local deployment

**Problem: Profile cleanup removes wrong profiles**
- **Solution:** Use `-DryRun` first to preview
- Add users to `-ExcludeUsers` parameter
- Increase `-DaysOld` value to be more conservative

---

## Quick Start (Summary)

### Building a Portal

1. **Double-click** `RunBuilder.bat`
2. Select programs from the list (auto-detected from Start Menu)
3. Click **"Add Program"** to manually add programs not on build PC
4. Click **"Add URL"** to add website links
5. Go to **File → Customize Portal** to set colors, logo, branding
6. Click **"Build Portal Package"**
7. Choose save location
8. Done! Copy the `ApplicationPortal` folder to target PCs

### Deploying to PCs

**Simple Method:**
1. Copy `ApplicationPortal` folder to target PC (e.g., `C:\ApplicationPortal`)
2. Copy the shortcut to `C:\Users\Public\Desktop`
3. Users double-click to launch

**Automated Method:**
```powershell
.\DeployPortal.ps1 -SourcePath "\\server\share\ApplicationPortal"
```

## System Requirements

**Build PC:**
- Windows 7 or higher
- PowerShell 3.0+ (included in Windows)
- .NET Framework 4.0+ (included in Windows)

**Target PCs:**
- Windows 7 or higher
- PowerShell 3.0+
- .NET Framework 4.0+
- No special permissions needed

## Usage Examples

### Adding Programs Not on Build PC

1. Click **"Add Program"**
2. Enter name: "Company ERP"
3. Enter path: `C:\Apps\ERP\erp.exe` (where it will be on target PC)
4. Browse for custom icon (optional)
5. Click **"Add"**

### Adding Websites

1. Click **"Add URL"**
2. Enter name: "Company Intranet"
3. Enter URL: `https://intranet.company.com`
4. Browse for custom icon (optional)
5. Click **"Add"**

### Customizing Appearance

**File → Customize Portal**

- Portal Title, Header, Footer text
- Colors (R,G,B format): `0,120,215` = Blue
- Font: Segoe UI, Arial, Calibri, etc.
- Logo image (PNG, JPG, ICO) - shown in portal header
- Desktop shortcut icon (PNG, JPG, ICO) - shown on user's desktop
- Show user info & time

**User Experience Features:**
### User Customization (Per Windows Profile)

**Settings Button (⚙) in Portal:**

Each user can personalize their portal view:
- **Hide Apps** - Uncheck apps they don't use
- **Mark Favorites** - Apps marked with ★ appear at top
- **Reset to Default** - Restore all apps
- Settings saved to user's Windows profile
- Works on shared PCs - each domain login has separate preferences

- Close button in header - one click to exit
- Minimize/Maximize buttons - standard Windows controls
- Silent launch - no PowerShell windows visible
- Smooth hover effects on tiles
- Responsive layout with scrolling

## Deployment Options

### Option 1: Manual Deployment (Small Scale)
Copy `ApplicationPortal` folder to each PC's local drive manually

### Option 2: Network Share
Place on shared network location: `\\server\apps\ApplicationPortal`

### Option 3: Automated Deployment (Enterprise)
Use `DeployPortal.ps1` for automated deployment across multiple PCs:

**Features:**
- Copies portal from network share to local PC
- Creates desktop shortcuts for all users
- Creates Start Menu entries
- Logs all deployment actions
- Works with SCCM, Group Policy, or PDQ Deploy

**Example Usage:**
```powershell
# Deploy to default location (C:\ApplicationPortal)
.\DeployPortal.ps1 -SourcePath "\\server\share\ApplicationPortal"

# Deploy to custom location
.\DeployPortal.ps1 -SourcePath "\\server\share\ApplicationPortal" -TargetPath "D:\Apps\Portal"

# Deploy without creating shortcuts
.\DeployPortal.ps1 -SourcePath "\\server\share\ApplicationPortal" -CreateShortcuts $false
```

**When to Use:**
- Deploying to 20+ computers
- Group Policy deployments
- SCCM/PDQ Deploy integration
- Standardized enterprise rollout

## Security & Compliance

- No external dependencies or downloads  
- No internet connectivity required  
- All code is local and reviewable  
- No registry modifications  
- No PowerShell execution policy bypass needed  
- Compatible with antivirus and endpoint protection  
- Domain policy compliant  
- Fully auditable code with SYNOPSIS documentation  

## Profile Management for Shared PCs

For shared workstations where disk space fills up with old user profiles:

### Manual Profile Cleanup

**Test First (Dry Run):**
```powershell
.\CleanOldProfiles.ps1 -DryRun
```
Shows which profiles would be deleted without actually deleting them.

**Remove Profiles Older Than 90 Days:**
```powershell
.\CleanOldProfiles.ps1 -DaysOld 90
```

**Exclude Specific Users:**
```powershell
.\CleanOldProfiles.ps1 -DaysOld 90 -ExcludeUsers @("admin.user", "it.support")
```

### Automated Profile Cleanup

**Schedule Weekly Cleanup (Sundays at 2 AM):**
```powershell
.\ScheduleProfileCleanup.ps1
```

**Schedule Daily Cleanup:**
```powershell
.\ScheduleProfileCleanup.ps1 -ScheduleType Daily -Time "03:00" -DaysOld 60
```

**Features:**
- Automatically removes profiles not used in X days (default 90)
- Cleans both C:\Users folder and registry entries
- Protects system profiles (Administrator, Public, Default)
- Excludes currently logged-in users
- Comprehensive logging with space freed calculations
- Requires Administrator privileges

**Safety Features:**
- Automatic exclusion of system accounts
- Never deletes currently logged-in users
- Dry-run mode for testing
- Detailed logging of all actions
- Custom exclusion list support

## Technical Details

- **Language:** PowerShell 3.0+
- **Framework:** .NET Framework 4.0+
- **GUI:** Windows Forms (System.Windows.Forms)
- **Config Format:** JSON
- **User Preferences:** Stored in %APPDATA%\ApplicationPortal\preferences.json
- **Supported OS:** Windows 7/8/10/11, Server 2008 R2+

## Version

**v1.0** - March 2026 - Initial Release  
+ Application Portal with user customization  
+ Hide/show apps and favorites per Windows profile  
+ Profile management tools for shared PCs  
+ Automatic cleanup of old user profiles  
+ Portable deployment with no installation required

## License

Internal use only - Copyright © 2026

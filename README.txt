================================================================================
    APPLICATION PORTAL BUILDER - COMPLETE GUIDE
================================================================================

TABLE OF CONTENTS
-----------------
1. Overview
2. System Requirements
3. Builder PC Setup
4. Creating Your Portal
5. Deployment to Target PCs
6. Troubleshooting
7. Customization Options
8. Security & Compliance

================================================================================
1. OVERVIEW
================================================================================

The Application Portal Builder creates a portable, professional program 
launcher that can be deployed across multiple PCs. It provides:

- Visual tile interface for launching applications
- Support for local programs and web URLs
- Custom branding (colors, fonts, logo)
- User information display
- Search and category filtering
- Zero configuration on target PCs
- No administrator rights required
- No PowerShell policy changes needed

================================================================================
2. SYSTEM REQUIREMENTS
================================================================================

Builder PC (where you create the portal):
- Windows 7 or higher
- PowerShell 3.0 or higher (included in Windows)
- .NET Framework 4.0 or higher (included in Windows)

Target PCs (where the portal will run):
- Windows 7 or higher
- PowerShell 3.0 or higher
- .NET Framework 4.0 or higher
- No special permissions required
- No installation needed

================================================================================
3. BUILDER PC SETUP
================================================================================

STEP 1: Extract Files
---------------------
Extract all files to a folder on your build PC:
- PortalBuilder.ps1
- RunBuilder.bat
- RunBuilder.vbs
- README.txt (this file)

STEP 2: Launch the Builder
---------------------------
Option A: Double-click "RunBuilder.bat"
Option B: Double-click "RunBuilder.vbs" (silent)
Option C: Right-click PortalBuilder.ps1 > Run with PowerShell

The Portal Builder window will appear.

================================================================================
4. CREATING YOUR PORTAL
================================================================================

STEP 1: Review Detected Programs
---------------------------------
The builder automatically scans:
- C:\ProgramData\Microsoft\Windows\Start Menu\Programs
- User's Start Menu programs

All found shortcuts will be listed in the main window.

STEP 2: Add Custom Programs
----------------------------
If a program is not installed on the build PC:

1. Click "Add Program" button
2. Enter a display name (e.g., "Company ERP")
3. Click "Browse" and select the program's .exe file
   (Even if it's not on this PC, enter the path where it 
   will be on target PCs, e.g., C:\Apps\ERP\erp.exe)
4. Choose a category (e.g., "Business Apps")
5. Optionally select a custom icon (.ico, .png, .jpg)
6. Click "Add"

STEP 3: Add Websites/URLs
--------------------------
To add website links:

1. Click "Add URL" button
2. Enter a display name (e.g., "Company Intranet")
3. Enter the full URL (e.g., https://intranet.company.com)
4. Choose a category (e.g., "Websites")
5. Optionally select a custom icon
6. Click "Add"

STEP 4: Select Items for Portal
--------------------------------
1. Check the boxes next to programs/URLs you want in the portal
2. Use the search box to filter items
3. Click "Remove Selected" to delete unwanted entries

STEP 5: Customize Appearance
-----------------------------
1. Click "File" > "Customize Portal"
2. Configure:
   - Portal Title (window title)
   - Header Text (shown at top)
   - Footer Text (shown at bottom)
   - Colors (R,G,B format, e.g., "0,120,215")
   - Font name and size
   - Logo image (company logo)
   - Show user info checkbox
   - Show time checkbox
3. Click "OK"

STEP 6: Build the Portal Package
---------------------------------
1. Click "Build Portal Package"
2. Select where to save the portal folder
   (e.g., Desktop, network share, USB drive)
3. Wait for completion message
4. A folder named "ApplicationPortal" will be created

================================================================================
5. DEPLOYMENT TO TARGET PCs
================================================================================

METHOD 1: Local Deployment
---------------------------
1. Copy the entire "ApplicationPortal" folder to target PC
   
   Recommended locations:
   - C:\ApplicationPortal
   - C:\Program Files\ApplicationPortal
   - Any accessible location

2. For all users on that PC:
   Copy "Application Portal.lnk" to:
   - C:\Users\Public\Desktop
   
   Or:
   - C:\ProgramData\Microsoft\Windows\Start Menu\Programs

3. Users launch by double-clicking the shortcut

METHOD 2: Network Deployment
-----------------------------
1. Copy "ApplicationPortal" folder to shared network location
   Example: \\server\shared\ApplicationPortal

2. Create shortcut on each user's desktop pointing to:
   \\server\shared\ApplicationPortal\LaunchPortal.bat

3. Users access from any domain PC

METHOD 3: USB/Portable Deployment
----------------------------------
1. Copy "ApplicationPortal" folder to USB drive
2. Users can run directly from USB
3. No installation needed

LAUNCHING THE PORTAL
--------------------
Users can launch the portal using any of these:

1. Application Portal.lnk (desktop shortcut)
2. LaunchPortal.bat (shows command window briefly)
3. LaunchPortal.vbs (completely silent)

All methods work WITHOUT requiring:
- Administrator rights
- PowerShell execution policy changes
- Registry modifications
- System configuration changes

================================================================================
6. TROUBLESHOOTING
================================================================================

PROBLEM: Portal won't launch
SOLUTION:
- Verify PowerShell 3.0+ is installed (run: $PSVersionTable in PowerShell)
- Check that all files are present in portal folder
- Try launching portal.ps1 directly with PowerShell
- Review README.txt in portal folder

PROBLEM: Programs don't launch when clicked
SOLUTION:
- Verify the program is installed on target PC
- Check the path in items.json matches actual install location
- Ensure user has permission to run the program

PROBLEM: Icons don't display
SOLUTION:
- Check that Icons\ folder exists and contains icon files
- Verify icon file formats are supported (.ico, .png, .jpg)
- For programs without custom icons, icon is extracted from .exe

PROBLEM: URLs don't open
SOLUTION:
- Verify default browser is configured
- Check URL format includes https:// or http://
- Ensure network/internet connectivity

PROBLEM: "Script execution disabled" error
SOLUTION:
- Use LaunchPortal.bat or LaunchPortal.vbs instead of running .ps1 directly
- These launchers bypass execution policy restrictions

PROBLEM: Portal looks different on different PCs
SOLUTION:
- Ensure .NET Framework installed on all PCs
- Check Windows version compatibility
- Verify font specified in config is installed on target PCs

================================================================================
7. CUSTOMIZATION OPTIONS
================================================================================

PORTAL TITLE
------------
Default: "Application Portal"
Sets the window title bar text

HEADER TEXT
-----------
Default: "Welcome to Application Portal"
Main heading shown at top of portal

FOOTER TEXT
-----------
Default: "IT Department"
Text shown at bottom of portal

PRIMARY COLOR
-------------
Default: "0,120,215" (blue)
Main color for tiles and header/footer
Format: R,G,B where each is 0-255

HOVER COLOR
-----------
Default: "0,95,180" (darker blue)
Color when mouse hovers over tiles
Format: R,G,B

TEXT COLOR
----------
Default: "255,255,255" (white)
Color of text on tiles and header/footer
Format: R,G,B

BACKGROUND COLOR
----------------
Default: "245,245,245" (light gray)
Main window background color
Format: R,G,B

FONT NAME
---------
Default: "Segoe UI"
Options: Segoe UI, Arial, Calibri, Tahoma, Verdana

FONT SIZE
---------
Default: 10
Range: 8-16 points

LOGO IMAGE
----------
Optional company logo shown in header
Supported formats: .png, .jpg, .jpeg, .bmp, .ico
Recommended size: 50x50 pixels

SHOW USER INFO
--------------
Default: Enabled
Displays logged-in username in header

SHOW TIME
---------
Default: Enabled
Displays current time in header

CATEGORIES
----------
Custom categories organize programs into groups
Category labels display above each group of tiles

CUSTOM ICONS
------------
Each program/URL can have a custom icon
If not specified, icon is extracted from program file

================================================================================
8. SECURITY & COMPLIANCE
================================================================================

SECURITY FEATURES
-----------------
✓ No external dependencies or downloads
✓ No internet connectivity required
✓ All code is local and reviewable
✓ No registry modifications
✓ No system file changes
✓ Read-only operation (doesn't modify programs)
✓ No elevation/admin rights required
✓ No hidden processes or background services

COMPLIANCE
----------
✓ Compatible with corporate security policies
✓ No ExecutionPolicy bypass required (when using .bat/.vbs launchers)
✓ Works with antivirus and endpoint protection
✓ Domain policy compliant
✓ No Group Policy conflicts
✓ Audit-friendly (all actions logged in Windows Event Log)

POWERSHELL SECURITY
-------------------
The portal uses standard PowerShell features:
- System.Windows.Forms (GUI framework)
- System.Drawing (graphics)
- Built-in cmdlets only
- No external modules
- No internet downloads
- No remote execution

CODE VERIFICATION
-----------------
All PowerShell scripts are:
- Fully commented
- Human-readable
- Following standard conventions
- Free from obfuscation
- Documented with SYNOPSIS blocks

Your IT security team can review:
- PortalBuilder.ps1 (builder script)
- portal.ps1 (generated portal script)
- All launcher files (.bat, .vbs)

NETWORK SECURITY
----------------
The portal:
- Does NOT communicate over network
- Does NOT send telemetry
- Does NOT check for updates
- Does NOT access external resources
- Only launches local programs or URLs specified by admin

DATA PRIVACY
------------
No user data is:
- Collected
- Transmitted
- Stored externally
- Logged remotely

Only local configuration files (JSON) store portal settings.

================================================================================

SUPPORT INFORMATION
-------------------
Created: March 2026
Version: 1.0
PowerShell Version Required: 3.0+
.NET Framework Required: 4.0+

For issues or questions, contact your IT department.

================================================================================

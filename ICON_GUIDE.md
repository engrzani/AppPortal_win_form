# Application Icon Guide

## Overview

This guide explains how to add a custom icon to your compiled Application Portal executable. A custom icon will appear as:
- The **file icon** in Windows Explorer
- The **taskbar icon** when the application is running  
- The **desktop shortcut icon** if you create one

---

## Quick Start

### Option 1: Use an Existing .ICO File

If you already have a `.ico` file:

1. Place your icon file in the same folder as `BuildStandaloneExe.ps1`
2. Edit `QuickBuild.bat` and set:
   ```batch
   SET ICON_FILE=MyIcon.ico
   ```
3. Run `QuickBuild.bat`

### Option 2: Create Your Own Icon

Follow the detailed steps below to create a professional `.ico` file.

---

## Creating a Custom Icon (.ICO File)

### Method 1: Online Icon Converter (Easiest)

1. **Get or Create an Image**
   - Use a company logo, or create a simple icon
   - Recommended size: **256x256 pixels** or larger (square)
   - Supported formats: PNG, JPG, SVG

2. **Convert to .ICO Format**
   - Visit: https://convertio.co/png-ico/ (or similar converter)
   - Upload your image
   - Download the converted `.ico` file
   - Save it to your PortalBuilder folder (e.g., `AppIcon.ico`)

3. **Use in Build**
   - Edit `QuickBuild.bat`:
     ```batch
     SET ICON_FILE=AppIcon.ico
     ```
   - Run `QuickBuild.bat`

### Method 2: Using Free Desktop Software

#### ConvertICO (Free, Simple)
1. Download from: https://www.convertico.com/
2. Install and launch
3. Click "Choose File" and select your image
4. Click "Convert"
5. Download the `.ico` file

#### GIMP (Free, Professional)
1. Download GIMP: https://www.gimp.org/
2. Open your image in GIMP
3. Go to **Image → Scale Image** → Set width and height to **256x256**
4. Go to **File → Export As**
5. Name your file with `.ico` extension (e.g., `myicon.ico`)
6. Click **Export** → Click **Export** again
7. Save to your PortalBuilder folder

### Method 3: Extract Icon from Existing Application

If you want to use an icon from another program:

1. **Using IconsExtract (Free Tool)**
   - Download: https://www.nirsoft.net/utils/iconsext.html
   - Run the portable version (no installation needed)
   - Navigate to the folder containing the `.exe` you want to extract from
   - Right-click the icon → **Save Selected Icons**
   - Save as `.ico` format

2. **Manually from Windows**
   - Find the `.exe` file with the icon you want
   - Copy it to your PortalBuilder folder
   - Use IconsExtract to extract

---

## Icon Requirements and Best Practices

### Technical Requirements
- **File Format**: `.ico` (recommended) or `.png`
- **Recommended Sizes**: `.ico` files can contain multiple resolutions:
  - 16x16 pixels (small icons)
  - 32x32 pixels (standard)
  - 48x48 pixels (large icons)
  - 256x256 pixels (Windows 7+ high-res)

### Design Best Practices
- **Keep it simple**: Small icons should be clear and recognizable
- **Square aspect ratio**: Icons work best as squares
- **High contrast**: Ensure the icon is visible on different backgrounds
- **Avoid text**: Very small text becomes unreadable at small sizes
- **Test at multiple sizes**: Your icon should look good at 16x16 and 256x256

### Color Recommendations
- Use your company brand colors
- Ensure good contrast with common desktop backgrounds
- Consider how it looks in dark mode vs light mode
- Include a transparent background if appropriate

---

## Where to Find Free Icons

### Free Icon Websites (Properly Licensed)

1. **Icons8** - https://icons8.com/icons
   - Free for personal use
   - Wide variety of styles
   - Download as PNG, then convert to .ico

2. **Flaticon** - https://www.flaticon.com/
   - Free with attribution
   - Huge collection
   - Can download as .ico directly (on some)

3. **IconArchive** - https://www.iconarchive.com/
   - Large collection of free icons
   - Many available as .ico files

4. **Iconfinder** - https://www.iconfinder.com/free_icons
   - Free section available
   - Filter by license type

**Important**: Always check the license terms before using icons, especially for commercial/corporate use.

---

## Using Your Icon in the Build

### Method 1: Quick Build Batch File

Edit `QuickBuild.bat`:

```batch
REM Name for your executable
SET EXE_NAME=CompanyPortal

REM Path to your icon file
SET ICON_FILE=CompanyIcon.ico
```

Then run: `QuickBuild.bat`

### Method 2: Direct PowerShell Command

```powershell
.\BuildStandaloneExe.ps1 -ExeName "CompanyPortal" -IconPath "C:\Icons\CompanyIcon.ico"
```

### Method 3: Icon in Subfolder

```batch
SET ICON_FILE=Icons\MainIcon.ico
```

---

## Verifying Your Icon

After building your `.exe`:

1. **Check File Properties**
   - Right-click the `.exe` → Properties
   - The icon should appear in the dialog

2. **Check in Explorer**
   - Browse to the `.exe` in File Explorer
   - View should show your custom icon

3. **Check When Running**
   - Run the `.exe`
   - Look at the taskbar - your icon should appear
   - Check Alt+Tab - your icon should appear

4. **Check Desktop Shortcut**
   - Right-click `.exe` → Send to → Desktop (create shortcut)
   - The desktop shortcut should show your icon

---

## Troubleshooting

### Icon Doesn't Appear

**Problem**: Compiled EXE shows default Windows icon

**Solutions**:
1. Ensure the icon file path is correct
2. Verify the icon file is valid `.ico` format
3. Rebuild with the correct icon path
4. Try using absolute path: `C:\Full\Path\To\Icon.ico`

### Icon Looks Blurry

**Problem**: Icon appears blurry or pixelated

**Solutions**:
1. Use higher resolution source image (256x256 or larger)
2. Ensure `.ico` file contains multiple resolutions
3. Use a proper icon editor to create multi-resolution `.ico`

### Build Fails with Icon Error

**Problem**: Build script reports icon error

**Solutions**:
1. Check file exists at specified path
2. Ensure no special characters in filename or path
3. Try moving icon to same folder as build script
4. Verify icon file is not corrupted (open in image viewer)

### Icon Shows in File Explorer but Not Taskbar

**Problem**: Icon looks correct for the file, but wrong in taskbar

**Solutions**:
1. Rebuild the `.ico` to include 32x32 and 48x48 sizes
2. Clear Windows icon cache:
   ```batch
   taskkill /f /im explorer.exe
   del /a /q "%localappdata%\IconCache.db"
   start explorer.exe
   ```

---

## Example Build Commands

### Basic Build (No Icon)
```batch
QuickBuild.bat
```
Creates: `PortalBuilder.exe` with default Windows icon

### Custom Name + Icon
Edit `QuickBuild.bat`:
```batch
SET EXE_NAME=CompanyApps
SET ICON_FILE=CompanyLogo.ico
```

### Advanced PowerShell Build
```powershell
.\BuildStandaloneExe.ps1 `
    -ExeName "Corporate Application Portal" `
    -IconPath "C:\Branding\CorporateLogo.ico" `
    -OutputFolder "C:\Builds"
```

---

## Quick Reference: File Paths

All file paths can be:

| Path Type | Example | When to Use |
|-----------|---------|-------------|
| **Relative** | `MyIcon.ico` | Icon in same folder as build script |
| **Relative Subfolder** | `Icons\MyIcon.ico` | Icon in subfolder |
| **Absolute** | `C:\Icons\MyIcon.ico` | Icon anywhere on your PC |
| **Network** | `\\server\share\Icons\MyIcon.ico` | Icon on network share |

---

## Next Steps

After creating your icon and building the EXE:

1. ✅ **Test the EXE** - Double-click to ensure it runs
2. ✅ **Verify Icon** - Check in Explorer, taskbar, and properties
3. ✅ **Create Shortcut** - Test desktop shortcut icon appearance
4. ✅ **Deploy** - Copy the standalone `.exe` to target PCs

---

## Need Help?

Common issues:
- Icon file not found → Check the path is correct
- Icon doesn't show → Verify `.ico` format, rebuild
- Build fails → Ensure PS2EXE module is installed

For more help, see **BUILD_GUIDE.md** for complete build instructions.

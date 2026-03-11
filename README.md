# Application Portal Builder

A professional, portable Windows application launcher that allows you to create custom program portals and deploy them across multiple PCs without installation or administrator rights.

## Features

✅ **Portable Deployment** - Build on one PC, copy to any Windows PC  
✅ **Custom Program Addition** - Add programs even if not installed on build PC  
✅ **URL/Website Support** - Add custom website links with icons  
✅ **Custom Icons** - Set unique icons for each program/URL and desktop shortcut  
✅ **Full Customization** - Colors, fonts, logo, header/footer text  
✅ **User-Friendly Interface** - Close button, minimize/maximize, smooth animations  
✅ **Silent Launch** - No PowerShell windows, completely seamless user experience  
✅ **No Installation Required** - Zero configuration on target PCs  
✅ **No Admin Rights** - Runs with standard user permissions  
✅ **No ExecutionPolicy Bypass** - Uses VBScript silent launcher  
✅ **Domain Policy Compliant** - Works with corporate security policies  
✅ **Professional UI** - Modern tile-based interface with search and categories  

## Files Included

- **PortalBuilder.ps1** - Main portal builder application
- **RunBuilder.bat** - Batch launcher (recommended)
- **RunBuilder.vbs** - Silent VBScript launcher
- **DeployPortal.ps1** - Automated deployment script for IT
- **README.txt** - Complete documentation

## Quick Start

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
- ❌ Close button in header - one click to exit
- 🪟 Minimize/Maximize buttons - standard Windows controls
- 🔇 Silent launch - no PowerShell windows visible
- 🎨 Smooth hover effects on tiles
- 📱 Responsive layout with scrolling

## Deployment Options

### Option 1: Local Installation
Copy `ApplicationPortal` to each PC's local drive

### Option 2: Network Share
Place on shared network location: `\\server\apps\ApplicationPortal`

### Option 3: Automated Deployment
Use `DeployPortal.ps1` with SCCM, Group Policy, or PDQ Deploy

## Security & Compliance

✅ No external dependencies or downloads  
✅ No internet connectivity required  
✅ All code is local and reviewable  
✅ No registry modifications  
✅ No PowerShell execution policy bypass needed  
✅ Compatible with antivirus and endpoint protection  
✅ Domain policy compliant  
✅ Fully auditable code with SYNOPSIS documentation  

## Screenshots

*Coming soon - Portal Builder interface and generated portal*

## Technical Details

- **Language:** PowerShell 3.0+
- **Framework:** .NET Framework 4.0+
- **GUI:** Windows Forms (System.Windows.Forms)
- **Config Format:** JSON
- **Supported OS:** Windows 7/8/10/11, Server 2008 R2+

## Support

For complete documentation, see `README.txt`

## License

Internal use only - Copyright © 2026

## Version

**v1.0** - March 2026 - Initial Release

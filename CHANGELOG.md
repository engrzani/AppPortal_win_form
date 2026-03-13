# Application Portal - Recent Updates & Fixes

**Date:** March 12, 2026  
**Updated Files:** PortalBuilder.ps1, README.md, ADD_PROGRAMS_GUIDE.md

---

## 🔧 Critical Bug Fixes

### 1. **Fixed "Add Program" Returning Null**
**Problem:** When manually adding programs, clicking OK did nothing. The program wasn't added to the list.

**Root Cause:** DialogResult enum values were being compared to strings, causing the condition to fail.

**Solution:** Fixed all DialogResult comparisons throughout the code:
```powershell
# Before (Broken):
if ($result -eq "OK") { ... }

# After (Fixed):
if ($result -eq [System.Windows.Forms.DialogResult]::OK) { ... }
```

**Affected Functions:**
- `Show-AddProgramDialog` - Adding programs manually
- `Show-AddURLDialog` - Adding URLs/websites
- `Show-CategoryDialog` - Category management
- All file browser dialogs (OpenFileDialog)
- All confirmation dialogs (MessageBox)
- FolderBrowserDialog for selecting output path

✅ **Status:** RESOLVED - You can now successfully add programs that aren't on the build PC!

---

## 🆕 New Features

### 2. **Corporate-Friendly .exe Launchers**
**Problem:** Corporate environments block `.bat` and `.vbs` files due to security policies, triggering antivirus alerts.

**Solution:** Created compiled C# executables that launch the portal.

#### **For Portal Builder (Build PC)**
- **New File:** `RunBuilder.exe` (4.6 KB)
- **Purpose:** Launch PortalBuilder.ps1 without triggering AV
- **How to Use:** Double-click `RunBuilder.exe` instead of `.bat` or `.vbs`
- **Recompile:** Run `CreateBuilderExe.ps1` if needed

#### **For Deployed Portals (Target PCs)**
- **New File:** `LaunchPortal.exe` (auto-created during build)
- **Purpose:** Users run the portal via `.exe` instead of `.bat`/`.vbs`
- **Compilation:** Happens automatically when you click "Build Portal Package"
- **Fallback:** If compilation fails, `.bat` and `.vbs` are still created

**Technical Details:**
- Uses Windows' built-in C# compiler (`csc.exe`)
- Requires .NET Framework 4.0+ (pre-installed on Windows 7+)  
- No external tools or downloads needed
- Creates lightweight, optimized executables
- Less likely to trigger antivirus false positives
- Desktop shortcut automatically uses `.exe` if available

✅ **Status:** IMPLEMENTED

---

## 📦 Updated Build Process

### What Happens When You Build a Portal Package:

1. **Creates portal.ps1** - Main portal script with all your programs
2. **Creates config.json** - Portal customization settings
3. **Creates items.json** - List of programs and URLs
4. **Copies Icons folder** - All custom icons and logos
5. **Creates LaunchPortal.bat** - Batch launcher (fallback)
6. **Creates LaunchPortal.vbs** - VBScript launcher (fallback)
7. **✨ NEW: Compiles LaunchPortal.exe** - Primary launcher
8. **Creates Application Portal.lnk** - Desktop shortcut pointing to `.exe`
9. **Creates README.txt** - Deployment instructions

### Deployment Package Contents:
```
ApplicationPortal/
├── portal.ps1
├── config.json
├── items.json
├── LaunchPortal.exe          ⭐ RECOMMENDED
├── LaunchPortal.bat           (fallback)
├── LaunchPortal.vbs           (fallback)
├── Application Portal.lnk     (points to .exe)
├── README.txt
└── Icons/
    ├── (your custom icons)
    └── (logo files)
```

---

## 🚀 How to Use the New Features

### Building the Portal (On Your PC):
1. **Launch Builder:** Double-click `RunBuilder.exe` (or `.bat` if .exe isn't available)
2. **Add Programs:** Click "Add Program" and fill in details
   - ✅ Fixed: The OK button now works correctly
   - ✅ You can add programs not on this PC
3. **Customize:** Set colors, fonts, logo, etc.
4. **Build Package:** Click "Build Portal Package"
   - ✅ Automatically creates `LaunchPortal.exe`
5. **Deploy:** Copy the ApplicationPortal folder to target PCs

### Deploying to Target PCs (Corporate Environment):
1. **Copy Folder:** Deploy ApplicationPortal to `C:\ApplicationPortal` (or any location)
2. **Create Shortcut:** Copy `Application Portal.lnk` to user desktops or Start Menu
3. **Users Launch:** Double-click the shortcut (runs `LaunchPortal.exe`)
4. **Benefits:**
   - ✅ No antivirus alerts
   - ✅ No .bat/.vbs security warnings
   - ✅ Works with strict corporate policies
   - ✅ Can be digitally signed if needed

---

## 🛡️ Security & Compliance

### Why .exe is Better for Corporate:
- **No Script Execution Concerns** - Compiled executable, not a script
- **Digitally Signable** - IT can sign .exe files with company certificate
- **Less AV False Positives** - AV systems trust .exe more than .vbs
- **Policy Compliant** - Works with "block .bat files" policies
- **Transparent** - Users see a proper application, not a script

### What About .bat and .vbs?
- Still created as **fallback options**
- Use them if `.exe` compilation fails
- Use them if your environment allows scripts
- All three launchers do the same thing

---

## 📋 Testing Checklist

After these updates, verify:
- ✅ Add Program button works (manual program addition)
- ✅ Add URL button works (website addition)
- ✅ Build Portal Package creates `.exe` launcher
- ✅ Desktop shortcut points to `.exe` (not `.vbs`)
- ✅ Portal launches successfully on target PC
- ✅ No antivirus alerts when running `.exe`

---

## 🔍 Troubleshooting

### If .exe compilation fails:
**Symptom:** "C# compiler not found" warning during build

**Cause:** .NET Framework not installed or wrong version

**Solution:**
1. Install .NET Framework 4.0 or higher
2. Restart the builder
3. Build again - `.exe` will be created
4. **Fallback:** Use `.bat` or `.vbs` if `.exe` can't be created

### If antivirus blocks .exe:
**Symptom:** AV quarantines `LaunchPortal.exe` or `RunBuilder.exe`

**Solution:**
1. Add an exclusion for the ApplicationPortal folder
2. Or digitally sign the `.exe` files with your company's certificate
3. Or whitelist the files with your IT department

### If programs still don't add:
**Symptom:** Clicking "Add" in Add Program dialog does nothing

**Status:** This should be fixed now with the DialogResult fix
**If it still happens:** 
1. Check that you entered a program name
2. Check that you entered a path (even if not valid on this PC)
3. Report the issue with details

---

## 📝 Files Modified

| File | What Changed |
|------|-------------|
| `PortalBuilder.ps1` | • Fixed DialogResult enum comparisons<br>• Added `Compile-ExeLauncher` function<br>• Updated build process to create `.exe`<br>• Updated README content in built packages |
| `README.md` | • Added RunBuilder.exe to file list<br>• Updated launch instructions<br>• Emphasized corporate-friendly .exe option |
| `ADD_PROGRAMS_GUIDE.md` | • Added note about .exe launcher benefits |
| `CreateBuilderExe.ps1` | • NEW: Script to compile RunBuilder.exe |
| `RunBuilder.exe` | • NEW: Compiled launcher for PortalBuilder (4.6 KB) |

---

## 🎯 Summary

**Two Major Fixes:**
1. ✅ **Add Program button now works** - DialogResult comparisons fixed
2. ✅ **.exe launchers created** - Corporate-friendly alternative to .bat/.vbs

**Benefits:**
- You can now add programs that aren't installed on the build PC
- Deployed portals use `.exe` files instead of `.bat`/`.vbs`
- Works in corporate environments with strict security policies
- No more antivirus false positives
- Professional, enterprise-ready deployment

**Backward Compatible:**
- Still creates `.bat` and `.vbs` as fallbacks
- Existing portals continue to work
- No breaking changes

---

**For Questions or Issues:** Check the troubleshooting section above or review the updated README.md

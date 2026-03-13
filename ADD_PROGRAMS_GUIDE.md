# How to Add Programs and URLs - Step-by-Step Guide

This guide explains how to add programs and URLs to your Application Portal that may not be installed on the build PC (useful for adding programs installed on target PCs).

---

## ⚡ Quick Start - Corporate Environment Note

**Using .exe Launcher (Recommended for Corporate PCs):**
- The portal now creates `LaunchPortal.exe` automatically during build
- This is a compiled executable that works better in corporate environments
- `.exe` files are less likely to be blocked by antivirus or security policies than `.bat` or `.vbs` files
- The desktop shortcut will automatically use `LaunchPortal.exe` if available
- You can use `RunBuilder.exe` to launch the Portal Builder itself

---

## Adding Programs Not Installed on Build PC

### Step 1: Click "Add Program" Button
In the Portal Builder, click the **"Add Program"** button in the toolbar.

### Step 2: Enter the Display Name
- **Field:** Display Name
- **Example:** `Company ERP System`
- This is the name that will appear on the portal tile

### Step 3: Enter the Program Path
- **Field:** Program Path
- **Important:** The path does NOT need to exist on the build PC
- **Example for target PC paths:**
  - `C:\Apps\ERP\erp.exe` - will be on target PC
  - `C:\Program Files\CustomApp\app.exe` - custom installation path
  - `\\server\apps\myapp.exe` - network path (if available on all target PCs)

### Step 4: Select Category (Optional)
- **Default:** "Custom"
- You can change this to organize programs (e.g., "Finance", "Engineering")
- Programs with the same category will be grouped together

### Step 5: Add a Custom Icon (Optional)
- Click the **"Browse"** button in the Icon field
- Select an icon file (.ico, .png, .jpg, .exe)
- If you select an .exe, its icon will be extracted
- If not selected, the program's icon will be used on target PCs

### Step 6: Click "Add"
- The program is now added to the portal
- You'll see a confirmation message showing total programs

### Step 7: Repeat for All Programs
Add all custom programs one by one

---

## Adding Website/URL Links

### Step 1: Click "Add URL" Button
In the Portal Builder, click the **"Add URL"** button in the toolbar.

### Step 2: Enter the Display Name
- **Field:** Display Name
- **Example:** `Company Intranet`
- This is the name that will appear on the portal tile

### Step 3: Enter the URL
- **Field:** URL
- **Must start with:** `https://` or `http://`
- **Examples:**
  - `https://intranet.company.com`
  - `https://sharepoint.company.com/sites/documents`
  - `http://internal-wiki.company.to`

### Step 4: Select Category (Optional)
- **Default:** "Websites"
- You can change this to organize URLs (e.g., "Resources", "Support")
- URLs with the same category will be grouped together

### Step 5: Add a Custom Icon (Optional)
- Click the **"Browse"** button in the Icon field
- Select an icon file (.ico, .png, .jpg)
- If not selected, a default website icon will be used

### Step 6: Click "Add"
- The URL is now added to the portal
- You'll see a confirmation message

### Step 7: Repeat for All URLs
Add all websites/URLs one by one

---

## Important Notes

### About Program Paths
- **Paths do NOT need to exist on the build PC**
  - You're building a portal for target PCs, not the current PC
  - Program paths should point to where they'll be installed on target PCs
  - Network paths work if accessible from target PCs

### About URLs
- Must include the protocol (http:// or https://)
- Can include port numbers: `https://servername:8080/path`
- Can include ports: `http://192.168.1.100:3000`

### About Icons
- **Supported formats:** .ico, .png, .jpg, .exe, .dll
- For .exe/.dll files, the icon will be extracted automatically
- Recommended size: at least 64x64 pixels
- If no icon is selected:
  - Programs use their actual application icon on target PCs
  - URLs use a default globe/website icon

### About Categories
- Use consistent category names for grouping
- Categories can have spaces (e.g., "Internal Tools")
- Each category becomes a section in the portal
- Favorites always appear at the top regardless of category

---

## Troubleshooting

### Program path validation error
- **Message:** "Please enter a valid program path"
- **Solution:** Just provide a path, even if the program isn't installed locally
- The path will work when the portal runs on a PC with that program installed

### URL validation error
- **Message:** "Please enter a valid URL"
- **Solution:** Make sure URL starts with `http://` or `https://`
- Don't leave it as just "https://" - add the domain

### Items not appearing after adding
- Check the list view - scroll to see if items appear below visible area
- Search box auto-clears when adding items, so you should see new items immediately
- If still not visible, click "Refresh Programs" button

### Icon not showing on portal
- Icon file must be accessible when portal runs on target PC
- If using local file path, copy icon file when deploying portal
- If using program icon, it will extract from the .exe on target PC

---

## Example Complete Setup

Here's an example of adding 3 programs and 2 URLs:

### Programs:
1. **ERP System**
   - Path: `C:\Apps\ERP\v2.0\erp.exe`
   - Category: `Business Apps`
   - Icon: (none, will use program's icon)

2. **Code Editor**
   - Path: `C:\Program Files\VSCode\Code.exe`
   - Category: `Development`
   - Icon: (none, will use VSCode icon)

3. **Custom Tool**
   - Path: `\\fileserver\tools\mytool.exe`
   - Category: `Utilities`
   - Icon: `C:\icons\mytool.ico`

### URLs:
1. **Company Wiki**
   - URL: `https://wiki.company.intranet`
   - Category: `Documentation`
   - Icon: (none, default website icon)

2. **Project Management**
   - URL: `https://jira.company.intranet`
   - Category: `Project Tools`
   - Icon: (none, default website icon)

---

## After Adding Programs and URLs

1. **Select items** by checking the checkbox next to each item
2. **Build Portal Package** by clicking the blue button
3. **Choose deployment location** (Desktop, Network share, etc.)
4. The portal is created and ready to deploy to target PCs!

All programs and URLs will be available in the portal along with any installed programs detected from Start Menu.

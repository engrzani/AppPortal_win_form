<#
.SYNOPSIS
    Application Portal Builder - Creates portable program launcher interface

.DESCRIPTION
    This tool builds a customizable application portal that can be deployed 
    across multiple PCs. It scans Start Menu programs, allows manual program 
    and URL additions, supports custom icons and branding, and generates a 
    portable folder ready for deployment.

.NOTES
    File Name      : PortalBuilder.ps1
    Author         : IT Department
    Prerequisite   : PowerShell 3.0, .NET Framework 4.0
    Version        : 1.0
    Date           : March 2026
    
.EXAMPLE
    .\PortalBuilder.ps1
    Launches the portal builder interface for creating a new application portal.

#>

# Required assemblies for Windows Forms GUI
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Enable modern visual styles
[System.Windows.Forms.Application]::EnableVisualStyles()

# ============================================================================
# GLOBAL CONFIGURATION VARIABLES
# ============================================================================

$script:PortalFolderName = "ApplicationPortal"
$script:AllItems = @()
$script:PortalConfig = @{
    PortalTitle = "Application Portal"
    HeaderText = "Welcome to Application Portal"
    FooterText = "IT Department"
    PrimaryColor = "0,122,204"
    HoverColor = "0,102,184"
    TextColor = "255,255,255"
    BackgroundColor = "240,240,240"
    FontName = "Segoe UI"
    FontSize = 10
    ShowUserInfo = $true
    ShowTime = $true
    LogoPath = ""
    DesktopIconPath = ""
}

# ============================================================================
# FUNCTION: Get-InstalledPrograms
# PURPOSE: Scans Start Menu for installed applications
# ============================================================================
function Get-InstalledPrograms {
    $programList = @()
    
    # Define scan locations
    $scanPaths = @(
        "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
    )
    
    $shell = New-Object -ComObject WScript.Shell
    
    foreach ($basePath in $scanPaths) {
        if (Test-Path $basePath) {
            $shortcuts = Get-ChildItem -Path $basePath -Filter "*.lnk" -Recurse -ErrorAction SilentlyContinue
            
            foreach ($shortcut in $shortcuts) {
                try {
                    $link = $shell.CreateShortcut($shortcut.FullName)
                    
                    if ($link.TargetPath -and (Test-Path $link.TargetPath)) {
                        $programList += [PSCustomObject]@{
                            Name = $shortcut.BaseName
                            Path = $link.TargetPath
                            Type = "Program"
                            Category = "Applications"
                            IconPath = ""
                        }
                    }
                }
                catch {
                    # Skip invalid shortcuts
                    continue
                }
            }
        }
    }
    
    # Clean up COM object
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
    
    # Remove duplicates
    $programList = $programList | Sort-Object -Property Name -Unique
    
    return $programList
}

# ============================================================================
# FUNCTION: Show-CustomizationDialog
# PURPOSE: Displays portal customization options
# ============================================================================
function Show-CustomizationDialog {
    $customForm = New-Object System.Windows.Forms.Form
    $customForm.Text = "Portal Customization"
    $customForm.Size = New-Object System.Drawing.Size(500, 600)
    $customForm.StartPosition = "CenterParent"
    $customForm.FormBorderStyle = "FixedDialog"
    $customForm.MaximizeBox = $false
    $customForm.MinimizeBox = $false
    
    $yPos = 10
    
    # Portal Title
    $lblTitle = New-Object System.Windows.Forms.Label
    $lblTitle.Text = "Portal Title:"
    $lblTitle.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblTitle.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblTitle)
    
    $txtTitle = New-Object System.Windows.Forms.TextBox
    $txtTitle.Location = New-Object System.Drawing.Point(140, $yPos)
    $txtTitle.Size = New-Object System.Drawing.Size(330, 20)
    $txtTitle.Text = $script:PortalConfig.PortalTitle
    $customForm.Controls.Add($txtTitle)
    
    $yPos += 30
    
    # Header Text
    $lblHeader = New-Object System.Windows.Forms.Label
    $lblHeader.Text = "Header Text:"
    $lblHeader.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblHeader.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblHeader)
    
    $txtHeader = New-Object System.Windows.Forms.TextBox
    $txtHeader.Location = New-Object System.Drawing.Point(140, $yPos)
    $txtHeader.Size = New-Object System.Drawing.Size(330, 20)
    $txtHeader.Text = $script:PortalConfig.HeaderText
    $customForm.Controls.Add($txtHeader)
    
    $yPos += 30
    
    # Footer Text
    $lblFooter = New-Object System.Windows.Forms.Label
    $lblFooter.Text = "Footer Text:"
    $lblFooter.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblFooter.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblFooter)
    
    $txtFooter = New-Object System.Windows.Forms.TextBox
    $txtFooter.Location = New-Object System.Drawing.Point(140, $yPos)
    $txtFooter.Size = New-Object System.Drawing.Size(330, 20)
    $txtFooter.Text = $script:PortalConfig.FooterText
    $customForm.Controls.Add($txtFooter)
    
    $yPos += 30
    
    # Primary Color
    $lblPrimary = New-Object System.Windows.Forms.Label
    $lblPrimary.Text = "Primary Color (R,G,B):"
    $lblPrimary.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblPrimary.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblPrimary)
    
    $txtPrimary = New-Object System.Windows.Forms.TextBox
    $txtPrimary.Location = New-Object System.Drawing.Point(140, $yPos)
    $txtPrimary.Size = New-Object System.Drawing.Size(330, 20)
    $txtPrimary.Text = $script:PortalConfig.PrimaryColor
    $customForm.Controls.Add($txtPrimary)
    
    $yPos += 30
    
    # Hover Color
    $lblHover = New-Object System.Windows.Forms.Label
    $lblHover.Text = "Hover Color (R,G,B):"
    $lblHover.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblHover.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblHover)
    
    $txtHover = New-Object System.Windows.Forms.TextBox
    $txtHover.Location = New-Object System.Drawing.Point(140, $yPos)
    $txtHover.Size = New-Object System.Drawing.Size(330, 20)
    $txtHover.Text = $script:PortalConfig.HoverColor
    $customForm.Controls.Add($txtHover)
    
    $yPos += 30
    
    # Font Name
    $lblFont = New-Object System.Windows.Forms.Label
    $lblFont.Text = "Font Name:"
    $lblFont.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblFont.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblFont)
    
    $cmbFont = New-Object System.Windows.Forms.ComboBox
    $cmbFont.Location = New-Object System.Drawing.Point(140, $yPos)
    $cmbFont.Size = New-Object System.Drawing.Size(330, 20)
    $cmbFont.DropDownStyle = "DropDownList"
    $fonts = @("Segoe UI", "Arial", "Calibri", "Tahoma", "Verdana")
    $cmbFont.Items.AddRange($fonts)
    $cmbFont.SelectedItem = $script:PortalConfig.FontName
    $customForm.Controls.Add($cmbFont)
    
    $yPos += 30
    
    # Font Size
    $lblFontSize = New-Object System.Windows.Forms.Label
    $lblFontSize.Text = "Font Size:"
    $lblFontSize.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblFontSize.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblFontSize)
    
    $numFontSize = New-Object System.Windows.Forms.NumericUpDown
    $numFontSize.Location = New-Object System.Drawing.Point(140, $yPos)
    $numFontSize.Size = New-Object System.Drawing.Size(100, 20)
    $numFontSize.Minimum = 8
    $numFontSize.Maximum = 16
    $numFontSize.Value = $script:PortalConfig.FontSize
    $customForm.Controls.Add($numFontSize)
    
    $yPos += 30
    
    # Logo Path
    $lblLogo = New-Object System.Windows.Forms.Label
    $lblLogo.Text = "Logo Image:"
    $lblLogo.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblLogo.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblLogo)
    
    $txtLogo = New-Object System.Windows.Forms.TextBox
    $txtLogo.Location = New-Object System.Drawing.Point(140, $yPos)
    $txtLogo.Size = New-Object System.Drawing.Size(250, 20)
    $txtLogo.Text = $script:PortalConfig.LogoPath
    $txtLogo.ReadOnly = $true
    $customForm.Controls.Add($txtLogo)
    
    $btnBrowseLogo = New-Object System.Windows.Forms.Button
    $btnBrowseLogo.Location = New-Object System.Drawing.Point(395, $yPos)
    $btnBrowseLogo.Size = New-Object System.Drawing.Size(75, 23)
    $btnBrowseLogo.Text = "Browse"
    $btnBrowseLogo.Add_Click({
        $openFile = New-Object System.Windows.Forms.OpenFileDialog
        $openFile.Filter = "Image Files|*.png;*.jpg;*.jpeg;*.bmp;*.ico"
        $openFile.Title = "Select Logo Image"
        if ($openFile.ShowDialog() -eq "OK") {
            $txtLogo.Text = $openFile.FileName
        }
    })
    $customForm.Controls.Add($btnBrowseLogo)
    
    $yPos += 30
    
    # Desktop Shortcut Icon
    $lblDesktopIcon = New-Object System.Windows.Forms.Label
    $lblDesktopIcon.Text = "Desktop Icon:"
    $lblDesktopIcon.Location = New-Object System.Drawing.Point(10, $yPos)
    $lblDesktopIcon.Size = New-Object System.Drawing.Size(120, 20)
    $customForm.Controls.Add($lblDesktopIcon)
    
    $txtDesktopIcon = New-Object System.Windows.Forms.TextBox
    $txtDesktopIcon.Location = New-Object System.Drawing.Point(140, $yPos)
    $txtDesktopIcon.Size = New-Object System.Drawing.Size(250, 20)
    $txtDesktopIcon.Text = $script:PortalConfig.DesktopIconPath
    $txtDesktopIcon.ReadOnly = $true
    $customForm.Controls.Add($txtDesktopIcon)
    
    $btnBrowseDesktopIcon = New-Object System.Windows.Forms.Button
    $btnBrowseDesktopIcon.Location = New-Object System.Drawing.Point(395, $yPos)
    $btnBrowseDesktopIcon.Size = New-Object System.Drawing.Size(75, 23)
    $btnBrowseDesktopIcon.Text = "Browse"
    $btnBrowseDesktopIcon.Add_Click({
        $openFile = New-Object System.Windows.Forms.OpenFileDialog
        $openFile.Filter = "Icon Files|*.ico;*.png;*.jpg"
        $openFile.Title = "Select Desktop Shortcut Icon"
        if ($openFile.ShowDialog() -eq "OK") {
            $txtDesktopIcon.Text = $openFile.FileName
        }
    })
    $customForm.Controls.Add($btnBrowseDesktopIcon)
    
    $yPos += 30
    
    # Show User Info
    $chkUserInfo = New-Object System.Windows.Forms.CheckBox
    $chkUserInfo.Text = "Show logged-in user information"
    $chkUserInfo.Location = New-Object System.Drawing.Point(10, $yPos)
    $chkUserInfo.Size = New-Object System.Drawing.Size(300, 20)
    $chkUserInfo.Checked = $script:PortalConfig.ShowUserInfo
    $customForm.Controls.Add($chkUserInfo)
    
    $yPos += 25
    
    # Show Time
    $chkTime = New-Object System.Windows.Forms.CheckBox
    $chkTime.Text = "Show current time"
    $chkTime.Location = New-Object System.Drawing.Point(10, $yPos)
    $chkTime.Size = New-Object System.Drawing.Size(300, 20)
    $chkTime.Checked = $script:PortalConfig.ShowTime
    $customForm.Controls.Add($chkTime)
    
    $yPos += 40
    
    # OK Button
    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Location = New-Object System.Drawing.Point(290, $yPos)
    $btnOK.Size = New-Object System.Drawing.Size(80, 30)
    $btnOK.Text = "OK"
    $btnOK.DialogResult = "OK"
    $btnOK.Add_Click({
        $script:PortalConfig.PortalTitle = $txtTitle.Text
        $script:PortalConfig.HeaderText = $txtHeader.Text
        $script:PortalConfig.FooterText = $txtFooter.Text
        $script:PortalConfig.PrimaryColor = $txtPrimary.Text
        $script:PortalConfig.HoverColor = $txtHover.Text
        $script:PortalConfig.FontName = $cmbFont.SelectedItem
        $script:PortalConfig.FontSize = $numFontSize.Value
        $script:PortalConfig.LogoPath = $txtLogo.Text
        $script:PortalConfig.DesktopIconPath = $txtDesktopIcon.Text
        $script:PortalConfig.ShowUserInfo = $chkUserInfo.Checked
        $script:PortalConfig.ShowTime = $chkTime.Checked
        $customForm.Close()
    })
    $customForm.Controls.Add($btnOK)
    
    # Cancel Button
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(380, $yPos)
    $btnCancel.Size = New-Object System.Drawing.Size(80, 30)
    $btnCancel.Text = "Cancel"
    $btnCancel.DialogResult = "Cancel"
    $customForm.Controls.Add($btnCancel)
    
    $customForm.AcceptButton = $btnOK
    $customForm.CancelButton = $btnCancel
    
    $result = $customForm.ShowDialog()
    return $result
}

# ============================================================================
# FUNCTION: Show-AddProgramDialog
# PURPOSE: Allows manual addition of programs not in Start Menu
# ============================================================================
function Show-AddProgramDialog {
    $addForm = New-Object System.Windows.Forms.Form
    $addForm.Text = "Add Program Manually"
    $addForm.Size = New-Object System.Drawing.Size(500, 280)
    $addForm.StartPosition = "CenterParent"
    $addForm.FormBorderStyle = "FixedDialog"
    $addForm.MaximizeBox = $false
    $addForm.MinimizeBox = $false
    
    # Program Name
    $lblName = New-Object System.Windows.Forms.Label
    $lblName.Text = "Program Name:"
    $lblName.Location = New-Object System.Drawing.Point(10, 20)
    $lblName.Size = New-Object System.Drawing.Size(100, 20)
    $addForm.Controls.Add($lblName)
    
    $txtName = New-Object System.Windows.Forms.TextBox
    $txtName.Location = New-Object System.Drawing.Point(120, 20)
    $txtName.Size = New-Object System.Drawing.Size(350, 20)
    $addForm.Controls.Add($txtName)
    
    # Program Path
    $lblPath = New-Object System.Windows.Forms.Label
    $lblPath.Text = "Program Path:"
    $lblPath.Location = New-Object System.Drawing.Point(10, 60)
    $lblPath.Size = New-Object System.Drawing.Size(100, 20)
    $addForm.Controls.Add($lblPath)
    
    $txtPath = New-Object System.Windows.Forms.TextBox
    $txtPath.Location = New-Object System.Drawing.Point(120, 60)
    $txtPath.Size = New-Object System.Drawing.Size(270, 20)
    $txtPath.ReadOnly = $true
    $addForm.Controls.Add($txtPath)
    
    $btnBrowse = New-Object System.Windows.Forms.Button
    $btnBrowse.Location = New-Object System.Drawing.Point(395, 58)
    $btnBrowse.Size = New-Object System.Drawing.Size(75, 23)
    $btnBrowse.Text = "Browse"
    $btnBrowse.Add_Click({
        $openFile = New-Object System.Windows.Forms.OpenFileDialog
        $openFile.Filter = "Executable Files|*.exe;*.bat;*.cmd|All Files|*.*"
        $openFile.Title = "Select Program"
        if ($openFile.ShowDialog() -eq "OK") {
            $txtPath.Text = $openFile.FileName
        }
    })
    $addForm.Controls.Add($btnBrowse)
    
    # Category
    $lblCategory = New-Object System.Windows.Forms.Label
    $lblCategory.Text = "Category:"
    $lblCategory.Location = New-Object System.Drawing.Point(10, 100)
    $lblCategory.Size = New-Object System.Drawing.Size(100, 20)
    $addForm.Controls.Add($lblCategory)
    
    $txtCategory = New-Object System.Windows.Forms.TextBox
    $txtCategory.Location = New-Object System.Drawing.Point(120, 100)
    $txtCategory.Size = New-Object System.Drawing.Size(350, 20)
    $txtCategory.Text = "Custom"
    $addForm.Controls.Add($txtCategory)
    
    # Icon Path
    $lblIcon = New-Object System.Windows.Forms.Label
    $lblIcon.Text = "Custom Icon:"
    $lblIcon.Location = New-Object System.Drawing.Point(10, 140)
    $lblIcon.Size = New-Object System.Drawing.Size(100, 20)
    $addForm.Controls.Add($lblIcon)
    
    $txtIcon = New-Object System.Windows.Forms.TextBox
    $txtIcon.Location = New-Object System.Drawing.Point(120, 140)
    $txtIcon.Size = New-Object System.Drawing.Size(270, 20)
    $txtIcon.ReadOnly = $true
    $addForm.Controls.Add($txtIcon)
    
    $btnBrowseIcon = New-Object System.Windows.Forms.Button
    $btnBrowseIcon.Location = New-Object System.Drawing.Point(395, 138)
    $btnBrowseIcon.Size = New-Object System.Drawing.Size(75, 23)
    $btnBrowseIcon.Text = "Browse"
    $btnBrowseIcon.Add_Click({
        $openFile = New-Object System.Windows.Forms.OpenFileDialog
        $openFile.Filter = "Icon Files|*.ico;*.png;*.jpg;*.exe"
        $openFile.Title = "Select Icon"
        if ($openFile.ShowDialog() -eq "OK") {
            $txtIcon.Text = $openFile.FileName
        }
    })
    $addForm.Controls.Add($btnBrowseIcon)
    
    # OK Button
    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Location = New-Object System.Drawing.Point(270, 190)
    $btnOK.Size = New-Object System.Drawing.Size(85, 30)
    $btnOK.Text = "Add"
    $btnOK.Add_Click({
        if ($txtName.Text -and $txtPath.Text) {
            $addForm.Tag = [PSCustomObject]@{
                Name = $txtName.Text
                Path = $txtPath.Text
                Type = "Program"
                Category = $txtCategory.Text
                IconPath = $txtIcon.Text
            }
            $addForm.DialogResult = "OK"
            $addForm.Close()
        }
        else {
            [System.Windows.Forms.MessageBox]::Show("Please provide program name and path.", "Validation", "OK", "Warning")
        }
    })
    $addForm.Controls.Add($btnOK)
    
    # Cancel Button
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(375, 190)
    $btnCancel.Size = New-Object System.Drawing.Size(85, 30)
    $btnCancel.Text = "Cancel"
    $btnCancel.DialogResult = "Cancel"
    $addForm.Controls.Add($btnCancel)
    
    $addForm.AcceptButton = $btnOK
    $addForm.CancelButton = $btnCancel
    
    if ($addForm.ShowDialog() -eq "OK") {
        return $addForm.Tag
    }
    return $null
}

# ============================================================================
# FUNCTION: Show-AddURLDialog
# PURPOSE: Allows addition of custom URLs/websites
# ============================================================================
function Show-AddURLDialog {
    $urlForm = New-Object System.Windows.Forms.Form
    $urlForm.Text = "Add Website/URL"
    $urlForm.Size = New-Object System.Drawing.Size(500, 240)
    $urlForm.StartPosition = "CenterParent"
    $urlForm.FormBorderStyle = "FixedDialog"
    $urlForm.MaximizeBox = $false
    $urlForm.MinimizeBox = $false
    
    # URL Name
    $lblName = New-Object System.Windows.Forms.Label
    $lblName.Text = "Display Name:"
    $lblName.Location = New-Object System.Drawing.Point(10, 20)
    $lblName.Size = New-Object System.Drawing.Size(100, 20)
    $urlForm.Controls.Add($lblName)
    
    $txtName = New-Object System.Windows.Forms.TextBox
    $txtName.Location = New-Object System.Drawing.Point(120, 20)
    $txtName.Size = New-Object System.Drawing.Size(350, 20)
    $urlForm.Controls.Add($txtName)
    
    # URL
    $lblURL = New-Object System.Windows.Forms.Label
    $lblURL.Text = "URL:"
    $lblURL.Location = New-Object System.Drawing.Point(10, 60)
    $lblURL.Size = New-Object System.Drawing.Size(100, 20)
    $urlForm.Controls.Add($lblURL)
    
    $txtURL = New-Object System.Windows.Forms.TextBox
    $txtURL.Location = New-Object System.Drawing.Point(120, 60)
    $txtURL.Size = New-Object System.Drawing.Size(350, 20)
    $txtURL.Text = "https://"
    $urlForm.Controls.Add($txtURL)
    
    # Category
    $lblCategory = New-Object System.Windows.Forms.Label
    $lblCategory.Text = "Category:"
    $lblCategory.Location = New-Object System.Drawing.Point(10, 100)
    $lblCategory.Size = New-Object System.Drawing.Size(100, 20)
    $urlForm.Controls.Add($lblCategory)
    
    $txtCategory = New-Object System.Windows.Forms.TextBox
    $txtCategory.Location = New-Object System.Drawing.Point(120, 100)
    $txtCategory.Size = New-Object System.Drawing.Size(350, 20)
    $txtCategory.Text = "Websites"
    $urlForm.Controls.Add($txtCategory)
    
    # Icon Path
    $lblIcon = New-Object System.Windows.Forms.Label
    $lblIcon.Text = "Custom Icon:"
    $lblIcon.Location = New-Object System.Drawing.Point(10, 140)
    $lblIcon.Size = New-Object System.Drawing.Size(100, 20)
    $urlForm.Controls.Add($lblIcon)
    
    $txtIcon = New-Object System.Windows.Forms.TextBox
    $txtIcon.Location = New-Object System.Drawing.Point(120, 140)
    $txtIcon.Size = New-Object System.Drawing.Size(270, 20)
    $txtIcon.ReadOnly = $true
    $urlForm.Controls.Add($txtIcon)
    
    $btnBrowseIcon = New-Object System.Windows.Forms.Button
    $btnBrowseIcon.Location = New-Object System.Drawing.Point(395, 138)
    $btnBrowseIcon.Size = New-Object System.Drawing.Size(75, 23)
    $btnBrowseIcon.Text = "Browse"
    $btnBrowseIcon.Add_Click({
        $openFile = New-Object System.Windows.Forms.OpenFileDialog
        $openFile.Filter = "Icon Files|*.ico;*.png;*.jpg"
        $openFile.Title = "Select Icon"
        if ($openFile.ShowDialog() -eq "OK") {
            $txtIcon.Text = $openFile.FileName
        }
    })
    $urlForm.Controls.Add($btnBrowseIcon)
    
    # OK Button
    $btnOK = New-Object System.Windows.Forms.Button
    $btnOK.Location = New-Object System.Drawing.Point(270, 180)
    $btnOK.Size = New-Object System.Drawing.Size(85, 30)
    $btnOK.Text = "Add"
    $btnOK.Add_Click({
        if ($txtName.Text -and $txtURL.Text) {
            $urlForm.Tag = [PSCustomObject]@{
                Name = $txtName.Text
                Path = $txtURL.Text
                Type = "URL"
                Category = $txtCategory.Text
                IconPath = $txtIcon.Text
            }
            $urlForm.DialogResult = "OK"
            $urlForm.Close()
        }
        else {
            [System.Windows.Forms.MessageBox]::Show("Please provide name and URL.", "Validation", "OK", "Warning")
        }
    })
    $urlForm.Controls.Add($btnOK)
    
    # Cancel Button
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Location = New-Object System.Drawing.Point(375, 180)
    $btnCancel.Size = New-Object System.Drawing.Size(85, 30)
    $btnCancel.Text = "Cancel"
    $btnCancel.DialogResult = "Cancel"
    $urlForm.Controls.Add($btnCancel)
    
    $urlForm.AcceptButton = $btnOK
    $urlForm.CancelButton = $btnCancel
    
    if ($urlForm.ShowDialog() -eq "OK") {
        return $urlForm.Tag
    }
    return $null
}

# ============================================================================
# FUNCTION: Refresh-ItemList
# PURPOSE: Updates the displayed list based on search filter
# ============================================================================
function Refresh-ItemList {
    param($ListView, $SearchText, $ResultLabel = $null)
    
    $ListView.Items.Clear()
    
    $filtered = $script:AllItems
    if ($SearchText -and $SearchText.Trim() -ne "") {
        # Case-insensitive search in name, path, and category
        $searchTerm = $SearchText.Trim()
        $filtered = $script:AllItems | Where-Object { 
            ($_.Name -like "*$searchTerm*") -or 
            ($_.Path -like "*$searchTerm*") -or 
            ($_.Category -like "*$searchTerm*")
        }
    }
    
    if ($filtered.Count -eq 0 -and $SearchText.Trim() -ne "") {
        # Show "No results" message when search has no matches
        $noResultItem = New-Object System.Windows.Forms.ListViewItem("No programs found matching '$($SearchText.Trim())'")
        $noResultItem.ForeColor = [System.Drawing.Color]::Gray
        $ListView.Items.Add($noResultItem) | Out-Null
        
        if ($ResultLabel) {
            $ResultLabel.Text = "No results found"
            $ResultLabel.ForeColor = [System.Drawing.Color]::Red
        }
    }
    else {
        foreach ($item in $filtered) {
            $listItem = New-Object System.Windows.Forms.ListViewItem($item.Name)
            $listItem.SubItems.Add($item.Type)
            $listItem.SubItems.Add($item.Category)
            $listItem.SubItems.Add($item.Path)
            $listItem.Tag = $item
            $ListView.Items.Add($listItem) | Out-Null
        }
        
        if ($ResultLabel) {
            if ($SearchText.Trim() -ne "") {
                $ResultLabel.Text = "Found $($filtered.Count) program(s)"
                $ResultLabel.ForeColor = [System.Drawing.Color]::Green
            }
            else {
                $ResultLabel.Text = "Showing all $($filtered.Count) program(s)"
                $ResultLabel.ForeColor = [System.Drawing.Color]::Gray
            }
        }
    }
}

# ============================================================================
# FUNCTION: Build-PortalPackage
# PURPOSE: Generates the complete portal deployment package
# ============================================================================
function Build-PortalPackage {
    param($SelectedItems, $OutputPath)
    
    # Create portal directory
    $portalPath = Join-Path $OutputPath $script:PortalFolderName
    
    if (Test-Path $portalPath) {
        $confirm = [System.Windows.Forms.MessageBox]::Show(
            "Portal folder already exists. Overwrite?",
            "Confirm",
            "YesNo",
            "Question"
        )
        if ($confirm -ne "Yes") {
            return $false
        }
        Remove-Item $portalPath -Recurse -Force
    }
    
    New-Item -Path $portalPath -ItemType Directory -Force | Out-Null
    
    # Create Icons subfolder
    $iconsPath = Join-Path $portalPath "Icons"
    New-Item -Path $iconsPath -ItemType Directory -Force | Out-Null
    
    # Copy logo if specified
    if ($script:PortalConfig.LogoPath -and (Test-Path $script:PortalConfig.LogoPath)) {
        $logoFile = Split-Path $script:PortalConfig.LogoPath -Leaf
        Copy-Item $script:PortalConfig.LogoPath (Join-Path $iconsPath $logoFile) -Force
        $script:PortalConfig.LogoPath = "Icons\$logoFile"
    }
    
    # Copy desktop icon if specified
    $desktopIconFile = ""
    if ($script:PortalConfig.DesktopIconPath -and (Test-Path $script:PortalConfig.DesktopIconPath)) {
        $desktopIconFile = Split-Path $script:PortalConfig.DesktopIconPath -Leaf
        Copy-Item $script:PortalConfig.DesktopIconPath (Join-Path $iconsPath $desktopIconFile) -Force
        $script:PortalConfig.DesktopIconPath = "Icons\$desktopIconFile"
    }
    
    # Process items and copy custom icons
    $portalItems = @()
    foreach ($item in $SelectedItems) {
        $newItem = $item.PSObject.Copy()
        
        # Copy custom icon if specified
        if ($item.IconPath -and (Test-Path $item.IconPath)) {
            $iconFile = Split-Path $item.IconPath -Leaf
            Copy-Item $item.IconPath (Join-Path $iconsPath $iconFile) -Force
            $newItem.IconPath = "Icons\$iconFile"
        }
        
        $portalItems += $newItem
    }
    
    # Save configuration and items as JSON
    $configPath = Join-Path $portalPath "config.json"
    $script:PortalConfig | ConvertTo-Json -Depth 3 | Set-Content $configPath -Encoding UTF8
    
    $itemsPath = Join-Path $portalPath "items.json"
    $portalItems | ConvertTo-Json -Depth 3 | Set-Content $itemsPath -Encoding UTF8
    
    # Generate the portal launcher script
    $portalScriptContent = @'
<#
.SYNOPSIS
    Application Portal - Launcher Interface

.DESCRIPTION
    Portable application launcher that displays selected programs and URLs
    in a user-friendly tile interface with search capabilities.

.NOTES
    File Name      : portal.ps1
    Prerequisite   : PowerShell 3.0
    Version        : 1.0
    
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Load configuration
$configPath = Join-Path $PSScriptRoot "config.json"
$itemsPath = Join-Path $PSScriptRoot "items.json"

if (-not (Test-Path $configPath) -or -not (Test-Path $itemsPath)) {
    [System.Windows.Forms.MessageBox]::Show("Configuration files missing.", "Error", "OK", "Error")
    exit
}

$config = Get-Content $configPath | ConvertFrom-Json
$items = Get-Content $itemsPath | ConvertFrom-Json

# Parse colors from configuration
$primaryRGB = $config.PrimaryColor -split ','
$hoverRGB = $config.HoverColor -split ','
$textRGB = $config.TextColor -split ','
$bgRGB = $config.BackgroundColor -split ','

$primaryColor = [System.Drawing.Color]::FromArgb([int]$primaryRGB[0], [int]$primaryRGB[1], [int]$primaryRGB[2])
$hoverColor = [System.Drawing.Color]::FromArgb([int]$hoverRGB[0], [int]$hoverRGB[1], [int]$hoverRGB[2])
$textColor = [System.Drawing.Color]::FromArgb([int]$textRGB[0], [int]$textRGB[1], [int]$textRGB[2])
$backgroundColor = [System.Drawing.Color]::FromArgb([int]$bgRGB[0], [int]$bgRGB[1], [int]$bgRGB[2])

# Create main form
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = $config.PortalTitle
$mainForm.Size = New-Object System.Drawing.Size(1100, 750)
$mainForm.StartPosition = "CenterScreen"
$mainForm.BackColor = $backgroundColor
$mainForm.Font = New-Object System.Drawing.Font($config.FontName, $config.FontSize)
$mainForm.FormBorderStyle = "Sizable"
$mainForm.MinimizeBox = $true
$mainForm.MaximizeBox = $true

# Set application icon
try {
    $iconPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    if (Test-Path $iconPath) {
        $mainForm.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
    }
} catch { }

# Header panel
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Height = 60
$headerPanel.Dock = "Top"
$headerPanel.BackColor = $primaryColor
$mainForm.Controls.Add($headerPanel)

# Logo
if ($config.LogoPath) {
    $logoPath = Join-Path $PSScriptRoot $config.LogoPath
    if (Test-Path $logoPath) {
        $logoPicture = New-Object System.Windows.Forms.PictureBox
        $logoPicture.Location = New-Object System.Drawing.Point(10, 5)
        $logoPicture.Size = New-Object System.Drawing.Size(50, 50)
        $logoPicture.SizeMode = "Zoom"
        $logoPicture.Image = [System.Drawing.Image]::FromFile($logoPath)
        $headerPanel.Controls.Add($logoPicture)
    }
}

# Header label
$headerLabel = New-Object System.Windows.Forms.Label
$headerLabel.Text = $config.HeaderText
$headerLabel.ForeColor = $textColor
$headerLabel.Font = New-Object System.Drawing.Font($config.FontName, 16, [System.Drawing.FontStyle]::Bold)
$headerLabel.AutoSize = $true
$headerLabel.Location = New-Object System.Drawing.Point(70, 15)
$headerPanel.Controls.Add($headerLabel)

# User info label
if ($config.ShowUserInfo -or $config.ShowTime) {
    $infoLabel = New-Object System.Windows.Forms.Label
    $infoLabel.ForeColor = $textColor
    $infoLabel.AutoSize = $true
    $infoLabel.Location = New-Object System.Drawing.Point(680, 22)
    $infoLabel.Anchor = "Top,Right"
    
    $infoText = ""
    if ($config.ShowUserInfo) {
        $infoText = "Workstation: $env:COMPUTERNAME"
    }
    if ($config.ShowTime) {
        if ($infoText) { $infoText += " | " }
        $infoText += "Time: " + (Get-Date -Format "HH:mm")
    }
    $infoLabel.Text = $infoText
    $headerPanel.Controls.Add($infoLabel)
}

# Close button in header (anchored to right)
$btnClosePortal = New-Object System.Windows.Forms.Button
$btnClosePortal.Text = "X"
$btnClosePortal.Size = New-Object System.Drawing.Size(45, 45)
$btnClosePortal.Location = New-Object System.Drawing.Point(1040, 8)
$btnClosePortal.Anchor = "Top,Right"
$btnClosePortal.BackColor = [System.Drawing.Color]::FromArgb(220, 50, 50)
$btnClosePortal.ForeColor = $textColor
$btnClosePortal.FlatStyle = "Flat"
$btnClosePortal.FlatAppearance.BorderSize = 0
$btnClosePortal.Font = New-Object System.Drawing.Font($config.FontName, 16, [System.Drawing.FontStyle]::Bold)
$btnClosePortal.Cursor = "Hand"
$btnClosePortal.Add_Click({ $mainForm.Close() })
$btnClosePortal.Add_MouseEnter({ $this.BackColor = [System.Drawing.Color]::FromArgb(255, 0, 0) })
$btnClosePortal.Add_MouseLeave({ $this.BackColor = [System.Drawing.Color]::FromArgb(220, 50, 50) })
$headerPanel.Controls.Add($btnClosePortal)

# Search panel
$searchPanel = New-Object System.Windows.Forms.Panel
$searchPanel.Height = 50
$searchPanel.Dock = "Top"
$searchPanel.BackColor = $backgroundColor
$mainForm.Controls.Add($searchPanel)

$searchLabel = New-Object System.Windows.Forms.Label
$searchLabel.Text = "Search:"
$searchLabel.Location = New-Object System.Drawing.Point(10, 15)
$searchLabel.AutoSize = $true
$searchPanel.Controls.Add($searchLabel)

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(70, 12)
$searchBox.Size = New-Object System.Drawing.Size(300, 25)
$searchPanel.Controls.Add($searchBox)

# Category filter
$categoryLabel = New-Object System.Windows.Forms.Label
$categoryLabel.Text = "Category:"
$categoryLabel.Location = New-Object System.Drawing.Point(390, 15)
$categoryLabel.AutoSize = $true
$searchPanel.Controls.Add($categoryLabel)

$categoryCombo = New-Object System.Windows.Forms.ComboBox
$categoryCombo.Location = New-Object System.Drawing.Point(460, 12)
$categoryCombo.Size = New-Object System.Drawing.Size(200, 25)
$categoryCombo.DropDownStyle = "DropDownList"
$categoryCombo.Items.Add("All Categories") | Out-Null
$uniqueCategories = $items | Select-Object -ExpandProperty Category -Unique | Sort-Object
foreach ($cat in $uniqueCategories) {
    $categoryCombo.Items.Add($cat) | Out-Null
}
$categoryCombo.SelectedIndex = 0
$searchPanel.Controls.Add($categoryCombo)

# Tile panel with scrollbar
$tilePanel = New-Object System.Windows.Forms.FlowLayoutPanel
$tilePanel.Dock = "Fill"
$tilePanel.AutoScroll = $true
$tilePanel.WrapContents = $true
$tilePanel.BackColor = $backgroundColor
$tilePanel.Padding = New-Object System.Windows.Forms.Padding(10)
$mainForm.Controls.Add($tilePanel)

# Add empty state message if no items
if ($items.Count -eq 0) {
    $emptyLabel = New-Object System.Windows.Forms.Label
    $emptyLabel.Text = "No applications added yet.`n`nUse the Portal Builder to add programs and URLs."
    $emptyLabel.Font = New-Object System.Drawing.Font($config.FontName, 14)
    $emptyLabel.ForeColor = [System.Drawing.Color]::Gray
    $emptyLabel.AutoSize = $true
    $emptyLabel.TextAlign = "MiddleCenter"
    $emptyLabel.Location = New-Object System.Drawing.Point(350, 200)
    $tilePanel.Controls.Add($emptyLabel)
}

# Footer panel
$footerPanel = New-Object System.Windows.Forms.Panel
$footerPanel.Height = 30
$footerPanel.Dock = "Bottom"
$footerPanel.BackColor = $primaryColor
$mainForm.Controls.Add($footerPanel)

$footerLabel = New-Object System.Windows.Forms.Label
$footerLabel.Text = $config.FooterText
$footerLabel.ForeColor = $textColor
$footerLabel.AutoSize = $true
$footerLabel.Location = New-Object System.Drawing.Point(10, 7)
$footerPanel.Controls.Add($footerLabel)

# Function to create tile button
function Create-TileButton {
    param($Item)
    
    $button = New-Object System.Windows.Forms.Button
    $button.Size = New-Object System.Drawing.Size(170, 150)
    $button.BackColor = $primaryColor
    $button.ForeColor = $textColor
    $button.FlatStyle = "Flat"
    $button.FlatAppearance.BorderSize = 1
    $button.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    $button.TextAlign = "BottomCenter"
    $button.Font = New-Object System.Drawing.Font($config.FontName, 9, [System.Drawing.FontStyle]::Bold)
    $button.Margin = New-Object System.Windows.Forms.Padding(8)
    $button.Cursor = "Hand"
    $button.TabStop = $false
    
    # Set button text with word wrap
    if ($Item.Name.Length -gt 25) {
        $button.Text = $Item.Name.Substring(0, 22) + "..."
    }
    else {
        $button.Text = $Item.Name
    }
    
    # Load icon
    $iconLoaded = $false
    
    # Try custom icon first
    if ($Item.IconPath) {
        $iconFullPath = Join-Path $PSScriptRoot $Item.IconPath
        if (Test-Path $iconFullPath) {
            try {
                $img = [System.Drawing.Image]::FromFile($iconFullPath)
                $resizedImg = New-Object System.Drawing.Bitmap($img, 64, 64)
                $button.Image = $resizedImg
                $button.ImageAlign = "TopCenter"
                $button.TextImageRelation = "ImageAboveText"
                $iconLoaded = $true
            }
            catch {
                # Icon load failed
            }
        }
    }
    
    # Try extracting from executable
    if (-not $iconLoaded -and $Item.Type -eq "Program") {
        if (Test-Path $Item.Path) {
            try {
                $icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Item.Path)
                $iconBitmap = $icon.ToBitmap()
                $resizedImg = New-Object System.Drawing.Bitmap($iconBitmap, 64, 64)
                $button.Image = $resizedImg
                $button.ImageAlign = "TopCenter"
                $button.TextImageRelation = "ImageAboveText"
            }
            catch {
                # Icon extraction failed
            }
        }
    }
    
    # Hover effects
    $button.Add_MouseEnter({
        $this.BackColor = $hoverColor
        $this.FlatAppearance.BorderColor = $textColor
    })
    
    $button.Add_MouseLeave({
        $this.BackColor = $primaryColor
        $this.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    })
    
    # Click action
    $button.Add_Click({
        $itemData = $this.Tag
        
        if ($itemData.Type -eq "URL") {
            Start-Process $itemData.Path
        }
        elseif ($itemData.Type -eq "Program") {
            if (Test-Path $itemData.Path) {
                Start-Process $itemData.Path
            }
            else {
                [System.Windows.Forms.MessageBox]::Show(
                    "Program not found: $($itemData.Path)",
                    "Error",
                    "OK",
                    "Error"
                )
            }
        }
    })
    
    $button.Tag = $Item
    
    return $button
}

# Function to refresh tiles
function Refresh-Tiles {
    $tilePanel.Controls.Clear()
    
    $searchText = $searchBox.Text.Trim()
    $selectedCategory = $categoryCombo.SelectedItem
    
    $filteredItems = $items
    
    if ($searchText -and $searchText -ne "") {
        # Case-insensitive search in name, path, and category
        $filteredItems = $filteredItems | Where-Object { 
            ($_.Name -like "*$searchText*") -or 
            ($_.Path -like "*$searchText*") -or 
            ($_.Category -like "*$searchText*")
        }
    }
    
    if ($selectedCategory -and $selectedCategory -ne "All Categories") {
        $filteredItems = $filteredItems | Where-Object { $_.Category -eq $selectedCategory }
    }
    
    # Group by category
    $grouped = $filteredItems | Group-Object -Property Category | Sort-Object Name
    
    foreach ($group in $grouped) {
        # Category label with separator line
        $categoryPanel = New-Object System.Windows.Forms.Panel
        $categoryPanel.AutoSize = $false
        $categoryPanel.Width = 1050
        $categoryPanel.Height = 40
        $categoryPanel.BackColor = $backgroundColor
        
        $categoryLabel = New-Object System.Windows.Forms.Label
        $categoryLabel.Text = "  " + $group.Name
        $categoryLabel.Font = New-Object System.Drawing.Font($config.FontName, 11, [System.Drawing.FontStyle]::Bold)
        $categoryLabel.AutoSize = $false
        $categoryLabel.Width = 1050
        $categoryLabel.Height = 30
        $categoryLabel.TextAlign = "MiddleLeft"
        $categoryLabel.BackColor = [System.Drawing.Color]::FromArgb(230, 230, 230)
        $categoryLabel.ForeColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
        $categoryLabel.Padding = New-Object System.Windows.Forms.Padding(10, 5, 0, 0)
        $categoryPanel.Controls.Add($categoryLabel)
        
        $tilePanel.Controls.Add($categoryPanel)
        
        # Add tiles
        foreach ($item in $group.Group) {
            $tile = Create-TileButton -Item $item
            $tilePanel.Controls.Add($tile)
        }
    }
}

# Wire up search events
$searchBox.Add_TextChanged({ Refresh-Tiles })
$categoryCombo.Add_SelectedIndexChanged({ Refresh-Tiles })

# Initial load
Refresh-Tiles

# Show form
$mainForm.Add_Shown({$mainForm.Activate()})
[void]$mainForm.ShowDialog()
'@
    
    $portalScriptPath = Join-Path $portalPath "portal.ps1"
    $portalScriptContent | Set-Content $portalScriptPath -Encoding UTF8
    
    # Create batch file launcher to avoid ExecutionPolicy issues
    $batchContent = @"
@echo off
REM Application Portal Launcher
REM Launches portal with minimal window display

cd /d "%~dp0"
start /min powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File "portal.ps1"
exit
"@
    
    $batchPath = Join-Path $portalPath "LaunchPortal.bat"
    $batchContent | Set-Content $batchPath -Encoding ASCII
    
    # Create VBS launcher for completely silent execution
    $vbsContent = @"
' Application Portal Silent Launcher
' Launches portal without any visible windows
Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
strPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
objShell.CurrentDirectory = strPath
objShell.Run "powershell.exe -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command ""& {Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; & '""" & strPath & "\portal.ps1'"""}""", 0, False
Set objShell = Nothing
Set objFSO = Nothing
"@
    
    $vbsPath = Join-Path $portalPath "LaunchPortal.vbs"
    $vbsContent | Set-Content $vbsPath -Encoding ASCII
    
    # Create desktop shortcut
    $shell = New-Object -ComObject WScript.Shell
    $shortcutPath = Join-Path $portalPath "Application Portal.lnk"
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = Join-Path $portalPath "LaunchPortal.vbs"
    $shortcut.WorkingDirectory = $portalPath
    $shortcut.Description = "Launch Application Portal"
    
    # Set custom icon if specified, otherwise use default
    if ($script:PortalConfig.DesktopIconPath) {
        $iconPath = Join-Path $portalPath $script:PortalConfig.DesktopIconPath
        if (Test-Path $iconPath) {
            $shortcut.IconLocation = $iconPath
        }
        else {
            $shortcut.IconLocation = "$env:SystemRoot\System32\imageres.dll,3"
        }
    }
    else {
        $shortcut.IconLocation = "$env:SystemRoot\System32\imageres.dll,3"
    }
    
    $shortcut.Save()
    
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
    
    # Create README file
    $readmeContent = @"
APPLICATION PORTAL - DEPLOYMENT GUIDE
======================================

OVERVIEW
--------
This folder contains a portable application portal that can be deployed
to any Windows PC without requiring administrator privileges or PowerShell
execution policy changes.

CONTENTS
--------
- portal.ps1              : Main portal script
- config.json             : Portal configuration (colors, fonts, text)
- items.json              : List of programs and URLs
- Icons\                  : Custom icons and logo files
- LaunchPortal.bat        : Batch file launcher
- LaunchPortal.vbs        : Silent VBScript launcher
- Application Portal.lnk  : Desktop shortcut
- README.txt              : This file

DEPLOYMENT INSTRUCTIONS
-----------------------
1. Copy this entire folder to the target PC
   Recommended locations:
   - C:\ApplicationPortal
   - C:\Program Files\ApplicationPortal
   - Any shared network location

2. To make available to all users:
   - Copy "Application Portal.lnk" to:
     C:\Users\Public\Desktop
   
   - Or add to Start Menu:
     C:\ProgramData\Microsoft\Windows\Start Menu\Programs

3. Users can launch the portal by:
   - Double-clicking "LaunchPortal.bat"
   - Double-clicking "LaunchPortal.vbs" (silent)
   - Using the desktop shortcut

CUSTOMIZATION
-------------
To modify portal settings, edit config.json using any text editor.
To add/remove programs, rebuild using PortalBuilder.ps1 on the build PC.

TROUBLESHOOTING
---------------
- If programs don't launch, verify paths in items.json
- If icons don't display, check Icons\ folder contents
- Portal requires .NET Framework 4.0 or higher
- Portal requires PowerShell 3.0 or higher (pre-installed on Windows 7+)

SECURITY & COMPLIANCE
---------------------
- No external modules or internet downloads required
- No ExecutionPolicy bypass needed with .bat/.vbs launchers
- All code is local and can be reviewed
- Compatible with corporate security policies
- Does not require administrator privileges

Created: $((Get-Date).ToString("yyyy-MM-dd"))
"@
    
    $readmePath = Join-Path $portalPath "README.txt"
    $readmeContent | Set-Content $readmePath -Encoding UTF8
    
    return $portalPath
}

# ============================================================================
# MAIN BUILDER FORM
# ============================================================================

# Initialize program list
$script:AllItems = @(Get-InstalledPrograms)

# Create main form
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "Application Portal Builder"
$mainForm.Size = New-Object System.Drawing.Size(1000, 700)
$mainForm.StartPosition = "CenterScreen"
$mainForm.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$mainForm.MinimizeBox = $true
$mainForm.MaximizeBox = $true
$mainForm.FormBorderStyle = "Sizable"

# Set application icon (extract from PowerShell executable)
try {
    $iconPath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    if (Test-Path $iconPath) {
        $mainForm.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)
    }
} catch { }

# Menu strip
$menuStrip = New-Object System.Windows.Forms.MenuStrip

$menuFile = New-Object System.Windows.Forms.ToolStripMenuItem
$menuFile.Text = "File"

$menuCustomize = New-Object System.Windows.Forms.ToolStripMenuItem
$menuCustomize.Text = "Customize Portal"
$menuCustomize.Add_Click({
    Show-CustomizationDialog
})
$menuFile.DropDownItems.Add($menuCustomize)

$menuExit = New-Object System.Windows.Forms.ToolStripMenuItem
$menuExit.Text = "Exit"
$menuExit.Add_Click({
    $mainForm.Close()
})
$menuFile.DropDownItems.Add($menuExit)

$menuStrip.Items.Add($menuFile)
$mainForm.Controls.Add($menuStrip)

# Toolbar
$toolbar = New-Object System.Windows.Forms.ToolStrip
$toolbar.GripStyle = "Hidden"

$btnAddProgram = New-Object System.Windows.Forms.ToolStripButton
$btnAddProgram.Text = "Add Program"
$btnAddProgram.Add_Click({
    $newProgram = Show-AddProgramDialog
    if ($newProgram) {
        $script:AllItems += $newProgram
        Refresh-ItemList -ListView $listView -SearchText $txtSearch.Text -ResultLabel $lblSearchResults
    }
})
$toolbar.Items.Add($btnAddProgram)

$btnAddURL = New-Object System.Windows.Forms.ToolStripButton
$btnAddURL.Text = "Add URL"
$btnAddURL.Add_Click({
    $newURL = Show-AddURLDialog
    if ($newURL) {
        $script:AllItems += $newURL
        Refresh-ItemList -ListView $listView -SearchText $txtSearch.Text -ResultLabel $lblSearchResults
    }
})
$toolbar.Items.Add($btnAddURL)

$btnRefresh = New-Object System.Windows.Forms.ToolStripButton
$btnRefresh.Text = "Refresh Programs"
$btnRefresh.Add_Click({
    $script:AllItems = @(Get-InstalledPrograms)
    Refresh-ItemList -ListView $listView -SearchText $txtSearch.Text -ResultLabel $lblSearchResults
    [System.Windows.Forms.MessageBox]::Show("Program list refreshed.", "Info", "OK", "Information")
})
$toolbar.Items.Add($btnRefresh)

$toolbar.Items.Add((New-Object System.Windows.Forms.ToolStripSeparator))

$btnRemove = New-Object System.Windows.Forms.ToolStripButton
$btnRemove.Text = "Remove Selected"
$btnRemove.Add_Click({
    if ($listView.SelectedItems.Count -gt 0) {
        $selectedItem = $listView.SelectedItems[0].Tag
        $script:AllItems = @($script:AllItems | Where-Object { $_ -ne $selectedItem })
        Refresh-ItemList -ListView $listView -SearchText $txtSearch.Text -ResultLabel $lblSearchResults
    }
})
$toolbar.Items.Add($btnRemove)

$mainForm.Controls.Add($toolbar)

# Search panel
$searchPanel = New-Object System.Windows.Forms.Panel
$searchPanel.Height = 40
$searchPanel.Dock = "Top"

$lblSearch = New-Object System.Windows.Forms.Label
$lblSearch.Text = "Search:"
$lblSearch.Location = New-Object System.Drawing.Point(10, 10)
$lblSearch.AutoSize = $true
$searchPanel.Controls.Add($lblSearch)

$txtSearch = New-Object System.Windows.Forms.TextBox
$txtSearch.Location = New-Object System.Drawing.Point(70, 8)
$txtSearch.Size = New-Object System.Drawing.Size(300, 25)
$searchPanel.Controls.Add($txtSearch)

$lblSearchResults = New-Object System.Windows.Forms.Label
$lblSearchResults.Location = New-Object System.Drawing.Point(380, 10)
$lblSearchResults.AutoSize = $true
$lblSearchResults.ForeColor = [System.Drawing.Color]::Gray
$searchPanel.Controls.Add($lblSearchResults)

$txtSearch.Add_TextChanged({
    Refresh-ItemList -ListView $listView -SearchText $txtSearch.Text -ResultLabel $lblSearchResults
})

$mainForm.Controls.Add($searchPanel)

# ListView for programs
$listView = New-Object System.Windows.Forms.ListView
$listView.Dock = "Fill"
$listView.View = "Details"
$listView.FullRowSelect = $true
$listView.GridLines = $true
$listView.CheckBoxes = $true

$listView.Columns.Add("Name", 250) | Out-Null
$listView.Columns.Add("Type", 80) | Out-Null
$listView.Columns.Add("Category", 150) | Out-Null
$listView.Columns.Add("Path", 400) | Out-Null

$mainForm.Controls.Add($listView)

# Bottom panel with buttons
$bottomPanel = New-Object System.Windows.Forms.Panel
$bottomPanel.Height = 60
$bottomPanel.Dock = "Bottom"

$btnBuild = New-Object System.Windows.Forms.Button
$btnBuild.Text = "Build Portal Package"
$btnBuild.Location = New-Object System.Drawing.Point(750, 15)
$btnBuild.Size = New-Object System.Drawing.Size(200, 35)
$btnBuild.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnBuild.Add_Click({
    # Get checked items
    $selectedItems = @()
    foreach ($item in $listView.Items) {
        if ($item.Checked) {
            $selectedItems += $item.Tag
        }
    }
    
    if ($selectedItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show(
            "Please select at least one item to include in the portal.",
            "No Items Selected",
            "OK",
            "Warning"
        )
        return
    }
    
    # Select output folder
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select location to create portal package"
    $folderBrowser.SelectedPath = [Environment]::GetFolderPath("Desktop")
    
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $portalPath = Build-PortalPackage -SelectedItems $selectedItems -OutputPath $folderBrowser.SelectedPath
        
        if ($portalPath) {
            $result = [System.Windows.Forms.MessageBox]::Show(
                "Portal package created successfully!`n`nLocation: $portalPath`n`nWould you like to open the folder?",
                "Success",
                "YesNo",
                "Information"
            )
            
            if ($result -eq "Yes") {
                Start-Process $portalPath
            }
        }
    }
})
$bottomPanel.Controls.Add($btnBuild)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Ready - Select programs and click Build Portal Package"
$lblStatus.Location = New-Object System.Drawing.Point(10, 25)
$lblStatus.AutoSize = $true
$bottomPanel.Controls.Add($lblStatus)

$mainForm.Controls.Add($bottomPanel)

# Initial list population
Refresh-ItemList -ListView $listView -SearchText "" -ResultLabel $lblSearchResults

# Show form
$mainForm.Add_Shown({$mainForm.Activate()})
[void]$mainForm.ShowDialog()

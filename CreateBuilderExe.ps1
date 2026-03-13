# Compile RunBuilder.exe from C# source
Write-Host "Creating RunBuilder.exe..." -ForegroundColor Cyan

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$csharpCode = @'
using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace PortalBuilderLauncher
{
    class Program
    {
        [STAThread]
        static void Main()
        {
            try
            {
                string appDir = AppDomain.CurrentDomain.BaseDirectory;
                string scriptPath = Path.Combine(appDir, "PortalBuilder.ps1");
                
                if (!File.Exists(scriptPath))
                {
                    MessageBox.Show("Error: PortalBuilder.ps1 not found.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = "powershell.exe",
                    Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + scriptPath + "\"",
                    UseShellExecute = false,
                    CreateNoWindow = false,
                    WorkingDirectory = appDir
                };
                
                Process.Start(psi);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to launch: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
'@

$tempCs = Join-Path $scriptDir "temp_builder.cs"
$csharpCode | Set-Content $tempCs -Encoding UTF8

# Find C# compiler
$cscPath = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if (-not (Test-Path $cscPath)) {
    $cscPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe"
}

if (Test-Path $cscPath) {
    $exePath = Join-Path $scriptDir "RunBuilder.exe"
    
& $cscPath /target:winexe /out:"$exePath" /reference:System.Windows.Forms.dll /reference:System.Drawing.dll /optimize+ /nologo "$tempCs" 2>&1 | Out-Null
    
    Remove-Item $tempCs -ErrorAction SilentlyContinue
    
    if (Test-Path $exePath) {
        Write-Host "SUCCESS: RunBuilder.exe created!" -ForegroundColor Green
        Write-Host "You can now use RunBuilder.exe to launch the Portal Builder" -ForegroundColor Cyan
    } else {
        Write-Host "ERROR: Compilation failed" -ForegroundColor Red
    }
} else {
    Write-Host "ERROR: C# compiler not found" -ForegroundColor Red
    Remove-Item $tempCs -ErrorAction SilentlyContinue
}

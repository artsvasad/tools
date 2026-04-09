# --- Asad's Toolbox Launcher ---
# Location: D:\UserData\OneDrive\Desktop\run.ps1

Clear-Host
$base = "https://tools.suyena.com/scripts"

Write-Host "--- Asad's Toolbox [tools.suyena.com] ---" -ForegroundColor Cyan
Write-Host "1. Word, Excel to PDF (Office to PDF - Windows Only)"
Write-Host "2. JPEG to PDF (Image to PDF & ID Resize)"
Write-Host "3. PDF to JPEG (High-Res PDF to JPEG)" -ForegroundColor Magenta
Write-Host "4. PNG to JPEG (Convert PNG to JPEG)"
Write-Host "5. Video to Images (Fast Frame Extraction)"
Write-Host "6. Enlarge Image (Parallel 500% Resize)"
Write-Host "7. Flip the Video (Video Horizontal Flip)"
Write-Host "8. Download on RAM (High-Speed RAM Download)"
Write-Host "9. Write Log (Daily Progress Report)" -ForegroundColor Yellow
Write-Host "10. Create a large file (Generate a large dummy file for testing)" -ForegroundColor Green
Write-Host "11. YouTube Downloader (Download YouTube videos with yt-dlp)" -ForegroundColor Blue
Write-Host "0. Exit"

$choice = Read-Host "`nSelect a tool number"

# --- Function for Remote Python Tools ---
function Run-Tool($name, $deps) {
    if ($deps) { 
        Write-Host "`n[!] Checking dependencies for $name..." -ForegroundColor Yellow
        pip install $deps --quiet 
    }

    $tmpPath = Join-Path $env:TEMP $name
    
    try {
        Write-Host "[+] Fetching $name from $base..." -ForegroundColor Gray
        Invoke-RestMethod -Uri "$base/$name" -OutFile $tmpPath -ErrorAction Stop
        
        Write-Host "[+] Launching $name...`n" -ForegroundColor Green
        python $tmpPath
    }
    catch {
        Write-Host "[-] Error: Could not download or run $name. Check your connection." -ForegroundColor Red
    }
    finally {
        if (Test-Path $tmpPath) { Remove-Item $tmpPath }
        Write-Host "`n[!] Process finished. Press any key to return..." -ForegroundColor Cyan
        $null = [System.Console]::ReadKey($true)
        & $PSCommandPath
    }
}

# --- Function for Local Progress Logging ---
function Write-DailyLog {
    $logFile = "progress.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "`n--- Daily Progress Logger ---" -ForegroundColor Green
    $task = Read-Host "Task Description"
    $status = Read-Host "Status (e.g. In Progress, Done, Blocked)"
    
    $logEntry = "[$timestamp] | Status: [$status] | $task"
    
    Add-Content -Path $logFile -Value $logEntry
    Write-Host "`n[+] Entry saved to $logFile" -ForegroundColor Gray
    
    Write-Host "`n[!] Press any key to return..." -ForegroundColor Cyan
    $null = [System.Console]::ReadKey($true)
    & $PSCommandPath
}

# --- Menu Logic ---
switch ($choice) {
    "1" { Run-Tool "w2p.py" "pywin32" }
    "2" { Run-Tool "j2p.py" "Pillow" }
    "3" { Run-Tool "pdf2jpg.py" "PyMuPDF" }
    "4" { Run-Tool "png2jpg.py" "Pillow" }
    "5" { Run-Tool "v2img.py" "opencv-python" }
    "6" { Run-Tool "limg.py" "Pillow" }
    "7" { Run-Tool "VMirror.py" "" }
    "8" { Run-Tool "down.py" "requests" }
    "9" { Write-DailyLog } 
    "10" { Run-Tool "allocate.py" "" }
    "11" {Run-Tool "ytdl.py" "yt-dlp"}
    "0" { exit }
    Default { 
        Write-Host "Invalid selection." -ForegroundColor Red 
        Start-Sleep -Seconds 1
        & $PSCommandPath
    }
}
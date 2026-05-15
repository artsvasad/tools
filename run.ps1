# --- Sovereign Toolbox Launcher (Zero-Cache Architecture) ---
# Location: D:\UserData\OneDrive\Desktop\run.ps1

# [!] TACTICAL KILL-SWITCH: Eradicate legacy cache structures unconditionally
$LegacyCache = Join-Path $env:USERPROFILE ".suyena_cache"
if (Test-Path $LegacyCache) {
    Write-Host "`n[!] Purging senescent legacy directory: $LegacyCache..." -ForegroundColor Red
    Remove-Item -Path $LegacyCache -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "[+] Legacy cache destroyed." -ForegroundColor DarkGray
}

$base = "https://tools.suyena.com/scripts"
$WorkspaceDir = Join-Path $env:USERPROFILE ".suyena_workspace"

# Ensure local workspace exists for quarantine and venv preservation
if (-not (Test-Path $WorkspaceDir)) {
    New-Item -ItemType Directory -Path $WorkspaceDir -Force | Out-Null
}

# --- Function for Remote Python Tools (Live Synchronization) ---
function Run-Tool($name, $deps) {
    $localPath = Join-Path $WorkspaceDir $name
    $venvPath = Join-Path $WorkspaceDir "venv"
    $pythonExe = Join-Path $venvPath "Scripts\python.exe"
    $pipExe = Join-Path $venvPath "Scripts\pip.exe"
    
    # Telemetry Hook for ActivityWatch precision
    $originalTitle = $Host.UI.RawUI.WindowTitle
    $Host.UI.RawUI.WindowTitle = "[Sovereign Operations] - Executing: $name"

    # Quarantine Setup: Maintain environment to preserve velocity
    if (-not (Test-Path $venvPath)) {
        Write-Host "`n[!] Constructing isolated containment environment..." -ForegroundColor Yellow
        & python -m venv $venvPath | Out-Null
    }
    
    # ZERO-CACHE PROTOCOL: Forcefully overwrite local payload with master data
    Write-Host "`n[!] Synchronizing live payload: $name..." -ForegroundColor Yellow
    try {
        Invoke-RestMethod -Uri "$base/$name" -OutFile $localPath -ErrorAction Stop
        
        # Inject missing dependencies silently
        if ($deps) { 
            # Critical Fix: Array separation ensures pip processes multiple arguments correctly
            $depArray = $deps -split " "
            Write-Host "[+] Verifying dependencies..." -ForegroundColor Gray
            & $pipExe install $depArray --quiet 
        }
        Write-Host "[+] Payload secured." -ForegroundColor Green
    }
    catch {
        Write-Host "[-] Live synchronization failed. Attempting offline execution..." -ForegroundColor DarkYellow
        if (-not (Test-Path $localPath)) {
            Write-Host "[-] Fatal: No local module found. Aborting." -ForegroundColor Red
            $Host.UI.RawUI.WindowTitle = $originalTitle
            return
        }
    }

    # Execute from overwritten payload based on file type
    try {
        Write-Host "`n[+] Executing $name...`n" -ForegroundColor Green
        
        if ($localPath.EndsWith(".ps1")) {
            # Execute as a PowerShell script
            & powershell.exe -ExecutionPolicy Bypass -File $localPath
        } 
        elseif ($localPath.EndsWith(".py")) {
            # Execute as a Python script inside the venv
            & $pythonExe $localPath
        } 
        else {
            Write-Host "[-] Unknown payload format: $name" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "[-] Execution Failure during runtime." -ForegroundColor Red
    }
    finally {
        Write-Host "`n[!] Operation concluded. Press any key to re-engage..." -ForegroundColor Cyan
        $null = [System.Console]::ReadKey($true)
        # Restore Telemetry
        $Host.UI.RawUI.WindowTitle = $originalTitle
    }
}

# --- Function for Local Progress Logging ---
function Write-DailyLog {
    $logFile = "progress.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "`n--- Sovereign Progress Ledger ---" -ForegroundColor Green
    $task = Read-Host "Operation Name"
    $status = Read-Host "Status Vector (e.g., Executing, Secured, Obstructed)"
    
    $logEntry = "[$timestamp] | Vector: [$status] | $task"
    
    Add-Content -Path $logFile -Value $logEntry
    Write-Host "`n[+] Ledger updated: $logFile" -ForegroundColor Gray
    
    Write-Host "`n[!] Press any key to return to command..." -ForegroundColor Cyan
    $null = [System.Console]::ReadKey($true)
}

# --- Infinite Loop Architecture ---
while ($true) {
    Clear-Host
    Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║       SOVEREIGN TOOLBOX [tools.suyena.com]        ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    # --- CATEGORY 1: DOCUMENT & IMAGE OPERATIONS ---
    Write-Host "┌── [ DOCUMENT & IMAGE OPERATIONS ] ────────────────┐" -ForegroundColor DarkCyan
    Write-Host "│  1. Word, Excel to PDF                            │" -ForegroundColor Cyan
    Write-Host "│  2. JPEG to PDF                                   │" -ForegroundColor DarkGreen
    Write-Host "│  3. PDF to JPEG (High-Res)                        │" -ForegroundColor Magenta
    Write-Host "│  4. PNG to JPEG                                   │" -ForegroundColor DarkYellow
    Write-Host "│  5. Enlarge Image (Parallel 500%)                 │" -ForegroundColor White
    Write-Host "└───────────────────────────────────────────────────┘" -ForegroundColor DarkCyan

    # --- CATEGORY 2: VIDEO & MEDIA UTILITIES ---
    Write-Host "┌── [ VIDEO & MEDIA UTILITIES ] ────────────────────┐" -ForegroundColor DarkBlue
    Write-Host "│  6. Video to Images (Fast Frame)                  │" -ForegroundColor DarkMagenta
    Write-Host "│  7. Flip the Video (Horizontal)                   │" -ForegroundColor Gray
    Write-Host "│  8. YouTube Downloader (yt-dlp)                   │" -ForegroundColor Blue
    Write-Host "└───────────────────────────────────────────────────┘" -ForegroundColor DarkBlue

    # --- CATEGORY 3: SYSTEM & NETWORK ARCHITECTURE ---
    Write-Host "┌── [ SYSTEM & NETWORK ARCHITECTURE ] ──────────────┐" -ForegroundColor DarkGreen
    Write-Host "│  9. Download on RAM (High-Speed)                  │" -ForegroundColor Cyan
    Write-Host "│ 10. Create a Large File (Dummy Generator)         │" -ForegroundColor Green
    Write-Host "└───────────────────────────────────────────────────┘" -ForegroundColor DarkGreen

    # --- CATEGORY 4: OPERATIONS & TRACKING ---
    Write-Host "┌── [ OPERATIONS & TRACKING ] ──────────────────────┐" -ForegroundColor DarkYellow
    Write-Host "│ 11. Write Log (Daily Progress Report)             │" -ForegroundColor Yellow
    Write-Host "│ 12. Organize Files (File Organizer)               │" -ForegroundColor DarkCyan
    Write-Host "│ 13. Convert Image to A4                           │" -ForegroundColor DarkGreen
    Write-Host "│ 14. Convert Image to PDF                          │" -ForegroundColor Magenta
    Write-Host "│ 15. Rename Files (Batch Rename)                   │" -ForegroundColor DarkYellow
    Write-Host "└───────────────────────────────────────────────────┘" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "   0. Exit System" -ForegroundColor Red
    Write-Host ""

    $choice = Read-Host "Select a strategic asset"

    switch ($choice) {
        "1"  { Run-Tool "w2p.py" "pywin32" }       
        "2"  { Run-Tool "j2p.py" "Pillow" }        
        "3"  { Run-Tool "pdf2jpg.py" "PyMuPDF tqdm" }   
        "4"  { Run-Tool "png2jpg.py" "Pillow" }    
        "5"  { Run-Tool "limg.py" "Pillow" }       
        "6"  { Run-Tool "v2img.py" "opencv-python" }
        "7"  { Run-Tool "VMirror.py" "" }          
        "8"  { Run-Tool "ytdl.py" "yt-dlp ffmpeg-python" }     
        "9"  { Run-Tool "down.py" "requests" }     
        "10" { Run-Tool "allocate.py" "" }         
        "11" { Write-DailyLog }                   
        "12" { Run-Tool "fileOrganizer.ps1" "" }
        "13" { Run-Tool "img2a4.py" "" }
        "14" { Run-Tool "img2pdf.py" "" }
        "15" { Run-Tool "rename.ps1" "" }
        "0"  { exit }
        Default { 
            Write-Host "Invalid parameter. Recalibrating." -ForegroundColor Red 
            Start-Sleep -Seconds 1
        }
    }
}
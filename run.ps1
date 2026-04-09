# --- Sovereign Toolbox Launcher (Finalized Architecture) ---
# Location: D:\UserData\OneDrive\Desktop\run.ps1

$base = "https://tools.suyena.com/scripts"
$CacheDir = Join-Path $env:USERPROFILE ".suyena_cache"

# Ensure local cache directory exists for offline sovereignty
if (-not (Test-Path $CacheDir)) {
    New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null
}

# --- Function for Remote Python Tools (Isolated & Tracked) ---
function Run-Tool($name, $deps) {
    $localPath = Join-Path $CacheDir $name
    $venvPath = Join-Path $CacheDir "venv"
    $pythonExe = Join-Path $venvPath "Scripts\python.exe"
    $pipExe = Join-Path $venvPath "Scripts\pip.exe"
    
    # Telemetry Hook: Update Window Title for ActivityWatch precision
    $originalTitle = $Host.UI.RawUI.WindowTitle
    $Host.UI.RawUI.WindowTitle = "[Sovereign Operations] - Executing: $name"

    # Quarantine Setup: Ensure Virtual Environment exists
    if (-not (Test-Path $venvPath)) {
        Write-Host "`n[!] Constructing isolated containment environment..." -ForegroundColor Yellow
        python -m venv $venvPath | Out-Null
    }
    
    # Cache Miss: Download and install dependencies into quarantine
    if (-not (Test-Path $localPath)) {
        Write-Host "[!] Synchronizing $name to local cache..." -ForegroundColor Yellow
        try {
            Invoke-RestMethod -Uri "$base/$name" -OutFile $localPath -ErrorAction Stop
            
            if ($deps) { 
                Write-Host "[+] Injecting dependencies ($deps) into quarantine..." -ForegroundColor Gray
                & $pipExe install $deps --quiet 
            }
            Write-Host "[+] Synchronization complete." -ForegroundColor Green
        }
        catch {
            Write-Host "[-] Execution Failure: Could not synchronize $name. Verify uplink." -ForegroundColor Red
            $Host.UI.RawUI.WindowTitle = $originalTitle
            return
        }
    }

    # Execute from high-speed local cache using isolated Python binary
    try {
        Write-Host "`n[+] Executing $name...`n" -ForegroundColor Green
        & $pythonExe $localPath
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

# --- Infinite Loop Architecture (Prevents Stack Overflow) ---
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
    Write-Host "│                                                   │"
    Write-Host "│ 99. Force Update Tools (Clear Cache)              │" -ForegroundColor DarkRed
    Write-Host "└───────────────────────────────────────────────────┘" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "   0. Exit System" -ForegroundColor Red
    Write-Host ""

    $choice = Read-Host "Select a strategic asset"

    switch ($choice) {
        "1"  { Run-Tool "w2p.py" "pywin32" }       
        "2"  { Run-Tool "j2p.py" "Pillow" }        
        "3"  { Run-Tool "pdf2jpg.py" "PyMuPDF" }   
        "4"  { Run-Tool "png2jpg.py" "Pillow" }    
        "5"  { Run-Tool "limg.py" "Pillow" }       
        "6"  { Run-Tool "v2img.py" "opencv-python"}
        "7"  { Run-Tool "VMirror.py" "" }          
        "8"  { Run-Tool "ytdl.py" "yt-dlp" }       
        "9"  { Run-Tool "down.py" "requests" }     
        "10" { Run-Tool "allocate.py" "" }         
        "11" { Write-DailyLog }   
        "99" { 
            Write-Host "`n[!] Purging local cache..." -ForegroundColor Red
            Remove-Item -Path "$CacheDir\*" -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host "[+] Cache cleared. Tools will redownload on next execution." -ForegroundColor Green
            Start-Sleep -Seconds 2
        }                 
        "0"  { exit }
        Default { 
            Write-Host "Invalid parameter. Recalibrating." -ForegroundColor Red 
            Start-Sleep -Seconds 1
        }
    }
}
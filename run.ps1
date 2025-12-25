# --- Asad's Toolbox Launcher ---
# Location: D:\UserData\OneDrive\Desktop\run.ps1

Clear-Host
$base = "https://tools.suyena.com/scripts"

Write-Host "--- Asad's Toolbox [tools.suyena.com] ---" -ForegroundColor Cyan
Write-Host "1. J2P (Image to PDF & ID Resize)"
Write-Host "2. LIMG (Parallel 500% Resize)"
Write-Host "3. V2IMG (Fast Frame Extraction)"
Write-Host "4. VMIRROR (Video Horizontal Flip)"
Write-Host "5. W2P (Office to PDF - Windows Only)"
Write-Host "6. DOWN (High-Speed RAM Download)"
Write-Host "7. PNG2JPG (Convert PNG to JPEG)"
Write-Host "0. Exit"

$choice = Read-Host "`nSelect a tool number"

function Run-Tool($name, $deps) {
    if ($deps) { 
        Write-Host "`n[!] Checking dependencies for $name..." -ForegroundColor Yellow
        pip install $deps --quiet 
    }

    # This temporary path is the KEY fix for the 'unclosed parenthesis' error
    $tmpPath = Join-Path $env:TEMP $name
    
    try {
        Write-Host "[+] Fetching $name from $base..." -ForegroundColor Gray
        # Download the full script to a file first
        Invoke-RestMethod -Uri "$base/$name" -OutFile $tmpPath -ErrorAction Stop
        
        Write-Host "[+] Launching $name...`n" -ForegroundColor Green
        # Execute the file instead of a truncated string
        python $tmpPath
    }
    catch {
        Write-Host "[-] Error: Could not download or run $name. Check your connection." -ForegroundColor Red
    }
    finally {
        # Cleanup temp file
        if (Test-Path $tmpPath) { Remove-Item $tmpPath }
        Write-Host "`n[!] Process finished. Press any key to return..." -ForegroundColor Cyan
        $null = [System.Console]::ReadKey($true)
        # Re-run the launcher to keep the menu active
        & $PSCommandPath
    }
}

switch ($choice) {
    "1" { Run-Tool "j2p.py" "Pillow" }
    "2" { Run-Tool "limg.py" "Pillow" }
    "3" { Run-Tool "v2img.py" "opencv-python" }
    "4" { Run-Tool "VMirror.py" "" }
    "5" { Run-Tool "w2p.py" "pywin32" }
    "6" { Run-Tool "down.py" "requests" }
    "7" { Run-Tool "png2jpg.py" "Pillow" }
    "0" { exit }
    Default { Write-Host "Invalid selection." -ForegroundColor Red }
}